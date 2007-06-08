From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Fri, 08 Jun 2007 11:38:08 -0500
Message-ID: <1181320688.3620.14.camel@localhost.localdomain>
References: <20070604140414.GI32105@kernel.dk>
	 <200706042203.l54M3rtf031762@mbox.iij4u.or.jp>
	 <20070607112309.GY4735@kernel.dk>
	 <20070609013306Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44869 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967835AbXFHQiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 12:38:12 -0400
In-Reply-To: <20070609013306Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

On Sat, 2007-06-09 at 01:33 +0900, FUJITA Tomonori wrote:
> James, any chance that the SMP passthru patches will be got into
> 2.6.23?

Yes, assuming we get sufficient progress on the required bidi bits.

I think we've got several weeks yet to get the 2.6.23 queue in shape

James


