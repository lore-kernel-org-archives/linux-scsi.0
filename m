From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/5] bnx2fc: Bumped version to 1.0.14
Date: Wed, 01 May 2013 18:05:36 -0700
Message-ID: <1367456736.26485.1.camel@dabdike>
References: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
	 <1362778134-21045-6-git-send-email-bprakash@broadcom.com>
	 <513A79F6.5070301@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49861 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3EBBFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 May 2013 21:05:46 -0400
In-Reply-To: <513A79F6.5070301@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2013-03-08 at 15:53 -0800, Bhanu Prakash Gollapudi wrote:
> On 03/08/2013 01:28 PM, Bhanu Prakash Gollapudi wrote:
> > Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
> > ---
> >   drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
> >   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
> > index 676dba3..1ece6e9 100644
> > --- a/drivers/scsi/bnx2fc/bnx2fc.h
> > +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> > @@ -64,7 +64,7 @@
> >   #include "bnx2fc_constants.h"
> >   
> >   #define BNX2FC_NAME		"bnx2fc"
> > -#define BNX2FC_VERSION		"1.0.13"
> > +#define BNX2FC_VERSION		"1.0.14"
> >   
> >   #define PFX			"bnx2fc: "
> >   
> > diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> > index 1e852d6..9ab62da 100644
> > --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> > +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> > @@ -22,7 +22,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
> >   
> >   #define DRV_MODULE_NAME		"bnx2fc"
> >   #define DRV_MODULE_VERSION	BNX2FC_VERSION
> > -#define DRV_MODULE_RELDATE	"Dec 21, 2012"
> > +#define DRV_MODULE_RELDATE	"Mar 08, 2012"
> James, I realized there was a typo in the date - 2012 instead of 2013.
> 
> Please apply this patch instead. Sorry for the inconvenience.
> 
> 
> Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
> ---
>   drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
> index 676dba3..1ece6e9 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc.h
> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> @@ -64,7 +64,7 @@
>   #include "bnx2fc_constants.h"
> 
>   #define BNX2FC_NAME        "bnx2fc"
> -#define BNX2FC_VERSION        "1.0.13"
> +#define BNX2FC_VERSION        "1.0.14"
> 
>   #define PFX            "bnx2fc: "
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c 
> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 1e852d6..9ab62da 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -22,7 +22,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
> 
>   #define DRV_MODULE_NAME        "bnx2fc"
>   #define DRV_MODULE_VERSION    BNX2FC_VERSION
> -#define DRV_MODULE_RELDATE    "Dec 21, 2012"
> +#define DRV_MODULE_RELDATE    "Mar 08, 2013"

This doesn't actually apply ... your mailer has converted tabs to
spaces.  Since it's only a couple of lines, I fixed it up by hand this
time ...

James


