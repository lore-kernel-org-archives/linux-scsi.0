Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012003.outbound.protection.outlook.com [52.101.126.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AA42222B7;
	Tue,  9 Sep 2025 02:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757383806; cv=fail; b=oNcHjEzwhaSCBrpXd6h+zfKQ6EdpZw8ohVBzGQsOWM7+H9e8FO8v/GzJUuM4YYuC58qp+DfYzYC5FK7RNU1yM/60V8YxPdR2XymIMf0+9WyUR+TOFA69G3qgU7ElG2CuVjRFTFKTp5Xo+19kcepnpjXBt8Ox0AiGWbtzjxtWTgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757383806; c=relaxed/simple;
	bh=CxAjh1FS1UQCjsQIs0o9FtCV9puiaZbaARB5FP+bJ2U=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=CyGmtCMYYD6JAEG9aAAPD1bgijM9QnUhuqOQR7V1hYEQ387fnpq4fvutA9mL7n9oyPN3ywKHnyvX2YiUCIXzNJPhR613mdvFkYJp5pphRnSwMMVvsaDIW39h9CTkswvk9+kPZTnTECu5m6DkcExi2ZzU4Pbt3nMjDXODFD0SAZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Rcy758h4; arc=fail smtp.client-ip=52.101.126.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Rcy758h4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvjoZ0w0wF97ii9RS3mhDmM7IpFdccov5YQtFGoNeCVv2IPNRuBdbzMAoseYNnVwvUYf3LcSs18XLO3uVDjjZcoo7NR/Pth+y8FN5lcfbkNq4dVO5fvIr2P4nQGy7Snk6dLlxt5IrzK1akqxcBm/FGjgbfeKV9bkJ2v6UUxlzOgM8NgDAisk+cuFbdMLZeNfu77E4RQNF6/cabP8HT4HD3uZgZ0lxbD6tvsIMZr3e2hVHVKZlzqIW874Iz2rNp1FzK3ws/SMF0NotZ6gfiaspg/kzw8VpsxsCqK2IeeeLeXEhqtkei/DSvcXpiygoDKSuPyM3udKaBWycYCaZuMTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EnArDNN3WsMHONzvPzB22rtZBtbGHu7FKEnf68Q/WIU=;
 b=zSB2Z9ukOzdTvQ6BkeMWAhd6ZMHj619g6E+Y2TNBdyufucIy73Kg4j5PQJlX+8qy8EtTdsh3eovmaZh7MPs7u6MAdyZ1h/YC+/rNTSxJ/r+d+cF3uTOFZzmRg3H9ZVSbpVwk/VJMI61+x/a+Bn4FrwIIGmGGdRpW5Moobx1TT1E92zjq9CMYSrqWHhyp8KePF6ko3sdAxWL/hEx/1WriyXigM1voFa4N03y+ZRKF/+XgGudNLg27xM1pVNDR49im3K3Zd1jpIJeTMAEx+wzeAfUL7bBNXr9+1mosTKg5wL8xAMVpbus+lbW7wNlcAhwwEruANHIe2YVzwmmbN11EKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnArDNN3WsMHONzvPzB22rtZBtbGHu7FKEnf68Q/WIU=;
 b=Rcy758h41AWsS4R7D1cG9TVTRV2OINnWMrp2Hjxwe/YK0wQzeeLxCF40DKQ8gpqWu2kaSBIsppYqY7vEQItG12Va4JotayCQfhoqsSpaQS5jf2zWYiJkKUFjMCIbtQ9oJSDvKhrVKHWzoPmkDshb1q5eAToZHOl4Ml8GoYwmuZRrdycphMB9Vfq6c4OME60GWX1+WjfP67AdmyoV4L7j4NeHa9XSrS57c0AwVRDiL3wBjgV9yWfVqF+Z/cEq2j8eX6vDemPP3PD5eP0tIBmPN+U5dsKku2AiGvoZcC7tjjLt45HwEQE9ynYH46Zow+Wv/dB8M1EEDGV/W9T1iBBsjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB7330.apcprd06.prod.outlook.com (2603:1096:820:146::7)
 by PS1PPFEFCBCC15E.apcprd06.prod.outlook.com (2603:1096:308::26d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 02:10:01 +0000
Received: from KL1PR06MB7330.apcprd06.prod.outlook.com
 ([fe80::d1d3:916:af43:55f5]) by KL1PR06MB7330.apcprd06.prod.outlook.com
 ([fe80::d1d3:916:af43:55f5%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 02:10:01 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] scsi: isci: remove redundant condition checks
Date: Tue,  9 Sep 2025 10:09:53 +0800
Message-Id: <20250909020953.382791-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0084.apcprd02.prod.outlook.com
 (2603:1096:4:90::24) To KL1PR06MB7330.apcprd06.prod.outlook.com
 (2603:1096:820:146::7)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB7330:EE_|PS1PPFEFCBCC15E:EE_
X-MS-Office365-Filtering-Correlation-Id: 1faf52ca-682c-468a-1d89-08ddef45fbde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kGbrgyOqleAdfW758bkfFy4RTccyTbBw6n3JUHcsTV4D4VZqVfgwJMoA2FnW?=
 =?us-ascii?Q?MCiTwH47i/bpyO788sTr3gcSqhgNWQJD19Jg4W0LoAklSxqa7MD1GZmHERZd?=
 =?us-ascii?Q?ZEfKl1yFrf5JLouvjiLKd6NkWW3gAxgOc8rJg9yabHBNbDf2sVceyTsT/0J/?=
 =?us-ascii?Q?trtIpYbBCGOg2BHgcYgwhZqwQUcrEOb1YF7vqExfHFGM11NPWiauA+v1p2oT?=
 =?us-ascii?Q?K+qOK5xMFmFF8wlu7zUp1JGF77nLmcFZa+wvuLE4k3/4F82xw493yhRQ8gcF?=
 =?us-ascii?Q?+nR8T2ybYKC79Te6QldQpth4uaXyyqZMEaTxdkMbrq454/hK2rJjePv8s/EV?=
 =?us-ascii?Q?Fy0GKwXb52itNkBLOXNZ9bsSOgladFD7AsqQ6VziPB77n3SgD+ZN/MuSkd47?=
 =?us-ascii?Q?1sRLdeeeihZQKHDWUtTyjmXFgTySba8/HfgyAipT9V6uj1Q5tYEcBy2ft12A?=
 =?us-ascii?Q?uw6AIRBrQY6cWBz6W/g/yj4Xdf0izVsqlwmBAwAV+6JM9cD6MSzcVLgILe1v?=
 =?us-ascii?Q?IRrSUvePf7zPgotMqrQ2fh5Drew1cEnIxZsO6QGUjQKYaD4BdG6IrogG9d0x?=
 =?us-ascii?Q?KzhlDP/exdrXFXPRnfguZzWANNpZcJGfi4ZxMScX27ELCFpEwf+I5xrw3YXj?=
 =?us-ascii?Q?2FDneXiNUsq8SuLCPrsyKK3BDitxrRYahBfYGIiqE+sbsRv1dcMAah46Obvq?=
 =?us-ascii?Q?Z6mWTRUg+XV7GTqZzTwoPYlhp25LXscR8FeplbohQDH/SENznW/TNI1gm/Tj?=
 =?us-ascii?Q?69rOGm/Vr6tJk5UlsHrmXFPhJbS0CB15KLSEKCZH7Ir/X8q4LTFumAJ9mwmp?=
 =?us-ascii?Q?8qprfXlONnIDgwSJUMkKS2IUGew++BdKUBWKCeo+3sTxTNHGHD1raUU9YxQc?=
 =?us-ascii?Q?Kk+9iSm2wilvaejVgMKZutxWvclIC3wEtgdmMI67RfBIEjBdnip4031StrAO?=
 =?us-ascii?Q?PpNeHu5y2iG2+m6A6zupy1ZzxM7Pp/gsEfJWMQqSlE232dQ7XsbOSdFZ3sXS?=
 =?us-ascii?Q?K0JmcqYrhgxvmi2PPCyShGMG/B3js+RBTChQyX5+NW3zTEIrokbZtLt4ledm?=
 =?us-ascii?Q?xsLSaGiJ77KkxW69hRYm1sdGBV4NCxp6ztjPqm6JU1vmAG+WBXM8iuCEmo7n?=
 =?us-ascii?Q?PlTTOwmSyeuk8Oz/Ps5FpavDAj1Jmd9ZzMRq/o+/KWpjz65w9C8Ybs8CK3/k?=
 =?us-ascii?Q?eJNCoKUXBpARD+eio79PbnBiileejQHFatmBsowJ1oLj8CnEvRgOOr4bkFHZ?=
 =?us-ascii?Q?WiTnXABlihztVJLUrv4KSYeiT+3aIJsnoQsJwNnakpC88N/jUci+Xq8RV5PH?=
 =?us-ascii?Q?zi71YBlKfY6Y8f3HIPHWkb1JlR/wG4P2sQdenGIh7Ey3aCx834JLopOiek9t?=
 =?us-ascii?Q?4C7BkSJvHMcSGiXohdSdAumkIdD9zBhH+DR1KlI1GkW9G3sakc2+nbRFv+U8?=
 =?us-ascii?Q?IRBs8jNpSM3C2Xo9VdpXTBQvfOcqE00qSrYieWTt0UgGN3BPCrAMfjzo25J6?=
 =?us-ascii?Q?Ns4eJ4tg/75dQAs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB7330.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gEx2DQL3v4yTrOWlGSeS2lk40IhKESwIuEbDyw2mDvdcXy1IxOYoQD96RV/P?=
 =?us-ascii?Q?ibffqCrqaEa50QsF8tUVyNxroMANOPMnR7bjKMIP66w8D3ZHQbUHJDW0ZWll?=
 =?us-ascii?Q?tKikE/cX5yx+UnLcbnPA2mTS2h508KlmKnYa1CCK/7JGwfXyyYoSZskYb8qQ?=
 =?us-ascii?Q?NHniUa/xSB8D/f1q6d5jGdJwW0xUh70u2BmqQImwRgv2KsqvUIZNKvp2C0V+?=
 =?us-ascii?Q?seLAi5sYfCHD+mOmOStheFkwM3pMphz+02gDtCp2sS7cmNrXbN/JuN/brlRr?=
 =?us-ascii?Q?hGDmwWreRYqA59xvN0maEFxrshLxsOi/L43vOIUCvpnP20o9gavxbh2hcdOV?=
 =?us-ascii?Q?jYtiEpbGGw6cYzXmoGd5hs0gF9iBbWXT9ppHSUnClZX/2vWPJMwX/Uof3quy?=
 =?us-ascii?Q?2EgU3Is0nTqQ4s+H/UYnirmMMUpduSjDRFEdRnFH4A0XMfyhR/pIuGON/hgE?=
 =?us-ascii?Q?cNkiZ1UndQkmtkceV1XYF8o35Qlw2MG9g9i3xJiCf/L2LKJHedKzsXA1rfPS?=
 =?us-ascii?Q?i/U/hy1W7DXLA/v2NPn4M+hfbbRoD+b/n9uUCIbFIlpVkcQvUgfkx13A7WTt?=
 =?us-ascii?Q?3dZ/iWgIgoibcu0jCdJ8zRKjxYYFd8Ln2Tn727WZauYYs8NLmluHwHBKfC20?=
 =?us-ascii?Q?G7gq2v4+0TsGVSv/49eEaOIMVnqbKmrAE22nEB2tELLuOsOvo5Xr1eIcPYG/?=
 =?us-ascii?Q?JXBbpz7jqL37Fsv6SV3knrBeR4go2SNgMEXKDmWagc/lbHjcIDTwlD0FGGpa?=
 =?us-ascii?Q?DqbjlVM96tVK7JSuGJY6QIPO6YB8Exiv1xGXxW2Nw1gPGIbLfapX945iRymU?=
 =?us-ascii?Q?QRiK0ATo64JU/wB4bAjj3fKFMhk4PjOVYhu/RtwJlTv2qajenQO5QHKaR0fI?=
 =?us-ascii?Q?N8FZFTgD+STZAi5T3a9oNVggZd7fh6c+E1BAKEnnHmnpflWQxjwMC8iYl10h?=
 =?us-ascii?Q?LJK2TUNEiWWEmiNx/lvhhamzi/hb1CVtt/ZRIcVJlLuZMU2GR3speoG2Iit4?=
 =?us-ascii?Q?fmBOQ04AD+DR+13Wyxv6m2QGa9C4LOKDEkOioYpUzgHRXcG5fBGEEBtrI/Da?=
 =?us-ascii?Q?A1Pz2jZVZabbHm8LIzUcwAlU08a2VmbZOK+G1UJhnjfxbv3sDDPDU0ME9xE2?=
 =?us-ascii?Q?M02VRmdDiKKeMJ+5rbGoDj4Gg/ZJSnhjeioNCyxIQf8KyxAvXcP0hnHPgK7d?=
 =?us-ascii?Q?AoLCnzLO/R4WeSC2N2ZcWlRpNwFn6g30zH8wEgjgyaKoZwapiXje40PCukIy?=
 =?us-ascii?Q?uop7Gw4XwO1biPtTOE1thQC4dCd5HNJvKcw9i4jT0Zs33g6LEgI5WCfmWKBl?=
 =?us-ascii?Q?B1OEK8Bd4N/GUDMR8nwauCtlM1mtxyk28OdVPTsIoNuuAODl9W1BOqAaNv2m?=
 =?us-ascii?Q?bmX/MuBqDs8poFrTvZWbCSPHHOCsEcOf4ENuWje3RMQtQ22TNQ6IDV6Lit1p?=
 =?us-ascii?Q?RD4lY0GuNAqT9JlrsRsKf+poKUtscm/s0xVl/shoJtJwtGtvlEBxdLQNKv+6?=
 =?us-ascii?Q?e3T746ISCxaLS+1LGIqf4JaH1pvnE6W+caBNCFsIqxY1V+N4YtOUNZQCoJGj?=
 =?us-ascii?Q?nmbYaS2r5HvE3mGU4YjmKtomPH0a4fHXSSQNIo86?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1faf52ca-682c-468a-1d89-08ddef45fbde
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB7330.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 02:10:01.5836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwVDkdol8VDd0mvF2ie4zXHwSqMJGxd0oKGzPoHVaG74kNpJDqUjXHVQNYcyFRpyVQEhdmkc6DIOQz9+XyMORg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PPFEFCBCC15E

Remove redundant condition checks and replace else if with else.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 drivers/scsi/isci/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index bb89a2e33eb4..e035c88775ef 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1374,7 +1374,7 @@ static enum sci_status sci_stp_request_pio_data_out_transmit_data(struct isci_re
 		/* update the current sgl, offset and save for future */
 		sgl = pio_sgl_next(stp_req);
 		offset = 0;
-	} else if (stp_req->pio_len < len) {
+	} else {
 		sci_stp_request_pio_data_out_trasmit_data_frame(ireq, stp_req->pio_len);
 
 		/* Sgl offset will be adjusted and saved for future */
@@ -1511,7 +1511,7 @@ pio_data_out_tx_done_tc_event(struct isci_request *ireq,
 				if (stp_req->pio_len == 0)
 					all_frames_transferred = true;
 			}
-		} else if (stp_req->pio_len == 0) {
+		} else {
 			/*
 			 * this will happen if the all data is written at the
 			 * first time after the pio setup fis is received
-- 
2.34.1

