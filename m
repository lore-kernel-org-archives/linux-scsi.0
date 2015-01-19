From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] aha1542: Stop using scsi_module.c
Date: Mon, 19 Jan 2015 00:57:53 -0800
Message-ID: <20150119085753.GC15809@infradead.org>
References: <1421447489-28835-1-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbASI5z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2015 03:57:55 -0500
Content-Disposition: inline
In-Reply-To: <1421447489-28835-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Jan 16, 2015 at 11:31:29PM +0100, Ondrej Zary wrote:
> Convert aha1542 to use scsi_add_host instead of scsi_module.c
> Use pnp_driver and isa_driver to manage cards.
> 
> I hope that the PnP code is OK, don't have a PnP card to test.
> 
> The code needs much more work, there's a lot of things to delete.

Thanks this looks pretty nice to me.  The use of the ->match for the isa
driver looks weird, but lots of the isa drivers seem to do it that way.
