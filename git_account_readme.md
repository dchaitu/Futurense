#### Test both connections:                                                
                                                                             
    ssh -T git@github.com                                                    
    ssh -T git@github-second                                                 
                                                                             
  Both should return: Hi <username>! You've successfully authenticated...    
  with their respective usernames.                                           
  ──────                                                                     
  ### Step 4: Clone or update repositories for the second account            
                                                                             
  When interacting with repositories for the second account, replace         
  github.com with your alias (github-second):                                
                                                                             
  • To clone a new repository:                                               
    git clone git@github-second:second-user/repo-name.git                    
                                                                             
  • To update an already cloned repository:                                  
    cd /path/to/repo                                                         
    git remote set-url origin git@github-second:second-user/repo-name.git    
                                                                             
  ──────                                                                     
  ### Step 5: Configure commit author details (Name & Email)                 
                                                                             
  Since your global Git config currently commits as dchaitu /                
  chaitanyadokara@gmail.com, you can configure commits for the second account
  using either of these approaches:                                          
                                                                             
  #### Option A: Per-repository config                                       
                                                                             
  Inside any repository belonging to the second account:                     
                                                                             
    git config user.name "Second Account Name"                               
    git config user.email "second_email@example.com"                         
                                                                             
  #### Option B: Automatic directory-based config (Recommended)              
                                                                             
  If you keep all second-account repositories in a dedicated folder (e.g.    
  ~/work/ or ~/second-account/):                                             
                                                                             
  1. Create a config file for the second account:                            
    nano ~/.gitconfig-second                                                 
  Add:                                                                       
    [user]
        name = Second Account Name
        email = second_email@example.com
  
  2. Edit your main ~/.gitconfig and append at the bottom:
    [includeIf "gitdir:~/work/"]
        path = ~/.gitconfig-second
  (Any repo inside ~/work/ will automatically use those credentials.)        
  ──────
  ### Optional: Using GitHub CLI (gh)
  
  Since you have GitHub CLI installed, you can also manage multiple accounts 
  with gh:
  
    # Authenticate the second account
    gh auth login
  
    # Switch between accounts anytime
    gh auth switch
