From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] tests/scsi: add SCSI midlayer test group
Date: Wed,  9 Aug 2017 12:50:05 +0200
Message-ID: <1502275806-27972-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751890AbdHIKuR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 06:50:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@fb.com>
Cc: linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a test group for tests of the SCSI midlayer.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 tests/scsi/group | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 tests/scsi/group

diff --git a/tests/scsi/group b/tests/scsi/group
new file mode 100644
index 0000000..73459a6
--- /dev/null
+++ b/tests/scsi/group
@@ -0,0 +1,26 @@
+#!/bin/bash
+#
+# SCSI regression tests
+#
+# Copyright (C) 2017 Hannes Reinecke, SUSE Linux GmbH
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation, either version 3 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+#
+# Usually, group_requires() just needs to check that any necessary programs and
+# kernel features are available using the _have_foo helpers. If
+# group_requires() returns non-zero, all tests in this group will be skipped.
+group_requires() {
+	_have_root
+}
-- 
1.8.5.6
