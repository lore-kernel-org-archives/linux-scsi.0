From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Wed, 20 Jun 2007 22:43:16 +0900 (JST)
Message-ID: <20070620223131L.fujita.tomonori@lab.ntt.co.jp>
References: <20070607112309.GY4735@kernel.dk>
	<20070608132326B.fujita.tomonori@lab.ntt.co.jp>
	<20070608152049.GT7341@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:35916 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXFTNn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2007 09:43:58 -0400
In-Reply-To: <20070608152049.GT7341@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Fri, 8 Jun 2007 17:20:49 +0200

> On Sat, Jun 09 2007, FUJITA Tomonori wrote:
> > I'll submit the bsg bidi patches shortly.
> 
> Great - I see them, will review and integrate next week.

Any progress on this?
