From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/5] PCI : Move pci_fixup_device and is_enabled
Date: Wed, 22 Nov 2006 19:34:51 -0800
Message-ID: <20061123033451.GB15439@kroah.com>
References: <456404EF.3090902@jp.fujitsu.com> <20061122180901.GD378@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755091AbWKWDlT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20061122180901.GD378@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz, Andrew Morton <akpm@osdl.org>, e1000-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 22, 2006 at 11:09:01AM -0700, Grant Grundler wrote:
> On Wed, Nov 22, 2006 at 05:06:07PM +0900, Hidetoshi Seto wrote:
> > --- linux-2.6.19-rc6.orig/drivers/pci/pci.c
> > +++ linux-2.6.19-rc6/drivers/pci/pci.c
> > @@ -558,12 +558,18 @@
> >  {
> >  	int err;
> > 
> > +	if (dev->is_enabled)
> > +		return 0;
> 
> This is unfortunately going to collide with the previous
> patch posted by inaky@linux.intel.com:
> 
>     Subject: [patch 0/2] pci: make pci_{enable,disable}_device() be nested

Not a problem, that's what I'm here for :)

thanks,

greg k-h
