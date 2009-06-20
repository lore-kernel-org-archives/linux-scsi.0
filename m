From: Ravish Tayal <ravish.tayal@gmail.com>
Subject: generic_make_request fucntion for scsi_disk
Date: Sat, 20 Jun 2009 19:35:03 +0530
Message-ID: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I am debugging Filesystem code for USB mass storage devices.  I need
help to figure out after generic_make_request how the request is
placed to scsi disk (sd) requeset queue and than how sd qeueuecommand
to usb_storeage thread.  (in which context, is it system call context)


inside generic_make_request

1.   q = bdev_get_queue(bio->bi_bdev);  [is sd.c register queue this
queue or any other scsi file?]
2.     ret = q->make_request_fn(q, bio);  [which file contain this
make_request_fn for scsi disk driver (generic)]

As per my unsderanding flow is like
Fat_writepage ->_block_write_full_page --> blkdev_writepage-->
block_write_full_page-->submit_bh-->generic_make_request ???  (sd ??)
----> queuecommand

Please suggest any sorce file, link or document.

with thanks
Ravish
