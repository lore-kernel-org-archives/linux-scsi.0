From: "Surekha.PC" <surekhap@cisco.com>
Subject: What factors limit the SCSI I/O request size?
Date: Wed, 19 May 2004 21:13:28 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAtCTpDJFaLE2uBc3buWekQgEAAAAA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:50436 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264276AbUESPng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 11:43:36 -0400
Received: from surekhapw2k (dhcp-10-77-7-183.cisco.com [10.77.7.183])
	by sj-core-2.cisco.com (8.12.10/8.12.6) with ESMTP id i4JFhTSu028192
	for <linux-scsi@vger.kernel.org>; Wed, 19 May 2004 08:43:30 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>


Hi,

 I have been testing linux iSCSI driver with 2.6 kernel and
 following are my observations on the SCSI I/O requests being
 sent to iSCSI driver.

 The sg_table_size and max_sectors are initialised to 64 and
 256 in scsi_host template. I am aware that these parameters
 have effect on the maximum SCSI I/O request queued to HBA driver.

I am doing 512K raw I/O on the iSCSI disk. By tuning sg_table_size
and max_sectors setting in scsi_host temple following was the
SCSI I/O request size being sent per command.

Sg_table_size            max_sectors          SCSI I/O size
   64                       256                   128k
  128                       256                   128k
   64                      1024                   256k
  128                      1024                   512k
 
 I would like to know on what basis the SCSI I/O request size per
command is determined. What are the other factors apart from
sg_table_size and max_sectors which can limit the I/O size?

thanks,
surekha 

