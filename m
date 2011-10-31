From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 4/5] hpsa: fix potential array overflow in hpsa_update_scsi_devices
Date: Mon, 31 Oct 2011 09:36:06 -0500
Message-ID: <20111031143606.GQ6635@beardog.cce.hp.com>
References: <20111026212006.15570.26229.stgit@beardog.cce.hp.com> <20111026212112.15570.72971.stgit@beardog.cce.hp.com> <1319969782.5215.23.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1319969782.5215.23.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 30, 2011 at 02:16:22PM +0400, James Bottomley wrote:
> On Wed, 2011-10-26 at 16:21 -0500, Stephen M. Cameron wrote:
> > From: Scott Teel <scott.teel@hp.com>
> > 
> > The currentsd[] array in hpsa_update_scsi_devices had room for
> > 256 devices.  The code was iterating over however many physical
> > and logical devices plus an additional number of possible external
> > MSA2XXX controllers, which together could potentially exceed 256.
> > 
> > We increased the size of the currentsd array to 1024 + 1024 + 32 + 1
> > elements to reflect a reasonable maximum possible number of devices
> > which might be encountered.  We also don't just walk off the end
> > of the array if the array controller reports more devices than we
> > are prepared to handle, we just ignore the excessive devices.
> > 
> > Signed-off-by: Scott Teel <scott.teel@hp.com>
> > Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> This should be Signed-off-by not Acked-by.  The reason is that the
> signoffs track whose hands the patch passes through.  If you send
> Scott's patch to me, it must have your signoff.  If Scott sends the
> patch directly to me and then you OK it on the list, then I'll add
> Acked-by.  I've assumed your acquiescence to correcting this in my tree.
> 
> James
> 

Thanks James.  

I don't often have patches from other people to forward, so I tend to
forget how it's supposed to work.   I'll try to remember that for next time.

-- steve
