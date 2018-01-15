From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [RFC 1/2] mpt3sas/megaraid_sas : irq poll to avoid CPU hard and
 soft lockups
Date: Mon, 15 Jan 2018 18:00:31 +0530
Message-ID: <b9ee2a9a5429f56b5ead8e6197a3bc84@mail.gmail.com>
References: <eca669d88fbd468c5dad2c9940632fff@mail.gmail.com> <20180115121919.ux3owxg7fozfmnv7@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:44547 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933102AbeAOMad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 07:30:33 -0500
Received: by mail-io0-f196.google.com with SMTP id k18so12884305ioc.11
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 04:30:33 -0800 (PST)
In-Reply-To: <20180115121919.ux3owxg7fozfmnv7@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Peter Rivera <peter.rivera@broadcom.com>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, January 15, 2018 5:49 PM
> To: Kashyap Desai
> Cc: linux-scsi@vger.kernel.org; Peter Rivera
> Subject: Re: [RFC 1/2] mpt3sas/megaraid_sas : irq poll to avoid CPU hard
and
> soft lockups
>
> On Mon, Jan 15, 2018 at 05:42:35PM +0530, Kashyap Desai wrote:
> > Patch for Fix-1 explained in PATCH 0.
>
> Ahm, PATCH 0 a.k.a the cover letter doesn't get merged so the git
history
> won't have an explanation at all. Please write a proper commit message.

For now I am looking for input from linux community regarding approach
used in my solution.
I will convert RFC to PATCH and most suitable header I will attach with
each patch. Hope it is OK.

Current RFC has changes included for mpt3sas. Same logic will be followed
for megaraid_sas as well. Just for reference I have posted changes of
mpt3sas and not included megaraid_sas.


>
> Thanks,
> 	Johannes
>
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton HRB 21284 (AG
> N=C3=BCrnberg) Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969=
D 2D76
> 0850
