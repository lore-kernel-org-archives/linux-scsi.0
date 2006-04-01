From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 01 Apr 2006 19:56:29 +0200
Message-ID: <1143914189.3076.20.camel@laptopd505.fenrus.org>
References: <20060401172104.GA16921@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from morbo.e-centre.net ([66.154.82.3]:63981 "EHLO
	cubert.e-centre.net") by vger.kernel.org with ESMTP
	id S1750786AbWDAR4k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Apr 2006 12:56:40 -0500
In-Reply-To: <20060401172104.GA16921@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Sat, 2006-04-01 at 19:21 +0200, Christoph Hellwig wrote:
> Overriding the whole EH code is a per-transport, not per-host thing.
> Move ->eh_strategy_handler to the transport class, same as
> ->eh_timed_out.


I like it, nice cleanup and it's fundamentally the right place to do it


