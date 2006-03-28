From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 04/10] Mark div_10M array const
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <1143561824125-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.magma.ca ([206.191.0.250]:51894 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S932078AbWC1QDh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:37 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>

Patch below is one out of a large series to mark kernel data const when
possible, goal is to use .rodata and avoid false sharing

Signed-off-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

e042461b9e5f62b0c9862cd1af711444e13f41bd
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index a95b262..b2ac482 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -472,7 +472,7 @@ static int sym_getpciclock (struct sym_h
  *  calculations more simple.
  */
 #define _5M 5000000
-static u32 div_10M[] = {2*_5M, 3*_5M, 4*_5M, 6*_5M, 8*_5M, 12*_5M, 16*_5M};
+static const u32 div_10M[] = {2*_5M, 3*_5M, 4*_5M, 6*_5M, 8*_5M, 12*_5M, 16*_5M};
 
 /*
  *  Get clock factor and sync divisor for a given 
-- 
1.2.4.g375a5


