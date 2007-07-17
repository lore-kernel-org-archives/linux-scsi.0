From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Date: Mon, 16 Jul 2007 17:53:47 -0700
Message-ID: <20070716175347.bea345dd.akpm@linux-foundation.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<469C11B1.8000302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbXGQAyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 20:54:24 -0400
In-Reply-To: <469C11B1.8000302@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 16 Jul 2007 20:47:45 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> > The modern way of shutting up gcc is uninitialized_var().
> 
> 
> Should I convert my misc-2.6.git#gccbug repository over to this, and 
> push upstream?

Opinions differ (a bit) but personally I think the benefit of fixing the
warnings outweighs the risk that these suppressions will later hide a real
bug.

Certainly, using uninitialized_var() is better than open-coding "= 0" all
over the place.

Purists can add a config variable to centrally disable uninitialized_var()
if they want to check on the warnings.

> #gccbug branch is a set of places where I have verified that the 
> variable is indeed initialized, even though gcc complains it may not be.
> 

Do it!
