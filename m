From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Tue, 10 Dec 2002 13:14:11 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021210131411.A30930@infradead.org>
References: <203630000.1039477998@aslan.btc.adaptec.com> <20021210001256.A9363@infradead.org> <244760000.1039480419@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <244760000.1039480419@aslan.btc.adaptec.com>; from gibbs@scsiguy.com on Mon, Dec 09, 2002 at 05:33:40PM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linus Torvalds <torvalds@transmeta.com>

On Mon, Dec 09, 2002 at 05:33:40PM -0700, Justin T. Gibbs wrote:
> I don't see why they are necessary.  The usual reasons for patches are:
> 
> 1) To review the changes
>    With the exception of Doug Ledford, I doubt that many others bother
>    to understand how the aic7xxx drivers work

Even if I don't unserstand all of the aic7xxx driver I do understand the linux
scsi midlayer and DDI interface.

> 
> 2) To avoid conflicts with other developers
>    Who else is maintaining this driver?  Except for a few minor changes
>    to the SCSI Makefile and Kconfig/Config.in file, all of the changes
>    are contained within the aic7xxx directory.

Even if not many people are working on aic7xx directly the scsi midlayer
and the linux DDI are changing.  I.e. your tarball that I downloaded
yetserday doesn't seem to deal with Doug's slave_* changes yet.

Similarly I am working on making aic7xxx exploit the PCI driver API
properly and use scsi_add_host/scsi_remove_host to properly support
hotplugging.  Having the diffs to look at makes merging a lot easier.

> 
> Of course, I'll happily generate patches against whatever kernel versions
> the power that be want me to if it will help a driver update to occur.

I'll have a box with three aic7xxx of different types and a hotplug pci
controller at work and I'd like to help integrating both your updates and
my hotplug pci changes (which I'll send you and linux-scsi for review one
done of course) into mainline.

For 2.4 the APIs are stable so Alan and Marcelo should just grab it.  Of
course they prefer patches for applying because that's how linux development
works.. :)
