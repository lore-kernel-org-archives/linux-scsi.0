From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2] drivers: scsi: #define missing include guards
Date: Mon, 25 Aug 2014 10:10:48 +0200
Message-ID: <1408954248-5913-1-git-send-email-linux@rasmusvillemoes.dk>
References: <20140824153515.GB16490@infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63674 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaHYILM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 04:11:12 -0400
Received: by mail-lb0-f175.google.com with SMTP id 10so11639737lbg.6
        for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 01:11:10 -0700 (PDT)
In-Reply-To: <20140824153515.GB16490@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>

The four files aha1542.h, aha1740.h, gvp11.h and mvme147.h under
drivers/scsi/ contain two-thirds of an include guard, but do not
#define the macro. Add those #defines. git grep says the macro names
are not defined elsewhere.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
For good measure, here's a version with a non-broken commit message.

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
2.0.4

