From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid: fix null pointer check in megasas_detach_one().
Date: Wed, 3 Feb 2016 10:12:26 +0530
Message-ID: <ab1dc36c2043384f7058d05cf19cd16b@mail.gmail.com>
References: <1453466502-9335-1-git-send-email-mlombard@redhat.com> <yq1d1sfop1n.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35509 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbcBCEm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 23:42:29 -0500
Received: by mail-lb0-f175.google.com with SMTP id bc4so5095475lbc.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Feb 2016 20:42:28 -0800 (PST)
In-Reply-To: <yq1d1sfop1n.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>
Cc: sumit.saxena@avagotech.com, kashyap.desai@avagotech.com, uday.lingala@avagotech.com, linux-scsi@vger.kernel.org, jbottomley@parallels.com, thenzl@redhat.com

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, February 02, 2016 7:24 AM
> To: Maurizio Lombardi
> Cc: sumit.saxena@avagotech.com; kashyap.desai@avagotech.com;
> uday.lingala@avagotech.com; linux-scsi@vger.kernel.org;
> jbottomley@parallels.com; thenzl@redhat.com
> Subject: Re: [PATCH] megaraid: fix null pointer check in
megasas_detach_one().
>
> >>>>> "Maurizio" == Maurizio Lombardi <mlombard@redhat.com> writes:
>
> Maurizio> The pd_seq_sync pointer can't be NULL, we have to check its
> Maurizio> entries instead.
>
> Sumit?
Martin,
Patch looks good but it needs to be rebased with latest repo as very
recently you have checked in few megaraid_sas patches and there are two
critical patches for megaraid_sas are yet pending.
Once we get status of those two outstanding patches, I will ask submitter
to rebase and send this patch again or I will be resending.

Thanks,
Sumit
>
> --
> Martin K. Petersen	Oracle Linux Engineering
