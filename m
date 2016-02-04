From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid: fix null pointer check in megasas_detach_one().
Date: Wed, 03 Feb 2016 21:36:31 -0500
Message-ID: <yq17filjj68.fsf@sermon.lab.mkp.net>
References: <1453466502-9335-1-git-send-email-mlombard@redhat.com>
	<yq1d1sfop1n.fsf@sermon.lab.mkp.net>
	<ab1dc36c2043384f7058d05cf19cd16b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40438 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbcBDCgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 21:36:46 -0500
In-Reply-To: <ab1dc36c2043384f7058d05cf19cd16b@mail.gmail.com> (Sumit Saxena's
	message of "Wed, 3 Feb 2016 10:12:26 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>, sumit.saxena@broadcom.com, kashyap.desai@broadcom.com, uday.lingala@broadcom.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, thenzl@redhat.com

>>>>> "Sumit" == Sumit Saxena <sumit.saxena@broadcom.com> writes:

Sumit,

Sumit> Patch looks good but it needs to be rebased with latest repo as
Sumit> very recently you have checked in few megaraid_sas patches and
Sumit> there are two critical patches for megaraid_sas are yet pending.

You still need to respond to Tomas' comments to:

[PATCH 1/2] megaraid_sas: Fix for IO failing post OCR in SRIOV environment

Sumit> Once we get status of those two outstanding patches, I will ask
Sumit> submitter to rebase and send this patch again or I will be
Sumit> resending.

Rebase? The patch fixes a bug and it applies cleanly. That's all that
matters.

-- 
Martin K. Petersen	Oracle Linux Engineering
