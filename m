From: Vecu Bosseur <vecu.bosseur@gmail.com>
Subject: BUG Needs Broader Audience (Bisect Successfull, Bugzilla #196343) :
 CDROM-related bug introduced in 4.11 merge window makes kernel freeze instead
 of doing read retires.
Date: Sat, 15 Jul 2017 08:34:58 +0200
Message-ID: <CACivvv0tuu0QoLc+jg24gn+Ld+8zEve=w8j584MU0Dgr-xnyuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux <linux@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

I happened to stumble into some (Linux kernel) bug a few days ago and
hopefully managed to collect evidences of its cause, bissection for
instance.

I was really in need to share my report with the Community, but
pitifully failed to spot the right mailing lists involved. That's why
some of you might consider this message bothersome.

For the rest, the people who really care about this bug, please,
follow this pointer :

https://bugzilla.kernel.org/show_bug.cgi?id=196343

For eager people, offending commit is :

commit 82ed4db499b8598f16f8871261bff088d6b0597f
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jan 27 09:46:29 2017 +0100

    block: split scsi_request out of struct request

    And require all drivers that want to support BLOCK_PC to allocate it
    as the first thing of their private data.  To support this the legacy
    IDE and BSG code is switched to set cmd_size on their queues to let
    the block layer allocate the additional space.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jens Axboe <axboe@fb.com>



And, not as an option, you the specialists, please tell me which the
right mailing lists are to post such a bug report.

Thanks in advance for any kind of comment.

Yours Sincerely,
Valentin
