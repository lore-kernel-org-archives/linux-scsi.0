From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 21:49:23 -0700
Message-ID: <20080925044923.GA4310@kroah.com>
References: <4C94DE2070B172459E4F1EE14BD2364E01F27D19@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37875 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYIYEuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2008 00:50:15 -0400
Content-Disposition: inline
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F27D19@HQ-EXCH-5.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>

On Wed, Sep 24, 2008 at 08:56:14PM -0700, Jing Huang wrote:
> --- orig/drivers/scsi/bfa/bfad_attr.c	1969-12-31 16:00:00.000000000
> -0800
> +++ patch/drivers/scsi/bfa/bfad_attr.c	2008-09-24 12:08:23.000000000
> -0700
> @@ -0,0 +1,660 @@
> +/*
> + * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
> + * All rights reserved
> + * www.brocade.com
> + *
> + * Linux driver for Brocade Fibre Channel Host Bus Adapter.
> + *
> + * This program is free software; you can redistribute it and/or modify
> it

Your patch is line-wrapped and can't be applied :(

Also, did I miss a [0/6] patch that describes this driver and what it is
all about?

Care to try again?

thanks,

greg k-h
