From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH]  2.4.23-pre8 driver udpate for MPT Fusion (2.05.10)
Date: Sat, 25 Oct 2003 14:05:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031025210550.GB23437@kroah.com>
References: <0E3FA95632D6D047BA649F95DAB60E57035A9458@exa-atlanta.se.lsil.com> <20031025191828.GA17144@kroah.com> <20031025204405.GB5172@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from storm.he.net ([64.71.150.66]:33517 "HELO storm.he.net")
	by vger.kernel.org with SMTP id S262955AbTJYVGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2003 17:06:33 -0400
Content-Disposition: inline
In-Reply-To: <20031025204405.GB5172@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: "Moore, Eric Dean" <emoore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Oct 25, 2003 at 09:44:05PM +0100, Matthew Wilcox wrote:
> On Sat, Oct 25, 2003 at 12:18:28PM -0700, Greg KH wrote:
> > On Fri, Oct 24, 2003 at 11:12:25AM -0400, Moore, Eric Dean wrote:
> > > I'm going to be working on that.
> > > Can't say when its going to be ready.
> > 
> > How about support for all of the pci hotplug systems on 2.4 that are
> > shipping today? 
> 
> The SCSI system isn't really capable of supporting hotplug PCI in 2.4.

Yeah, but some drivers almost do (Adaptec comes to mind.)  It will work
in a pci hotplug system, while other scsi drivers will not work at all.

thanks,

greg k-h
