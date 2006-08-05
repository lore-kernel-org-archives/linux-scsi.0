From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCHSET ver3] qla4xxx: miscellanous clean-ups
Date: Sat, 05 Aug 2006 17:19:37 -0500
Message-ID: <20060805221937.3349.73409.stgit@bebe.enoyolf.org>
References: <20060805065442.21282.17412.stgit@bebe.enoyolf.org 1154027483.3997.7.camel@dcslnxpc.site>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:925 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751401AbWHEWyR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 18:54:17 -0400
In-Reply-To: <20060805065442.21282.17412.stgit@bebe.enoyolf.org 1154027483.3997.7.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Mike,

The following 4 patch series replaces the 2 previous patchsets
Subject: [PATCHSET] qla4xxx: miscellanous clean-ups
Message-ID: 20060805065442.21282.17412.stgit@bebe.enoyolf.org
and
Subject: [PATCHSET ver2] qla4xxx: miscellanous clean-ups

Please drop both previous series.  The patches themselves did not
change, but mail addressing stuff was thoroughly borken.

Apparently the stgit mailer does not like continuation lines in CC
lists, some of the cc'd folks got silently dropped. :-/  One address
per line, please.  Actually, I think as long as all the addrs were on
one line woud be ok.  So many MUA's, so many.  Oh well.

The duplicate qla4xxx: in the subject line of the individual patches
has been fixed.  This series has also been compile tested.  More
extensive testing is in progress on x86-64 and powerpc64.

As with the previous patchset, these patches are on top of the 7-27
submission.

Shortlog:
Doug Maxey:
      qla4xxx: Remove funcs with no callers in ql4_init.c
      qla4xxx: Add a timeout period and return status from ql4xxx_lock_drvr_wait()
      qla4xxx: use dev_xxx on some pci/dma resource alloc warning and error printks
      qla4xxx: improve symmetry in buffer codepaths


Diffstats:
 drivers/scsi/qla4xxx/ql4_init.c |  189 ++++-----------------------------------
 drivers/scsi/qla4xxx/ql4_os.c   |   50 ++++------
 2 files changed, 40 insertions(+), 199 deletions(-)

--
++doug
