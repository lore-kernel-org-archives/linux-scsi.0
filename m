From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: be2iscsi: Fixes
Date: Wed, 6 Oct 2010 23:38:11 +0530
Message-ID: <20101006180811.GA25689@emulex.com>
Reply-To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:45158 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759526Ab0JFSOx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 14:14:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi

  	These set of patches have been made on 
latest scsi-rc-fixes-2.6 tree.

0001     Provide for time for FW to respond
0002     Fixing premature free of cid                        
0003     Handling for sge length == 64K. This was 
	 submitted earlier but missed out

	Pl apply to scsi-rc-fixes-2.6 tree.

Thanks
Jayamohan Kallickal

Signed off by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com> 

---

