From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 0/2] Export lld busy state for request
	stacking drivers
Date: Thu, 25 Sep 2008 11:53:55 -0400 (EDT)
Message-ID: <20080925.115355.71085765.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: akpm@linux-foundation.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Andrew, Jens, James,

The following patches are the revised version to use lld's private data
instead of backing_dev_info.state for exporting lld busy state.

Please review and give me your opinion.
If all of you have no problem, I'll re-send the patches separately
to each maintainer, Jens and James.

The patches are created on the following commit of for-2.6.28
in linux-2.6-block, but the scsi part can be also applied to
scsi-post-merge-2.6.
---------------------------------------------------------------
commit c5062758edbe59286d7d8e718a59e4d4347ef541
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Wed Sep 24 13:05:10 2008 +0200

    libata: set queue SSD flag for SSD devices
---------------------------------------------------------------


Previous post and discussions about the interface:
    http://lkml.org/lkml/2008/9/19/138


Summary of the patches:
    1/2: block: add lld busy state exporting interface
    2/2: scsi: export busy state via q->lld_busy_fn()

Thanks,
Kiyoshi Ueda
