From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission (2nd
	try)
Date: Thu, 25 Sep 2008 19:52:56 -0700
Message-ID: <20080926025256.GB9480@kroah.com>
References: <200809260054.m8Q0slEL027478@swe37.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYIZCzM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 22:55:12 -0400
Content-Disposition: inline
In-Reply-To: <200809260054.m8Q0slEL027478@swe37.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, srayas@brocade.com, vravindr@brocade.com

On Thu, Sep 25, 2008 at 05:54:47PM -0700, Jing Huang wrote:
> +/**
> + * @file bfa_attr.c Linux driver configuration interface module.
> + */

What is this, kerneldoc isn't like this, right?

> +#include "bfad_drv.h"
> +#include "bfad_im.h"
> +#include "bfad_trcmod.h"
> +#include <scsi/scsi_transport.h>
> +#include "bfad_attr.h"

Why a scsi .h file after your local ones?

> +
> +/**
> + * @dg FC_transport_template FC transport template
> + * @{
> + */

What is this?

> +/**
> + * @brief
> + * FC transport template entry, get SCSI target port ID.
> + */

Same here, this looks very wierd.  This goes for all of your function
comments :(

thanks,

greg k-h
