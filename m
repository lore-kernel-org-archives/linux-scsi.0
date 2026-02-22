Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB8B13959D;
	Sun, 22 Feb 2026 23:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771802996; cv=fail; b=UP+SxPALo1aiV4+qwBmk7HA9dDOC8nyEJ0C7FtyJh9+Sz/Lgg+Z4sEjZCdHuEQ88q0GM2Zh8m0X7CRw+fyP7ENPNPyBKAKcb8Q4wzFhtVwx+BdvGpyO+RtddhwMy13gCksv5DKfz2pMdNHwY70pjquwsRUwGGhDW1SHQoEjVdxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771802996; c=relaxed/simple;
	bh=KEyZxdhgl3qzZhx7wZYsAt/QPSIHMTVliR0AoyF8Ink=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tHh5zvc60LUlXoRjbuD/4cDvzQ0BSDOmcN+uKqcX0MMC1BtptOAmaNU/3cqHHrdWrdxMDJp9rGubGc1hC8xDM5JALMsL7skL9rTcGJkaigykPBS7V5jeVKAeoDPr9E//poukd4kPoWL+E8WCJ0EEFVut+kxUXgdQJTGPicDLfkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ND1Mvzq0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f1445hHB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ND1Mvzq0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f1445hHB"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MMGqWW1726004;
	Sun, 22 Feb 2026 23:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wwBlaRmvMliuieveWl+v1XXUKJXciAoP9JC2jkNRUyI=; b=
	ND1Mvzq0E75Z/wwx4GFfCnlK3g6rxLBtTVoYw0Gw8mXm7Iz8K5INorkc+Ucgf9ug
	e5bVjz4g4lPgk2HXKwCianOdmDi4yLpQwoENUUge8cRrPl/RaOrbGnJISBUn+n7p
	wMI8eoGcYlq0J9hDYSs4BGRJy+PLzzSu6LGihmOVF5xyS+5ypy8T7WsD/hmNAU2f
	9jV49lcVN/ER50ffSzTKNHuRQahFZxBTmCyjnxFK/XZ6JMDjV5KHX3qj0OsVYEQa
	h70+b/2rUiW97D92fx3Yjr7Tw5mvygNihDVwk2QXy06Gr4yurUj2AHWj0NVoqDX9
	DbclQEfa7dvNvUUhgf1kCQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rb9b8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61MG9KQ4038516;
	Sun, 22 Feb 2026 23:29:52 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35hxtcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Feb 2026 23:29:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZkIQkJUJC9Pv9M+FYEUnJUw+f6niNlJuhppzZBOKZVX4wJsO8ICbeMSIfuZrsVIcsYyUDnoRNdKcBK3xP9D6JrlArckZUznRqn0OsLAS+s4eLzeMuQrNvjdfQzsLl6g8RJLbpgOiW1ycauBpswVe/ONcyp/u0Dy9QUbs1k+wSlK48r+uv4B0DTv9AMqHt5wCoUu4e7vUMZH0jem3m3HE9koYHRLZCfnL5tNv8TO3OQ8dMZFJNREbVdBW/q941qjEeIAwi5S1JXrVknFyskhjbzQZJFLZh9NX6pd9DCVYuN13TPTooPs6TdcZxZ44I/pprltPnELtpwgr15O6IFpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwBlaRmvMliuieveWl+v1XXUKJXciAoP9JC2jkNRUyI=;
 b=TsY+atph7PopKGt2NO58iWv9XSlrs8nsh4DWyEPww/GDjkiFlWDmOE4tOvFk9HfCaSo3dKMZnLpiqmb+EoYjSSe+wCE3QZJjzPMqxwGF0hevXqZOOvmSPliZzyrU3ANl+nzAuemPYMLTEr0OUOReNc75JPX+KK1Wm2ePlVq7fJ5WIxOPgL4RID0kzIfWUWLdBHwIgb+mNFklnd71VcjlRMytTiMKMy5dOe1+R/dnIAvo6t20MNhnPUKAAW4pm+Cp89bWZjws1FAqQikmJI2DD7/rK+G4UA6LXpIAstxJdf+JyZlUcTYmh21CSI8KWdA1JS2vPRWDTcSO8SrR0r6XZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwBlaRmvMliuieveWl+v1XXUKJXciAoP9JC2jkNRUyI=;
 b=f1445hHBaG+Jj3Lv/ccbv9ngBSPJMYBvjW/gbezKxoIbfG28pWZGGClXVQAf2PQTOUxr5iYh3CGpM1cJLYWw650DZ4lHruUt+UPnYIr3YZqUxED2RTz2bn+yiU9L7CbkM6JsI20qWiq07PD4ygOA5mAB9K+iK2dTCbfJK4c9iDM=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CO6PR10MB5587.namprd10.prod.outlook.com
 (2603:10b6:303:146::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Sun, 22 Feb
 2026 23:29:50 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9632.015; Sun, 22 Feb 2026
 23:29:50 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/4] scsi: target: Add support for completing commands from backend context
