From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Sat, 11 Sep 2010 18:05:51 +0300
Message-ID: <4C8B9ACF.1080404@gmail.com>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com> <20100903221303.GA9527@localhost.localdomain> <4C876B47.50805@gmail.com> <4C88BBB2.8080309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39147 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0IKPF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Sep 2010 11:05:59 -0400
Received: by wwb13 with SMTP id 13so1435440wwb.1
        for <linux-scsi@vger.kernel.org>; Sat, 11 Sep 2010 08:05:58 -0700 (PDT)
In-Reply-To: <4C88BBB2.8080309@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, Wouter Naaktgeboren <wouter_naaktgeboren@xs4all.nl>

  Dear David,

After a few days of testing your patch i think it is pretty solid. The 
only troubling messages I got are these

ata61.00: qc timeout (cmd 0x27)
ata61.00: failed to read native max address (err_mask=0x4)
ata61.00: HPA support seems broken, skipping HPA handling
drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[b]:rc= 0

ata61: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata61.00: device reported invalid CHS sector 0
ata61: status=0x01 { Error }
ata61: error=0x04 { DriveStatusError }

