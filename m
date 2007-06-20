From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix req->cmd == INT cases
Date: Wed, 20 Jun 2007 13:26:56 +0100
Message-ID: <20070620122656.GA4620@infradead.org>
References: <4677FD50.2090803@panasas.com> <20070619171610.GH18863@kernel.dk> <4679072C.2010604@panasas.com> <20070620122247.GA4443@infradead.org> <20070620122409.GU18863@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35995 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbXFTM06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2007 08:26:58 -0400
Content-Disposition: inline
In-Reply-To: <20070620122409.GU18863@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 02:24:09PM +0200, Jens Axboe wrote:
> > These are old cdrom drivers that are broken in various ways and probably
> > should be killed off aswell.
> 
> I agree (with both sentiments), would anyone mind if I just killed them
> off? mitsumi support is being reworked, that can get reintroduced once
> the driver is in a stable state.

Yeah - the new mitsumi doesn't share anything with the old one anyway.
