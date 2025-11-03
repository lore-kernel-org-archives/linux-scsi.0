Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF6E280CD2;
	Mon,  3 Nov 2025 02:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762138347; cv=fail; b=V0lcEp/OfZ1IvC36ZycAGx4dHLdM5EdJsW3+D+yzxed6SHoEd3p8AwPSIEZLrjKh9+bPogsqgvb+4VDanyBugiQRCi5/PAs7kp67qaSNdGmfGxVtSah/9HTeGzwcSE0+Rmq2QtEm3mi0ogPBz3mIpDC5M0emPYZkWVSsyAcJxOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762138347; c=relaxed/simple;
	bh=eYlIT4TYYeYNoV+R/3Y+BthDBNuEXCa7qIDDXYnd0ME=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hn3uJ8MMIeCPZaegEP4U/6NVzHbBX5GiHTnNjyebFoXjYP4HNZ465fWP/+99GjoAc7nbHz3AG04Pu4yMqmt0INRxxaCqLfvt9ERaCO4DawLSKADMpcALmS+GmHoAYcen1z8DMcPKkyN+/TFApAAEUbXg4hcvnrrtI2Ed5tCP1Sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LznAo7MQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VmgYZk1V; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LznAo7MQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VmgYZk1V"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A32nfJB020846;
	Mon, 3 Nov 2025 02:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2HHZ3Rd9Yu2GTGlTpM
	PKLUF68UGBqQ6rWezn0DmC89Y=; b=LznAo7MQBD8IlGCqZYp9Lmzu6cj/9op4M5
	8pJtrttVQFM9GtcibU8olv9vRoYGf3VeNDGRyNvtXdtj20b2BrEf1ZH/bXg3ur7v
	XueLqYEiI1rmTXYl6I3PN+dkw+EEyi986EMJqfq1eGOLtWyRG+tL2JQRiO1BT1N6
	9sbb1MnYE6zcTFek7pX6Nh8Vns8QI+QmcMbUskqD4DgACcUep16lxbJEe49TL2Gs
	ALftvSxJLslmzhxzRKSQynMJSEaVyw+AAfYFWmX97gEEXeSvp/owoDOZPztGOhFD
	9J7ZdIbXDcqNGSdop/Q//14c0WOA+Tp6bAvNnfEN27NFFHJFlpkw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a6kxrr037-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:52:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A2N3W7V010877;
	Mon, 3 Nov 2025 02:52:03 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nb2qxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 02:52:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=itDbDT2NiiVpypRP7NwlHuXoW6PLKmyg50iCIk9Tp6jThJaPqtxOGCyHv1286ZLS0Yk+BGY1rlABkOANltMp+u4ReMwYghfzNAXuHi6Hoa1+bx8fTdSbjuQVIdeBMQ9ufhIgA3fszNXVCbnCclrCWrLlW6hIpW/56lCTjX6BVmDejCiiYPXIUs+ZygXXkdwb5yMN/+/HZ273jFig6s1LTakegDM3HSRp4486zk5HMDI0mR14O87W6KFyICunIInERgePs3ouudVJRc+1RhzB6y59vNLeAzI1hMoR00N9ujVBZexynhUjELYr93/CtBmeggtxf9nQ9ydNBNoxMUmGAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HHZ3Rd9Yu2GTGlTpMPKLUF68UGBqQ6rWezn0DmC89Y=;
 b=cJc9XxIKuTsnhPMj183DTpXgG9Fr69Gjy7M1v155SeZkuuI+XKf+i6BFVNXS6g5zwxbwV5qVRNop65sPoSGNpgbh7DcLg40d8OTeYGr3rQ1gUKIg/Enm+5VNeSNUEGyfHk2B7PnTkrlsQy/VL+2kphhJ1CNDL8/WUHgiElhamxDwLvJyCXRvPQSB/8s+VCpPbW5GGEuOcTuhwExfzTFNw9m2E2LwMuyDmTtV+8n9x4wgu9ES8TxrMgefxteJAyF8o/O1ShVSGP8m6OGGZZoIWrf7W42nFgIGraDeQCyOeLknrSw65bnBIKzr3YAzCBlKjtUjhXBLHie7RG7AzQCZSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2HHZ3Rd9Yu2GTGlTpMPKLUF68UGBqQ6rWezn0DmC89Y=;
 b=VmgYZk1VRPJek0lf3QPo0qE79R1eXvM+6LjBMk/UUuxH1N0Ii7G24YBLRfwdx9QkIoAQa8HZ/JrPyoTABdEIa24q/G4As3Zjvisl15qY1d6oEUmbgP0ahZhtVih+PiMeBkH1Fei8vkt86kd0fOJGOnYk178akCs4K+970I6Q8+E=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB5027.namprd10.prod.outlook.com (2603:10b6:208:333::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 02:51:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 02:51:59 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <bvanassche@acm.org>, <robh@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <matthias.bgg@gmail.com>,
        <angelogioacchino.delregno@collabora.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <wenst@chromium.org>,
        <michael@walle.cc>, <conor.dooley@microchip.com>,
        <chu.stanley@gmail.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <naomi.chu@mediatek.com>,
        <ed.tsai@mediatek.com>
Subject: Re: [PATCH v1] dt-bindings: ufs: mediatek,ufs: Update maintainer
 information in mediatek,ufs.yaml
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251031122008.1517549-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 31 Oct 2025 20:19:12 +0800")
Organization: Oracle Corporation
Message-ID: <yq1fravsu9o.fsf@ca-mkp.ca.oracle.com>
References: <20251031122008.1517549-1-peter.wang@mediatek.com>
Date: Sun, 02 Nov 2025 21:51:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0294.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: 22d0c6a8-c1e1-4266-ca6b-08de1a83f5a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nTRk/UKRxEw2xK2qcYWdkjwkRJ/psOtSyTWePW7hItB5xcC8foMhKRNhUfDZ?=
 =?us-ascii?Q?4TvGCG5mUCmw1nsoKZTFxlaeL9cWIt5FPPYlINkFPl8tbpLd1KLZGW9SZTSA?=
 =?us-ascii?Q?HY0VKgrl06SFwlcI1ciW3SBQY8DvuXqCKLv4WULNVS3AFdRl51PpWsk51XNH?=
 =?us-ascii?Q?NjIMe+48JMzBd5GPQKMAk+sMOsuakOYO7Tf/EY1B20k2n9dfiTBVsZ6MxTF7?=
 =?us-ascii?Q?trPqNWyClcWT/NtbgCuxYdchG2vH+XYc6GEtjfqN9TgOHFZ7aiLY35XRrf03?=
 =?us-ascii?Q?WugaWpiNQN9U44yZYpLXkctunZ6RPQ8/enkCH8UZnEk1qb59mwGrn2g/zVUe?=
 =?us-ascii?Q?uWcLb8SaL4805ZPby8FrrsQq9XFE81Yl5zwRC09ZgubU9pCI0SbzOSv2uzv+?=
 =?us-ascii?Q?ipbL2CTFe2NNBBa8649wYa4kJjpj4YZH40RuAtiZK3KmIKrKKSOvkOIYsGca?=
 =?us-ascii?Q?z5Z+6i12X5DO+ZaXAHXHRWRhZ0Hd7NSadTO1kThMVMuguDeLL30JVIxGt2uA?=
 =?us-ascii?Q?xToOSQ2BL4d4aJ3uQ/FuXwIHxEt7f2omEwKolrJtS4UZOc8dsMh69BNi1Z4T?=
 =?us-ascii?Q?UR1CI/usLFVCFDTXjE/VoUaPB1+7NcRlg0EMzpz+UitrWq0Xw38vLCuHfPkQ?=
 =?us-ascii?Q?VBJueguCDgBV4sZDHtRIegfPs+hW2SRnt/wvndP5lZJ7SJrSjFTA5/vFDjMj?=
 =?us-ascii?Q?1mcPd5NO0CfVWQlbMwhnwRhOn1T3abIY8lXtU9x+qO48ALNkrfAPBbfdt/xv?=
 =?us-ascii?Q?J+jOGZ4xm9ksAj4bK6UeERqQYcrlLkkEH9diZE3DGtnUQyPRw4YdZ3BCoGcI?=
 =?us-ascii?Q?NQip6hMCgfyCAtUDhwrubTlLtO9CecUmjmAYEcCYLkD9GhvlJtM/4naiz9eF?=
 =?us-ascii?Q?otdECQ5CxYAUPTVhvD879nSCZ1lESZkl1up8nX/MLaRVjcpWFnIjKqM2RXkh?=
 =?us-ascii?Q?REzynpK5Fipup2kB/5y7rJidu0dU8zWYb0P85O0Zm3Gl6uoR/dgb7saAwLWs?=
 =?us-ascii?Q?UuibNhpbZdPxZW/HRdOJ3f5k//9zhDqLBMC6qqQs8yji86Or2rciLWJY5kec?=
 =?us-ascii?Q?b5mTdWIFFze+ReNIP7FGL97vPjm2ZxBB4WVIv4U8eq1p+qjUTbxeo914kaDL?=
 =?us-ascii?Q?uHNwI+N7TFkcYA7HPTHbMDLNFiZODIbqgOYTAmwV3BjKfOgQ1F6sTu4zGBD8?=
 =?us-ascii?Q?laHSsG+vDMarPtNChyO3kJm8ZZ5BEbY0lBi/bLUjbKeOIdIpQv1+kWh3hAcv?=
 =?us-ascii?Q?arX5rCYotq4aEDZq6j1c4vsVoEofuMqNg3PtATIR1leTQ4WtP/wSNFiIvm07?=
 =?us-ascii?Q?Dcl5jfz+Ul3E1HEXC0fEnr1p2zoCNpVLaojbse4RkuFIzysbob/lVmYAAs3+?=
 =?us-ascii?Q?GdFCkvnUjDZRNY0UC2GPDqYrUDfFgOlvj/Ewdn2EYTP+syRUPSD5xptACRsL?=
 =?us-ascii?Q?cz3gdMLaEBjicmCPG8aj789GoW6qBaYr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1QnWbP/rsl7wJRBoxr9ONNA30dOr70YDh6JFqDH1qdwt0G71ow7Y4Yl5Asd6?=
 =?us-ascii?Q?VOkUzhvX1gzmEAJ08UdcLPzD3aDAAatt/aL0NcE9Bk7tXpLXyzJiamhQ0mEf?=
 =?us-ascii?Q?DFft7QWxRYSXJYxD3/ilpEFB8dSRZbn7wLYWiX4TFnAGKYnVPq1Fh8G3YlES?=
 =?us-ascii?Q?hmd4T3xa/fjNSdR18URbOgNenr+cN30eZo+14c9+z9DGwhqgFg9OblTaj03S?=
 =?us-ascii?Q?pGI6EtRO/1eP6SAGzPJEb9Rz2nQtIkFPX5HKHkU2iLlxviRucQRGJePUEWUs?=
 =?us-ascii?Q?vJYmY7+zww+pqvY3ccd1Y4ysCB/okDQRPZdmwA69BF6wxOGxBJQRIaw9hDxQ?=
 =?us-ascii?Q?emBQjXThVksQMMAUr401PBwgORWCn0yJG2SGcMhgWDbh4J62EBv7f+6rxEDH?=
 =?us-ascii?Q?vhFR4RWDztx/3v0mRs+u3i1oGdgSr3scuv2ak7KdjNPgeOWole0Otfr3Squn?=
 =?us-ascii?Q?cDdtsMGDezTpJ9cbAki0sPHlRGsmtApJJ9s7ew6ylw2aNNUPIfJNDOk5uCDN?=
 =?us-ascii?Q?jUNxUpmvItV8H/QOXcV4K/aWJev9q52Y/pqKk/zXc1mnhZlebjXC45g42vFt?=
 =?us-ascii?Q?V9YWjtKXFIH6ik1x5ZR80pTOvGZqZuqPQFN9oBfOg8Q5pOVxHwAY3Ceg38QF?=
 =?us-ascii?Q?SriBBCRgJScw3MAm14IUfc4cRTl5mkvqr/UCBESrZFyi3uLzrWEy4rgEAwj+?=
 =?us-ascii?Q?KWgL2GvVwnI55CK1FT1eFEwPWMmB3tXc/A4OP6wy6bOZMvZ7n+xWFApczU/e?=
 =?us-ascii?Q?/6ZeQZ85Oi64PwYICXjJ8B78DE5VEzWsSm8+fnpuk0K+buxxYi5/Q4NNS+Wh?=
 =?us-ascii?Q?2bJH804S72SOXvYwf8nTXHuIQKrhEgWyHU46xS4j+gmw8X72BczFifsfSW8x?=
 =?us-ascii?Q?23E4u6WTsj5VYJw3WKjPNQ9B1PPjnPd/TM0dCRb45xHM0M6u4t4VEKEZ+2Gm?=
 =?us-ascii?Q?twwyLcTsrMziKjUWbFDzEjGXW2RLH9hZtMosUIlKxhgV36UU/hoXip7dGkBC?=
 =?us-ascii?Q?EKoO1x4SvG5O0519EGZ6HPFaitnD4wj4ZRsEQGy5JT8AFHeaRk1sQswNzMrc?=
 =?us-ascii?Q?GgMAq1f2aT8MASu8ntHV7vNZ63M8kR7tXnHdEhpzCT42lF7OhyfQtHTv4geY?=
 =?us-ascii?Q?ks1kwg2ZPFeS17Vn362noQa5RCh7zsg+2EcqQCZVBrZZ9LUzeaAmO+xVnnrS?=
 =?us-ascii?Q?v/Dr4GHWdMfLspEMN1fP6bHbWGn1aJm7b/X3tk2uaTsU1f3/csJP1FZQEJVS?=
 =?us-ascii?Q?tTiuae8zsPaQujzEqI9ZHvaeguTulEFzMQkw4SxvBvw/Je4JIiOJnK09rffK?=
 =?us-ascii?Q?YJr1m9tS0Cmaa42FXvNyzlVZn6X+nEUBe7AvjgbBvzM3uoV9AJ1b4QHtq5Br?=
 =?us-ascii?Q?TGebtJOTYU674ujQfeH/zfe71BLOuURZbsW/t1qIVpLBZNkHHR6U3pI9dc0D?=
 =?us-ascii?Q?ngaDiH2KYo8EgDWLD1Ga3XrTAFABJlaHZSjd5VEIeBu9guxHetJpQVwk+iwx?=
 =?us-ascii?Q?OW02Y79FHW/wCDtblTrbVH6nPIbU4FT9mQZU2oPDROjPImIoJJ9QvwRkSBWW?=
 =?us-ascii?Q?sKjy+r6rTzkppxVs+LfY1VxJvJu8hWbQnHOiijG9XSAceE+max6D2AtkY/sA?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wN5Y4Tks9/P7s/iqxGXSpDCVavdAp+nG28aGSk6q7vTBdJYngvwRmM4d4FfvaGIHHcJQRxJ7BD2DqUqb9Jq0qcryL+MdiRauod8fx5HsKbNsN32rnxcLekQUrLFJyFS+LMr0s0y1XUlfNQvgjIKyMHHwAH2st6SrrZ46Z8Q0EHHbmwsOTiorvh9sfSdFmb00rNI+wsiMS+CDWX8vQeFg6ehJuFLfhV3DRE95f+2G7BoIrutuRx3Xs6rv7Y3vGPL2hbVoUhcQxGpHl/hVMmzi5QSYZBTX0Wr+cPK+j9jvgdyp5Iu82DPlRx6aj7QJgAByTMsttUvbwKlYMLO7aEdzI58c2rCZlT9bjBhagZCYD3aRRIYgu16JBka75OAhRVbdhV1dgtILoj7NwGgNRm78fEJ8SXplHaH1YKV/JKZWnz73VuukOsU3pu0evSkIcr9P6RaoThccMI0Kz86D9mOnvpPjxEpNyVoHtFvnXuHo9sX3AWreol3yPcA6pESZdTto3frhx64F+FAWEjH9TpWAI/osOBAxS1aQj4jEvp7Qu94uirg2HkDuzaP+Vq2h1QwJO+nCmtjY4UIAxu2M9vpNmos6qwWyFYzSBZKnXRCc1o0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d0c6a8-c1e1-4266-ca6b-08de1a83f5a7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 02:51:59.8760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEVKIgPd8C6bcLklg4phdXrrWjFIdBBp40FKc84PuiPFKjtVFPzr0sr/mDv17K7RD+R7MvpUoeyxw76KXCYufvyB7sjp5cDgQxSzX+K+K74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5027
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=879 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030023
X-Proofpoint-GUID: wYoAwrVANb2Hlf604lL1XHqvRwDkgbik
X-Authority-Analysis: v=2.4 cv=BKS+bVQG c=1 sm=1 tr=0 ts=690818d4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:13657
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAyNCBTYWx0ZWRfXxx3A0v8fZa7L
 DP8h808CrSK+7pPpdVJ/Fy45EgcQmlgrlgBW6btKimEztlIHD6wqr7/vD0dhkwrkaH7Aem8HUGJ
 IMY0STJ3dFASWP50l9Die999b1FG/4OB26Ivrs9YOkUE2vR+LvdQDVP1wnamrFDvMEpzAd5R06N
 yhGZQH8fXOS6oDhKgsHmtozTXI3eXGUwM3QMG3IPBQhT/6a0DPR3BbEvohGG0H9iu3j3UtGEZsQ
 5/hL+bpYPWsYG8CZ9vx4K0GkspmyH4MgmQOYsonzMtMGWZfvkQ1YmgJO9XKHOkEUzvCXn7R9lDM
 IEifKrV/hKtXlgV1oapCfFrzCDrfFwmhkUSqhHOXkwSGGVz6hE2HAiWkaz5/0BLPqA4jvWmCN7s
 2UXYY/nzcnj+LWz4ams26XMtPmF6DGa1K8buzN6Gfv6muDffnJw=
X-Proofpoint-ORIG-GUID: wYoAwrVANb2Hlf604lL1XHqvRwDkgbik


Peter,

> Replace Stanley Chu with me and Chaotian in the maintainers field,
> since his email address is no longer active.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
