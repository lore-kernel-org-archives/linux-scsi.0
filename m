From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/5] virtio_blk: change to use __blk_end_request()
Date: Thu, 2 Oct 2008 14:52:46 +1000
Message-ID: <200810021452.47136.rusty@rustcorp.com.au>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com> <20081001.101120.41628825.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:60456 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbYJCBbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2008 21:31:09 -0400
In-Reply-To: <20081001.101120.41628825.k-ueda@ct.jp.nec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, oakad@yahoo.com, adrian@mcmen.demon.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com

On Thursday 02 October 2008 00:11:20 Kiyoshi Ueda wrote:
> This patch converts virtio_blk to use __blk_end_request() directly
> so that end_{queued|dequeued}_request() can be removed.
> Related 'uptodate' argument is converted to 'error'.

Hi Kiyoshi,

   Nice and clear; now matches common kernel style.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
