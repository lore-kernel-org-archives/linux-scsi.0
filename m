From: prash_t@softhome.net
Subject: why is there an empty scsi device ?
Date: Fri, 09 May 2003 00:31:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <courier.3EBB4B41.00006BEF@softhome.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jive.SoftHome.net ([66.54.152.27]:57298 "HELO jive.SoftHome.net")
	by vger.kernel.org with SMTP id S262299AbTEIGSw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2003 02:18:52 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
   In linux-2.4 kernels, I notice an empty Scsi_Device structure being added 
at the end of Scsi_Host list while detecting the scsi devices [scan_scsis( ) 
in scsi_scan.c].  This empty structure would get filled later in 
scan_scsis_single( ), in which case, again an empty device is appended.   
Can anybody let me know to why the structure is to be added in the linked 
list before filling up the fields rather than filling it first and adding to 
the host list later ? 

Thanks 

