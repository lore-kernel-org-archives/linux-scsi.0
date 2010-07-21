From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Adding features to be2iscsi
Date: Thu, 22 Jul 2010 04:10:48 +0530
Message-ID: <20100721224027.GA9063@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:21909 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753020Ab0GUWki (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:40:38 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

  	These set of patches have been made on 
latest scsi-misc tree.

	I have recreated the patches after changes to handle
 the comments received from Mike and Konrad.


0001     Fix warnings from new checkpatch.pl         
0002     Fixing return values                        
0003     Fixing the return type of functions         
0004     pass the return from beiscsi_open_conn      
0005     Fix for freeing cid                         
0006	 No return value for hwi_enable_intr 
0007	 Fix to handle request_irq failure            
0008	 Free tags allocated                          
0009	 Adding crashdump support                 
0010	 Maintain same ITT across login           
0011	 Limit max_xmit_length                    
0012	 Remove debug print in IO path            
0013	 Fix for premature buffer free            
0014	 The extend shift                         
0015	 Add support for iscsi boot               
0016	 from Randy Dunlap                        
0017	 Increase max sector                    
0018	 Driver Version change                    

Thanks
Jayamohan Kallickal

Signed off by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

