From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 0/4] block: move sd_format_disk_name() into block core as
 disk_name_format()
Date: Fri, 30 Mar 2012 17:50:12 +0800
Message-ID: <4F7581D4.4040301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41744 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2C3Jt7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2012 05:49:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>



This patch series renames "sd_format_disk_name()" to
"disk_name_format()" and moves it into block core. So
that who needs formatting disk name can use it, instead
of duplicating these similar help functions.

Ren Mingxin (4):
   block: add function disk_name_format() into block core
   scsi: replace sd_format_disk_name() to disk_name_format()
   block: replace rssd_disk_name_format() to disk_name_format()
   virtio_blk: use disk_name_format() to support mass of disks naming

  block/genhd.c                     |   49 ++++++++++++++++++++++++++++++++++++++
  drivers/block/mtip32xx/mtip32xx.c |   33 -------------------------
  drivers/block/virtio_blk.c        |   13 ----------
  drivers/scsi/sd.c                 |   48 -------------------------------------
  include/linux/genhd.h             |    2 +
  5 files changed, 54 insertions(+), 91 deletions(-)

Any comment will be appreciated.

Thanks,
Ren


