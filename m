From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Tue, 27 Sep 2005 22:07:07 -0400
Message-ID: <4339FACB.2090606@pobox.com>
References: <4339440C.6090107@adaptec.com>	 <20050927131959.GA30329@infradead.org>  <43395ED0.6070504@adaptec.com> <1127836380.4814.36.camel@mulgrave> <43399F17.4090004@adaptec.com> <4339ACDA.3090801@pobox.com> <4339BD58.7060300@adaptec.com> <4339C12C.5020004@pobox.com> <4339CFC7.6080507@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965253AbVI1CHZ@vger.kernel.org>
In-Reply-To: <4339CFC7.6080507@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 09/27/05 18:01, Jeff Garzik wrote:
>>Just follow the recipe Christoph outlined.  It's not difficult, just 
>>requires some work.
> 
> 
> Anyone have a clear technical plan and/or infrastructure
> on how to do this?  Any specs, plans, consolidations, etc?

Yes, read Christoph's todo list.

We need to separate out bits specific to parallel SCSI, moving the bits 
to transport-specific code, since SAS doesn't need them.


>>It does an end run around 90% of the SCSI core.  You might as well make 
>>it a block driver, if you're going to do that.
> 
> 
> The "90%" part isn't quite true.
> 
> But going with a block device isn't that bad:
> Now since the architecture _is_ SCSI after all, what would be
> needed is a minimal, fast, straightforward, SAM/SPC fully complient
> new SCSI Core.  That SCSI Core would register block devices
> with the block layer.  Maybe Jens can point out cool things
> to do and make the whole infrastructure fast and very fast.
> (since we don't need to be bound by this legacy stuff)
> 
> Essentially other new technology LLDD and Transport layers
> can probably make use of this: Infiniband, USB2 Storage, etc.
> 
> So if all you have is an AIC-94xx or BCM8603 storage chip
> you can exclule all of the legacy SCSI Core and compile this
> new mean, lean, fast SAM Core.
> 
> Jeff, this isn't bad at all!
> 
> Are you willing to contribute to such an effort?

No.  I'm much more willing to help integrate aic94xx and 
Broadcom/ServerWorks into the existing SCSI core, working with the 
community.

As Andrew guessed, it's a way to get you your own playpen, where you 
won't be constrained by members of the Linux-SCSI community.

	Jeff