Date: Sun, 22 Feb 2026 17:27:01 -0600
Message-ID: <20260222232946.7637-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260222232946.7637-1-michael.christie@oracle.com>
References: <20260222232946.7637-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0022.prod.exchangelabs.com (2603:10b6:5:296::27)
 To DM3PPF905D77450.namprd10.prod.outlook.com (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: c4c478a7-2267-4549-bd7b-08de726a4634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v3jiHvZVcuB/3t0b5T2u6146DQH/+o+VchQzvpcjhH+wQCJR/eRFfzvs+xpn?=
 =?us-ascii?Q?2AfLwqZiu9Saj9NdrOjHdo2Y2/qMM9curhIGH70JZovcEQzaWcnWCectS7sH?=
 =?us-ascii?Q?/O6h9LKyCoBCoOVhac2WeeoG0d4waFdsejZb6l29c7LA5J9+f8srMc9MMr2O?=
 =?us-ascii?Q?E7uhbMv6X0L5tRTQzHZ1XktAApgnjQ8cVK/th1dIrizFp/HT+HzaaZ/2UzeJ?=
 =?us-ascii?Q?N9hL6zNbO5RPYhuanZszwQNMTPPcwT1Rz7WKZZ3sqOH1/WEtLPSyknEVv9gZ?=
 =?us-ascii?Q?N39tISURX5rR9LTopW8wIYnvqknEeYOneOmKdYyLH5oY8kxLJGxx5/SVl3qe?=
 =?us-ascii?Q?2ryU22ourOSkxhnKx7u+6o/bAWw4Sl//iisu9hUZG+e0MzLHnGRleMxw4JzD?=
 =?us-ascii?Q?0n7/i3mxD59DJY380iwnsdJQ8KDAr8LeQLJ2gy7i0ify99ewOvP7KCbzWncf?=
 =?us-ascii?Q?ZSTNPEAelrM60wOSrUlM8XmY8QxuEciraZxe6CAdEf4RqilzNx1JBXFxLnqY?=
 =?us-ascii?Q?FmHt/ueXucZxlPIrTeGZJS86R0rVGtZbjPFmFlwP1BeY+b1MkdL67CWtx8hf?=
 =?us-ascii?Q?BlXtIzZ8dhSgKlLnqtW7AKeQftkrsrHsq9RUnqzIAMcK29IWLUqfCvFx0jdl?=
 =?us-ascii?Q?iqO1AayPCMDhfdyfSv1dFmTl+18vHMnLROhGmDyQ5dW8MhkWbSgpkLTEdcR0?=
 =?us-ascii?Q?Ip/2sTlFYI5UNDVNTsik1TJU7R2BhchZ18dy9JSJbfLVSsS4dtgRD1yDVbwe?=
 =?us-ascii?Q?lzl7vkBN+Aux6bjKXVbkkmgHU9kdR8kjcvF7VNbslTfCnTg0ZmYEV6hlLqSi?=
 =?us-ascii?Q?krqb7qj8WAUVNrr7GTkrYia6DJ0wrBf+mA7y6myyLSABygMV86MGkM8B9qtI?=
 =?us-ascii?Q?xnJ5jNGHhkOFshNCn9WN+fcE40xawZ8fQ8eo+DPf1q6jlMu2Ytd1+h5rau10?=
 =?us-ascii?Q?emNTBKDQAYUkSFBTQhYmOCybMW3R+8jUJFihAF2rw9l3msKgT7F9iJKyFEtm?=
 =?us-ascii?Q?PsdW7TzR8vYLqMEX8sPr8RGzlwdeYlJOBVteFQUpUklVkjkC2mtqxXhckR/A?=
 =?us-ascii?Q?q/AfKsGC2nsB1gScjA98xMVkwvDQaFkrDBos2G90ljtw/PVXAjHJFTY3WcDc?=
 =?us-ascii?Q?mO2wru1OIQ7yowx311ctRxatsRwVJbf2cnatASxfMWlwEDoi2f/2Wtu+S2Br?=
 =?us-ascii?Q?elgCTs4WnE3NjO04/0wXGLvB4syIbzlaMbAvec851LysG3x110eWHrUtQ2Up?=
 =?us-ascii?Q?+HFZJokt0gbmkjW+CKQVQ25nqTkCZpva+RlXiNAszHgnhJEg6+qKZEbaZLnA?=
 =?us-ascii?Q?9RWPzVwO7yOIaGDPbpO2UJ5vWhG2j1pv68UhG9Cw+Wexp8GZ85D1WMFQsVJb?=
 =?us-ascii?Q?XpEMh1KM45z9jtrFbXv0ofDaDm7gV+pN/ak7bOf9wzw3KV+VvHxruA6lZdUF?=
 =?us-ascii?Q?MOSExUAx3hc5d4f08aK/65CdRbqhKYyUYAhhdVu2Ejngb3jL6HhWNJPoZxMg?=
 =?us-ascii?Q?Zmevk9aIqRDY1Pee0aibOCB4lCnA4U5U7tl9kxSZQ+GASwVkijTLKSNRME07?=
 =?us-ascii?Q?az6qBccfXNHT5I9TdGM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LSniwQBttr8DSxuMygfDfpb3ySIIC7Woj+ygXjooK5jHlEC+wrRDBjhYUAEg?=
 =?us-ascii?Q?spWM6/ChtBjU4C1Ha4m2XxiVM5+9rRSf1julhhnMsPSSg3aNjjv04+SrhlNJ?=
 =?us-ascii?Q?BXDZ5csTcdar8za+KLscO5lG30YYCTL8WeadP7j8k9zYddERfZRSxoUVc3MY?=
 =?us-ascii?Q?lZZmuv4K4Ry6BRh7o9Am5TtY50NBmpi6higgOw78PFAyXEI/3RNhqxXHwNgB?=
 =?us-ascii?Q?E/CwOrvpyyzF+Hm6whHO/0202PT6fc7p5gJJ/JOj+if5tqby/kPTd2AFNCvI?=
 =?us-ascii?Q?Ws5ux/jX7PlBBuLBlI1Zigdf7NZaDYqDt0NO+ZECBoniVY82XnzIS8gYT0Xn?=
 =?us-ascii?Q?6uOl0Wc3sSKdHLaishy8BlxGOvbHu1dGDCpPdpuk85C2aeh2H7SAzhG8JtTw?=
 =?us-ascii?Q?lFHp4w9VGAlVc9rEONrEe2iouUfQbdcF05uV8yDXUpbvHr76AVNkc7Z0MLOw?=
 =?us-ascii?Q?2fPiPmAijUhVO9BzmFaVCkkSXm3Str6N48ZjL9izwh1NAOEjT9uqjxlZxh4z?=
 =?us-ascii?Q?KT5jS9nOdrJ4wvsw1cWTgjGy8jYWo8DXK4Gcc488vweDlkZWlpAIZIzqZQVP?=
 =?us-ascii?Q?dtP9vOr/qVMEGN/MVYVGaWg7AyeaE5A762ixdKjNbuhLovb0deE9gf8UzcGY?=
 =?us-ascii?Q?bYxy8oRXEVAo7KtHWb/kX6cCe+kZ9nMwOioXOXgjHHDWtIDn4JuB/LMKA0X6?=
 =?us-ascii?Q?REXwjDjhhZLEQB2LS9ouu7sIH/eoSDbKXH9QD4QxbbQ/KW9fJ0rYUXyqiL9z?=
 =?us-ascii?Q?0m7xzTcgn9Jfjf5/2Qdr5IBLoGxmS8oFMnlUBP8Rb3WuHNhFL0cAnD6vOlK5?=
 =?us-ascii?Q?pvVVhVvE9CgHEa0lWcUh5rX97N5nLYfBBdKqEMPTraeG2dBGYHjlQ/upwHwg?=
 =?us-ascii?Q?ICWhnz+EaoDpir5XWkKOsWRr5WcHMunebx7Wkemq2Lv98xIaSqWsU+P5vNX5?=
 =?us-ascii?Q?7b+PeZ261sFBioGpCTOVcevT/NOfV2zK5jMQPYmMXJkul9Cp0MdbifFnSI4Q?=
 =?us-ascii?Q?/XqwhlLB1RB7DW4m+d5w1bJqPk9hcj0N7oznb1hx3eDbJQJS39Q0J3CML+4R?=
 =?us-ascii?Q?5GxZDmacAWO20yy19X/Tc69Dsd0ryBAf9PZ6uEYozPkFpm6zLzXF8+fEYx+0?=
 =?us-ascii?Q?olEOfopCaVko3svy9HryUkBFDemuh3L422r9g+M754arrJj6Xb+lC4dy66SJ?=
 =?us-ascii?Q?ihVeQHUVkiGFvPf5GL9+e0Lecmxew4MR0+vJYrnOUugunD8xQb0GobwuoX54?=
 =?us-ascii?Q?elielBLL+peghxlIaWImBINdAquiwglPKQ1sxzhd3RXmAQ3L57HDdFfphzzj?=
 =?us-ascii?Q?LXGv0M26GbxtTbVW59az+A/KJpR8WOWjDT3OkdzfKM/+91u+fq0nwQHk5pJy?=
 =?us-ascii?Q?1cm+WnVbslkSlLq2tKxreNLS4jG7qcKpCGOYgxaXL93gDSQX3rWl9R9ufD4R?=
 =?us-ascii?Q?qJDGplth4ruzYXl5yEO+uEfgvDYsSwDRVccAOQXJPq6Q6Q4P+GfrxD0ItOVM?=
 =?us-ascii?Q?pNSgxqRCU00oPiavPfb6b+IN8kWKrEJjKgyA3PNpEjook6TC0KaaQU0Q/SeT?=
 =?us-ascii?Q?XuaimWEG3mVP/EhmYV1pHZOTOrQ+gyWsND6UD20NUZGqtVjQT6HYDwaZolmp?=
 =?us-ascii?Q?3NtPduBtc+my5KUuN0/RqDt/lex2X6gcNBpNJ9oYld36M2mlgwZ55d5aPVhW?=
 =?us-ascii?Q?5yZYpMNPvqbq0x01S/p1k7pTj0El3iJ74hCZ8c5ncP/vuWGu5UPfgMAe5bs+?=
 =?us-ascii?Q?I5mpTeuUarEb80Y0GyCl62bnXfQ9PMI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2SQv37oQskhyRq2AUuJjwLtzxDenRWfVhastvG5Lxuc47vilC1oM2TuK6OSpsGKgMuXgq342sj67I1FBWmM6utqvj2juOJaJ0rzMp1PiQBUUny+348FTITdg3XN/GeG1arXlu4ABPDbofFMZQrqxkaoD+CWOlKCaOz0P5vHaYonlKoAvdGClMPEsNGEn1itao0PugqUUoCuPkGHjYpiJLc4FmWEt/U+mJHw73hoXykuKpjo8AwLCYW0dLsRiRW+20trmwYYDCs2nOlJ75NsGSSNCKi8mX93/H+PrgR14irmmWSPNyO8zZCV7bGYqV51jyr7foOELWLemnDFgPG6mIZOgm0mijA3yKYQTZaLXom1XzL8r5drDJQ48eXhn7CJWteZdjgfrJscfh8KtwIDR1ZLEXpLPmZwjpE52cVzv45MAvF7Zu9sz29995ZhXY1S2E+PyWViZd3NvyC9cPP0IgP+OX/6aSNNMaOKSM9ACNoqtX+qn3XrUDJgY52pKGXzqQrg/4k5fUe3ftSdw6DlNA5auVn1FnU7EbDUMGLrtP+07W/I+1IhiC9wu5Yp1zAdmAc16y+PHNibnv5p85raVexCCMv6WO/KpqUWg/T7ZMX4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c478a7-2267-4549-bd7b-08de726a4634
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2026 23:29:50.4594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trxSjqxkGbFwt/eMOlagy1OmRbs+Hw3MBpieuVMefz/MQxJMS79FqcL/kGPCAUoqrNuONL9s5JnTaI/FQNgsOSCCsAxRwqSvGydVz8Pi0+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-22_05,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602220224
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIyMDIyNCBTYWx0ZWRfX/dmkPxIP6csN
 gj8lEZ0Pq1EDkxBGixWTzVGxuQ3TOCVvw7dknw0Y0XmPa/FWyqEgzBYh6yyiuoU53h8Gs+Lbo7v
 ZX4QsWRcsKbGoDyQjXyotr42FIGK7sueRZk+Y7cZgeF0OSTRtuQWVBZfg3OgrR+zbl7m4buzysb
 gU1RmaCux+BNh47hJGudxQjTl2/yq4ZU/ecdu2KrIR8XlAyYF3UNNwIwbXbXNJgmfZB33N1sEl7
 MnkQTkSqX+VUjcXE1HLRNUi1BrYrtKgi1sW1gKLBWChdWQhDK61LBl1N5RJyMtrTSUSS6WfeCMn
 cJ/XpupZOtmLJu4wVbJs/B3JkGLw/JU5TC+oXk5eUKJ91Supf+gMFyCwvesGI9u1PJJdAwLPGFT
 GakAFXXNh9ohV5OCpYizqcBEIlx4LR/kYOYM6JpdwImkH4Ow2iUQdaVHwe8YREH6Lo7tvbdEn7v
 8ZU2PLUnQdIefi7iNxIjqys0/cXsW2LiOgNNaF0M=
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699b9171 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=lwqBHraMydpJNF5POA4A:9 cc=ntf
 awl=host:12261
X-Proofpoint-ORIG-GUID: s1mg01VXSoIlA93IcB-eN_uGbpqWKp4b
X-Proofpoint-GUID: s1mg01VXSoIlA93IcB-eN_uGbpqWKp4b

To complete a command several drivers just drop their reference and
add it to list to be processed by a driver specific thread. So there's
no need to go from backend context to the LIO thread then to the
driver's thread. When avoiding the LIO thread, IOPS can increase from
20-30% for workloads like:

fio --filename=/dev/sdb  --direct=1 --rw=randrw --bs=8K \
--ioengine=libaio --iodepth=128  --numjobs=$jobs

where increasing jobs increases the performance improvement
(this is using NVMe drives with LIO's submit_type=1 to directly
submit).

This patch adds the infrastructure so drivers and userspace can
control how to complete a command like is done for the submission
path. In this patch there is no behavior change and we continue to
defer to the LIO workqueue thread. In the next patches we will
allow drivers to report what they support and allow userspace to
control the behavior.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c    |  1 +
 drivers/target/target_core_transport.c | 60 +++++++++++++++++++++-----
 include/target/target_core_base.h      | 12 +++++-
 include/target/target_core_fabric.h    | 12 ++++--
 4 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 8ccb8541db1c..4e6736d469fd 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -813,6 +813,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
 	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
+	dev->dev_attrib.submit_type = TARGET_QUEUE_COMPL;
 
 	/* Skip allocating lun_stats since we can't export them. */
 	xcopy_lun = &dev->xcopy_lun;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 50d21888a0c9..2034a0761dfc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -902,13 +902,59 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 	return false;
 }
 
