From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 02/12] megaraid_sas : Code optimization- remove PCI Ids
 based checks
Date: Wed, 28 Oct 2015 13:13:42 +0530
Message-ID: <8e8133a4c138153187671ddf75181b8b@mail.gmail.com>
References: <201510150816.t9F8GqPJ029555@palmhbs0.lsi.com> <yq1si4v90yp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36029 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbJ1Hno (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2015 03:43:44 -0400
Received: by lffz202 with SMTP id z202so183862037lff.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2015 00:43:43 -0700 (PDT)
In-Reply-To: <yq1si4v90yp.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, October 28, 2015 8:03 AM
> To: sumit.saxena@avagotech.com
> Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
> martin.petersen@oracle.com; hch@infradead.org; jbottomley@parallels.com;
> kashyap.desai@avagotech.com; kiran-kumar.kasturi@avagotech.com;
> uday.lingala@avagotech.com
> Subject: Re: [PATCH 02/12] megaraid_sas : Code optimization- remove PCI
Ids
> based checks
>
> >>>>> "Sumit" == sumit saxena <sumit.saxena@avagotech.com> writes:
>
> Sumit> Code optimization: remove PCI id based checks and instead of
> Sumit> those use instance->ctrl_context to make call whether controller
> Sumit> is MFI based OR fusion adapter.  fusion adapters further are also
> Sumit> divided in two categories- 1)THUNDERBOLT SERIES and 2)INVADER
> Sumit> SERIES.
>
> Does not apply against current upstream. Please fix and repost.

Martin, This patch set is not based on current upstream but rebased on top
of few patches sent by me prior to this patch series. Patches sent prior
to this patch series are not yet accepted.

Thanks,
Sumit
>
> --
> Martin K. Petersen	Oracle Linux Engineering
