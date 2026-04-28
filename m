Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC299413225;
	Tue, 28 Apr 2026 11:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374814; cv=fail; b=Vrsef8AU9Wa5SMm4cc8votXH2WRQHyJNAg1yzDT84fyCrrnh1FJ1XtzzJV3Mjm5RauSz1c51n8PWquY+GQQfXcYeMJ8Nq2xAVUIOchrDCRrvz5lge696up/y9et/fjWU5PCy9OlEaCLZeYQelmGOhs4WmofmnzKuPyQDx/ehv18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374814; c=relaxed/simple;
	bh=ITAdqiZazZG0FB3ApSM3dkG/lXdmGqkiBOgrbNlUFbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eh5goAlqYxL7u2Huo71pNsKS8L1E9l6OSUzDy2wTBjV4Mx/UOlFu4nVivPTPUzq6haQ9QoCi+GpZesI1Ai9mAV3CH4cRyRlnkAKgG2eXq23V/fngL8AreYl6JWh1S/OoSIyb8zYxAzOsP3A8h5vNM19MYAYAdILiLPc3YKGKIkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mv801Ij4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Iql4sHYl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mv801Ij4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Iql4sHYl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S8qi1X2128105;
	Tue, 28 Apr 2026 11:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DenTAVuJVMrKbxEDY1RmKuVfQAKWLTDK8q4B9QrnAMQ=; b=
	Mv801Ij4v59GFlWEyNmb25eQNlECVEbzyltqwojLiqmJ/STtYM1fz8KjOieMUcr9
	H/t4gBhBmWkdRRogCrMI4fW7BMwmge87L4K6PiykvlRWR9YGGqHdiW4lT+Gq1AIT
	Pu8oRraSRoEbrS8fz62HucoL3UBQ/cGrndQA+5cN43n0p7loFJz+rVrTftV6SCW0
	34abd1ZpFOxDB9Q3oD/+7BidAPrT6VhUbaCIMeIEk6kgtYfn/EaTG+k+ixxaIP3u
	jg9EqhdrzoaDYLdJfL3anKFIMqNHkYnlPSEFdIOQElEZWmHQ/Itjuxa4my+NJj51
	/dsOwT03Bh9q+kbdDiEqow==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drmha7jmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63SBCRWJ025901;
	Tue, 28 Apr 2026 11:13:15 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2ckhw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Apr 2026 11:13:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BO3oOyFwG3mk6Ryea+R8N+t667MMa3XNAPRoREpDUQSQsp3rU6ZVh3Ns0yAKqIKaB6N0d9upwEwaEki1TYifwyXzU8KGGd2iRbPcOds0RAZNGMg1sTbzPXC42ad6CFaqwZxcN8eEvC8R/XydYlcHComlOSbz9qH0qLCUm6zw0au1YqRq3Hnvw1If69jf0dxGWjJ6XwY0BRz+KZ8g3FZAkzpehfdM+ih8H4a6TuE7kzOx/sRIX3iHBEDtSZTTxi6dFRd86Cv+djLLcUl3JZauk16UCbx+XoqS3UKvyQN64BU660DvC7WhM1Aqt792ANzLZ0uNXZrj5A5Pi5iwXlCGSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DenTAVuJVMrKbxEDY1RmKuVfQAKWLTDK8q4B9QrnAMQ=;
 b=UPDJgdiSlL8HZupLWbemzsIZbSYhl0JjXEIGUDOUpSWmypS4Ie/r028ppTXejyGZNraA9nB58HrUV0LVgngwVKlbJu0hgL6vzyq4Zlo9yeiWFN8rjhp3nrovkPV/oRO102WnJ4C3bXLOcJUdn+sWlXrhkJBUT77soRQVsI1vd8nJyVzoC+s4AW2yAjWuR4g84NJL2FxQpih2mpjDmfHSPZfwOiQUnkX2Nxy4WheSWEkLu2tqPUYC0HixY8o9aBJsFqSOh/H63LtGqQXdRENYDLPjV0p1wkrtOCG5vJksYG4Jl9BbjOmQCEhZWLFn9PlXsMSMNLNDPGRyEsRYtKBKDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DenTAVuJVMrKbxEDY1RmKuVfQAKWLTDK8q4B9QrnAMQ=;
 b=Iql4sHYl43NTvjp2PIHJVXwRNKSl0sCANGTgMwew5nqTYb3S88QVTaJidPPNXVHRK2uBnlRh+npyxXsr0n5qG/p3LIUQm7RAzbtNyLUF0POaVgn86MZiP1gF400d+EA3YEjgRvvPfOsbmXwZyUDzD6HmjxvZGs7idOGEZKpAVb8=
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6) by DS0PR10MB6222.namprd10.prod.outlook.com
 (2603:10b6:8:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 11:13:10 +0000
Received: from PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16]) by PH3PPFEDB06D67A.namprd10.prod.outlook.com
 ([fe80::234c:e047:21c1:6d16%8]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 11:13:09 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, bmarzins@redhat.com, nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 03/13] nvme-multipath: add nvme_mpath_available_path()
