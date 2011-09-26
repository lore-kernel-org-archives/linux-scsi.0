From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] libsas: set sas_address and device type of rphy
Date: Mon, 26 Sep 2011 08:47:42 +0800
Message-ID: <FDD03A452EDF4547818E22F25EDC647F@usish.com.cn>
References: <67EFB401F0334372A629F8C2A4AFADDD@usish.com.cn> <CAA9_cmdgV_2DWiLCAcEoda_wajcVXZ23gVPQYru=PagA=B-odw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:34314 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab1IZAr0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2011 20:47:26 -0400
In-Reply-To: <CAA9_cmdgV_2DWiLCAcEoda_wajcVXZ23gVPQYru=PagA=B-odw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: 'James Bottomley' <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, 'Xiangliang Yu' <yuxiangl@marvell.com>, 'Mark Salyzyn' <mark_salyzyn@us.xyratex.com>, 'Luben Tuikov' <ltuikov@yahoo.com>, lindar_liu@usish.com, =?UTF-8?B?J+S6jueIseWNjic=?= <crystal_yu@usish.com>

Hi Dan,

Sorry for my mistake and thanks for your fix.
Re: [PATCH] libsas: set sas_address and device type of rphy
> 
> 2011/9/22 Jack Wang <jack_wang@usish.com>:
> > Hi James,
> >
> > Libsas forget to set the sas_address and device type of rphy lead to file
> > under /sys/class/sas_x show wrong value, fix that.
> >
> > From 976849ae6da4bc454a89d91b98824c915d3c99a2 Mon Sep 17 00:00:00 2001
> > From: Jack Wang <jack_wang@usish.com>
> > Date: Fri, 23 Sep 2011 14:19:24 +0800
> > Subject: [PATCH] set rphy sas_address and device type correctly
> >
> > Signed-off-by: Jack Wang <jack_wang@usish.com>
> > Tested-by: Crystal Yu <crystal_yu@usish.com>
> > ---
> >  sas_expander.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Hi Jack, quick note, this patch does not apply...
> 
> > diff --git a/sas_expander.c b/sas_expander.c
> > index 874e29d..4ad0a40 100644
> > --- a/sas_expander.c
> > +++ b/sas_expander.c
> 
> ...should be:
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> 
> I went ahead and fixed this up.
> 
> --
> Dan

