From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add spi attributes to qla1280
Date: Wed, 11 Aug 2004 23:22:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040811232225.A1192@infradead.org>
References: <20040810230552.GA26569@sgi.com> <20040811081118.A26256@infradead.org> <20040811215651.GA30821@sgi.com> <20040811230555.A984@infradead.org> <20040811221636.GA31154@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:3087 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268275AbUHKWWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 18:22:31 -0400
Content-Disposition: inline
In-Reply-To: <20040811221636.GA31154@sgi.com>; from jeremy@sgi.com on Wed, Aug 11, 2004 at 03:16:36PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, Aug 11, 2004 at 03:16:36PM -0700, Jeremy Higdon wrote:
> > bk://linux-scsi.bkbits.net/scsi-misc-2.6, it's also part of the
> > latest -mm tree.
> 
> 
> So I'll submit a patch to 2.6.8-rc4-mm1 then, if that's okay.

Sounds good.  While you're at it can you also fix the compilation
error when the driver is compiled for port I/O instead of normal
mmio (e.g. SGI ViswW), you broke that with your readb_relaxed changes.
