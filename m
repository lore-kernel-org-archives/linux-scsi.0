From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh_alua: Remove stale variables
Date: Mon, 7 Dec 2015 17:12:55 -0800 (PST)
Message-ID: <yq1mvtl7nfs.fsf@sermon.lab.mkp.net>
References: <1449125855-66372-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38270 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbbLHBOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 20:14:03 -0500
In-Reply-To: <1449125855-66372-1-git-send-email-hare@suse.de> <(Hannes>
 <Reinecke's> <message> <of> <"Thu> <> <3> <Dec> <2015> <07:57:35> <+0100")>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@odin.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> With commit 83ea0e5e3501 these variables became obsolete, but
Hannes> weren't removed.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