+static void target_complete(struct se_cmd *cmd, int success)
+{
+	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
+	struct se_dev_attrib *da;
+	u8 compl_type;
+	int cpu;
+
+	if (!wwn) {
+		cpu = cmd->cpuid;
+		goto queue_work;
+	}
+
+	da = &cmd->se_dev->dev_attrib;
+	if (da->complete_type == TARGET_FABRIC_DEFAULT_COMPL)
+		compl_type = wwn->wwn_tf->tf_ops->default_compl_type;
+	else if (da->complete_type == TARGET_DIRECT_SUBMIT &&
+		 wwn->wwn_tf->tf_ops->direct_compl_supp)
+		compl_type = TARGET_DIRECT_COMPL;
+	else
+		compl_type = TARGET_QUEUE_COMPL;
+
+	if (compl_type == TARGET_DIRECT_COMPL) {
+		/*
+		 * Failure handling and processing secondary stages of
+		 * complex commands can be too heavy to handle from the
+		 * fabric driver so always defer.
+		 */
+		if (success && !cmd->transport_complete_callback) {
+			target_complete_ok_work(&cmd->work);
+			return;
+		}
+
+		compl_type = TARGET_QUEUE_COMPL;
+	}
+
+queue_work:
+	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
+		  target_complete_failure_work);
+
+	if (!wwn || wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
+		cpu = cmd->cpuid;
+	else
+		cpu = wwn->cmd_compl_affinity;
+
+	queue_work_on(cpu, target_completion_wq, &cmd->work);
+}
+
 /* May be called from interrupt context so must not sleep. */
 void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
 				    sense_reason_t sense_reason)
 {
-	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
-	int success, cpu;
 	unsigned long flags;
+	int success;
 
 	if (target_cmd_interrupted(cmd))
 		return;
@@ -933,15 +979,7 @@ void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
-		  target_complete_failure_work);
-
-	if (!wwn || wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
-		cpu = cmd->cpuid;
-	else
-		cpu = wwn->cmd_compl_affinity;
-
-	queue_work_on(cpu, target_completion_wq, &cmd->work);
+	target_complete(cmd, success);
 }
 EXPORT_SYMBOL(target_complete_cmd_with_sense);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7016d93fa383..aef61826922a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -108,6 +108,15 @@
 #define SE_MODE_PAGE_BUF			512
 #define SE_SENSE_BUF				96
 
