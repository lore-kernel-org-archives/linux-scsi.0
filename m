From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Thu, 7 Aug 2003 17:20:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807172028.A13400@infradead.org>
References: <1060042082.1985.53.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:53770 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S270208AbTHGQUa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 12:20:30 -0400
Content-Disposition: inline
In-Reply-To: <1060042082.1985.53.camel@fuzzy>; from James.Bottomley@steeleye.com on Mon, Aug 04, 2003 at 08:54:55PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 04, 2003 at 08:54:55PM -0700, James Bottomley wrote:
> 1. Multi-path is relevant to more layers of the I/O stack than just
> SCSI. Thus, it makes sense to do it at the layer just above bio.  This
> would either be md/multipath or the Device Mapper multi-path module.

Are the compatible?  What's the downside of one vs another?

> 4. Configuration of this solution would be extremely important.  The
> idea here is to rely on the udev solution currently making its way into
> the kernel and essentially have a vendor specific multi-path
> configuration as a udev plug-in.
> 
> 5. Vendor value add for specific devices could be encoded both as
> configuration (udev) pieces and plug-ins to the upper layer multi-path
> driver to activate any proprietary vendor specific configuration options
> that may be needed for specific solutions.

What are examples of such value add?
 
