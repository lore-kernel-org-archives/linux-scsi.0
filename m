From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH blktests 0/3] Add SCSI generic test group
Date: Thu, 18 May 2017 14:13:05 +0200
Message-ID: <cover.1495109149.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58725 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932642AbdERMN7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 08:13:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Add a test group for the SCSI generic driver and one syzcaller
reproducer for this group.

The reprodcuer is distributed as a C program, so the makefile is
amended to build C files to be used in the test.

I didn't get the TIMEOUT to work (not even with block/001) so I
decided to just require the 'timeout' program in my testcase.

Johannes Thumshirn (3):
  Add ability to build test-cases
  tests/sg: add SCSI generic test grouop
  sg/001: add regression test for syzcaller generated GPF

 Makefile         |  26 +++-
 common/sg        |  22 +++
 src/.gitignore   |   1 +
 src/Makefile     |  14 ++
 src/sg-001.c     | 430 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/sg/001     |  48 +++++++
 tests/sg/001.out |   2 +
 tests/sg/group   |  40 ++++++
 8 files changed, 582 insertions(+), 1 deletion(-)
 create mode 100644 common/sg
 create mode 100644 src/.gitignore
 create mode 100644 src/Makefile
 create mode 100644 src/sg-001.c
 create mode 100755 tests/sg/001
 create mode 100644 tests/sg/001.out
 create mode 100644 tests/sg/group

-- 
2.12.0
