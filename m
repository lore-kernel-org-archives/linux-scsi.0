From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.5.56 aha1542 driver
Date: Sat, 11 Jan 2003 18:06:32 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111180632.A3178@infradead.org>
References: <200301111839.34330.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301111839.34330.russell@coker.com.au>; from russell@coker.com.au on Sat, Jan 11, 2003 at 06:39:34PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Russell Coker <russell@coker.com.au>
Cc: linux-scsi@vger.kernel.org

On Sat, Jan 11, 2003 at 06:39:34PM +0100, Russell Coker wrote:
> In 2.4.x kernels you could compile it with such options.  Ideally in 2.5.x it
> would still be possible to compile such a configuration, but it would be OK
> if the kernel configuration refused to allow AHA1542 to be supported without
> ISAPNP.

The real problem is that the driver hasn't been updated to the new pnp layer
that got introduced lately without updating most of the pnp-capable drivers..

