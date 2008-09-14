From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/13] request-based dm-multipath
Date: Sun, 14 Sep 2008 15:17:43 +0200
Message-ID: <20080914131743.GN20055@kernel.dk>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:34415 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbYINNRr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Sep 2008 09:17:47 -0400
Content-Disposition: inline
In-Reply-To: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: agk@redhat.com, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, stefan.bader@canonical.com, akpm@linux-foundation.org

On Fri, Sep 12 2008, Kiyoshi Ueda wrote:
> Hi Jens, James and Alasdair,
> 
> This is a new version of request-based dm-multipath patches.
> The patches are created on top of 2.6.27-rc6 + Alasdair's dm patches
> for linux-next below:
>     dm-mpath-use-more-error-codes.patch
>     dm-mpath-remove-is_active-from-struct-dm_path.patch

You have to base the block patches off the for-2.6.28 branch of the
block git repo, otherwise I cannot merge the block bits.

-- 
Jens Axboe

