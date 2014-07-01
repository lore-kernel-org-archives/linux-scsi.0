From: Andy Grover <agrover@redhat.com>
Subject: [RFC 0/2] target: userspace pass-through backend
Date: Tue,  1 Jul 2014 12:11:13 -0700
Message-ID: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Shaohua Li wrote an initial implementation of this, late last year[1].
Starting from that, I started working on some alternate implementation
choices, and ended up with something rather different.

Please take a look and let me know what you think. Patch 1 is a
design and overview doc, and patch 2 is the actual code, along with
implementation rationale.

Thanks -- Andy

[1] http://thread.gmane.org/gmane.linux.scsi.target.devel/5044

Andy Grover (2):
  target: Add documentation on the target userspace pass-through driver
  target: Add a user-passthrough backstore

 Documentation/target/tcmu-design.txt   |  210 +++++++
 drivers/target/Kconfig                 |    5 +
 drivers/target/Makefile                |    1 +
 drivers/target/target_core_transport.c |    4 +
 drivers/target/target_core_user.c      | 1078 ++++++++++++++++++++++++++++++++
 drivers/target/target_core_user.h      |  126 ++++
 6 files changed, 1424 insertions(+)
 create mode 100644 Documentation/target/tcmu-design.txt
 create mode 100644 drivers/target/target_core_user.c
 create mode 100644 drivers/target/target_core_user.h

-- 
1.9.3
