From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH]  2.4.23-pre8 driver udpate for MPT Fusion (2.05.10)
Date: Sat, 25 Oct 2003 21:44:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031025204405.GB5172@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E57035A9458@exa-atlanta.se.lsil.com> <20031025191828.GA17144@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21199 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262792AbTJYUoJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2003 16:44:09 -0400
Content-Disposition: inline
In-Reply-To: <20031025191828.GA17144@kroah.com>
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "Moore, Eric Dean" <emoore@lsil.com>, Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Oct 25, 2003 at 12:18:28PM -0700, Greg KH wrote:
> On Fri, Oct 24, 2003 at 11:12:25AM -0400, Moore, Eric Dean wrote:
> > I'm going to be working on that.
> > Can't say when its going to be ready.
> 
> How about support for all of the pci hotplug systems on 2.4 that are
> shipping today? 

The SCSI system isn't really capable of supporting hotplug PCI in 2.4.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
