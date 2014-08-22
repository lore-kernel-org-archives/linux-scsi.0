From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: scsi: #define missing include guards
Date: Fri, 22 Aug 2014 14:37:33 +0200
Message-ID: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56192 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaHVMhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2014 08:37:40 -0400
Received: by mail-lb0-f179.google.com with SMTP id v6so9160706lbi.24
        for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 05:37:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>

The four files aha1542.h, aha1740.h, gvp11.h and mvme147.h under
drivers/scsi/ contain two-thirds of an include guard, but do not
elsewhere.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/aha1542.h | 1 +
 drivers/scsi/aha1740.h | 1 +
 drivers/scsi/gvp11.h   | 1 +
 drivers/scsi/mvme147.h | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index b871d2b..8f4e07a 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -1,4 +1,5 @@
 #ifndef _AHA1542_H
+#define _AHA1542_H
 
 /* $Id: aha1542.h,v 1.1 1992/07/24 06:27:38 root Exp root $
  *
diff --git a/drivers/scsi/aha1740.h b/drivers/scsi/aha1740.h
index af23fd6..7ea484f 100644
--- a/drivers/scsi/aha1740.h
+++ b/drivers/scsi/aha1740.h
@@ -1,4 +1,5 @@
 #ifndef _AHA1740_H
+#define _AHA1740_H
 
 /* $Id$
  *
diff --git a/drivers/scsi/gvp11.h b/drivers/scsi/gvp11.h
index 852913c..5aabe90 100644
--- a/drivers/scsi/gvp11.h
+++ b/drivers/scsi/gvp11.h
@@ -1,4 +1,5 @@
 #ifndef GVP11_H
+#define GVP11_H
 
 /* $Id: gvp11.h,v 1.4 1997/01/19 23:07:12 davem Exp $
  *
diff --git a/drivers/scsi/mvme147.h b/drivers/scsi/mvme147.h
index bfd4566..479e9b4 100644
--- a/drivers/scsi/mvme147.h
+++ b/drivers/scsi/mvme147.h
@@ -1,4 +1,5 @@
 #ifndef MVME147_H
+#define MVME147_H
 
 /* $Id: mvme147.h,v 1.4 1997/01/19 23:07:10 davem Exp $
  *
-- 
1.9.2

