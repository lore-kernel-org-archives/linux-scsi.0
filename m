From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH resend] bsg: Add support for submitting requests at
 tail of queue
Date: Wed, 25 Mar 2009 13:06:21 +0900
Message-ID: <20090325130533K.fujita.tomonori@lab.ntt.co.jp>
References: <49C89CBC.7050306@panasas.com>
	<20090324210440Z.fujita.tomonori@lab.ntt.co.jp>
	<49C8D7E0.9000107@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38529 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZCYEHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 00:07:03 -0400
In-Reply-To: <49C8D7E0.9000107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, dgilbert@interlog.com

On Tue, 24 Mar 2009 14:53:52 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> > instead of
> > EXPORT_SYMBOL_GPL?
> 
> What is that got to do with it?
> The libosd.ko is a general purpose library for any kind of user.
> It exports the API defined in osd_initiator.h. This API is globally
> public, and has until now 3 implementations Linux-kernel, Linux-user-mode,
> BSD-kernel. I hope it will have many more implementations on all
> major OSs.
> I do not designate this API to be private Linux API, hence
> EXPORT_SYMBOL_GPL does not apply.

I don't understand your logic.

Your osd code is released under GPL so of course anyone can use (and
modify) your code (design, or whatever) for whatever he wants as long
as he follows GPL. EXPORT_SYMBOL_GPL has nothing to do with it.

We are talking about EXPORT_SYMBOL_GPL, it's all about Linux kernel;
what kinds of Linux kernel modules can use your osd code in Linux
kernel. The your code will be newly added so EXPORT_SYMBOL_GPL should
be fine here unless you encourage non-GPL kernel modules.

Or I miss something?
