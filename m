Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DD53515CC;
	Sun, 26 Jul 2026 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785096156; cv=fail; b=OG9aLTCOQeyvlSZ/tXGc5tlJkgqZZKcAU+NXUiaIJ74bwTRboe6toxEg5Hnu3xVngYfrlqPyMns1h36mXOahA+H6OgicnbTTOwd5n4qbtjQjVtzNRaP0ypzj4CZb2zjFP6G1sreLmijrfPN/HO29ECv49kIybH5CLZGZfjPBwUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785096156; c=relaxed/simple;
	bh=lN/HDyxKTaiS0nsuXcja9AxF8YJ737/YYbvL0Kr6BPg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=omrJ/rx7JwSOocko1q4e725qmtBVTvLRXBZPVJGJUwT/KxU4+1UAjPVvoGdV65LWMVrtRI0OMxSddNyRp4Ab0XR2k5vCb75hV5w0R3upXiP/Wszs7v7uRJhdUfqUwRmsf5onnsVYksW8LGGhHG3JzOGvyGtrSEn03kzarqr/qyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cf7m0bul; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bAF4UgSu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cf7m0bul";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bAF4UgSu"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QJFQTq506580;
	Sun, 26 Jul 2026 20:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jYWT4uqgx/gu3pVhSb
	9WFcXPDVEqLmYl7dRkpWptGNE=; b=Cf7m0bulXhANdH+aFe58TpVooXUp5M6Xl6
	Fxq4AS9t0kGe0PLfpS8kbsU+qb4qbbKJ/axGDne1LL9jyvzerolSniV7PKYYtE3i
	EgTHVOfK+fvemeALTmbFVNGTmsxFFvQCe/ps+2OeARgTwZO25Tmj2QYJRWSHuI2o
	mTQ092xZ24wGZGr6uQaZ3X3s7QW22W/oyF12F5xNk75ybQStnsD7S7+2RXjvkmjy
	fUqKJHJ5Q2tR2YhsNBFK024G4ARme2o3buCYzGDLQC2pfP6I0zIKM0SrZrrjjNfn
	u29kyukJk9CPmWf9I2mvtzwoFnKVN2LN0ZtBai61MeKmjL8KQ8jg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pgyta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 26 Jul 2026 20:02:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66QK01uw022270;
	Sun, 26 Jul 2026 20:02:23 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013013.outbound.protection.outlook.com [40.93.201.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87e3mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sun, 26 Jul 2026 20:02:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wlYGIE+zW0r9xbW2M2N1IVtNkH86ZtaPOacQdcFeKbYgCCOBboMtrMBLHVunTx97KqDBnKEhsXsjo8YMBk/T7P0mKKTnowtKS+6B49ILYW59nxiQv2jmCIQS1h/Wei0XsnbnmzYPFTSoh/j7NhISYE85o1gCzYI9zUWIzImIFeGqF1a3elKuJNyLSFcZpvkZSHMldLXZ0y4AyZnAt7fqa/F8IlRmG2dNKXelEwvlZixIGIVNgC8MN8a9apQtf6hDMEZxpNvaBHRFCeyocJK0l0IyjgPk41Ep5CBWcuzGrRAgd6FUWd/Dd9eSHY5Fh4SjBZK4C+A664KGXuw56aflgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYWT4uqgx/gu3pVhSb9WFcXPDVEqLmYl7dRkpWptGNE=;
 b=vkw7FNWpT8W9xxZFwmEJScKAwrjqpqv9Fdxjl9LGlToIWFZkzynNk35StK+KmOMzEI1xnnE6XDpVVODzBg8W9oP4DvEyD1F7XyBNWWJz2gku+0uwWTgh3EHBoGyJ1Jdfmj8XoBfJcu85XV7eKZkxkKkg1NZC/08GSNNE2mkb20vtKYBO6OQcAUsiznEFJr9W/UFy8cXdF7QjacsJ0ET13lsrb4MzeBtxNanXJm/eZnbvG3B2Ex5KQQmWL6oHzYu9pynnpZWA7OEUJA2sTRwuy3gd1dVasdOsNMeVHi98Ok5irfYrQvcF7oLbPpq11xnyDXE5cl+qe4aYn0xi8bAS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYWT4uqgx/gu3pVhSb9WFcXPDVEqLmYl7dRkpWptGNE=;
 b=bAF4UgSuAlfdh1gkoI3Pb3TrLhi4q9vSfwJtaCYsAp99yx+/qGfRjaVraDpl7tEWOsVnKYWAxyFizYGpETOOexpxfjEtoszHiRjvNlIymiXJ2UsLI2w7SL2eVOOK6Be95EYil3DETKuHTcKhjfJREJ44JAZBgnY5DwTgMvA0tAc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH9PR10MB997881.namprd10.prod.outlook.com (2603:10b6:610:345::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 20:02:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 20:02:19 +0000
To: Pan Chuang <panchuang@vivo.com>
Cc: Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing
 <chaotian.jing@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Manivannan Sadhasivam
 <mani@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-scsi@vger.kernel.org (open list:UNIVERSAL FLASH STORAGE HOST
 CONTROLLER DRIVER...),
        linux-mediatek@lists.infradead.org (moderated
 list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER...),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-msm@vger.kernel.org (open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek)
Subject: Re: [PATCH] ufs: host: Remove redundant dev_err()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260717035013.563791-1-panchuang@vivo.com> (Pan Chuang's
	message of "Fri, 17 Jul 2026 11:50:13 +0800")
Message-ID: <yq1y0exzfi5.fsf@ca-mkp.ca.oracle.com>
References: <20260717035013.563791-1-panchuang@vivo.com>
Date: Sun, 26 Jul 2026 16:02:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0122.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH9PR10MB997881:EE_
X-MS-Office365-Filtering-Correlation-Id: f2a43fe9-3d20-4d0f-dda1-08deeb50cc1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ORGMRZ+LXdGHcxzk4+PniLxHh5W/p4NPZ3ghufFMlO2/9wnsENyVZ0gpISSBVLdS+KNC2mm0mvVR4WYoIQluI2KLPMdRFukxBtOuhgHc78jlFMubSBXHbWaUytwJ1yX7UuxrHF6CP/ZmLVb12STeadO7Uk5NIHBe4hyUl5UEH5ttHoFv3SwQivrQ/48E0opGeYkUs0v6ZOUaRMHLu9RWL4aKPGOItdP7E1IbwL46wTXD/KxFhjerER9VLPXpXNBFiJkx15bCp0dByyTlUpfxSexZmrpjRcPX6fZOxnqB9JGddkISIq1M3aRCAELE9bCIfS1UkQOr6bQ3dqEQzaVJtJuxacp8glktUNs0e+iFgdGnMQS1w0sBP6rIyn9IuNh2TYvKY4FsH8QZ4Ofy85v2AlcE8t2b3JF3ncTk7OW1rLG3ABWXUyltBnukV13ELDrAO5/zzdgwnfDTQY+wyGD9bT4H4t2xkGgeeB19mb52CtzzIrr/+pigrTRiImIv8Ula+OhF7Fib31PNYlsUtDwZIdfc+kv2FfXtUK8dcnBY2dFYZzBVi6iv2N2k9tahBlzFuDlhQZrYlafJ4SXjE5SUc5puTvKQSBjKA6jhVUIYhlLKntb/dfNtm5pR9Bdtxljyc0al4ZDMxVZhPuZhEx43ITjx7MtF204ngLUm/aBy41g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YWEKVm1ka/4Qtlxo/5NCn3AxFDLfTuglaYqnD2kXAmK6ZzrT4tpw4G0s99I1?=
 =?us-ascii?Q?RVEVH/o/xuusOWyOH1M0W3YKPFbvXIPzhBRVQIGq21KpgyGeSzgvNbLOdXtf?=
 =?us-ascii?Q?lTxL9LpXS9kli3EB/RBzMehsVoKw7Y8B1w4xtu/6ne4TWIL462/TZqqMbWO5?=
 =?us-ascii?Q?S/u4Rx9Slv7o79xXd4HFD96Tw878YpfvF5XP+3n+JdRT2CCD0CzTP+fG08dC?=
 =?us-ascii?Q?1TdHwsO7vTPTZQf+q1mjpjndhjHkxXfa83RdcQ/5Vmy3DBSAMqM2sh1y9x0L?=
 =?us-ascii?Q?U8Sn7sC6KHCSS7h+aakVBJOKVE35TOJWQcHi7eu6E7eZy/xq273IHANNNdCL?=
 =?us-ascii?Q?4pzCoF2GEO8z3YweoiH3zuR/k/XKIlSd1hFsqcV5ImIZvRrocXrMcLxmb5g5?=
 =?us-ascii?Q?3El3fj1TMJLoOZtyTrsM1dzCQHREQCKqnccudGZ9j634kjv30N8orTNSuDiL?=
 =?us-ascii?Q?eBhPozHWV4aqsEMTnQb+aMsBoFaxFZuWEVYyv3KstuHx4Z6m6QypjIbKSa9B?=
 =?us-ascii?Q?z1a1vU2co92cyHqJ5k5XTLGjtA1Qctkrg0f1tlQX4VqneDBoT+OvxokoqSWL?=
 =?us-ascii?Q?wlC0uchVFe4kSGWjf6kHC+MC2WUGMbuHoiSDLjcqOBzUNsaSPHjwRTUd21qB?=
 =?us-ascii?Q?vIufYcBzWAi0kV/2ra1iOrT8Aq8WFJ8ZDuoacCiISpOlPelfwxCIOHYvtS30?=
 =?us-ascii?Q?WNSf+MTElpCw5Rx+Mr5toAZoRPckbZiyaySCfZb2iWlD8HRa/TvquRMp5nM4?=
 =?us-ascii?Q?UQsgMqKPZCW3DWJftHQzvi3cA+2sgk9kiBPgYsKcMPFKbzkesu41UATAx0Wq?=
 =?us-ascii?Q?2z6xaFYZEbpQ2c3rjEmbPE/1Ymi2808d7zJX2nngcJ0zJLVsg7Ir6OkF9bbG?=
 =?us-ascii?Q?wBTQslR43BDaS1bQMMaBF+DpSn1VpvgaX8Y1M6Fs7pa5B015uG+BmIbh/tUi?=
 =?us-ascii?Q?0qLF42meW52CE0wNBWT4cJ3PKYRHjQ2LgGOv3HsAS7QOIGahCY+3mD+fU1zp?=
 =?us-ascii?Q?oexffWiglvGfEJqGRyUR1sPqwsmwKPDNVVjXGFe6jEdQrObd8epBpAkSAuwY?=
 =?us-ascii?Q?I6fIYMRBXvN2CZug4FYjxQ4fcpTbBnrp0lAqY2mDZ7CKGNCfn+KIu69Megch?=
 =?us-ascii?Q?5g0RN44AR6vl4K1nTyJJaKziPkT8E/Hy3blrBuCPfQmg8Gh4OckiZiyKNgxB?=
 =?us-ascii?Q?IzOcHotElNu7jXhcsKcm+dCwUuGI/lJiwqoo1hLKylGXG3E1ke8W0qmsfLLL?=
 =?us-ascii?Q?0F+cY8x9yxQvnuNxB0hw8/7PIiJK/HCkSygMFURY+wI3drTyLBbtNT5BmW8N?=
 =?us-ascii?Q?K0Mpm+E2Mg7qsDGe8iDD+CH7rR5zfcM01VHss6N1/9eqrMfYKmiaX7KquI9B?=
 =?us-ascii?Q?LYZckxE+keApHAdA+3sgyffm1JcMSjdYfc860t/f6E/oZtre8fiCUM2fsS94?=
 =?us-ascii?Q?sBZbC/vXB54ODeSIMkSGwPnPScnaBkfbbS5cOqvPHSoJ6ja47EVy/++A28Jh?=
 =?us-ascii?Q?Zn79wmmbKyBFVtfxOdhcNuDHQxa9TDbKglOYva+3vtDCPORTvrNCKRaSTIss?=
 =?us-ascii?Q?EliljBmLN3wHF5sHEfFy3V4141x9tqGIyMf53DwpItZl4iOW92m6bNmYi2Hx?=
 =?us-ascii?Q?p2jEfaQ3HCPGrrvcTS+w+GQhyZ+ddSfaM3JI9MT3XaOFcJgo6lISXPMiD64b?=
 =?us-ascii?Q?ys9Ln0+XuV39pmwsdpVX7yqNoFgIuKAsg7hCs97+Od9NrNN0DAkaepSzFQtI?=
 =?us-ascii?Q?hrzF+br+xk3LAFAgQZpIXBUD9/rc/kQ=3D?=
X-Exchange-RoutingPolicyChecked:
	cX2SbkStpH+7wCqQqp80odPQQ5pjZMhWA2rPVdoAkl32RpXuO8cEoyb9WHjcEBErdfrwYV7Es8on0hSbYydStJb/SlSWR2Dxk2Z5hdQm2TKSdX46dIDP6sryYU4HnDgi4SVYI0Qi06rMhsB4oe8L1iXu3km3Acirkq7HepuPpLatEStXT91izsMz/5rrBjACMrxYMLi1rYCH2nYXoKy9cAIJTcCgZb0rEJHnWuvZS6FjWTIdsbNign1kDtq1xC/8h2H06BU5ayFnFxztA3dxEYRA+Z2TZzlWwhQAxB+ap8Jiq4qGMMFfVYU8dA5zIQGErhMzpXacjvPGT1nH5UeEZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F2Wde6tXINzsN0pBFx1EmGv0y2NfOBDJpvZ2qga8j0CYzCSXR3YRW62qbI0lb5iu007U0kUpYBTvFSXRmWh0UJ1ho98rzAygHn2v9NoOsLzjU3/VU9WJlGx66qA/OCrvUIISzA+z9Y0jU1uX6i5VUrEHMEEqHMuDgscyYsxpkpwwVEEJr/PehHxQNz3PoutrJax1A0YEXUmYJDGS3ScloEqYQXPgVX3SvE3XxF/wVFGnXByAACEjZAPdgdy/rnpfIYCjmeQvdc4ymHx54HlP21Tm82pWPoTSxIKj54qQRFYCUOBlpTHguL1QoANIPvr1+EmBC3RadAraNN/qNQLIsFwpIFkifeshbMYoyR576n2YD9dawh2608kmFjtlvt1bhxOC0gPg1KWKYw/ZcfWCbZku9Ez/AyFJz6RiEMj1ZD+1ZvuC+cBnCIXX4Qh5ivp0n+7LF0HThYvrrwKs0uvX4z/L0Nl/o/2eYTgXKKIrkEb0jDAzXWd0oX4pgNzUXnck1s8Gs/0YpxVsmIj+UutpMiPu6ChpNIGsBm/n/CNNkleVDjNbvRaFDdVc+1gYHcSIBMzHOaVbkU3VYmPQAwnRoLqtl1x2jtJsF22cA0rtw4M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a43fe9-3d20-4d0f-dda1-08deeb50cc1a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 20:02:19.0904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eCYUah+WEVE+gZTikLEaRUtzHVG3Ekz5tRQfZuj6UJFKflqSwu3dmKsozhm2CWcg3gi/AJAoVvGOaNv2aSIuvKe8RKgOn6ACuuTCJkD78Ys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997881
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_06,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607260203
X-Proofpoint-GUID: Zwl3raoY1ZgW5TIY0TzaOI2lxKuWMRDI
X-Proofpoint-ORIG-GUID: Zwl3raoY1ZgW5TIY0TzaOI2lxKuWMRDI
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a6667cf b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=U75qAp1fu8h16lXNoiEA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDIwMyBTYWx0ZWRfX50JJAQwrDFM9
 rY26VTlhsaDfpt3m0VvrixbaeHHzHAlHt6kRRyzfCLoauPCQIyrfhm8hyq/4OcI2e7lgF/Od4IW
 pSGmzqfPsylFuLKi+ZXYgnuj3xYRn8DFPN2mI16ryQi9fJ1ooNHQkmPT9wK30lVpw0mdHEvCoTT
 1MwixW9p5hWyq7SvtmPIBmD1DekcUj0ot6zcntghQJ96DRUVrbtznv8+szpRch9DAmbiDJKw5Bp
 687mi6KJI0vbcz0DGUhGxcukdamM1a40Nt7Sug1hJmpoLpiYo51jUjs64di0I8mbf2k5NtF1wKO
 sP+XFD1JMJf8X3ZnI4QELEjrp7d0i4HY93+Bsz4uECzrEDVixkSTD601ZEwe62efCnO/9GbAYrB
 dC8JRM/Ez1EU1V2Q5YLHeR0ac2W4gtnzZuCQsgltaENtlZQrw8pQ1wPPwYb3pt6S62gnZ15wyY0
 amb+hQaOsUUzfUuWXNQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDIwMyBTYWx0ZWRfX/yhh0Jzg6xoE
 aDIbDqY/EhGQaKu1GGWgP338B1rKh1e4FqU0jqGQ2MPYBBkegyH8wHW2q58XTZoU5a9OPbBTBZE
 TFmjkRapc88znbnTAq3j6Mrm6PGpgUly7k419VhNXf40gQzQmjsb


Pan,

> Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
> devm_request_*_irq()"), devm_request_irq() automatically logs
> detailed error messages on failure. Remove the now-redundant
> driver-specific dev_err() calls.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
