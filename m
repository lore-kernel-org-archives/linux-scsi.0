From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Adding features to be2iscsi
Date: Wed, 30 Jun 2010 05:24:55 +0530
Message-ID: <20100629235425.GA20042@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34739 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754812Ab0F3ACc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:02:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

	The following patches have been made over the latest scsi-misc 
tree pulled today  and are intended to provide additional features
and fix some bugs.

0001	Fix warnings from new checkpatch.pl
0002	Fix for 64K data                    
0003	Adding crashdump support            
0004	Maintain same ITT across login      
0005	Cleanup of load failure             
0006	including patch from Dan Carpenter  
0007	Fix for premature buffer free       
0008	The extend shift                    
0009	iscsi boot changes for the kernel   
0010	Add support for iscsi boot          
0011	patch from Randy Dunlap             
0012	Increase max sector           

	       
	Request that these patches be applied to scsi-misc tree.

Thanks
Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

