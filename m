From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: a correction in unmap_resources
Date: Mon, 04 Jan 2016 21:01:21 -0500
Message-ID: <yq1lh84lr7y.fsf@sermon.lab.mkp.net>
References: <1450876907-3913-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26370 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbcAECBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2016 21:01:32 -0500
In-Reply-To: <1450876907-3913-1-git-send-email-thenzl@redhat.com> (Tomas
	Henzl's message of "Wed, 23 Dec 2015 14:21:47 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, chaitra.basappa@avagotech.com, mlombard@redhat.com

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> It might happen that we try to free an already freed pointer.
Tomas> Tomas

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
