From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH 1/7] megaraid_sas : Driver version upgrade
Date: Wed, 12 Nov 2014 16:43:09 +0530
Message-ID: <b74d3f1d51c13b444c5d8c47079243d8@mail.gmail.com>
References: <201411101224.sAACOcKw018039@palmhbs0.lsi.com> <546212BC.5070906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:40122 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKLLNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 06:13:12 -0500
Received: by mail-la0-f54.google.com with SMTP id s18so11261245lam.13
        for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2014 03:13:10 -0800 (PST)
In-Reply-To: <546212BC.5070906@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, aradford@gmail.com

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, November 11, 2014 7:14 PM
> To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; hch@infradead.org;
> jbottomley@parallels.com; kashyap.desai@avagotech.com;
> aradford@gmail.com
> Subject: Re: [PATCH 1/7] megaraid_sas : Driver version upgrade
>
> On 11/10/2014 01:21 PM, Sumit.Saxena@avagotech.com wrote:
> > megaraid_sas driver version upgrade
> >
> > Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas.h      | 2 +-
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> b/drivers/scsi/megaraid/megaraid_sas.h
> > index a49914d..f3eccf1 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas.h
> > +++ b/drivers/scsi/megaraid/megaraid_sas.h
> > @@ -33,7 +33,7 @@
> >  /*
> >   * MegaRAID SAS Driver meta data
> >   */
> > -#define MEGASAS_VERSION				"06.805.06.00-
> rc1"
> > +#define MEGASAS_VERSION				"06.805.06.01-
> rc1"
> >  #define MEGASAS_RELDATE				"Sep. 4, 2014"
> >  #define MEGASAS_EXT_VERSION			"Thu. Sep. 4
17:00:00
> PDT 2014"
>
> Usually you have changed the dates too, but this not important, feel
free to
> ignore  it.

Agree that we always keep  version/date sync-up in same patch.
I think having RELDATE is not really helpful and I see only megaraid_sas
driver use this.

Probably we should keep only VERSION and remove RELDATE and EXT_VERSION

>
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index f6a69a3..36f463c 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -18,7 +18,7 @@
> >   *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
02111-1307
> USA
> >   *
> >   *  FILE: megaraid_sas_base.c
> > - *  Version : 06.805.06.00-rc1
> > + *  Version : 06.805.06.01-rc1
> >   *
> >   *  Authors: LSI Corporation
> >   *           Sreenivas Bagalkote
