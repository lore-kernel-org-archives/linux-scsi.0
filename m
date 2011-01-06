From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 03/11] hpsa: Remove duplicate defines of DIRECT_LOOKUP_
	constants
Date: Thu, 06 Jan 2011 14:47:58 -0600
Message-ID: <20110106204758.10753.94612.stgit@beardog.cce.hp.com>
References: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:46121 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1AFUsD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 15:48:03 -0500
In-Reply-To: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

From: Stephen M. Cameron <StephenM.Cameron>

They are defined in hpsa_cmd.h

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e2089a3..b345cc4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2863,13 +2863,11 @@ static inline void finish_cmd(struct CommandList *c, u32 raw_tag)
 
 static inline u32 hpsa_tag_contains_index(u32 tag)
 {
-#define DIRECT_LOOKUP_BIT 0x10
 	return tag & DIRECT_LOOKUP_BIT;
 }
 
 static inline u32 hpsa_tag_to_index(u32 tag)
 {
-#define DIRECT_LOOKUP_SHIFT 5
 	return tag >> DIRECT_LOOKUP_SHIFT;
 }
 

