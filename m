From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_transport_sas: remove local_attached flag
Date: Tue, 29 Aug 2006 12:47:17 +0100
Message-ID: <20060829114717.GF4076@infradead.org>
References: <1156531698.3462.11.camel@mulgrave.il.steeleye.com> <20060828093012.GB8980@infradead.org> <1156773696.3465.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51385 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964960AbWH2LrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 07:47:24 -0400
Content-Disposition: inline
In-Reply-To: <1156773696.3465.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsil.com>

On Mon, Aug 28, 2006 at 09:01:36AM -0500, James Bottomley wrote:
> On Mon, 2006-08-28 at 10:30 +0100, Christoph Hellwig wrote:
> > You can of course do the reset and stats using the normal smp code from
> > libsas for fusion aswell.  I just added the flag as a quick hack because
> > I was waiting for the libsas merge to implement this instead of adding
> > a mptsas-specific implementation.
> 
> Well ... we need an SMP input for that, which mptsas doesn't provide.
> If it did, we could move SMP execution out of libsas into the transport
> class proper and use it for the non-local expander stuff.

I had something like that for the experimental SG_IO SMP passthrough
patch.  I'll see if I can do something useful once I get some time
allocated for it.
