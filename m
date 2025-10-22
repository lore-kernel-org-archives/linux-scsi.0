Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902A01474CC;
	Wed, 22 Oct 2025 01:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761096335; cv=fail; b=uAmLZXFYaVqE/Ff29yZBhQDHHbr04xwwmMADkHoE11NzOAGZvYZtIC12Mwo5yYMlE3OCtnNqLPHyjTmNGW1H87BNmScBuuAGiq+6rn249/UpSD+lM7TTi5yV6I9ovEKZw6k9rPV9i3W2QNVMSrUlMUYeFuvNZiRvm1JuwYHbDpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761096335; c=relaxed/simple;
	bh=RI9qcYz0ygm+s0nG/KZEcVj1lYWtLZkjZqeTDWUrkJk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uxKryf76PmRE5vARXUOtlbID9lRq9vFHEKY7ch5pWQLO4X085eiu20szEm9SiUErL5GIGFC8baE0ZfqTTKdHsFUVWxzhI6QdqIWjpZL/wz4Wh31+vi/sNryB15CDW18wY5ttebW2R5AKH5GsQfdrhKqNzbfDKA4ZJw9NHXeYJFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PXiW0DGc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=to0Uy1gF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PXiW0DGc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="to0Uy1gF"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMu6YY013106;
	Wed, 22 Oct 2025 01:25:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=we5xltcIeJKagAgjCY
	wwSjx87prOvfHqyO0CEBfuM7Y=; b=PXiW0DGcCr/AAztVAONLOVO2mvFQQyFhjq
	dx3Gf2cwTV+w2TUe1kT0OsQpr+kAenen/iPGf5DXezJpbkooVILlqTjrW2ZyVFZ5
	GFvSzVuARm7WXMnzsl21OhcBHPo7wE+4p69eHsgkYYQuXAoWriMdgnZJjCsd4AuM
	dDnkFSUqzDkp129VfF8wDLqXlfs+5hp3EBkmzbR4YugSXWLbCsd0YQd8MrdcjED0
	wtjWk6XGcHOu95iVTpiTHZHYB+PCMdE4SqyZX8j4tWCURxa2DqtugUa56hUdvksU
	SibwDq2+F3+Y9WRTeqz/iATx/A+FGH2w4Qap0qEbp7aSQPsspQbw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2waxsdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:25:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M13KFV009966;
	Wed, 22 Oct 2025 01:25:16 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010013.outbound.protection.outlook.com [52.101.61.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bchr3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 01:25:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vufeKrLfRL1+w35Q+n9vjCGulmLEvRTv7qLNSo8k3/icF5QZvNUQaJqyz9nKJ+RXxrKdtx2/4AfUT/d3Q/A1KyzwV6sQ4ngLWPHFC8nazkAsO/xye04KROkRd2HUSB8e/DWv5lWRn+RiUml03gRoWRYwWdBeKeQDtFHdJjqEza2yvurzGcqovxvnj+JVJkLhViit9Lp3pDFSo+0zHdsCwuO8nmWqbUXIYlUUSUGd2OlpNUQQrotWmr9XGRaS0HZdvFboYp5tieOUQdnZFsZKz24iIkZy5BJdA69hI009UL62uMv5iTTWFVFtatu/Vph/PQSQCaIuAZnw63NpeJSlYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=we5xltcIeJKagAgjCYwwSjx87prOvfHqyO0CEBfuM7Y=;
 b=sPuryuMd6j+6vif2vpz78rDv+66gs33yNitgedQpIexQfrzLgqXI1hKSdjbVPPon3VRMbfFKdLydyFJpKDR0EnTVC28ubwVJWhaKh+zCSh7Nc9XctScnDCtL16JpZe2Tg00loIl5UMe3TQeSatFTSzH+9E3qpk9lIhTMYkjdp6ajmGy65Hr9s7wNI5aX0+cCENrplVPMb4SwMV7M5qAXKBsPCYRrcp5inrZILtBkxRHWCbIWXdgd/6+LVqfzf8IxVkuiEaJQTwbtbA+kHK1HDhAMPvOeesSCnGQ43BUWZS0QQYmdinItV0Tx01NhywJU3Qa6oF+jCww+6IhpmScj+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=we5xltcIeJKagAgjCYwwSjx87prOvfHqyO0CEBfuM7Y=;
 b=to0Uy1gFKznmEoEyqKmAT6SaN42G/ikhH4JBSo2W+aGpMQYOyAC2LMq7lqvHYd9llTwAl9R08Qp7cQKDMmcseKIQA+6BgEeQ/XpVttwJ2Il/EhYn3cYYBhyi52EKPY48d36qRKBxMzvFoBu8Wt1MfKxqBvvfTMK+sJKhm2tkj1A=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB6046.namprd10.prod.outlook.com (2603:10b6:930:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 01:25:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 01:25:11 +0000
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: <quic_cang@quicinc.com>, <quic_nitirawa@quicinc.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <peter.wang@mediatek.com>,
        <adrian.hunter@intel.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "open list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v3 0/2] *** Remove UFS_DEVICE_QUIRK_DELAY_AFTER_LPM
 quirk ***
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cover.1760383740.git.quic_nguyenb@quicinc.com> (Bao D. Nguyen's
	message of "Mon, 13 Oct 2025 12:38:14 -0700")
Organization: Oracle Corporation
Message-ID: <yq14irr6848.fsf@ca-mkp.ca.oracle.com>
References: <cover.1760383740.git.quic_nguyenb@quicinc.com>
Date: Tue, 21 Oct 2025 21:25:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0018.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ef1bc36-a892-47d1-17d5-08de1109d845
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4kxXKb/la6nXLH9yxPSAjIQdSU2szyLLS8M2kjajS0fLyC8ZnvPpvNsDwZ0/?=
 =?us-ascii?Q?fGMIMI9KU5TqWbngf8g/uFfEHPp3tP0PxGoQM73O5ciDwE7UFnIIYrL8d7b1?=
 =?us-ascii?Q?TtQU13t0bXK0A/DUwiuUWFePHmRnEYz5FAX7dWTiOGMjEOxEFRr2XnpVflPi?=
 =?us-ascii?Q?U87P78s6plrLblBmyN6IgKCTrTNJvzJnvf3+oe59N770Riklyi91bNsMi6Tg?=
 =?us-ascii?Q?jYULamJagTNlHXGI3QdqrfxkNZLJSYPe1ptlfAORpQPbimMUDQDn5XF04QI7?=
 =?us-ascii?Q?+1fvNt0d3TyFi5A4zEDlgASkwgtVBP+k2JkQZO6D1Zg83a46wYwUHTNRv9Gd?=
 =?us-ascii?Q?k2kMJgkySi+ifWxAg96uhaECzLN4BNdwOcGo66JHss3ICLiXlrhFJDKgO4o0?=
 =?us-ascii?Q?dxpzRFHBgH1rFMFAY/mejmFo67mGvAIbLFxVUo5/yJH0Bq6MYfC5GPuv0/V+?=
 =?us-ascii?Q?3OjQwedCFFFgD8OnqiI65pvd85zuclT/npsDPyp4lvPPqY1JbQtReDIs4+mr?=
 =?us-ascii?Q?AjzjUYPnmYkmnkrTQvL21NYEwbeoZqi0n7qv5mXM+9ThN+pXXA3oCQ+xKOxX?=
 =?us-ascii?Q?RDA5ZgDImri3Pb7YXnoy5r2ZCNzM6HgpBsc+kSyCMk4abmo3H9du2Dp3PKBk?=
 =?us-ascii?Q?1TSIpjmYDck6wVFIRgA6CyiTzykoAhfBSDyq5eP1pkTAVpmeugBIKVVuQLUM?=
 =?us-ascii?Q?jY5wtAxSiCNpWSK5cb8K3Dv2/JJD5d1oMQ2Onk6qh8U0eUJ+rkJ3WoJiwuJl?=
 =?us-ascii?Q?9fyVVMl95cWwVeVUzsgHrLmLJzFkh/yOFCv+v1ZxQE7D746PBRKo7p4gEU+X?=
 =?us-ascii?Q?G/xKRNMthH0mGQxpMWvkzDIw7UMTgDdn1lCK5a0UGCkAaszh+0/hADFI9VAp?=
 =?us-ascii?Q?wZyJaO12CikOyhucebzsBNUDXfu8pXwC2snC/zzvTAn2kNI3bB8xNQ7Nk8fc?=
 =?us-ascii?Q?GSUVIQqklbzPp8FZFzsvCIGUX+PvmIgYOFrfzcJaYZT10fJN4GgbKk1jq1BG?=
 =?us-ascii?Q?rfT3xkCJZsCrbuL7LsyXW661eyxTVypeJ3zeluvu/nBHQEcegax4oFbUJ0Td?=
 =?us-ascii?Q?ryW8Tai1mFZ3PKU8glBqg2BdGWOVYIQJpbiis0gg6G6gOOF6auBVL5Tz2gAo?=
 =?us-ascii?Q?3mfI8FTeI5SqPU2BayJjSkpsVCBGloPOHt5SXQYMFkygIqn3XqEPpZLC6voX?=
 =?us-ascii?Q?GtEHviUKN+36nFjFIwwjeSUNyA3OdRAjcb7vNoL4n7qIgrH0gYf91ud5ovx1?=
 =?us-ascii?Q?yv1hHc0GgA9il8KlDUcgXXLn4WcIuS3kp2XFG33da7MbdHZ107ttBzyckqN2?=
 =?us-ascii?Q?rMgpcpmHgnDZ5BoFY4LHXg/R5It2EaWBuTe8QFi1kvn1mPCvXu/FgKB0MQ1+?=
 =?us-ascii?Q?7JKzr5XgBj4XbCEEz1jvoruHPD95RDuS0es8jS2bI7d5gEX0vw0csUCWrzZ7?=
 =?us-ascii?Q?z7t9rzko+YcuyKKi3VrPdARbkUZrcKrf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i3aKlSbq54yQMzJsQvlFMcq3cQcoQMzTp8eV7+SBuYzjXA/WZARjfXfmLJSh?=
 =?us-ascii?Q?QqO2sCJ+gb5xqsHXQ0SVctByFVCTJriKgcCjQvSllYXsh25OqM0NWjPJ77mj?=
 =?us-ascii?Q?5ess4ZsoimUOdNy5OZ5uHdDl3a0Chc0BGiNWBQnRmgoRXUZ70onr5eQ3FmuC?=
 =?us-ascii?Q?uYTnBRPuXbvuuR8v0WepJz8WbzLMO54dOL9RpnFH1o+UtvsMalff/bgVmSTu?=
 =?us-ascii?Q?15jSVhS7SswhQBML4yCbTFm+rjGozs0d5MnP1/KpEHCjg8Vznl0L/nlVwz+p?=
 =?us-ascii?Q?i7SuFZUd6gcummfqWxpSZwJ8O2U+FutNZLY3sfT3Owb2h8akTUU+4szD0S5A?=
 =?us-ascii?Q?6b8gd1xKybCcox2BKnz+o6m1T3asduyoilvUdVV7AsQN0O94sbk7Gvp+VDM6?=
 =?us-ascii?Q?3591T37JWV8wZKngvTn743rSzOpTqlzd7Agy3OfhBs4Q1rBAKaajA0CgHyzQ?=
 =?us-ascii?Q?9usVbca2CkI7PjtOsP/kWDOzyclOOBtUOFdGYn34AEAhtbAEjr1ungu5FaKF?=
 =?us-ascii?Q?o30Kk0T8/TYG0JFP4Lz3vVDcl0gzQCQ4WM+XF58Ds1bvvi7sqMiiDzI0cpyu?=
 =?us-ascii?Q?AjQDz73zLQdQCwF0CMRYBvIktCoG3lvzVwbaqDxMaPGf7G41mTF+NoDe1hIu?=
 =?us-ascii?Q?F3SyBAJWI7x5vDUWb00DQIoVkkZ5UybQSpm3noCsBOrshzxD3ctnR1r6dDdU?=
 =?us-ascii?Q?Jyo/7bDA+BUgLWi1bSUjABHiDoJQOb/MinNdqBYxQvDgcG58JbRwyMVMAXY9?=
 =?us-ascii?Q?+8N/GCYoVGDKvukw/tK5vLwP/BZuMVjuSKqLqCXoSEcFkk1mQGyeiPAmugHz?=
 =?us-ascii?Q?RyXW0/Dfz4GF69/4UvLNu7aYoyRWR3ohg+bgnAWtwebhHpDW+38HV2Xveb+9?=
 =?us-ascii?Q?P5MhoSbBPQuvImDPEMGAay3u8er8iNQFasQYQkSNHzPBEXqKTCu4iAlA/ppT?=
 =?us-ascii?Q?N1JaXiI+1kTyQAkxiPF70wX/oCLHiBfAXnGg94p1DvRaNKFUAcUvptzp2Ni7?=
 =?us-ascii?Q?7N1fq7aDmGdnjeVKfu+0qITteDF+1g7Zmb5VGakzEBQ/fOkJNu5YgWEwWwqf?=
 =?us-ascii?Q?AKqa6HdDPVipRPo3ah1A9fonnWZhB9i8C5IZo66vIuyo+d30STGk3DvbpoE6?=
 =?us-ascii?Q?I9FHT7J7SWrdA9TiFp9JG/zeYD8oXp5Nc1i0VILm+pNTXtc8gnFd4Na7GSmE?=
 =?us-ascii?Q?RzBKxJlbmaPZ7ZFFjdo9YSOgx0CRES/C10AEhxqx0YiBNyVTKimJLDhVSwYS?=
 =?us-ascii?Q?NOnD5xstbK2r3t+Hm2YCOCpZBWjFPcKYrJiAyebNnXnJgNqHDaOPuKVon/yu?=
 =?us-ascii?Q?9xf/+qZ9RuzzICMj+FPk73bHSngIsvFbl0azExoXR4EOVlZvjgCSdTFNPrrT?=
 =?us-ascii?Q?AutaHnJpP9kRQd9q0kVG/rEeO4z0mW9T0Lbj7/sBnNVsRNA70chx0697SEUl?=
 =?us-ascii?Q?hGTKeCLpC0HrIoe6pEGE0MiNoICAeu7xtIbFKEf9NB/ZyPBBahLWdPcLXYdC?=
 =?us-ascii?Q?flyNRD9j08U5rxXmWP0IXupa16lkq5l+dF5KK0uyUggOXjI3mkrGicpfwobo?=
 =?us-ascii?Q?Ah+aTTn5Y8Xyeo44F9LMv8B1RV7QxbfSD03bJIZFXXtmdQ7V+lM+qoculQfu?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pbV3MVPI2I2uQ7phUSmmNGb+OiCHJ7JPPU+nYZmDh5DfDnkXWe5lK5EYuFLosIGF20j3d7Dk9/JJvK4bwHs3rtCeywsfZoG2Crw62T1a+ZKXqcofg1ako+uHUOzqkHNXxtQ7s+Og2XeRK/ocrjWBVrqDv5BJcxYCOb0Lbzfi8Xt9wrQmYOCdeWFBntWFw1gjn4UynGbo8CyMOs/GUEjVidx/UOu9UQM+98fTahJN1lAQXOrUq7gUDYbaCEizH2pB4QuD7hn1KvEjgPYLUSTOsVGFHazs8fo7RLTouDI7/eac1x1MLWquDpZUXfcIjHEVE2deGZlKJc6fKOHjvUGgKnaXiuDMLUDC7PyW9PuK2INdK7TjOAH2NkeoPPv4DFsA7tUjJ4r47+8iHq26aSRoEMeun50VN79svetgtZ/t1j8LoLtV3+cgNyQM3qf52hgSPMgg5UBkkVFuep9d5XlORyX7QPgCo3wXZVosI5z53X8Wbc2oKxa0xBnWi3so0eFIqlkoiVq5THYxvdNFnfNNN0EyeZHtHelVD4t56HFnjCAbdBkJWlFUu9zNu/8JziUuyqaW5KCDsMI76h62Ur9BHFTNJ1Ys8JNBmBeD9GGsvjs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef1bc36-a892-47d1-17d5-08de1109d845
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 01:25:11.6271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHiE9LtmZQxyje52IvRrfjfKCSc/Jsbwx4QuTh7zNyHE6eL69xY3e3bFSX9isvewOxNzTxcF8ucR74XaIsDhqaPGSmlHown3yQW+Q1nILMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510220010
X-Proofpoint-ORIG-GUID: A0pcEPZ2x-KZPChyXOuKsK8_A0PHbUhr
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f8327e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=W12DiMFBgLdbyJZWUR4A:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX1xvEisco2TF0
 ybOUmkXF0G2Dod0CDz+kEPBhjEz7KAYKieEqzoE8QI74wEhyZ0csHdnlM2FN2GuhlIqe6vORxNz
 zF5Hsl3Bw6JIfH+XFezLA7DzAh1tbI7rur1KrCqPiKH1jk5KgjbnuSmnpULiGJt5YihoMUb91hq
 qg8GBHEOkfaYVUgo131lOrzhiItA7WnL9bT73alWnnnxeLLIFT8UuLwyEl5Wkskk2k+Kwr/ZaP0
 +paqb/yWYRiziaROGQYjx/Y6QRwK08lYMXlbqE37fvz+dTIqKtEyfC3sRBXQNzrc674CQrO4hRQ
 ARuDQmhKbVLovgK19iHFbl3ShaiuXZ72JM7Gn5bKnOCaK+cJoS0tW/DU8zn05NnPotPVrl3nLlb
 gRHqqfqd7vzHpFNkT9CG5n3SZMP7BQ==
X-Proofpoint-GUID: A0pcEPZ2x-KZPChyXOuKsK8_A0PHbUhr


Bao,

> Multiple ufs device manufacturers request support for the
> UFS_DEVICE_QUIRK_DELAY_AFTER_LPM quirk in the Qualcomm's platform
> driver. After checking further with the major UFS manufacturers
> engineering teams such as Samsung, Kioxia, SK Hynix and Micron, all
> the manufacturers require this quirk. Since the quirk is needed by all
> the ufs device manufacturers, remove the quirk in the ufs core driver
> and implement a universal delay for all the ufs devices.
>
> In addition to verifying with the public device's datasheets, the ufs
> device manufacturer's engineering teams confirmed the required vcc
> power-off time for the devices is a minimum of 1ms before vcc can be
> powered on again. The existing 5ms delay implemented in the ufs core
> driver seems too conservative, so replace the hard coded 5ms delay
> with a variable default to 2ms setting to improve the system resume
> latency. The platform drivers can override this setting as needed.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
