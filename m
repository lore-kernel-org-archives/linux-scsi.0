Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396783595B;
	Sat, 17 Jan 2026 04:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768623117; cv=fail; b=Qcvsb2ein0oqzuZWGrOucCIIJ3sjTBqORQHTEAyBBEFpnDdUio3w5vHTVJWzwc6mxe3icFPSaAS8s9ayyQL1kohw9uwXZRS9O2On4mRcaDpQaxRLeV5QMZxrTQRfFDL8o4rP6/nS7LATpFwDCiItO0NRQLl+YoOBQ5q2Fk5k/QY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768623117; c=relaxed/simple;
	bh=Uz8lQajQc3hZHQBvbl98bsgHxUhSFeKu52EbcUGzcbw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UF/2uxHUjW09HF+NxG3jz9iIy/17DUw+N53QitDNcr2t3DP1oJagPtLoqoKkCVU3lVfbc/7iTkZ0ZVmgachLKjtThQitvF8tsnpqTknyDWL4LwFCiJyA59KOtvkxkWIXrjpihfLnVLfjGNWsXs9lxY9yarDAQNQMcA7Z/xsHvxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A/jf4siP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Qrv9rp1F; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A/jf4siP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Qrv9rp1F"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60H3vOv71088319;
	Sat, 17 Jan 2026 04:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zXgBddFdih4LPmyg6w
	p6DPE3SZMMc+7RLxmHEHOLK6c=; b=A/jf4siP4PeXazA05Wa0rtRvYJnkdEWw0W
	Bu+1IdMqFivJbZZPsuS1qCmmxNbeOuC+mc5X5YwjtRIE0lYEJh9ZBD3dElu2A5xe
	leAmD2PpsU/0dhqMn1QCPfiak5knbgHvbwUa1jkw6dXL6LJgB0caVqR8lHSMNWnL
	9fHklNFlBPvKam+dBErSkSfzM4RprQGQ7NtHnR6kx03IbQOt/pz1hYxvwneN3OZM
	xRB39UWoUlbhtLssOuwQb6U7E6SQ/1E1sJk/9n8uAAzYYzPOysfhL44sBDKjhhuc
	l+YbowKw6+Jw/99/8mUPwKyQw96kgFkQNNRlGcoz6XBabZLZw9Ng==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa00xc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:11:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60H1XpY5018004;
	Sat, 17 Jan 2026 04:11:41 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011065.outbound.protection.outlook.com [40.107.208.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v6b4v5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Jan 2026 04:11:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqFgfwtCIJ15AdhNEZZV3wW+qIjqonQ5R0yGfGzcmOFMcO1pYeIp1dccwmdVZEhQeT9dcCFsX+gZNtaO4wcEyZ7k1IhWw+Ybj1reJiekyOoZAvVt/81DCneauqq2jwkpG5wDSwFyVzmkQYEUr8DOW9pj1ExF46nfNQK5i0dAyuKI4+NbMka8aUKbRWXGPPAyarMC8/xqEAZkha0RVVSxgHbOyeQnU2erKYSTBUzVOCzoT+PiWcWPYLsi1gjkKTnn/nhTp/49Et4CsChoJ/DyByXM0krtfR0PEXTZ4QVxre+V3RIhxjK5SUgtUna0gxZxSRq79R0cYWEVlkzd3eaW9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXgBddFdih4LPmyg6wp6DPE3SZMMc+7RLxmHEHOLK6c=;
 b=OmFy4izSJH2kKDgM4xSVzFs1NTyOo5X+99E/JTLaLlsT/IL2cFR379StbOCMph5/OnmydFkGz456s/mvyTK0gpmw8HcW6uvV4xV4VjFX/4GHkZ3HFZJNwn8ETGQjZFuYKqits91Ygsv7driOaPm9r4Tt/FVL0qFY/ltpiy+8Fgi7dhOaEiakcEQ7asxkdQSBbD7Y9SrpfcY978hvutaOnnPEsM60GkC6AHUM4hcddAWLllzdUZ5DUkbcYH/6eLMAaifvAWw5Riu2SCL7awUD6+dx8FWGR3GEPkUYU+t1LbGEW2YbxnmIDiSTl2cv91g2KRdSAvR4Dt7PpOCQ5O9jug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXgBddFdih4LPmyg6wp6DPE3SZMMc+7RLxmHEHOLK6c=;
 b=Qrv9rp1FCxiedLKZCMtAyTPuO4LJ+LtgouMJmb/x5VktltsqVzsX0Op3Q49LoXit7O4mMY3Ush9AbKGtcEIhg4rVY/vm7JxX5le84Lwv99m+/JoFX7R9wRcj27E6u7qyhQViCtQwRsp+cjNX0sm38KGzsX9vyn6i99ZHXTkTrck=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BY5PR10MB4145.namprd10.prod.outlook.com (2603:10b6:a03:208::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Sat, 17 Jan
 2026 04:11:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9520.006; Sat, 17 Jan 2026
 04:11:38 +0000
To: Keoseong Park <keosung.park@samsung.com>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com"
 <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>,
        "peter.wang@mediatek.com"
 <peter.wang@mediatek.com>,
        "tanghuan@vivo.com" <tanghuan@vivo.com>,
        "zhongqiu.han@oss.qualcomm.com" <zhongqiu.han@oss.qualcomm.com>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>,
        "chullee@google.com"
 <chullee@google.com>,
        "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: core: Handle sentinel value for
 dHIDAvailableSize
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
	(Keoseong Park's message of "Fri, 26 Dec 2025 13:28:25 +0900")
Organization: Oracle Corporation
Message-ID: <yq1pl78j2to.fsf@ca-mkp.ca.oracle.com>
References: <CGME20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
	<20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
Date: Fri, 16 Jan 2026 23:11:36 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0238.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BY5PR10MB4145:EE_
X-MS-Office365-Filtering-Correlation-Id: cf44e305-74da-4522-f88c-08de557e82ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OXwMYSK2uJs/0Q1WKvQ8exZPbbUd+AdiPubds/MSbxcSk0/tR1mfpssyaSPq?=
 =?us-ascii?Q?fJ6oO0cU1e/RjoQRwyGBKaBDBzfGC0gXsOX3THNyeqSikwkRxKZ/01yiz9xx?=
 =?us-ascii?Q?puGwd7d/vzfz0VW3lWcWiKbElXMEPBNIkVkRzAzuWMPsiDK7vKGbP2RGzQ74?=
 =?us-ascii?Q?NkbRMvFSMFMG+OjmJN+GcVEKvR0ymkkXdf2BVCzowBjkU6WB61ZBzY9KCUO4?=
 =?us-ascii?Q?80x9Est4QH+Y1VZ/dGxVMm5A3sTCCm+Tz620x2x25KVqAAVlzbvRqSULHQih?=
 =?us-ascii?Q?Lk7ErdZLuLkVE1GcIvyFdLGR6Io4+llh3Q0yVZux5dnJ+0n/fgjOEgLBmHso?=
 =?us-ascii?Q?FNKNu6uKcspHiwfjQR4atVmhH91Suz699jxxMpBxUk0sszFBN1H4Gxp+CZky?=
 =?us-ascii?Q?8TBi7jTxc8PcYBAfK7GEQ9jC5KJyEQYztoWbWPVuilrZJLhCI6vg92w2rp0O?=
 =?us-ascii?Q?PK8p4ve2gXgQyeScXnPBlB/7GwtRyCYakzlrT4XZgxVycgk6aWy6y5z07OYz?=
 =?us-ascii?Q?cNKKYq1tpoYbZ65x3wMUSGK3va/12I6kmschYgG5XXV/L2fvLWo3VfA1W9Pw?=
 =?us-ascii?Q?TMHXuVNOLwI2oKEYKIYyRW/EM1IZj6lMZaoO+Ffq4dmHKSJbkCzrecYpZxED?=
 =?us-ascii?Q?vliF/GWfkY2fpjUNlQY0M48P9mnhpCb3Op7Hz/+Gb1lkhsb1wvxHALLaI1Te?=
 =?us-ascii?Q?RuOc9LqKr1XU1sJqi153mJFrnHT9rKZfl/4Tth9wxszh26naDp7rE+X+Q9IG?=
 =?us-ascii?Q?w4+XSxqPDmG9+mLzvu6rvY86VZyrb0J/ZNAFPytO0VUnZGfhRjQLNg0NKKG5?=
 =?us-ascii?Q?bGFuQsqSibzPQwCED9d3FkDM5LaWe7Bf5tH3xBIu8i6AYVh3zqIUCxjTB8RH?=
 =?us-ascii?Q?xLe/wDpfuanRlANNAbd8JtP0nEOM9Gj5aCmsUV7IVI1wZ6fm9e8hEibiPzR1?=
 =?us-ascii?Q?18w4nUrEXq/pIvpcCEK7aoKJZe6ve0jecJqWeetiBWorpmRbwtlzOnn3PUSw?=
 =?us-ascii?Q?EP1tCDyQrHuMaObHrJCvQw8EUM5LLeTLAg8ZNzlbbDrTPyCprJSy2GvLJOBB?=
 =?us-ascii?Q?/6Dw/6CFsuJCqA0/e7lfn18EIqWaUlWYyp6fn08kQaW3FfX5LBbN8I8t4fLY?=
 =?us-ascii?Q?ACG2FZE2UUQro/SpzzLCe+cEt5ePuJqSWN74UNH63MAQhcvlw+g5aA4BZ+n/?=
 =?us-ascii?Q?yx/l8CiQpHVUQyIVWkB0/0QKeM4tISPbmPYzdMK9KgXuomimDgrRSmxY7DqN?=
 =?us-ascii?Q?9tVE+Kfe1mdsPImXrAgUS9flJBzgaXqckzjaeS18zmeY5ImovG8JFFsSfzTA?=
 =?us-ascii?Q?n1oc98jQdLUjqt0cOZQR8HEEUhfmwzfueA4sSVmVEGHkL+i5Y7ao0nnLuBv+?=
 =?us-ascii?Q?FMadqDFlR9EiEokjNq58I9aOZ1rZ77qfDQtbczViCRDeXTSRWsi3EpTVAaP3?=
 =?us-ascii?Q?M+MWkFZ6vXPPhdZ4ToWVNhu5CW9s+uBJL/Qlqzzsml9TQciwx57NnNb/K4Wf?=
 =?us-ascii?Q?PIdHx0Dckkk5+FnHyxyuZQVsqxFmfYaxh63VzPmuvcRuJX8qXgB9JUiI2Gcm?=
 =?us-ascii?Q?7/ipzki1iFwd+/oemNo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dzvNqpnW2e8lMLBkjG18WwDXnCb3mF0vsTJ2TxDIO3jTD0Cd2c7G2du0t/xT?=
 =?us-ascii?Q?tcAl83zB9KKcryQTfCqZdsryXChBHG0DR56k2/cDcR4WKtwcWEZ4a+boFt10?=
 =?us-ascii?Q?biHR2hiB32jTbAJDs0j6uO2NaJE+V1UecKpJqfXA2EWRpb9uIhICStkp26qJ?=
 =?us-ascii?Q?WL7Y89pGHeMVYqmXQ31+ouwq4lleIc+PAi+IvYfPC9wRKRb8VlREd77GpkY9?=
 =?us-ascii?Q?4T3SVSsRWSIxjEive0T8ir7aKnkW+ckwDuAJyFLP1eK3UbeNDV8fwOCcVBhw?=
 =?us-ascii?Q?Whmk2vTOB4g1z0D2LsxL50doCeaUXzHCumOQ7F2bww7hc4q27FJzJ0ezZsBn?=
 =?us-ascii?Q?vae0dVTMGgjyEM2KetkcXzLxJRHpZ11MU1+U+1eIotRvKuSjDHJeAy0Oq9gp?=
 =?us-ascii?Q?0Q0noQQDTG2GxKJKgi3yvo9tqPpuFWhZFM+zc1pMeE+ssCrIztj6a/HT/NZj?=
 =?us-ascii?Q?IvQe88qTZZKtGUHee+1npJ7jKzg8Oppw9kwRi9PWiVM2/3Q8x8iC4QWi3tnj?=
 =?us-ascii?Q?m+C+3gI4VZwlLfoj900Lgwomgb2lJPpxKdwkS9bep+aYzC9/sAjuI5zClSee?=
 =?us-ascii?Q?nzDLk67KQrtfZ/CKwtY1ASQJbdU0m1RPM/jmBDDABB7T4jTR685l6UeVwVxx?=
 =?us-ascii?Q?j+SmGdank/+9lKVouGgf/CrXLsbYIxd86ov//RJlXJ0nYea8T1B4n7Q2XJd/?=
 =?us-ascii?Q?xpZSujaytPjOEeE2guXtTXXENp4YL01HqGd1Sa/bwRmyXf7Lg03GMvKr7tXb?=
 =?us-ascii?Q?6xNlkQwvOPP5r008AOnhhz4bdQn0rKjk4KX1xL1INQSsSdowRUKkCAdatPPe?=
 =?us-ascii?Q?Trw1mZoCbvCD0r2QTIfR86QTEdbSjPIoDk803hZw0kr4+i1sGtKR9VA2k17G?=
 =?us-ascii?Q?CjGsu3olL7b0tAJttElWBRdUtA729ppFnnXlSB9BQN2kZi3ReCFcqTJMHfqS?=
 =?us-ascii?Q?Vl48PslYXEi8HE2xN2VAt5PIiDrUMtUYOfl3Xl7wp1B6BT+vnYBhACzIkp4p?=
 =?us-ascii?Q?1PjS2b4XKdrxpchfwxoW5NaNvNcP1aH+sf+92exRg2QObhMEB2uwjmIfFc9a?=
 =?us-ascii?Q?xTHpAVqVt9mlrNZPBpTNcse7LZ1Ioa5sXepVmI1ZazJ0lMhUyiWqTV695Y6C?=
 =?us-ascii?Q?9IgQITTzp8k41Kbb6CevYW10Xra9+WKNAmffDeEJEgQmgvB5ct8/WI4U+Z5l?=
 =?us-ascii?Q?ZbpPxunLqRNfsebvKeI6caQjbOseWOYThbiZ6qXFL4115mW5KG6D7yhzSiu9?=
 =?us-ascii?Q?EzQzIQE5K03Sww4wKuAnACd9aMCuVBpMrET8wkLEyJfwdeDV0yEz6JFezm8E?=
 =?us-ascii?Q?zQVwKUpHZxdX8WP6ghOmQsSuMJTAtoVGKMcxebxe6j0yIB/TCDZ6AJV1/0T6?=
 =?us-ascii?Q?mkOQIgOOEW8koGlAuR5Hgtv7pipf8biqSmweIERt9s7eZQ/X9dlF6GeII2pW?=
 =?us-ascii?Q?47vAeJnb0eCjv4qPwRevAPWq2I24TliCmE+fzZ6UWZjd8AtXv/X6rT13AvDZ?=
 =?us-ascii?Q?EeXvsDqhGsFLi2/64jQD/QmxvzIXSMslOSP4zcyMcgI4j0yG7lsNikMK7BrC?=
 =?us-ascii?Q?s7pTXkTe57J9g2SWiv9e7YqkLNjeBKPku8V4NcYoQrreEfSJo98DtBA9VhLv?=
 =?us-ascii?Q?MHx/c05MA/RViRdi9NRQGobdNuP5/DsIblZdqDJNgKdsAoH2Iup5Suh9np9N?=
 =?us-ascii?Q?TRbk2KHqbtFQm+Yw1bF5LeXgrm3e8w6rPIXeD+akXOQD9PMFEJiVob4U69wL?=
 =?us-ascii?Q?16azLDjIXny1KTqUGyKnLFcLQOEhm1U=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EZSg1A0klJIbejt9sBlBC6vD91OnC+vufoUkduCX6gMzOU0FMJ4CpsTJOKKkG/z2q5CNRTcr3GpZjRsc2eABlihTGIv7VRNBU+wPpY0Aj9mS8Dyu3ICCt8lbg8evFV1Z85FsfL+w/dy31EAmeD2pfWlGsRDasFKUo+ORSYrSqvGTNwbMbveS1ioooqZcDHLqyZAPVnsb4vftQJlTS6UdrVEIJu3rZ7POWDYNalGOdy9A3WQgh9WgOadKogdZ85rUNBga7G2Uf4dCA4V3bKPauWDDxd9+fyxqHophB8x9mMGFEzN3G2vZEXegJwPwwlmdUYvj9j2t0PIKgSUMBk2H+XSxMRdAaQbf7um/MnkUycpyHiuRLAD7ENeWIUnewvSv6wvNK+FrgP0sS5Ru37Q2GzAcrORGJx44u1fOiRRjqG3+Tz2UZGgGAKtcp8QHzACb0J5TpQfr2HpvsSSwuMSZWDd47SnoLcEjK6KIzVbQb2DC7y5N9Uye9AjmviGxhRmR+euTaE1S2X+9J/bUq6Zvg5VhUYxGdiTlm0npq16gVpZPHtP8p3uXjVqf004uvtqBeP9FpWG0cIE3b8DaPiSBesdDWvud5f2RERAzokokqGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf44e305-74da-4522-f88c-08de557e82ef
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2026 04:11:38.5829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SD6NNGsEyDZ9nPjohv6rAJ+KcXOeratafSDEem+7TrjzeymiOcR6wH2ru14UMBVX3n3Oioppb1G78jVQcncK9WKV/5TojwCl8AYhbXse2/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_09,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=813 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601170031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE3MDAzMSBTYWx0ZWRfX83/3MKYxf84b
 5Sy/zvtJbSQfmVY0bJN50ifcOW3FlsvStOGLJVmZB6mp87Z+Sq90uo9o60wHGukSEkjAa38/Sr5
 +fKEiokO6NNEULonAQ6j2JgBJSiXZlYaM+vkfaxmOJ3kHGw2rucF0D8hgioYZXyPxEhOu1bW3pM
 Yz8g4gqvh56c6R+AQtB8Rarx8M4JocWsJgy2oJTCckV04sSQ3XE3qpP94NrE/7dXg4wqsuQEFAJ
 muFuPKuzigdRMXl60rekTjDT4RGVyp2h5AuAIsh6qg8x5sGvPCaX7NROUp+o/KtX4f7eRSd+ic1
 l73fHN5hwhbmBy1uoLsViu12rJrCDaXNfOghclvv2Lmq5v1tmLOmG9f2g3czjvpMNSeWchnjG5E
 0J0Ro2b+/51UUGF9d2Wxghnqk44nCR63JGXnp35fuQ6wdxlB1JESDGj4tENOKrA5UBSsqUFTPr/
 hDetWBsPRrGRH+rfI1w==
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696b0bfe cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
X-Proofpoint-ORIG-GUID: ciNFzm5722pQoFwNCxbDomIgrXVszBn5
X-Proofpoint-GUID: ciNFzm5722pQoFwNCxbDomIgrXVszBn5


Keoseong,

> JEDEC UFS spec defines 0xFFFFFFFF for dHIDAvailableSize as indicating no
> valid fragmented size information. Returning the raw value can mislead
> userspace. Return -ENODATA instead when the value is unavailable.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
