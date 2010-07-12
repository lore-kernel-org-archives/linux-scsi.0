From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Adding features to be2iscsi -V2
Date: Mon, 12 Jul 2010 23:17:32 +0530
Message-ID: <20100712174716.GA11289@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:30276 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752126Ab0GLRra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 13:47:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

  	These set of patches have been made on 
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git 

	I have recreated the patches after changes to handle
 the comments received from Mike and Konrad.


0001     Fix warnings from new checkpatch.pl         
0002     Fixing return values                        
0003     Fixing the return type of functions         
0004     pass the return from beiscsi_open_conn      
0005     Fix for freeing cid                         
0006     Fix for return type of mgmt_epfw_cleanup    
0007     No return value for hwi_enable_intr         
0008     Fix to handle request_irq failure           
0009     Free tags allocated                         
0010     Fix for 64K data                            
0011     Adding crashdump support                    
0012     Maintain same ITT across login              
0013     Limit max_xmit_length                       
0014     Remove debug print in IO path               
0015     Fix for premature buffer free               
0016     The extend shift                            
0017     Add support for iscsi boot                  
0018     from Randy Dunlap                     
0019     Increase max sector                         
0020     Driver Version change                      

Thanks
Jayamohan Kallickal

Signed off by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

