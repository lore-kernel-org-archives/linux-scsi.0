From: Borislav Petkov <bp@alien8.de>
Subject: Re: checkpatch: kill the bogus camelcase check
Date: Wed, 10 Apr 2013 17:19:11 +0200
Message-ID: <20130410151911.GG6857@pd.tnic>
References: <1365544254.2946.53.camel@dabdike>
 <20130410132628.GV7511@dm>
 <1365604558.27174.36.camel@joe-AO722>
 <20130410145213.GA6854@pd.tnic>
 <1365606461.1942.3.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1365606461.1942.3.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 10, 2013 at 08:07:41AM -0700, James Bottomley wrote:
> On Wed, 2013-04-10 at 16:52 +0200, Borislav Petkov wrote:
> > On Wed, Apr 10, 2013 at 07:35:58AM -0700, Joe Perches wrote:
> > > or maybe exclude drivers/scsi and include/scsi/
> > 
> > and arch/x86/kvm/emulate.c
> 
> Actually, we get this all over drivers.  Some of the problems are to do
> with the fact that the check is wrong, so it thinks things like this
> 
> drm_core_has_MTRR
> 
> are studly caps when they're not, but we have a lot of device
> programming manual driven studly caps in PCI, ata, ide etc ..
> 
> We also have sanctioned use in mm, things like:
> 
> SetPageReserved
> ClearPageReserved
> 
> But the point still stands.  When checkpatch warns about this, there's
> nothing that the person submitting the patch can do because the usage
> was already embedded into the file they're patching.

Ha, I hit the nail right on the head! :-) This is exactly the reaction I
was aiming at, with mentioning yet another file in the kernel where this
check fires.

Yes, excepting certain files is not a good idea.
Yes, the check needs to go away because it is plain wrong.

Even if its there, I keep ignoring it which makes checkpatch less useful
and trustworthy. So full ACK to the intent to either remove it or make
it a suggestion only.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
