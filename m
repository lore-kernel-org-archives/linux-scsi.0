From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] mpt3sas: Enable scsi MQ & lockless command submission
Date: Wed, 03 Jan 2018 23:07:18 -0500
Message-ID: <yq1bmiaxo5l.fsf@oracle.com>
References: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55040 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752001AbeADEHl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 23:07:41 -0500
In-Reply-To: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Thu, 21 Dec 2017 23:31:36 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>


Suganath,

> This patch set is initially posted by Hannes Reinecke to enable scsi
> multiqueue for the mpt3sas driver.  While the HBA only has a single
> mailbox register for submitting commands, it does have individual
> receive queues per MSI-X interrupt and as such does benefit from
> converting it to full multiqueue support.

This does not apply to 4.16/scsi-queue. Please rebase.

Also, the first patch has some out-of-tree debris in it.

-- 
Martin K. Petersen	Oracle Linux Engineering
