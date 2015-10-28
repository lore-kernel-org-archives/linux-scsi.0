From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH 02/12] megaraid_sas : Code optimization- remove PCI Ids
 based checks
Date: Wed, 28 Oct 2015 20:00:47 +0530
Message-ID: <c184826206ec6525b7ecb9e034cb6368@mail.gmail.com>
References: <201510150816.t9F8GqPJ029555@palmhbs0.lsi.com> <yq1si4v90yp.fsf@sermon.lab.mkp.net>
 <8e8133a4c138153187671ddf75181b8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33220 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965482AbbJ1Oau (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2015 10:30:50 -0400
Received: by lffv3 with SMTP id v3so4625270lff.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2015 07:30:48 -0700 (PDT)
In-Reply-To: <8e8133a4c138153187671ddf75181b8b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

>
> > -----Original Message-----
> > From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> > Sent: Wednesday, October 28, 2015 8:03 AM
> > To: sumit.saxena@avagotech.com
> > Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
> > martin.petersen@oracle.com; hch@infradead.org;
> > jbottomley@parallels.com; kashyap.desai@avagotech.com;
> > kiran-kumar.kasturi@avagotech.com;
> > uday.lingala@avagotech.com
> > Subject: Re: [PATCH 02/12] megaraid_sas : Code optimization- remove
> > PCI
> Ids
> > based checks
> >
> > >>>>> "Sumit" == sumit saxena <sumit.saxena@avagotech.com> writes:
> >
> > Sumit> Code optimization: remove PCI id based checks and instead of
> > Sumit> those use instance->ctrl_context to make call whether
> > Sumit> controller is MFI based OR fusion adapter.  fusion adapters
> > Sumit> further are also divided in two categories- 1)THUNDERBOLT
> > Sumit> SERIES and 2)INVADER SERIES.
> >
> > Does not apply against current upstream. Please fix and repost.
>
> Martin, This patch set is not based on current upstream but rebased on top
> of few patches sent by me prior to this patch series. Patches sent prior
> to
> this patch series are not yet accepted.

Martin -

Here is last outstanding patch series.
http://marc.info/?l=linux-scsi&m=144102204225400&w=2

Last patch series was missed because of small rebase issue. James suggested
not to ACK anything which is not critical to avoid such issue and probably
piggy back those patches.
Last series and latest series has reviewed-by tags. Can we have outstanding
patches committed in next window ?

>
> Thanks,
> Sumit
> >
> > --
> > Martin K. Petersen	Oracle Linux Engineering
