From: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 05/30] blk_end_request: changing um (take 4)
Date: Wed, 12 Dec 2007 15:55:51 -0500
Message-ID: <20071212205551.GC9244@c2.user-mode-linux.org>
References: <20071211.174253.106440139.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761356AbXLLU55@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071211.174253.106440139.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 11, 2007 at 05:42:53PM -0500, Kiyoshi Ueda wrote:
> This patch converts um to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
> 
> As a result, the interface of internal function, ubd_end_request(),
> is changed.

Looks OK to me...

		Jeff

-- 
Work email - jdike at linux dot intel dot com
