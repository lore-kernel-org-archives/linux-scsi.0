From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SCSI Generic version 4 interface, release 1.2
Date: Mon, 19 Mar 2007 19:49:35 +0900
Message-ID: <20070319194935H.fujita.tomonori@lab.ntt.co.jp>
References: <45F82048.6020401@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:41713 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXCSKtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 06:49:12 -0400
In-Reply-To: <45F82048.6020401@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, pw@osc.edu, jens.axboe@oracle.com

From: Douglas Gilbert <dougg@torque.net>
Subject: SCSI Generic version 4 interface, release 1.2
Date: Wed, 14 Mar 2007 12:18:16 -0400

>   - the write() usage in the sg driver's asynchronous interface has
>   caused problems when mistakenly applied to a block device node
>   rather than a sg device node. Using an ioctl(flag_async) followed
>   by a read() for asynchronous work offers similar functionality and
>   is safer. Using ioctl(flag_async_start) and
>   ioctl(flag_async_finish) is another possibility.

I'm not sure about this because users read/write via /dev/bsgX not
/dev/sdX.

Anyway, I'm not sure the read/write interface is good for bsg.


>   - the SCSI command tag field as currently defined in SAM-4 can be
>     up to 64 bits (with a proposal to increase that to 96 bits for FCP)
>     Should we let the transport layer/LLD worry about that?

SRP uses 64-bits tags.
