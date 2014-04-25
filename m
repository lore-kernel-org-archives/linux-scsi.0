From: Christoph Hellwig <hch@lst.de>
Subject: two small scsi fixes for 3.15-rc3
Date: Fri, 25 Apr 2014 13:09:48 +0200
Message-ID: <1398424190-21325-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Linus, hi James,

these are two simple use after free fixes that fix a regression introduced
by me in the first scsi update for 3.15-rc1.

I've sent them to the scsi list 10 days ago and haven't seen any reply to
them, and I'd hate if they miss -rc3 in addition to -rc2.
