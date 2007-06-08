From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Sat, 09 Jun 2007 01:45:59 +0900
Message-ID: <20070609014559W.fujita.tomonori@lab.ntt.co.jp>
References: <20070607112309.GY4735@kernel.dk>
	<20070609013306Z.fujita.tomonori@lab.ntt.co.jp>
	<1181320688.3620.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:33832 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969554AbXFHQp5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 12:45:57 -0400
In-Reply-To: <1181320688.3620.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Fri, 08 Jun 2007 11:38:08 -0500

> On Sat, 2007-06-09 at 01:33 +0900, FUJITA Tomonori wrote:
> > James, any chance that the SMP passthru patches will be got into
> > 2.6.23?
> 
> Yes, assuming we get sufficient progress on the required bidi bits.
> 
> I think we've got several weeks yet to get the 2.6.23 queue in shape

Great, thanks. I'll update and send the SMP passthru patches on the
top of Jens' tree when Jens applies the bsg bidi patchset.
