From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 04/11] hpsa: add PMC to copyright
Date: Sat, 18 Jul 2015 11:12:38 -0500
Message-ID: <20150718161238.31955.79097.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:56173 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbGRQOz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:14:55 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

need to add PMC to copyright notice and update the Hewlett-Packard
copyright notification.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |    9 +++------
 drivers/scsi/hpsa.h     |    9 +++------
 drivers/scsi/hpsa_cmd.h |    9 +++------
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6b083af..eaa35bd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1,6 +1,7 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
- *    Copyright 2000, 2014 Hewlett-Packard Development Company, L.P.
+ *    Copyright 2014-2015 PMC-Sierra, Inc.
+ *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
@@ -11,11 +12,7 @@
  *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  *    NON INFRINGEMENT.  See the GNU General Public License for more details.
  *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
+ *    Questions/Comments/Bugfixes to storagedev@pmcs.com
  *
  */
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6ee4da6..6f6084b 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -1,6 +1,7 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
- *    Copyright 2000, 2014 Hewlett-Packard Development Company, L.P.
+ *    Copyright 2014-2015 PMC-Sierra, Inc.
+ *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
@@ -11,11 +12,7 @@
  *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  *    NON INFRINGEMENT.  See the GNU General Public License for more details.
  *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
+ *    Questions/Comments/Bugfixes to storagedev@pmcs.com
  *
  */
 #ifndef HPSA_H
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index c601622..1a98bbe 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -1,6 +1,7 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
- *    Copyright 2000, 2014 Hewlett-Packard Development Company, L.P.
+ *    Copyright 2014-2015 PMC-Sierra, Inc.
+ *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
@@ -11,11 +12,7 @@
  *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  *    NON INFRINGEMENT.  See the GNU General Public License for more details.
  *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
+ *    Questions/Comments/Bugfixes to storagedev@pmcs.com
  *
  */
 #ifndef HPSA_CMD_H

