Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB48C401485;
	Tue, 28 Apr 2026 11:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374934; cv=fail; b=Dz5tdWNV9Xf9pbIx+yvx2h2EcZdhRROYtMNaE3eXxsfQykkJXcuKLLRvYj+NuTnaBDRiOyL+3PVXDCxMUvV050QfsT47DprxYJKCDoF4ahBAn4RqWgGafBaOxI1UrPFOCVo+IgtHlbMMcVDLfBmy6c7a2Kl3NPMnxUvgo8pwPs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374934; c=relaxed/simple;
	bh=Ob+91tjPluyYDVEW2Udy8/gaGp1MuXi5za5L5hVyaO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rM7HglfC6zfv6yP1Gi0rjXwNF7IJPocd10uSq6+VYrppXD480YN9ja3qEwx8cKTTjvcSkp+S7s8sjX4Wcuoy3qP9dR473IPJESlKnDhr8GrlJ8U8lzF33Dn8J7SGJNs2oUDEMTWL8vRoBn1SA/n5U1JdfxNQ5NK9gr6siiA68Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d/kIQjN9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ePN7beXY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d/kIQjN9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ePN7beXY"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SASLfI3055306;
	Tue, 28 Apr 2026 11:15:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yeKE6GJAxi0WVuO959TbT8gJfIMlJuVkECZp4kjjYH0=; b=
	d/kIQjN9WIamDr3X/cSBSw0t9o/ytQ3LQMxYRVhLXuiRx0doIyW6XN4KD2KFdMGW
	o9E1RWzRa9slHuFegZfqJcQL/zaCYM8CrelnCCZb+np9xKdM+NIHaL322c04wATp
	e/65ccoNI6SzGAO0UHdIe1jGkp/vrRLJnfWL6Sq0zjaRljwvzsLOQUSl6DzHDg+d
	8FT4920pADyRO1cNJDBkvvyaDNW7Wb8w+p8TaVmsabb1xX4uggVlkCbVX9FADjj8
	km+gbaKDQ+ZpM+IWLsPsufJ8xJeno7ufcgpsBIcLu3bz75sgMZzHuLChW3/m01fG
	E2nElqbooj3ZpLrEo0PjwA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmd5yccr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCK6f033208;
	Tue, 28 Apr 2026 11:15:11 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012057.outbound.protection.outlook.com [52.101.43.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2cuj79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:15:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nEQ4nE7bl4rwvnDtblLAGUuAcmf27ZMvARsyEA/tQs2gnDrLbkSjRLQ8tbWa9CxM7aiuDwJl3JuJrEHQSLQUTATAXWrf1W07XwJJId8gCe3nV2T0bNWKoHJ3f/dpsTzJIvye+WPbsVpj182pGlLqhW3eZVRxLiz7BYXjvKQS0x/nZuStZQigA9UbKejr/XlIYtAf9ugUvmFoHrBQHig1FgDzEPymPLT06Nf8jdgZgrUVdvwSfrV5yVR2fYQNnnLHeicDYRB/ZcmYdpoUjRRYa8pw6Z76qIrPTl/NR+3cdWo0gelgWVUprEPjkRrPdWwyQBirZYgvb3Nc1HVyiLOoag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yeKE6GJAxi0WVuO959TbT8gJfIMlJuVkECZp4kjjYH0=;
 b=PVFt54WtslskhGNWDag/mThXO4pGXDut8CPpcM2y4CPz3oV1l7E1P1biQDqDDG8CHX9W9LNszU2vfSGeuVfGasn/e3UF5RXWNfu3aCtdxO8meiAHjtGwH41hgnpZKAQ1Ve4aZDERDxKU+GMXB7gmcsuLV528hmhyZTSfTmahwN0MCr2linbqQohsmeCw4iOqwwhViI0MYtGe6f1FMOAFhhVBP8Qln1WtTDam2iL5lr052iLigmOWpILbj0zGt3WPKtVVqvrwwTZ738ZJXiAGK0jW404yRRo1iAcr2X0Uvo9/X+7GY7L2/FTTTFTFJ1HSldhtRhxFM6/YZEl7bU/XWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeKE6GJAxi0WVuO959TbT8gJfIMlJuVkECZp4kjjYH0=;
 b=ePN7beXY2SkBygqvt8JqXupSxbKlHAKICc6BeOkdnWrnjpoRdZaUVlrx2xexj8CSMgErER6VtAaWkoDffBhmdTQuC8wsm74WZDuqWURQ4uLH8E7AZVu8bSA/Gj3nOx6MuROXvnJDBk11kQJArXtVHaJxUAhJmYbdys/hB642Ywo=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by CH3PR10MB7458.namprd10.prod.outlook.com
 (2603:10b6:610:15a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:15:08 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:15:08 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 03/18] scsi-multipath: provide sysfs link from to scsi_device
Date: Tue, 28 Apr 2026 11:14:32 +0000
Message-ID: <20260428111447.1779062-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111447.1779062-1-john.g.garry@oracle.com>
References: <20260428111447.1779062-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0092.namprd04.prod.outlook.com
 (2603:10b6:610:75::7) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|CH3PR10MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: fd61ef4e-a293-45ab-489c-08dea51767d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fWII9JDIphR6TROYTlKcq7tGOGxhEqwe4A3+rsgG+arQh3bmk/eB8lBjCb+jpFgWW8w/aWSRU9I9mjzh/ZOtRZ+rLLxAJXeulKGmCt0OqoQGzS7/xX8kKmiwb65wyj+5dqLZJdS83e/0RjqlWX0U0NPl06vityUzPH/aVmCdXGajzIxg5ed3XpFoK/9w1I065sEHup6z7RKzdxoYz/9wSqVPt1oDk6WvPyFFr9vEkYk/QJZcCMdcnRIriUDt2ho3S+IE9j1o2ydaIi3ED1VK8B8b/L9BRRLrndrmQYxexuT9AEmtB+Tvyi06hFXcT5g/ya8ZaeqHSE/CilHx5naj2ZtYUO1ecGw/36WG3V2PNIEJTFzoh0C8BCWgtes6CQMeByp2IeUdQJS48SR2y8TZaL9KPiZryMhpvv2c6pNSBFx93/jm/YnGemH/gO59y6wmoLcC/SJwXA3nKZ6KITyb6QOl1YBXhlkd3J6nomaQR9FGKNtcAqW7JFUdivl6PVGDvOiYIonNw6e3Gp8jlriSmvrgHTRW7WFEiy4sKZF2HC0kvg1K9G5vcaUa3rmdJMC/VOYdiuxDYuSouFEPtU0EW5XuT++mchf4EQfXeHBsCIqllOzqHGUmQs07NvEdedfftKdCDEvY/iQZa3NjjGSWLdex2aJ4LNrJXgbzPW+FIyxlNWpZt5vVjr3PnGmnEXGW2ymmoCzOPHrLNhmQmk5tGyCA3u6ShyWyLIo2kF3z+BE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nmwgX/XDX32vpDDRwssdL+EQh4Gqi22LbnvHSKoY/inC/yxbnkxCnm1X9CZx?=
 =?us-ascii?Q?h5QwZ3n/AiXFCJ1hV2olYnUVcZG4WqYtNbshN4EmPIJu9oHwS6QBW8lnygwh?=
 =?us-ascii?Q?+6wYYDwk666xs0qhOR9oFupMqfaGkGrXtDc6dYlN6rW2rZw0s0xctMZ7A7Jo?=
 =?us-ascii?Q?koIKE3FeM+Tk6hs6j+yXMhguf3OW/fbRrhjnXXDIKfMEXldkwa6hUwT+oq6Q?=
 =?us-ascii?Q?I2gAVuHMBGIiktRkY3pxAdvws7InoudnCW8Rqek/MdZvWGxc1Fm1Jw58kGwI?=
 =?us-ascii?Q?ai968+Hu7tgIXIxBaj/wrspr+32hzciT8EzSi2syg0hVkNHziuoQF+bKDpQ9?=
 =?us-ascii?Q?CxVv4kYvaVjsWie+u8p3kLlECRHZ1BBwMvQfCT1qBGt7LgSgSU85a/+EDarB?=
 =?us-ascii?Q?koPmoWik1dx1Ae/puAMC6KusvWZ2ypsRd091iZ+dLyqZ1kjVGkrm1EjHzDPi?=
 =?us-ascii?Q?qGS/eddkdJH+HveMwVNrsV2ZtdFvK1aQDuRV2xKYmiEWBMMY2zq5LtdZbTc/?=
 =?us-ascii?Q?A4AppJSx/HenHvyBiMy33NfHXYRYvLnkJia7vg7qOK9HdYgee3cN2SxNgttu?=
 =?us-ascii?Q?0QpNsbIaGdWZ08kyf1JKEMaIwRbweV+Af4pSvse2RLSpEU2cqwebZWllVKEK?=
 =?us-ascii?Q?rBht7r35QiTPy7s8UQ/6txQb3L9+se2syf8aMzzHOwyKKOIno5ILfZgqsYQL?=
 =?us-ascii?Q?E5knZGpmedwXQamJMg4ZLQHMBakTJ2AFsemQ2dV+AHR8tvG0nTlw3zMRKT18?=
 =?us-ascii?Q?+9ubIeSfNX7JOt8sKMcRbDtqVBqPnnhd4NSnS9zZa8SQcQIQ0U+baVFsmpVR?=
 =?us-ascii?Q?6KpXTDCx52qYe1fIDMxR/7N00t2cnDs7XUzIlbMLQzwCgAOTEcR6xmqzEtwg?=
 =?us-ascii?Q?SDV84HAfUGjg7+VTJ9JT3JawEe8sSK06DaQcaYFgkoJZFq3qKefmC1IFCy1B?=
 =?us-ascii?Q?q+dgFLaqY3IObsVynFg3UgmRVuscSha+ZZJwLvK26zx7X5KbGH7c2zK+VPox?=
 =?us-ascii?Q?8JEQPnUJxsZEnrBuMqA4rGlm3rmjK1w9lzcMyOZYCez9SOw0mxMCqkrX1oNk?=
 =?us-ascii?Q?ozH79ImuNxYRts/Q5tguN2evPChCsIDl7fSP2S6+weqAximws7Bq+b7iJrj0?=
 =?us-ascii?Q?vLjBw5IZciBONpZlyMCOi8Xyl8gZguUSxScJxWD/okDoi4EPI7mkGmYIl9EX?=
 =?us-ascii?Q?/yKzXFBz3l4i9EkeB/NiD1fdDdVbu9YVUjuMX+x8Wwkr9Qy/Gfa4vu6ei9zd?=
 =?us-ascii?Q?VL7ECcGy82DJDLP9IhCLdyT+BM8sIoIrOJ3gZaUq6dAtEjyne1oxz/6sOFx8?=
 =?us-ascii?Q?gvSedVw+Sq0ciS2YhwOZX/9E7xTAy2Qj0vHfLVRAtPqiKrHPx2TIPXj/5sih?=
 =?us-ascii?Q?16VwFBmLW1nQ8zk09etVaT/EmpRZzkJrYPNRjet/EJYaqFzhE+F3AYjQkqW/?=
 =?us-ascii?Q?ujdZlaRuGzo7/O2bKcq4SyVlHQRpZMjF224tRnTYO9iqiAU5a9wShOFdB42c?=
 =?us-ascii?Q?ViRc8mVEiExVQ9ogr1N7gN8pCFiFONV+jIg3msVv2ACGp8sd1rdq1lleVyFn?=
 =?us-ascii?Q?sI8Fa4iHzJzA6FlfF+oUkUXdwCRT4ag3DG+x2Uo+VJIn7U01xYkY7o9KSW+J?=
 =?us-ascii?Q?DGZBQ5kqD7sgUaDRERIBwoJe3rxOaHTi1ZFuxR55OIUkHEmZwRWx+oB78WRm?=
 =?us-ascii?Q?EUOo+0M8g6C+xH/DiOGiDbAFvLVHyc66Ube36Fv2/zahaD8XZGPARW35rBHz?=
 =?us-ascii?Q?zqThYPJNmTovyiO8ER8kfbZXV45098I=3D?=
X-Exchange-RoutingPolicyChecked:
	NmD6AC/X0Vo3M+7HUplzHHFGx9YLCUTkD8bHEwGHm0CJ5/+rYfydjnQbp8FYet159H68DVeQokNFVMebeHrFGzY6eOajZTl0HKQGHkg/9i9B9f5f2VlGEYm17R8JQ5RONoKhHRMTxU+vMWUdBV8Xzf0ZVzxZCcRSjc25MGROsKKkU99t5tn7yNK76Ibkox0O46r9Ett5Pm5/5XRouBxX690XCKantAUK9kyQNtPbjKP1KWatr56YPs3gBE2v6uyHDyHngQ3sdlSH+FOny1ZQoFxYtBsIn8XSDNQy/2ebH4dLukPlpMiKKwuqUGKLc/apuV1+oUWHxPrHlwVYCDescg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K4Qrp3hZa0qsh2wioaKwfbvhH9gccLnxRWYYxOiltt+grymevxR4makiMlfZ0gbZvRqou8Y8JIxAV4EWQXEPY03XdSnfVFIpdm33F2yO4t9PQTVneQjf4R+QHHEeG1TwPKJCo8XWFUnu5zg2GkOw000GZrbd1F/4rS1zFWvGodhIudj8yncN09c2pYjELugYHXhribxlLy71MG8UW0QpgOY3v6FLxToG++ZRQLL83quv46cBAHldHTWG0Ls9fJF+WPRDoRtHXKhEbAvnXYfSVbpQb4Z68YGBeM4jV3hvT8kkfDGyLA9nsI7j0EL3D6Vq1/rQPkTYXxCDGzR3G8aV1cDRIxqGgbJeWPdQJQrlaREQLjU23+9Powv5HxJTIe98ra4Ixw9XMOfXvX0CgSb4wmuRuM5O2A/CjW3G9W32QtxxqCQ55v4Pf+BkPmikajVrnIV40N8pVt3oUoC/Umk8OhbQQB/T1EAygRu9PmPz3uzl/9qJyc2M7Si07t7ImgsQRxfECUaozvz/TGHIMBxKcp7yTZO0OJF96RVGoxuTzJxFYoZ/jN98+eBQhBBP9xwKiXGIu14WckRQH51il7CjK4t2DlpUEfuD/kTQPOsPOdw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd61ef4e-a293-45ab-489c-08dea51767d8
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:15:08.1368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Id9k6gKz6FZlhiWYPcVGNmIK/8c+pntNwSxvhGavXiAvC1zTmgmIkdvwoOLPAkFP5fwOy17K5xBs4g/4ipoHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Authority-Analysis: v=2.4 cv=V/VNF+ni c=1 sm=1 tr=0 ts=69f096c0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=yPCof4ZbAAAA:8 a=ZbQ-JUxe3OK3M8wTWUQA:9
X-Proofpoint-GUID: qTzXGKWUyS2d2pFW9Zjsod4dnE0i514I
X-Proofpoint-ORIG-GUID: qTzXGKWUyS2d2pFW9Zjsod4dnE0i514I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfX3Bi3Dcjrfusg
 LMJAC/MiAYuriyikvJtoLVJzWqtJU3qbOt14j8sX07/FLkHJ80BQ0jRlWsTuzDDB0TfsXDzSxBe
 WK9+ATm1CyZL7odGs2JGtWbvK26IYktM7gFAQX7QZhpYWTouEZemz5XVbT1iJ6RQh2UMc+9u4Jx
 xHGbLtKa0EhfQMtf9NIrKuuQ8CtpwzBoLRhTzfg8FL8XBVMOt3TngSt+6OG7hkhnaUa8taqAsPx
 g3VW3GBRlNVQCwk2IhISjUMkzlChS1V3FuplmuT3hnRJDiTuCyjeCW6etEc2DIC5KUR6K1/gsI5
 mLJVqc+wAfQjtzXDOJWWgdR1xQalT08nNPmihEtfx9wxil0GgKtSt74QgX0ptVJ1uYYlUJZ0rjw
 T3rOxmf3jLUXHfZv5O5afch5XyVfQ60jS6gUToIJB4L8Sr1GL/r6gUqWCGcJnXngBmK1aw6wzGe
 6TRJlY+snHEw6pCZWXA==

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 51 ++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  8 ++++++
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 18d50d051b3ba..31ab1d477c686 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -104,23 +104,62 @@ static const struct attribute_group scsi_mpath_device_attrs_group = {
 	.attrs = scsi_mpath_device_attrs,
 };
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
 static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 {
 	return true;
 }
+DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
-static bool scsi_multipath_sysfs_attr_visible(struct kobject *kobj,
-		struct attribute *attr, int n)
-{
-	return false;
-}
-DEFINE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
 
 const struct attribute_group *scsi_mpath_device_groups[] = {
 	&scsi_mpath_device_attrs_group,
+	&scsi_mpath_attr_group,
 	NULL
 };
 
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+	int error;
+
+	error = sysfs_add_link_to_group(&source->kobj, "multipath",
+			&target->kobj, dev_name(target));
+	if (error) {
+		sdev_printk(KERN_INFO, sdev, "Failed to create mpath sysfs link, error=%d\n",
+				    error);
+	}
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_add_sysfs_link);
+
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+	struct device *target = &sdev->sdev_gendev;
+	struct scsi_mpath_head *scsi_mpath_head =
+		sdev->scsi_mpath_dev->scsi_mpath_head;
+	struct device *source = &scsi_mpath_head->dev;
+
+	sysfs_remove_link_from_group(&source->kobj, "multipath",
+		dev_name(target));
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_remove_sysfs_link);
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 043fd2d9cc417..bb4fcd03d8777 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1427,6 +1427,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1479,6 +1482,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index b3e0b98f39c56..9e92d949392d4 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -46,6 +46,8 @@ void scsi_mpath_dev_release(struct scsi_device *sdev);
 int scsi_multipath_init(void);
 void scsi_multipath_exit(void);
 void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 int scsi_mpath_get_head(struct scsi_mpath_head *);
 void scsi_mpath_put_head(struct scsi_mpath_head *);
 #else /* CONFIG_SCSI_MULTIPATH */
@@ -80,5 +82,11 @@ static inline int scsi_mpath_get_head(struct scsi_mpath_head *)
 static inline void scsi_mpath_put_head(struct scsi_mpath_head *)
 {
 }
+static inline void scsi_mpath_add_sysfs_link(struct scsi_device *sdev)
+{
+}
+static inline void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.5

