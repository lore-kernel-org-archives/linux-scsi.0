From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 9 May 2007 19:49:51 +0900 (JST)
Message-ID: <20070509171610E.fujita.tomonori@lab.ntt.co.jp>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp>
	<4640C724.8030409@panasas.com>
	<1178654497.3737.81.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55192 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbXEIKud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 06:50:33 -0400
In-Reply-To: <1178654497.3737.81.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, bhalevy@panasas.com, jens.axboe@oracle.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Tue, 08 May 2007 15:01:37 -0500

> Roll all the required sglist definitions (request_bufflen,
> request_buffer, use_sg and sglist_len) into the sgtable pools.
> 
> We're getting very close to the point where someone gets to sweep
> through the drivers eliminating the now superfluous non-sg path in the
> queuecommand.

The non-use-sg case is still alive?
