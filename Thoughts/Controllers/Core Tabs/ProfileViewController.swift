//
//  ProfileViewController.swift
//  Thoughts
//
//  Created by Sherozbek on 17/11/23.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    private var user: User?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        return tableView
    }()
    
    let currentEmail: String
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSignOutButton()
        setUpTable()
        setUpTableHeader()
        fetchProfileData()
        fetchPosts()
        
    }
    
    private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: view.bounds.width,  
                                               height: view.bounds.width/1.5))
        headerView.backgroundColor = .systemBlue
        headerView.clipsToBounds = true
        headerView.isUserInteractionEnabled = true
        tableView.tableHeaderView = headerView
        
        // Profile Photo
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .white
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.bounds.width/2
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(x: (view.bounds.width-(view.bounds.width/4))/2,
                                    y: (headerView.bounds.height-(view.bounds.width/4))/2.5,
                                    width: view.bounds.width/4,
                                    height: view.bounds.width/4)
        headerView.addSubview(profilePhoto)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        //Email
        
        let emailLabel = UILabel(frame: CGRect(x: 20,
                                          y: profilePhoto.frame.maxY+10,
                                          width: view.bounds.width-40,
                                          height: 100))
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.textColor = .white
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
        headerView.addSubview(emailLabel)
        
        if let name = name {
            title = name
        }
        if let ref = profilePhotoRef {
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return

                
            }
                let task = URLSession.shared.dataTask(with: url) {
                    data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                
                task.resume()
            }
        }
    }
    
    @objc private func didTapProfilePhoto() {
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else {
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func fetchProfileData() {
        DataBaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            DispatchQueue.main.async {
                self?.setUpTableHeader(profilePhotoRef: user.profilePictureRef, name: user.name)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(
            title: "Sign Out",
            style: .done, target: self, 
            action: #selector(didTapSignOut))
    }
    
    //Sign out
    @objc private func didTapSignOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        let SignInVC = SignINViewController()
                        SignInVC.navigationItem.largeTitleDisplayMode = .always
                        
                        
                        let navVC = UINavigationController(rootViewController: SignInVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: nil )
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    
    
    // TableView
    
    private var posts: [BlogPost] = []
    
    private func fetchPosts() {
        guard let email = user?.email else {
            return
        }
        DataBaseManager.shared.getPosts(email: email) { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = post.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostViewController()
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }

    
    

}
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) {[weak self] success in
            guard let strongSelf = self else { return }
            if success {
                DataBaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) {updated in
                    guard updated else {
                        return
                    }
                    DispatchQueue.main.async {
                        
                    }
                }
            }
            
            
        }
        
    }
}
    
