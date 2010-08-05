From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 34/42] drivers/message/fusion: Adjust confusing if indentation
Date: Thu, 5 Aug 2010 22:27:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008052226570.31692@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:58038 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934323Ab0HEU1Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Aug 2010 16:27:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Indent the branch of an if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptbase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d8c668d..92e4b25 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -8049,7 +8049,7 @@ union loginfo_type {
 			code_desc = ir_code_str[sas_loginfo.dw.code];
 			if (sas_loginfo.dw.subcode >=
 			    ARRAY_SIZE(raid_sub_code_str))
-			break;
+				break;
 			if (sas_loginfo.dw.code == 0)
 				sub_code_desc =
 				    raid_sub_code_str[sas_loginfo.dw.subcode];
