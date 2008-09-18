From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/3] block changes for request-based dm-multipath
Date: Thu, 18 Sep 2008 10:43:56 -0400 (EDT)
Message-ID: <20080918.104356.74754407.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

The following patches are changes of the block layer for
request-based dm-multipath.
The patches are created on the following commit of for-2.6.28
in linux-2.6-block.
---------------------------------------------------------------
commit 1fd75f9b2e1c273ab145c9bf3e7a8afcbd8be87a
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Sep 16 15:09:28 2008 -0700

    block: cleanup some of the integrity stuff in blkdev.h
---------------------------------------------------------------

No major changes since the last post (http://lkml.org/lkml/2008/9/12/100),
except for following up the differences from 2.6.27-rc6.
(As I said, I don't include patches for refactoring of similar
 interfaces at this time.  The refactoring patches will be posted
 after the request-based dm-multipath work is done.)

Summary of the patches:
  1/3: block: add a request data completion interface
  2/3: block: add a request submission interface
  3/3: block: add a queue flag for request stacking support

Please review and apply.

Thanks,
Kiyoshi Ueda
