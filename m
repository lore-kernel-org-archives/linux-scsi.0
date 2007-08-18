From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] add use_sg_chaining option to scsi_host_template
Date: Sat, 18 Aug 2007 18:52:32 +0900
Message-ID: <20070818064737O.tomof@acm.org>
References: <200708161648.l7GGm15B000923@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50384 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbXHRJwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2007 05:52:41 -0400
In-Reply-To: <200708161648.l7GGm15B000923@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

On Fri, 17 Aug 2007 01:47:59 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> This is for Jens' sglist branch in the block git tree.
> 
> It enables sg chaining support for the LLDs that use scsi_for_each_sg
> accessor properly.
> 
> ---
> >From a6e50a3b476bc193de103e8c1d95877ced38918e Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Fri, 17 Aug 2007 01:35:41 +0900
> Subject: [PATCH] add use_sg_chaining option to scsi_host_template
> 
> This option is true if a low-level driver can support sg
> chaining. This will be removed eventually when all the drivers are
> converted to support sg chaining. q->max_phys_segments is set to
> SCSI_MAX_SG_SEGMENTS if false.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/ia64/hp/sim/simscsi.c            |    1 +
>  drivers/scsi/3w-9xxx.c                |    1 +
>  drivers/scsi/3w-xxxx.c                |    1 +
>  drivers/scsi/BusLogic.c               |    1 +
>  drivers/scsi/NCR53c406a.c             |    3 ++-
>  drivers/scsi/a100u2w.c                |    1 +
>  drivers/scsi/aacraid/linit.c          |    1 +
>  drivers/scsi/aha1740.c                |    1 +
>  drivers/scsi/aic7xxx/aic79xx_osm.c    |    1 +
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    1 +
>  drivers/scsi/aic7xxx_old.c            |    1 +
>  drivers/scsi/arcmsr/arcmsr_hba.c      |    1 +
>  drivers/scsi/dc395x.c                 |    1 +
>  drivers/scsi/dpt_i2o.c                |    1 +
>  drivers/scsi/eata.c                   |    3 ++-
>  drivers/scsi/hosts.c                  |    1 +
>  drivers/scsi/hptiop.c                 |    1 +
>  drivers/scsi/ibmmca.c                 |    1 +
>  drivers/scsi/ibmvscsi/ibmvscsi.c      |    1 +
>  drivers/scsi/initio.c                 |    1 +
>  drivers/scsi/ipr.c                    |    1 +

I should have dropped ipr since we haven't converted libata yet.
