From: "'hch@infradead.org'" <hch@infradead.org>
Subject: Re: ANNOUNCE: megaraid driver version 2.10.1
Date: Sun, 11 Jan 2004 14:06:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040111140640.A21952@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC2AA@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC2AA@exa-atlanta.se.lsil.com>; from Atulm@lsil.com on Fri, Jan 09, 2004 at 06:54:09PM -0500
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "'torvalds@osdl.org'" <torvalds@osdl.org>, "'marcelo.tosatti@cyclades.com'" <marcelo.tosatti@cyclades.com>, Matt_Domsch@dell.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 09, 2004 at 06:54:09PM -0500, Mukker, Atul wrote:
> All,
> 
> The megaraid driver version 2.10.1 is released and can be downloaded from
> ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.10.1/
> 
> Following other components are also available at this location:
> i.	Patches for Red Hat and SuSE stock kernels

Can't find patches for mainline anywhere.  Also it's usually a good
idea to send the _patches_ to lkml for review.

I've diffed the driver against the 2.4 megaraid2 driver and it looks
mostly sane, the 2.6 version OTOH copletly backs out the changes that
went into the driver from outside LSI.  Please try to port the changes
you made to the driver in 2.6.1.
