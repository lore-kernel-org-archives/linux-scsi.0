From: Christoph Hellwig <hch@infradead.org>
Subject: Re: buslogic-update.patch
Date: Mon, 29 Dec 2003 15:23:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229152310.A28993@infradead.org>
References: <20031229033515.32bc0576.akpm@osdl.org> <20031229115710.A27694@infradead.org> <1072710934.2123.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:42253 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263591AbTL2PXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 10:23:12 -0500
Content-Disposition: inline
In-Reply-To: <1072710934.2123.3.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Dec 29, 2003 at 09:15:33AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, "Randy.Dunlap" <rddunlap@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Dec 29, 2003 at 09:15:33AM -0600, James Bottomley wrote:
> On Mon, 2003-12-29 at 05:57, Christoph Hellwig wrote:
> > On Mon, Dec 29, 2003 at 03:35:15AM -0800, Andrew Morton wrote:
> > > James, can I unload this on you?   Thanks.
> > 
> > The patch needs rework anyway as I outlined to Randy in a previous mail.
> 
> I seem to remember the version I have was reworked (too long ago for
> precise memory, though).  Could you check the BK tree to make sure,
> please?

The patch looks the same to the one in your tree.  The particular missing
bits are:  implementing the eh_abort method based on the old EH code, and
removing all the old EH code so the driver continues to compile when
scsi_obsolete.h is gone (you can check that by commenting it out in scsi.h).

