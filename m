From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH blktests v2 0/3] Add SCSI generic test group
Date: Fri, 19 May 2017 15:55:28 +0200
Message-ID: <cover.1495201975.git.jthumshirn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Add a test group for the SCSI generic driver and one syzcaller
reproducer for this group.

The reprodcuer is distributed as a C program, so the makefile is
amended to build C files to be used in the test.

Changes to v1:
* Stripped left over TODO comment
* Modified reproducer to accept a device name
* Fixed Makefile so it can build more than one target

Johannes Thumshirn (3):
  Add ability to build test-cases
  tests/sg: add SCSI generic test grouop
  sg/001: add regression test for syzcaller generated GPF in sg_read
    path

 Makefile         |  26 +++-
 common/sg        |  41 ++++++
 src/.gitignore   |   1 +
 src/Makefile     |  16 ++
 src/sg-001.c     | 438 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/sg/001     |  47 ++++++
 tests/sg/001.out |   2 +
 tests/sg/group   |  28 ++++
 8 files changed, 598 insertions(+), 1 deletion(-)
 create mode 100644 common/sg
 create mode 100644 src/.gitignore
 create mode 100644 src/Makefile
 create mode 100644 src/sg-001.c
 create mode 100755 tests/sg/001
 create mode 100644 tests/sg/001.out
 create mode 100644 tests/sg/group

-- 
2.12.0
