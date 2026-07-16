Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022141.outbound.protection.outlook.com [52.101.126.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE51422E28;
	Thu, 16 Jul 2026 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784220283; cv=fail; b=XpJZm7vbG6/frIID6nGXDxa0bQHm0sZiVA+T/KRNrJB727eJ4/1XOxsxE3k8PQfxCFuUF7K8pcOHSBNPUYpXJsqIZ1ktXUqYRM/57yhfxCt1Sy5xJfB0y1nCOaRxUt0O51Ip+uWwNLqs4rJTDsW+OnYdY3IJTT9rRDmwgymYnzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784220283; c=relaxed/simple;
	bh=Sj1bN2I4afCpAP8/o2fzViy2TVBXBV2CVUVoL3jbmEU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=UT7aBI7947xN9yPmXFHBdA9FxQHzkujxxCxfU4YSBQRMFO2WSe7hwnaD7gm/TUveRMrOBdXGtRLbQHajq2dDM0a9h7wtSZ16RI5mvtZvdK56pCVOJM284JvUU0z6Bt8b38utoupABneooxq7GzEv6QTiwvpUSz0OW4KwuArD/14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg; spf=pass smtp.mailfrom=smu.edu.sg; dkim=pass (2048-bit key) header.d=smu.edu.sg header.i=@smu.edu.sg header.b=fGd0PrV0; arc=fail smtp.client-ip=52.101.126.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smu.edu.sg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smu.edu.sg header.i=@smu.edu.sg header.b="fGd0PrV0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sOoQPEZYkeeS/ZMNWzWHdNjc07I8mRg0RRG6EJRb/RKvNas9Pan2lrrIwcmtwujGwFTl51jas7VTN/xCSTX7V6+yEseR6W3fkYbGvVAlH3RkPXA+IP1eE55N0bdDs3VW/r/ChA+9j5B/TNmMkbH/zL+zwSmxV53U8AiGBu4Ekz9IhHxMczdsG3vE/Gfbbr7Cr+TYAffV1GKlMbroWjBZ0PY5NDgLu80xMI8KT3Bwso240mu62ImVVNBIUeOZMXzvV8Yt7f9Uaaj2L4b+8SNXH9f/92LZKGC1FW+H1H6Z8zfoyoC1YVJB0U4O9MTC7Lw/0/IllUFhsAUkUjjJ+gqOvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TcNxeWgfppkXGn3MyuuCTriv/5R0+Qk/m4hPr/z6Q90=;
 b=tS4b2dCnRHcyKK05KMb6KoaYR6mGGksfGwQ2Gb2a3UP41VAyvYBqyjhIboTch11qVpnIk9QewI0cRlxALT6ldI7dyjN4DkWd5WLN2muhkFi9/9AmcF8uI8P0TtSSl/+KJygXEBdED6IxNp6EileIcT4kKa61aBGmuihMQNlXI+k6zx3MwdvVhIKgH96koDV1HFg2qRohb9qB1hVJ2AjXcU4ftMXx/p+Cs0KUyq4xTyptnKR7vIVG5GiszPaoJMrc0+4Ys7diIewJGuTB5p8a6ol8QiG9XXTpBAgl7dlUrvOx2f62Yz1l1GlHR+frNt0ni/6/EbPKaizJeidtp1Jmig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=smu.edu.sg; dmarc=pass action=none header.from=smu.edu.sg;
 dkim=pass header.d=smu.edu.sg; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smu.edu.sg;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcNxeWgfppkXGn3MyuuCTriv/5R0+Qk/m4hPr/z6Q90=;
 b=fGd0PrV0XTSQyQyJXlqxIvHVN37OZPiRUEc1xWrIEAASWa91JlUrnk6NEAasDGJi4f26+9E/cDzMS4Lu6/HQ0/Hss0B6z3tP+CXi8+Mxv8gsGfFluvuwgVE1sjRquHmBu+GyTpMmvx8Q+jb69Yzhy4HyMpWTgVVQtkfpEA1pzOstx+yjXCS24F4ql3avKtSLZWSfSIu0lXNJy8wGsVErYblJFwR7Q7NRH7jWqlcvouXG5wlQaJw+VsySSX+WfT28wZkVIEec/qd3NB4XnlyospXceTNEuMeVCyJDIGhnNJSYzInAjrBuz2KsjGq+4TAkvfW/QadHHZXjQxouT2Sj6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=smu.edu.sg;
Received: from KUXPR01MB7791.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:3f::9) by SEYPR01MB4927.apcprd01.prod.exchangelabs.com
 (2603:1096:101:b9::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Thu, 16 Jul
 2026 16:44:23 +0000
Received: from KUXPR01MB7791.apcprd01.prod.exchangelabs.com
 ([fe80::6bd0:d704:7d90:a595]) by KUXPR01MB7791.apcprd01.prod.exchangelabs.com
 ([fe80::6bd0:d704:7d90:a595%5]) with mapi id 15.21.0223.011; Thu, 16 Jul 2026
 16:44:23 +0000
From: Huihui Huang <hhhuang@smu.edu.sg>
To: martin.petersen@oracle.com
Cc: Huihui Huang <hhhuang@smu.edu.sg>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Kees Cook <kees@kernel.org>
Subject: [PATCH] scsi: target: iscsi: NUL-terminate login req_buf
Date: Fri, 17 Jul 2026 00:44:07 +0800
Message-ID: <20260716164415.2302192-1-hhhuang@smu.edu.sg>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JH0PR01CA0104.apcprd01.prod.exchangelabs.com
 (2603:1096:990:58::12) To KUXPR01MB7791.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:3f::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUXPR01MB7791:EE_|SEYPR01MB4927:EE_
X-MS-Office365-Filtering-Correlation-Id: 1515e9c0-ad3a-4c54-c8b8-08dee3597d5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|786006|23010399003|1800799024|56012099006|11063799006|18002099003|10067099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	DJWeLN8qs+q3fz5WMQRvqPCztNIvzoQxo0+9Gwa6dei2Yb0C7rlKsDi8zUhzXuuhuUGNWX4wy+X3Vnl+f/ss0OL1XhIAf/3qA8ELc20vVp76QJq1Gwx+/ZXHxVErprF6qMZWl1/9TcmOqU1Z2nqL2uLbsNCp/M+TxDvlOWryowjkL9TU5fN+eS32vqstnYtR/zgOl3JHh6TY/z4hXwmLSkFhRjUNkjNc2t3RmGMX2ecVucJ/FanBZ9gRsgmhunP844kiN7GZVf4kmanQC6d3q1ly+WyFLL3cyzHaz5lAk38CKDODEAc/FydDFoQJPi62qo+H3i2gQXYQjda9U/YC/6WfrhbrUxRwV3mf9p91M9xn9/T4JkakINzSTKuBI20V85kFdQ7e4CPKocmtJ6yXojEcBSXNEGsXWReDPQeUUro6nLmJTjk6gZ42fRk2SaDjpblPe8GQQ/pvWh4wdu/he0WNr1czHvgi0E8eV3i/QfanuD6J94dnHdQyv5pmi4v/vVW2Kc+i5t4vULNOfshKuBbrfAo9tYgFzcwr9WyiC4yQpUovH9lrZ5wzg4mmDVD622Y1b+Xr636SvZvyDYcsc0EvASGDRmmQb37I6UJ6x3OJ8cw/bV0raSF3sL7d9//78ZtiS/wDuyfLPT5cURL8OrfnBeUSjDkRKMeqGOa5uJzi4MN32LV9m4kfCDlBvuP5ErsjfSTD5V/BOkJKki/rQaCvZk+irDAE6pF7f7lxc0Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KUXPR01MB7791.apcprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(786006)(23010399003)(1800799024)(56012099006)(11063799006)(18002099003)(10067099003)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xrxqyH0rqyAAxCfeDENThCh/yb1YlJPMlsT9G22bZjJtzXVi0slF+Sd/Xqf5?=
 =?us-ascii?Q?UyO64GJcWYxICV2fYYWpluSmMzXTXkvSJ9pcxLuSkf8MWkxW/xCCH07xZCx+?=
 =?us-ascii?Q?/Mv99kD4LnIgPuLy0JvmZaoFHbHNharO901Za1Uy8B2GoIkxw8K4tjwjmvJh?=
 =?us-ascii?Q?tS3VwINPqWdKdRaLFG4kvFVLy6LCoL+xW0zMYwMJvbhTYqowI5A+UV3LIwF1?=
 =?us-ascii?Q?tWMrfDKZkt9z5DZYgtC2BW0735wJ0nA4k88dcKS8SMwbZ++EgrRqrWnUp36Q?=
 =?us-ascii?Q?fH/E4CEndtSx49rSzTnKpUU1PJzUrdKZR4PHpNGTbbXyoUGDCS4JoCSlCIbN?=
 =?us-ascii?Q?owmAz95Qm6Dfx16VxwYywnNx35U/Q+TduRdxZNRcy7wf1c2dNYyKwrs6QkGM?=
 =?us-ascii?Q?bK8hdO57G+2fCKdLO7uu2sMfz64XoeZVoX67fX5rC35g5Pw7Ar/LBUVybJIw?=
 =?us-ascii?Q?KezwE3OTJnOMDSSz8GTHS58pSrZDJR2k8zD7vj8U5C5SwST2IAdYBt8+F4GK?=
 =?us-ascii?Q?2L0flLkERD1bL+0zxHir6bmtlNlNCQGi/PuZIXmo9/1PIXFCEHmoQ7gouYsQ?=
 =?us-ascii?Q?l/Xh71KGKK/Jojg5mN7/pbJgtXDCVtIx9a22Cev/IW2XSTeuKJDAZ2xTwh3n?=
 =?us-ascii?Q?9QvtbsxbcgZUAInuPHbMARAnzC3yi4tuPXK6yZ0k5GAKKKjcgVq9GL345TmO?=
 =?us-ascii?Q?muVX77ltpIKSdz9HjhTD0lJHhwJnYakybxQ3pz5CTuyGtMyqz6pGawuYLtRX?=
 =?us-ascii?Q?fie+ffETznQQ3v0RgHP10Avt5k5zdAvBfcOKNu263OiFdRvNNW7fsALJeXKO?=
 =?us-ascii?Q?MC6GHCsIxS0ess7rY4mAy7/Rtz/p8ZqI87Nq3yXsi9JaxNEZKtA+fxFHiT5+?=
 =?us-ascii?Q?SUYFVaJEObLXYJ89nG70Rl6OHuhTqC+K9A8KMXx82IJNwePQxCAgLkVCZf91?=
 =?us-ascii?Q?psI/Jy+LMs6O1cIjgm0vChxnNVuJjHAH0OqzNYLUN/dawXHL/tPMad0cBn+C?=
 =?us-ascii?Q?wo5exs4pGZDTley2uO4xZR370J5LFGFKMAE1JE+OWT9PPE/6WuRGmNQPSqjH?=
 =?us-ascii?Q?XSDxdd89aWM1K2UDZi3cffGcwTlxIVlRAUgo6BpzDxiN3qWsxrBF9bd1iaCS?=
 =?us-ascii?Q?nAbkQswkVe8QcUZZEBfu9rQeO1yfmWkI6uNx/kDgUaVpmZsRscuPqJ3KFzeq?=
 =?us-ascii?Q?g3ch8rz0zGvyTA4Om1EwJ7Mgx+8RCdp76L57IEqVKt1rq6KZ4/t7IWr518At?=
 =?us-ascii?Q?vhobUi2Y+1Tk8yzZox0XbLu+TpHv89rm/hWX0OQ4yPI4cqjvMvYiWce/J0xw?=
 =?us-ascii?Q?4rC0+ttgQi4ReSOCGmbVeSBCvuNPhOGw/+6kvKJX2LvNPYIm9x0OMEgwzqHu?=
 =?us-ascii?Q?AgAdzYe5fXSTAK2qTY4KNgZWp76G5o3DnqvXfR4mPtpRPC65ddBOs3aq02ql?=
 =?us-ascii?Q?DaTgcmlpzfSAJtpcQ7ic0QbQA9bzzeicxnluxV9HIW7U/cRSIt6QFK56VjMP?=
 =?us-ascii?Q?FKSNMv9yVpQU6jtHucq1rlr+dvcurSIooVlqXpto4PVz8JbmVLHwB1VnowDb?=
 =?us-ascii?Q?3W7kaPWQxLXzC+nkoDPQ/LUoEa4omclT3dmCB2QsZypDGkNW4uw1pPy/HtMT?=
 =?us-ascii?Q?aNpHBXEuYJz8ejcoXsRQ7LS6OsOOHWcLET987MLFd+Ki4lk+3IoVHcxHHpuk?=
 =?us-ascii?Q?s3NDuyBo+yOqV+Q5ICrDn/Hg8DLyXxLP2hlrj2d5vgfWxnTWN44HVbmhHUA7?=
 =?us-ascii?Q?XYClfhSGkQ=3D=3D?=
X-OriginatorOrg: smu.edu.sg
X-MS-Exchange-CrossTenant-Network-Message-Id: 1515e9c0-ad3a-4c54-c8b8-08dee3597d5b
X-MS-Exchange-CrossTenant-AuthSource: KUXPR01MB7791.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 16:44:23.0956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c98a79ca-5a9a-4791-a243-f06afd67464d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mqUVG2UypMf/T95wQXK2LfoOWeslB3krXgPvqJujqMrZQFQln170MOKDxEqiOBGuploGG17FnsI63a1lOfxbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR01MB4927

login->req_buf is a MAX_KEY_VALUE_PAIRS (8192) byte buffer that holds the
data segment of a received login PDU. iscsi_target_check_login_request()
rejects only payload_length > MAX_KEY_VALUE_PAIRS, so a payload of exactly
8192 bytes is accepted and fills req_buf completely, leaving no NUL
terminator (no padding is present because 8192 is four-byte aligned).

The security-phase text parser works on a kmemdup_nul() copy and is safe,
but the CHAP negotiation code consumes req_buf directly as a C string.
During the initial CHAP exchange, chap_check_algorithm() passes req_buf to
kstrdup(); during the subsequent CHAP exchange, convert_null_to_semi()
replaces embedded separators and extract_param() uses strstr() and
strlen_semi(). Both paths treat req_buf as a C string and therefore
require a terminating NUL within the allocated buffer.

A security-stage login request whose 8192-byte data segment begins with
"CHAP_A=" and contains no 0x00 byte therefore makes strlen() read past the
end of the allocation. This is reachable pre-authentication by a remote
initiator during CHAP negotiation.

Allocate one extra byte so a maximum-length data segment is followed by
a NUL terminator. In the socket receive path, also terminate at
payload_length so received padding bytes are not parsed as CHAP text.
Other login transports copy at most MAX_KEY_VALUE_PAIRS bytes into
req_buf, so the added final byte remains zero and bounds C-string scans.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
---
 drivers/target/iscsi/iscsi_target_login.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Tested with KASAN using a temporary KUnit test that calls the static
chap_check_algorithm() on an 8192-byte buffer beginning with "CHAP_A=" and
containing no NUL. Two cases model req_buf before and after the change, in
one kernel:

  tight    (kmalloc(8192), no terminator = current req_buf):
    BUG: KASAN: slab-out-of-bounds in strlen+0x23/0x40
     kstrdup
     chap_check_algorithm
  plus_one (kzalloc(8192 + 1), byte 8192 == 0 = req_buf after this change):
    ok, chap_check_algorithm returns cleanly, no KASAN report.

An unparsable CHAP_A algorithm returns CHAP_DIGEST_UNKNOWN, so the login
fails; the fix does not leave a malformed frame on a success path.

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index aafc94bcb635..417805cd62d7 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -47,7 +47,7 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsit_conn *conn)
 	login->conn = conn;
 	login->first_request = 1;

-	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	login->req_buf = kzalloc(MAX_KEY_VALUE_PAIRS + 1, GFP_KERNEL);
 	if (!login->req_buf) {
 		pr_err("Unable to allocate memory for response buffer.\n");
 		goto out_login;
@@ -966,6 +966,7 @@ int iscsit_get_login_rx(struct iscsit_conn *conn, struct iscsi_login *login)
 				payload_length + padding) < 0)
 		return -1;

+	login->req_buf[payload_length] = '\0';
 	return 0;
 }

base-commit: e166bafc483e927150cb9b5f286c9191ea0df84e
--
2.50.1
