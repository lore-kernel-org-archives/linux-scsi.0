From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/3] hpsa patches for July 2012
Date: Thu, 26 Jul 2012 11:34:05 -0500
Message-ID: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Only one important bug fix, we should use LUN reset rather
than target reset in the reset error handler as Smart Array
logical drives don't actually support target reset and end up
getting offlined, which is pretty bad.  I had done my reset
testing with tape drives only, which turns out to have been
a stupid thing to do.

The other two patches are very minor.

---

Stephen M. Cameron (3):
      hpsa: Use LUN reset instead of target reset
      hpsa: fix incorrect abort diagnostic message
      hpsa: use ioremap_nocache instead of ioremap 


 drivers/scsi/hpsa.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

-- 
-- steve
