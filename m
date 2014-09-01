From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [ PATCH  -logging 0/3] scsi/trace: Delete duplicated decoders
Date: Mon, 01 Sep 2014 12:33:25 +0000
Message-ID: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Doug Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi All,

This patchset deletes duplicated decoders in scsi_trace.c.
Almost decoders are implemented in constants.c, so we should use them.

This patchset deletes following decoders in scsi_trace.c:
 - hostbyte in patch [2/3]
 - driverbyte in patch [2/3]
 - SCSI command in patch [3/3]

This patchset is based on Hannes' logging branch:
http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/log/?h=logging

Thanks,
Yoshihiro YUNOMAE

---

Yoshihiro YUNOMAE (3):
      scsi/trace: Use macros for getting driver byte, host byte, msg byte, and status byte
      scsi/trace: Delete duplicated decoders of hostbyte and driverbyte
      scsi/trace: Delete a duplicated decoder of SCSI command


 drivers/scsi/constants.c    |   34 +++++---
 include/scsi/scsi.h         |    6 +
 include/trace/events/scsi.h |  179 ++++++++++---------------------------------
 3 files changed, 68 insertions(+), 151 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