+enum target_compl_type {
+	/* Use the fabric driver's default completion type */
+	TARGET_FABRIC_DEFAULT_COMPL,
+	/* Complete from the backend calling context */
+	TARGET_DIRECT_COMPL,
+	/* Defer completion to the LIO workqueue */
+	TARGET_QUEUE_COMPL,
+};
+
 enum target_submit_type {
 	/* Use the fabric driver's default submission type */
 	TARGET_FABRIC_DEFAULT_SUBMIT,
@@ -737,6 +746,7 @@ struct se_dev_attrib {
 	u32		atomic_granularity;
 	u32		atomic_max_with_boundary;
 	u32		atomic_max_boundary;
+	u8		complete_type;
 	u8		submit_type;
 	struct se_device *da_dev;
 	struct config_group da_group;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 3378ff9ee271..3f68efb5c7d3 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -118,15 +118,21 @@ struct target_core_fabric_ops {
 	 * its entirety before a command is aborted.
 	 */
 	unsigned int write_pending_must_be_called:1;
+	/*
+	 * Set this if the driver does not require calling queue_data_in
+	 * queue_status and check_stop_free from a worker thread when
+	 * completing successful commands.
+	 */
+	unsigned int direct_compl_supp:1;
 	/*
 	 * Set this if the driver supports submitting commands to the backend
 	 * from target_submit/target_submit_cmd.
 	 */
 	unsigned int direct_submit_supp:1;
-	/*
-	 * Set this to a target_submit_type value.
-	 */
+	/* Set this to a target_submit_type value. */
 	u8 default_submit_type;
+	/* Set this to the target_compl_type value. */
+	u8 default_compl_type;
 };
 
 int target_register_template(const struct target_core_fabric_ops *fo);
-- 
2.43.0