Date: Tue, 28 Apr 2026 11:12:46 +0000
Message-ID: <20260428111256.1778475-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260428111256.1778475-1-john.g.garry@oracle.com>
References: <20260428111256.1778475-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:510:339::20) To PH3PPFEDB06D67A.namprd10.prod.outlook.com
 (2603:10b6:518:1::7d6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPFEDB06D67A:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c81c0b7-9982-46a1-84b0-08dea51720ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	w+2v1dMYdGDOI6D0Ls/4dQi3y3/VclAO4A7fvABRIAbw2kD8K1iMJHq5kWPCcEUKZorikgLA1DfMGxfyRu3v+ebZDa0UyWpIPWaUmLyIz2rV0sa6YY28MTtk7MSdeIxr3KHv9OQn+2QFQyo/Ut/8wGcV/umZH1pciaqfISb+uFTk4yAGeR63kUuqmWX2YdRBYn74rJInT67uVvDfCMvxrmPrFmyN7VW+k3pvp7HNsVMwX1Vs3LynTJZDXOJef3Wc5shz+tKDOkIrp+7+huhE7jUG4eiq4t9SM8gj/96p6r+Jue3Y+bTz+IyFEXkSmIPjfhSmMWBA47b67xgaLLD90ZVaAtptFvFS457M5J0UyFT6Zxx69WjZSd0NZklazKHmGiKpgBXfPLqpe4+W26ulFK7RfaLpfS0pGFv6BTR2YdWl2UvAQQDxg/dg5A1K2RHDCpizUejK/GswoWml2dYNtie+7jdeVGPiBwU6Xoq4yMLtMjjGqtdrjnF8dXtme9j/c/AUXAaeLVVKgpmuPiVnCTibxwqoJKYqXACD8oqqaJtLFOferUeeRHF9PTdtm8gPS+EguxNxxOtxALwCDIMsjTTShAKmk/giKEJT8sqsgwY+twOY9ugt174yYA7dVbYUe0uwy8yPN4evhW5UO6InNsK5eHTXQjj/MgUMPXKYyY7jEVHLdDPlcLyx+qh5BYB2TKJPISQsLNi62Ap/+cMuKIufHqKkQ+BTOx123KEPkQs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPFEDB06D67A.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mbg8RjxFmKZKb7Zz4bIw61JbWwEzfdPAPxHG5goBZoAcCHqEdSl6KT4GkjOf?=
 =?us-ascii?Q?84GhQK3uHXveGfTo1QAef7FCVLOK/drqGK/zVb7UQk3xeYG9k+m/uxyC1cQd?=
 =?us-ascii?Q?spnIlkT7D8+9eyR7K8k7mzSr8rz9RpxUFW2vvWBtxYCtFP6Q4ImN0srYypJY?=
 =?us-ascii?Q?H45Z3nQHnm8xQKvB6kLoFBZMqWg39zMozrkFW+1y+3ktN4zEOl6Q99znhiiN?=
 =?us-ascii?Q?LJrve7EDUS7OQOLHvJM2VNfvn4BxmgtsVCWOzKwcBlul8R3ZiUh5GZTpYJS2?=
 =?us-ascii?Q?mIGxc80LZe6RWe3Z6IVDcLHQfDlzKhoblKIKWvTCEup8TwAKQQxY1WKuecML?=
 =?us-ascii?Q?fcNbfKqkmED2/nBVouCZEYvzpuRgfgfTPWnkbDhMBg+xPUlV33kR8wEhdnTx?=
 =?us-ascii?Q?JxJTXlWfBVZxTitJRlIl0T4vLDQqW9yUoLmSzU/ifCGHXnK4/w0aVV9ddFIr?=
 =?us-ascii?Q?Is14mixAUS78JteKk94AJ2auGrxrvNid+I7SCJbJ/11ftpESiuckCNKnis1A?=
 =?us-ascii?Q?45DMPtnEOQYRop9oBMtnx6pQT2s2D37N8kS9NUrCmUPKVqi2rHfEyzENUKq6?=
 =?us-ascii?Q?ore2x0JLD356FIHF2eUss0KHj7lVxfgjut/rO8r1uqyH2g0xvLHI94nLYOi3?=
 =?us-ascii?Q?mfeoxrNwvgo2PzvxW9qmPSNlRD48B6ka46rUjnXjSHK9kQu6JW0E4TpRx3xg?=
 =?us-ascii?Q?dHOMF06gwSs14nmzQatssyFDnffsVE9xVrxkLBsi61R2Fi+FqzxLfordmDvj?=
 =?us-ascii?Q?VUxyrf2JqU8soUbS9CGD+nGBDC4x9NkDweFoPb/aWFTMhajZmlyzo4AvDdz8?=
 =?us-ascii?Q?feTmFOKMF6CP4htrBAGxK0UcGh6VimP7gHmSYMZ4ZuC05wrp137oV4kJ9peK?=
 =?us-ascii?Q?J9w4d/zbzUkkkrE19p6bdZyGyjc+JoofUaD5Wtd1HpxipHQriz/8uWTHQWj5?=
 =?us-ascii?Q?xWK/DG1KhwBsx+tV1y3PsWeonDm28Y9TRE/Tk80aA0rwLSUnKdd0SPrgpnHO?=
 =?us-ascii?Q?HXJakpqJXrRPR+vZu8KIXxB6Z7s+B+jS/vdyHgXV2KkTwuMbRfIQWYfU891m?=
 =?us-ascii?Q?IZ2qnkBD4mghNg1w0VjxQKRsetvd3aUYyh3+LNhfGo5GsC/uwudcU97xOM6n?=
 =?us-ascii?Q?794qVVPmSv34GEduyzOTkVEMb8LTzjko7zEcVVmRZDovyf3KsshWKSkEDaOI?=
 =?us-ascii?Q?SHHOKq0vnBx096NhobfQb7DL+QdtXCaZE4YMrNdrybHW0ycTGmFLFXTreux3?=
 =?us-ascii?Q?ZuNBX7oqZTr4lf6HZ/fMcPBBLd75aSwkRCe9SiT03Y3SCmHdgA4zXZcKaXcv?=
 =?us-ascii?Q?ofp+i8XulWhbRBciJiFV3JLgQ2+Tx7HPjPxwxnFdn8vdWvoJJGMfCYhRhHCD?=
 =?us-ascii?Q?FVL7GqoIhs3Lo53SbcZAcmVOutZN2u0QOm4Y3+D0U2WHuZMtowqA2LGmpy8y?=
 =?us-ascii?Q?LFkRifByA3Q9+GEupIIeDB4gI+e9H57n2JazNM/N/qePfgz1Xi/L7A50TtGB?=
 =?us-ascii?Q?LxXDFQexSUyt67qH8tuXOZFTr+Fx0tconwNsd6Evmax0mK19TTJA6ZdiBX29?=
 =?us-ascii?Q?kII/xOY6Vt0r8vb78IaBazIBGr7cC1oMNkfCl7P/maLEfghOx0ssHwEAlTyt?=
 =?us-ascii?Q?ialO2bWYeFjSe3zjbysxz5P6cCb7gowOnx0GC82arNf2xfavja1WfUPjPxtI?=
 =?us-ascii?Q?ci97AFkNrLlbynNVbKSkDHNGdN6oF1xExqtnOQOpOB/ekn8OR0e2IuRziIJz?=
 =?us-ascii?Q?PCICh1Uc2lHJWkoEx0bhn400Y6tiO7o=3D?=
X-Exchange-RoutingPolicyChecked:
	PAPJGK0DL/+INMiSRDuFvZGZ0HehY8TpZLt91c2WzZR9HNulqox8TjQA0unRkW0vOtiJtMUx1+GUZJYfnz2Wh8VW7qySCnnmcetyBbuGZl9hrlR+ukkFhq1FEqm2ATB4FeT2O3wSr56vJQWUPtMr0gCtdEeU8VaPj1eU1IJ8C3BosLvGtQz5Kz33xEMdFDMCjB0C31gkKEz3dzVh1YpIy5mYAoMwke8Rd6KV63KZRPZtLFZ2incNSYx6J1j1rND6LxNsFNw5XCjFN4dugMP/KPZnp5Uqz+4IkiyKT1KaNXZd4DkB6Pd2o+HWzxFZEbLFNIRF15BTu+k4Uea7/ZN2XQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CEmCMOgSyFnzk5fnbbg7RL642OvHLU+mI267VIl6xlXJ9GyTXdGTLiqLCn5TuLpgCYYsJdbVXHemN4SvYXwxu7hAQ3Ndz7mc1xAc1LukoK9XYdwzhUzpvtDFiJqPVjt1NZ0dllLQH/MvlMf4dookabuBNOHYM9dgrGRJb28nPrJ81VtC0pfVmNQFUD5+RIMfR9bcUhQ2HhcqWo3olXMccMfB60qpMWQYpgcDQET9NfwXL35hS01I7KXFkIxqAZB99KSo014QkpGv7ROsWgMnayouJQ/Ma5DOyKblKVKjyQWjxASF6jSyy3UTLin0a5wEEh/TF++gUhccWxGL0V90jnM1EdWxc2sjILKKLMpCvXRosiWEQ0Z1YDJB8e2EaGdNAzdaseqwsS4clcfqjYG5lJJPiyVUxEx/DMj2M5mQwb6cQuybJhyPOkvDQ3VPW5PPgHgUNgRnM2yUUPPU2WDYv3CdeovKWK923QvWfI5bAUrGGnDkE7VQabV/KwySYths8aDgsxkaNhYfOx+YCLBX9BgRR8X+IZgiuJGRsLkYChpr/xpXN3CwnahkGqkOSRQARqpKM6X4soUB/vxdY+PMs2Hnyksm6ypxvNhSDkdZ4EE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c81c0b7-9982-46a1-84b0-08dea51720ef
X-MS-Exchange-CrossTenant-AuthSource: PH3PPFEDB06D67A.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 11:13:09.0235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CmJFahdq0jbD9UNAVvfmqNa3UJQR5P/aknoUPrfTtrDHSTuM85woNKU7iq4qAm3yK5qoxP7+onn1AvjlR3fbqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604280101
X-Proofpoint-GUID: -haAHOnoJvXWkoLvBNFY-QkWSZa1iL-r
X-Proofpoint-ORIG-GUID: -haAHOnoJvXWkoLvBNFY-QkWSZa1iL-r
X-Authority-Analysis: v=2.4 cv=CrOPtH4D c=1 sm=1 tr=0 ts=69f0964c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=WJg9rLiHYWik38eusUgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDEwMSBTYWx0ZWRfXwBo1pcLeCSFq
 P7xHSak6RCvvLiG9uYv5AdsQ2vlEbMFK5N3UhsWBQey9vjfuXQNlQzBBTAMjFhbksS6smVyCFhN
 QJr4ryIOjLWZgPVt/jCLdszooNBMof7cI4bKi0XStFIulfqRooe6WMN448TWE2eCJdZSWGr7Xhw
 B3U6tZrVPnbFK+3jixV8NhmibtZBfHFxUg7agfhiTpH7kd5GoReL4lQXiXWowIEKsJdMhVCEYUc
 aaVkjyGcnq32o65D2a3+TdDq9zR3AcGJuNTcSw4k3pMyYL6Vze47+RwFX16aROd0NaDjWgotI6l
 0kzJ3rfyDwwocqUXdMM29sTldBoNxNGQIJ5GvZGgZdyQyVWTfXShA5QdwpxGGXzBG2uoL/TdhNF
 hB477MquMxb9qO6D0fPqA1Blwhb8utBkGbuK9cLF1x5MnNgrTiYGUE/74WSvlpz3xTnfjMCjJZA
 WjiXrUNg+ylREyHHkEQ==

This is for mpath_head_template.available_path callback.

Currently the same functionality is in nvme_available_path().

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/multipath.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index b727d6b69f3df..cc5a3c6c272f7 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -491,6 +491,25 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 	return nvme_mpath_queue_if_no_path(head);
 }
 
+static bool nvme_mpath_available_path(struct mpath_device *mpath_device)
+{
+	struct nvme_ns *ns = nvme_mpath_to_ns(mpath_device);
+
+	if (test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ns->ctrl->flags))
+		return false;
+
+	switch (nvme_ctrl_state(ns->ctrl)) {
+	case NVME_CTRL_LIVE:
+	case NVME_CTRL_RESETTING:
+	case NVME_CTRL_CONNECTING:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 static void nvme_ns_head_submit_bio(struct bio *bio)
 {
 	struct nvme_ns_head *head = bio->bi_bdev->bd_disk->private_data;
@@ -1391,4 +1410,5 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
 
 __maybe_unused
 static const struct mpath_head_template mpdt = {
+	.available_path = nvme_mpath_available_path,
 };
-- 
2.43.5

