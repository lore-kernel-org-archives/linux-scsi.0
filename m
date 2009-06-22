From: Amit Kumar Sharma <amitsharma.9@samsung.com>
Subject: problem with implemnetation of microcode command
Date: Mon, 22 Jun 2009 16:54:44 +0530
Message-ID: <CEE9AA1197B14499B186CF7FFC10BA6D@sisodomain.com>
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:53728 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFVMq3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 08:46:29 -0400
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KLN009H94TEZ2@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 22 Jun 2009 21:46:26 +0900 (KST)
Received: from amitksharma ([107.108.214.35])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KLN006T04TC7G@mmp2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 22 Jun 2009 21:46:26 +0900 (KST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Guys,

I am implementing microcode command for SSD , I am using 
ATA_ioctl cmd inteface
I am getting two issues.

1. After downloading initial firmware, I am not able to see 
any change in version number of firmware .
I am using hdparam -I /dev/sdb , It shows device firmware 
and other details according to discusstion with window guys
after downlaoding of  initial firmware this value should 
goto xxxxxx. but i can not see any change .

2. during download of mainfirmware i am getting time out 
error
    cmd shows 92 that is used for microcode.


ata_dev_printk(qc->dev, KERN_ERR,
                        "cmd 
%02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x 
"
                        "tag %d%s\n         %s"
                        "res 
%02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x 
"
                        "Emask 0x%x (%s)%s\n",
                        cmd->command, cmd->feature, 
cmd->nsect,
                        cmd->lbal, cmd->lbam, cmd->lbah,
                        cmd->hob_feature, cmd->hob_nsect,
                        cmd->hob_lbal, cmd->hob_lbam, 
cmd->hob_lbah,
                        cmd->device, qc->tag, data_buf, 
cdb_buf,
                        res->command, res->feature, 
res->nsect,
                        res->lbal, res->lbam, res->lbah,
                        res->hob_feature, res->hob_nsect,
                        res->hob_lbal, res->hob_lbam, 
res->hob_lbah,
                        res->device, qc->err_mask, 
ata_err_string(qc->err_mask),
                        qc->err_mask & AC_ERR_NCQ ? " <F>" : 
"");



Any help is welcome


Regards,
Amit Kumar Sharma
Memory Solutions Division
Samsung India Software Operations
Tel : +91 9972211274
Fax :  +91 80 4181 9000 


