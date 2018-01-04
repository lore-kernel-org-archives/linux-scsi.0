From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Proper handling of set/clear of "ATA command pending" flag.
Date: Wed, 03 Jan 2018 23:08:34 -0500
Message-ID: <yq17esyxo3h.fsf@oracle.com>
References: <1514444951-9502-1-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39154 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbeADEIx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 23:08:53 -0500
In-Reply-To: <1514444951-9502-1-git-send-email-chaitra.basappa@broadcom.com>
        (Chaitra P. B.'s message of "Wed, 27 Dec 2017 23:09:11 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>


Chaitra,

>  This patch fixes above two issues by setting of "ATA command pending" flag
>  after checking for whether device deleted, invalid device handle, device
>  busy with task management. And by setting "ATA command pending" flag to
>  false in all of the qcmd failure return paths after setting the flag.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
