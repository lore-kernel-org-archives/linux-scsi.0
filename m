From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
Date: Thu, 25 Sep 2008 21:19:26 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F28072@HQ-EXCH-5.corp.brocade.com>
References: <200809260054.m8Q0slEL027478@swe37.brocade.com> <20080926025256.GB9480@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx20.brocade.com ([66.243.153.19]:22732 "EHLO mx20.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYIZETb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 00:19:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080926025256.GB9480@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

Hi Greg, 

Those comments are used by doxygen. We use doxygen to generate
documentation in my company. So I guess this contradicts to linux
kerneldoc. I will look into this.

Yes, the scsi_xx.h file after local one seems strange, I will fix it.

Thanks

Jing





-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Thursday, September 25, 2008 7:53 PM
To: Jing Huang
Cc: James.Bottomley@HansenPartnership.com; linux-kernel@vger.kernel.org;
linux-scsi@vger.kernel.org; Ramkumar Vadivelu; Srikanth Rayas (CW);
Vinodh Ravindran
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission
(2ndtry)

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
