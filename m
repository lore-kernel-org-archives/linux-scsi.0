From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [PATCH] dead code and missing statics in lpfc
Date: Wed, 9 Jun 2004 07:08:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F947B@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39933 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265727AbUFILJI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 07:09:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

So...

I agree that symbols such as this are not desired, but... If this is the
stance of the linux-scsi group - it says:

- For vendors such as ourselves, the driver that we put through extensive
qualification and testing - real, repeated, extended run time on many
platforms, distributions, and in many different configurations - will NEVER
be the same driver that is ultimately shipped with the kernel. Use of the
kernel-supplied driver will ALWAYS be a calculated risk.

- This implies that - for any production system wanting support - you are
MANDATING that the user replace the kernel-supplied driver with the vendor's
driver. 

- And lastly, although not as important, you are dictating that, for a
kernel-level entity, there is never an opportunity for them to extend their
product set by providing extra add-in or helper modules. This limitation is
reasonable for kernel protection - but it pushes the user, who wants the
features, back to the vendor's replacement driver.

- Ultimately, the byproduct of the above is, you are also focusing the
vendor away from the base kernel. Any effort to extend the driver, it's
feature set, etc - regardless of whether those features/extensions would be
good for the kernel or scsi subsystem overall, will be focused solely on the
mandated replacement driver. The kernel-supplied driver becomes a "put in
the least effort necessary" choice.

I know that I'm a bit strong in the statements above - but it is the reality
we are facing when trying to support Linux. This grinds me, as our desire is
to be 100% behind the kernel-supplied driver and it's community, not to be
doing replacement kits that just circumvent things.


-- James



> -----Original Message-----
> From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> Sent: Wednesday, June 09, 2004 4:56 AM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] dead code and missing statics in lpfc
> 
> <snip...>
> 
> In either case exported symbols in the driver and dead 
> symbols are completely
> uninteresting for a kernel submission, so make sure you get 
> rid of them
> before you try to submit the driver.
> 
