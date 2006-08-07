From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCHSET] qla4xxx: @@@Series short description@@@
Date: Mon, 07 Aug 2006 10:28:51 -0500
Message-ID: <20060807152851.29380.28736.stgit@bebe.enoyolf.org>
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:31138 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932156AbWHGPjT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:39:19 -0400
In-Reply-To: 20060805221937.3349.73409.stgit@bebe.enoyolf.org 20060806050903.19417.44444.stgit@bebe.enoyolf.org
References: 20060805221937.3349.73409.stgit@bebe.enoyolf.org 20060806050903.19417.44444.stgit@bebe.enoyolf.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

The following 10 patch series implements some miscellaneous cleanups.
This patchset depends on the previous 2 patchsets
Subject: [PATCH ver3 1/4] qla4xxx: Remove funcs with no callers in ql4_init.c
and
Subject: [PATCH] qla4xxx: cleanup all allocations on failed allocations in module_init()

Shortlog:
Doug Maxey:
      qla4xxx: move qla4xxx_reset_target defn before call
      qla4xxx: make one file funcs static 01
      qla4xxx: qla4xxx_mem_alloc-defn-before-use
      qla4xxx: qla4xxx_timer defn before use
      qla4xxx: qla4xxx_do_dpc defn before use
      qla4xxx: qla4xxx_recover_adapter defn before use
      qla4xxx: qla4xxx_flush_active_srbs defn before use
      qla4xxx: rename del_from_active_array
      qla4xxx: qla4xxx_reset_target delete decl


Diffstats:
 drivers/scsi/qla4xxx/ql4_glbl.h |    2
 drivers/scsi/qla4xxx/ql4_isr.c  |   14
 drivers/scsi/qla4xxx/ql4_os.c   | 1183 +++++++++++++++++++--------------------
 3 files changed, 596 insertions(+), 603 deletions(-)

--
++doug
