From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH] dead code and missing statics in lpfc
Date: Thu, 10 Jun 2004 12:17:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040610111746.GB1140@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F947B@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:7572 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263295AbUFJLRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 07:17:48 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F947B@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 09, 2004 at 07:08:55AM -0400, Smart, James wrote:
> So...
> 
> I agree that symbols such as this are not desired, but... If this is the
> stance of the linux-scsi group - it says:
> 
> - For vendors such as ourselves, the driver that we put through extensive
> qualification and testing - real, repeated, extended run time on many
> platforms, distributions, and in many different configurations - will NEVER
> be the same driver that is ultimately shipped with the kernel. Use of the
> kernel-supplied driver will ALWAYS be a calculated risk.
> 
> - This implies that - for any production system wanting support - you are
> MANDATING that the user replace the kernel-supplied driver with the vendor's
> driver. 

Well, ba strategy for Emulex than and you can be sure any kerneldeveloper
will not recommend Emulex hardware for such a braindead policy then.  Given
the code quality of the Emulex driver it's pretty obvious that youre QA tests
didn't find some of the most obvious bugs.  Anyway, another good example for
my talk on Saturday ;-)

> - And lastly, although not as important, you are dictating that, for a
> kernel-level entity, there is never an opportunity for them to extend their
> product set by providing extra add-in or helper modules. This limitation is
> reasonable for kernel protection - but it pushes the user, who wants the
> features, back to the vendor's replacement driver.

Exactly that's what we're doing.  Opensource your ibjection module and
integrate it with the driver release an everything is fine.

> - Ultimately, the byproduct of the above is, you are also focusing the
> vendor away from the base kernel. Any effort to extend the driver, it's
> feature set, etc - regardless of whether those features/extensions would be
> good for the kernel or scsi subsystem overall, will be focused solely on the
> mandated replacement driver. The kernel-supplied driver becomes a "put in
> the least effort necessary" choice.

Well, bad luck.  With that stance from Emulex we'd better stop any work on
getting it included if you're not interested in it beeing a 1st class citicen.


What you're missing is that the Linux kernel can very well live without a
Emulex driver, but it will hurt Emulex if it's not properly supported by
Linux.
