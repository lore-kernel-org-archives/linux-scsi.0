From: Yugendranath R Singh <yugendranath.s@hcl.in>
Subject: mvsas (2.6.31) driver for Adaptec ASC-1045/1405 SAS/SATA controller
Date: Tue, 29 Sep 2009 19:38:28 +0530
Message-ID: <4CA9DA403FFEC64AA62B3C295F8D47B7212674D127@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:55402 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZI2OIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 10:08:34 -0400
Received: from gws08.hcl.in (unknown [127.0.0.1])
	by IMSA (Postfix) with ESMTP id 1B70420F037
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 19:38:45 +0530 (IST)
Received: from chn-egw02-out.corp.hcl.in (unknown [10.249.64.38])
	by gws08.hcl.in (Postfix) with ESMTP id 0C74F20F036
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 19:38:45 +0530 (IST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,
We are currently working on open source drivers for Adaptec ASC 1045/1405 HBAs and these HBAs internally use Marvell 6440 SAS controller. The efforts started couple of weeks back with 2.6.30 mvsas driver as base. The 2.6.30 driver worked fine but had some issues with discovery and I/O of ATAPI devices and we were trying to fix these issues.  However, the newly released 2.6.31 mvsas seems to address all these issues and the test results of this driver are very encouraging. The testing basically included discovery - Hot plug, Cold plug and Overnight I/O with the various devices listed below except for the performance. There were few issues with discovery (Hot Plug) of daisy-chained expanders, but we have identified the fix for the same in 'libsas'.  

List of devices testing with ASC 1045/1405 using mvsas (2.6.31)
----------------------------------------------------------------
1. SAS disk drives
2. SAS Tape drives (HP LTO Ultrium-4)
3. Expanders (Adaptec, LSI and Promise)
4. SATA disk drives
5. SATA tape drives (DLT and AIT)
6. SATA DVD drives
7. Quantum GoVault drives
8. RBODs
9. 335 SAS JBOD

Below are our queries,
----------------------
1. How to get the PCI table of mv_init.c populated with vendor and device id of ASC 1045/1405? Should we submit a patch to mv_init.c or just sending the PCI details of ASC 1045/1405 to owners will suffice?
2. Going forward, we are very much interested in contributing to the support of issues related to mvsas driver.  Is it possible to have access to known-bugs list on this driver? We will do our best to fix the bugs utilizing whatever hardware resources we have.
3. Any plans of getting the 2.6.31 mvsas driver changes to older kernels (from 2.6.24 through 2.6.30) ? If not can we re-use this driver and submit to the earlier kernels under a different name?

We are currently preparing the patch for libsas (for the expander issue, mentioned above) and will submit the patch in couple of days.

Thanks,
Yugen,
HCL Technologies.



DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
