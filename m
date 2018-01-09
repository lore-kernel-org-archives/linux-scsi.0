From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Resend PATCH 00/11] mpt3sas: Enable scsi MQ & lockless command submission
Date: Mon, 08 Jan 2018 22:09:03 -0500
Message-ID: <yq1k1wrohio.fsf@oracle.com>
References: <1515070631-14740-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756657AbeAIDJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 22:09:35 -0500
In-Reply-To: <1515070631-14740-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Thu, 4 Jan 2018 04:57:00 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Hannes Reinecke <hare@suse.de>


Suganath,

> This patch set is initially posted by Hannes Reinecke to enable scsi
> multiqueue for the mpt3sas driver.  While the HBA only has a single
> mailbox register for submitting commands, it does have individual
> receive queues per MSI-X interrupt and as such does benefit from
> converting it to full multiqueue support.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
