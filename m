From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 8 Nov 2010 23:50:47 +0900
Message-ID: <20101108234328C.fujita.tomonori@lab.ntt.co.jp>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
	<20101108143307.GA22121@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42443 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0KHOvr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2010 09:51:47 -0500
In-Reply-To: <20101108143307.GA22121@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com

On Mon, 8 Nov 2010 09:33:07 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> I promised you and James to get back to a throughout review for more
> than just the backends.  It's still in progress, but here is what I
> think is most important:

Agreed about all the comments. I complained about similar issues
publicly and privately.

btw, when I'm back to Japan, I resume to work on the ibmvscsis driver.


>  - Sort of the the namepspace for both the file names and function
>    names.  I think you reluctantly agreed to do that a while ago anyway,
>    but I think it's time to bite the bullet now.  Please agree on a
>    common prefix for both function names and modules.  I think the
>    target name in the directory structure is the best one, but I really
>    don't care too much.  The transport_ prefix used in some code is
>    really misleading, and the se_ in other isn't too helpful either.

Agreed. And as I said, we definitely need to fix the module names
before the mainline inclusion.
