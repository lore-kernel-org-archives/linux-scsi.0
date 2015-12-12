From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/7] iscsi-target: Rename a jump label in
 iscsi_create_default_params()
Date: Sat, 12 Dec 2015 15:42:42 +0100
Message-ID: <566C3262.6010105@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <566C2F7B.6030704@users.sourceforge.net>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Dec 2015 14:12:50 +0100

This issue was detected by using the Coccinelle software.

Choose a jump label according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 64 +++++++++++++-------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 3f3842f..29ecf29 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -225,185 +225,185 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 			PHASE_SECURITY, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_AUTH, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, HEADERDIGEST, INITIAL_HEADERDIGEST,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_DIGEST, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, DATADIGEST, INITIAL_DATADIGEST,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_DIGEST, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, MAXCONNECTIONS,
 			INITIAL_MAXCONNECTIONS, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_1_TO_65535, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, SENDTARGETS, INITIAL_SENDTARGETS,
 			PHASE_FFP0, SCOPE_SESSION_WIDE, SENDER_INITIATOR,
 			TYPERANGE_UTF8, 0);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, TARGETNAME, INITIAL_TARGETNAME,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_ISCSINAME, USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, INITIATORNAME,
 			INITIAL_INITIATORNAME, PHASE_DECLARATIVE,
 			SCOPE_SESSION_WIDE, SENDER_INITIATOR,
 			TYPERANGE_ISCSINAME, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, TARGETALIAS, INITIAL_TARGETALIAS,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_TARGET,
 			TYPERANGE_UTF8, USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, INITIATORALIAS,
 			INITIAL_INITIATORALIAS, PHASE_DECLARATIVE,
 			SCOPE_SESSION_WIDE, SENDER_INITIATOR, TYPERANGE_UTF8,
 			USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, TARGETADDRESS,
 			INITIAL_TARGETADDRESS, PHASE_DECLARATIVE,
 			SCOPE_SESSION_WIDE, SENDER_TARGET,
 			TYPERANGE_TARGETADDRESS, USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, TARGETPORTALGROUPTAG,
 			INITIAL_TARGETPORTALGROUPTAG,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_TARGET,
 			TYPERANGE_0_TO_65535, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, INITIALR2T, INITIAL_INITIALR2T,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_BOOL_OR, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, IMMEDIATEDATA,
 			INITIAL_IMMEDIATEDATA, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH, TYPERANGE_BOOL_AND,
 			USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, MAXXMITDATASEGMENTLENGTH,
 			INITIAL_MAXXMITDATASEGMENTLENGTH,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, MAXRECVDATASEGMENTLENGTH,
 			INITIAL_MAXRECVDATASEGMENTLENGTH,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, MAXBURSTLENGTH,
 			INITIAL_MAXBURSTLENGTH, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, FIRSTBURSTLENGTH,
 			INITIAL_FIRSTBURSTLENGTH,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, DEFAULTTIME2WAIT,
 			INITIAL_DEFAULTTIME2WAIT,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_0_TO_3600, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, DEFAULTTIME2RETAIN,
 			INITIAL_DEFAULTTIME2RETAIN,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_0_TO_3600, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, MAXOUTSTANDINGR2T,
 			INITIAL_MAXOUTSTANDINGR2T,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_1_TO_65535, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, DATAPDUINORDER,
 			INITIAL_DATAPDUINORDER, PHASE_OPERATIONAL,
 			SCOPE_SESSION_WIDE, SENDER_BOTH, TYPERANGE_BOOL_OR,
 			USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, DATASEQUENCEINORDER,
 			INITIAL_DATASEQUENCEINORDER,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_BOOL_OR, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, ERRORRECOVERYLEVEL,
 			INITIAL_ERRORRECOVERYLEVEL,
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_0_TO_2, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, SESSIONTYPE, INITIAL_SESSIONTYPE,
 			PHASE_DECLARATIVE, SCOPE_SESSION_WIDE, SENDER_INITIATOR,
 			TYPERANGE_SESSIONTYPE, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, IFMARKER, INITIAL_IFMARKER,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_BOOL_AND, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, OFMARKER, INITIAL_OFMARKER,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_BOOL_AND, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, IFMARKINT, INITIAL_IFMARKINT,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_UTF8, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, OFMARKINT, INITIAL_OFMARKINT,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_UTF8, USE_INITIAL_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	/*
 	 * Extra parameters for ISER from RFC-5046
@@ -412,25 +412,25 @@ int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
 			PHASE_OPERATIONAL, SCOPE_SESSION_WIDE, SENDER_BOTH,
 			TYPERANGE_BOOL_AND, USE_LEADING_ONLY);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, INITIATORRECVDATASEGMENTLENGTH,
 			INITIAL_INITIATORRECVDATASEGMENTLENGTH,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	param = iscsi_set_default_param(pl, TARGETRECVDATASEGMENTLENGTH,
 			INITIAL_TARGETRECVDATASEGMENTLENGTH,
 			PHASE_OPERATIONAL, SCOPE_CONNECTION_ONLY, SENDER_BOTH,
 			TYPERANGE_512_TO_16777215, USE_ALL);
 	if (!param)
-		goto out;
+		goto release_list;
 
 	*param_list_ptr = pl;
 	return 0;
-out:
+release_list:
 	iscsi_release_param_list(pl);
 	return -1;
 }
-- 
2.6.3
