From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/16] gdth: Move members from SCp to gdth_cmndinfo, stage 2
Date: Wed, 3 Oct 2007 19:15:57 +0100
Message-ID: <20071003181557.GA10022@infradead.org>
References: <46FFFC8C.6080804@panasas.com> <4700040E.2000007@panasas.com> <200710022002.46919.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53625 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbXJCSQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 14:16:09 -0400
Content-Disposition: inline
In-Reply-To: <200710022002.46919.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Oct 02, 2007 at 08:02:45PM +0200, Rolf Eike Beer wrote:
> volatile here is probably nonsense. Either you need proper locking on this 
> struct in case there may be side-effects between different callers or it's 
> unneeded at all. This looks really suspicious:

Yes, it's most likely wrong.  But for now there's a really huge plate
of patches already, and we'd rather keep behaviour similar.  Once we've
managed to actually test this big pile we can move on to cleaning up things
like that.  And I suspect part of the right solution will be to get rid
of this busy loop entirely.

