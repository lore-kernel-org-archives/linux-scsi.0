From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid: fix null pointer check in megasas_detach_one().
Date: Fri, 5 Feb 2016 18:04:38 +0530
Message-ID: <a44b1632f8ce5b13be5e1e1bf79cae9a@mail.gmail.com>
References: <1453466502-9335-1-git-send-email-mlombard@redhat.com>
	<yq1d1sfop1n.fsf@sermon.lab.mkp.net>	<ab1dc36c2043384f7058d05cf19cd16b@mail.gmail.com>
 <yq17filjj68.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:34287 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbcBEMel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 07:34:41 -0500
Received: by mail-lf0-f42.google.com with SMTP id j78so56209208lfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Feb 2016 04:34:40 -0800 (PST)
In-Reply-To: <yq17filjj68.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Uday Lingala <uday.lingala@broadcom.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, thenzl@redhat.com

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, February 04, 2016 8:07 AM
> To: Sumit Saxena
> Cc: Martin K. Petersen; Maurizio Lombardi; sumit.saxena@broadcom.com;
> kashyap.desai@broadcom.com; uday.lingala@broadcom.com; linux-
> scsi@vger.kernel.org; James Bottomley; thenzl@redhat.com
> Subject: Re: [PATCH] megaraid: fix null pointer check in
megasas_detach_one().
>
> >>>>> "Sumit" == Sumit Saxena <sumit.saxena@broadcom.com> writes:
>
> Sumit,
>
> Sumit> Patch looks good but it needs to be rebased with latest repo as
> Sumit> very recently you have checked in few megaraid_sas patches and
> Sumit> there are two critical patches for megaraid_sas are yet pending.
>
> You still need to respond to Tomas' comments to:
>
> [PATCH 1/2] megaraid_sas: Fix for IO failing post OCR in SRIOV
environment

Sorry for delay. I responded to Tomas query.
>
> Sumit> Once we get status of those two outstanding patches, I will ask
> Sumit> submitter to rebase and send this patch again or I will be
> Sumit> resending.
>
> Rebase? The patch fixes a bug and it applies cleanly. That's all that
matters.
Ok, sorry for confusion. I was expecting those two critical patches
getting accepted before this patch as adding this patch first may cause
those 2 patches getting failed.
Anyways, this patch is committed now so if those 2 patches get applied
cleanly on top on new repo, that's well otherwise I may need to resend
those 2 patches.

Thanks,
Sumit
>
> --
> Martin K. Petersen	Oracle Linux Engineering
