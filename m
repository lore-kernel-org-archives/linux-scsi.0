Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC123BF689;
	Tue,  1 Sep 2026 10:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259658; cv=fail; b=RmX4mT7OJ2k0Pg857mW6IzXhIbnIyYTAegxIP4zhpIcPjyA1t8hgrEEiTBRszuIfD2YjU2jPdVd6wDMz+Ujfuv719Rj8tIY/fG2SdbDjMNbFX14ri2pEHiCx6+y4vVui8L71CX0wL+S2DLlk7xJXxDwbKljqdomiBrapxkiuNMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259658; c=relaxed/simple;
	bh=RqtLSEpgQ/C9z9P8X6i8qf0hp3aPrqsTcgh/sxyJO00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FP0JITL/cNmrnJs2s/dKTWiv1LUEMfbLRn+P4R+N7eckoLVfsS1lkpFT/0/Ayxl2Chhr2c0V7HMsb8yddloe/Wwe50JEIckliHxtC/TH92DXPcUyUWJmwf+IoWLgW/vNVYVDOYqd9dA1r8wjA1UJISJ56McsRJR4VJjj4xeJV8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jMf6HXfR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lUiKSbu5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jMf6HXfR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lUiKSbu5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VLCre62681587;
	Tue, 1 Sep 2026 10:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YMwGLfg5OZZbjGRLBsDa+MbTQEQ9i0uZkGRe5goRz4E=; b=
	jMf6HXfRlA+aVs/dif9KB2fRAlmkXhHRiPkYyk2QNEao49G2D8ydeINsFdpnLm+X
	mLTXSptyxZEJ1iRNmYlM6PjRwBHDYFeX/YgnVe8IUgC9csf73IdN52imp3cWsQ8v
	HEtE+ZPZnhJ2O/ifLfWGYs0zQoFevvFOW8TCHXHXt/nzJS5MymFrOJtvkjWzPLSf
	A2YEEnpi5doS+4LRshMcAo2ACHo5GGMVvjLuUI4L3zz57gILfrRdFf+FX+U2lT4i
	lx+vlFh6x5578alvjqrx376cRlY0q3MdRxYHulsU8zWctynegllqNDmB12R8C6XQ
	nbqJgZRgSRDT2L/wuFSXRw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqa7mby9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Sep 2026 10:46:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 681AjIgQ036924;
	Tue, 1 Sep 2026 10:46:02 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013009.outbound.protection.outlook.com [40.93.196.9])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnve34gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 01 Sep 2026 10:46:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cM7JP/jSvaBbV+/HKfJtbXnB92VwlFuewxYl6RptXomvqvawPfmibIgwGoRiORALUcL3bpJMuGQ6SbOwf1OWU5rA8K6cF1E2dE7UNE7YfePzL3SJkTB9fCVlNqPSeTo0dGiirPuYJ/VD77+gdTHqIQfxw1tmbsbEwO8iR4grqoWJiWh9GKC4bTCl1H0Ni4hBegaQWPsuH/wNIWqSpuWIisKWX7F8pksg0dpCTw9OWWKsx2pFoefghPLcAfpg3lwxerSicra2Nbkjvdf18/v87E3zIaUcZlnLoFv0Dh0jA/6o9cPRPkZfh7gCXyw2ewP99yh7J0zL7f5OXNsLyL9KiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YMwGLfg5OZZbjGRLBsDa+MbTQEQ9i0uZkGRe5goRz4E=;
 b=wVhsLFzLqF1MdT1ahqdZzu+u9MlOlbF0ilH0pBRSwQMxfVSzcGXYWbA7oHSu/tPpZGPlkUlwffvANmXqv96X15ZwwOcqTyD3VZ8b7wgjoa6217XMO/MuZl2PfWA9FiLEX80HN7ES5/P68LzrWnWo8JTQT8c+I9iMKBSs5NkfgCvnSjB4FuzTv0dF3O3b0o69DH9po24K4utUih4zlL8+9NBl3fzCcHlvK/8uSjOtoBRMj9pzr91qYwoWDzMHSPnFoClQnAL9sZMSzHEBU9+avRzPyhkvJKxD5D91zFEE1tf76vwZ8Tfl5maRAKzjgDb9V0Iawp7DnLSwH4khBc+zsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMwGLfg5OZZbjGRLBsDa+MbTQEQ9i0uZkGRe5goRz4E=;
 b=lUiKSbu5sKEs9+nhcVHFcNm84ADzPLjAtpbPlzQ7lQZy2J4PfxP8BtrLsvCRgfVjPtVCxzreSuQREgF5l+Obj2XFal2WYmH8f7CrL5Y+oWU2e0gfbJaXvGtECCVSp9jJiU4idavi+6PLbSJ0o9/Th8hMPjAdHYRL6UbVsiaIWRE=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.10; Tue, 1 Sep 2026 10:45:58 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 10:45:58 +0000
From: John Garry <john.g.garry@oracle.com>
To: james.bottomley@hansenpartnership.com, hare@suse.com, mkp@kernel.org
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, hch@lst.de, kbusch@kernel.org, sagi@grimberg.me,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v7 13/27] scsi-multipath: provide sysfs link from to scsi_device
Date: Tue,  1 Sep 2026 10:45:12 +0000
Message-ID: <20260901104526.3850621-14-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901104526.3850621-1-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::20) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: d0c97b86-11c0-4657-dece-08df081634c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	hKhxAOXpYeNdJfpyBk1a7BQLZ5C93HziPOrrElvzywgMjws+soDpIJNDFdYhupwYvtx+nQ+Txq0KsCroBQXAQNDF01dUcBNafj86PQmtQzp11zcR2HQBbuVFjFrmUCdcaYoz/mFRKIxiTp8oQZWVH+0mXiI+c1Xa2U+1poA499aOzUH0h4xr9QVDa7M/2LtIk+V7yo36SsNvqU91J8op/On2sKYMzk+IB0tT40xCPAl8vuSIcuIh/Bqu0lfMT8rJBSbJJfnOV/f1/jU5i20Xc7iaRZqN3Ev45nOfYl2ipTKNvjilNp1R7C/tG6DNdAWA/lfBHIGdjl/t1PW+Yet2GxtBZLweE7sFmcZi9Z46IVK/nxOU/ub4D2M4ABsDSnLUDwrUlHAecpyD+ipXFZHGU+QlGeh2s0hKLZE0M7LwYS4m5MEcKij2N2+HfIHQYICsAmfPwkBIZanRvx9OvyR8pDwqDNXe6jmCVbHZusiUwRqsi/IwHzI9H3Lw+YnII89xgDDk58/7oHm99kHwLIVPM99rI2QzCaGChN/MffCJ2iY/McQZ1shZeJEeUBsMfGhUEX2ShzRXs81uo9a5aoD9Zy5Kvf6DkMUCpEZEpPa7xgpdUUQu3YXIAgtOCtUVYCb419e45vQMb/sYzXaeySuva+PjHJWkBKBKViXX4f+Ct54=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Fnn67kWkCVMN3aA8bYSSFCTNPwgSqpBewGk1Amt12ibajSTrvys3fH7oMtT?=
 =?us-ascii?Q?aHxc9dN0MzOrNotmnuHCDlxanMrUntTWKDEmBKPYrDOxlLgqH6UCbws0JMsx?=
 =?us-ascii?Q?Ykm9zG4QJbBugkKitJpY1P7OER6yoPRmgSHdVtFfDsxWzJrwx8cx2Xnge2/5?=
 =?us-ascii?Q?dQb3ZxRjEskz3bsj6TBXhuSyq+ga2gebrO/hOkypQsoMQeCOqDgf9JhEeQ3U?=
 =?us-ascii?Q?xkUWpO0GDUHr8zbbju5MjCIsCFkhmtR+7nHJq/VmXgGD6pMMZ2mVdEAVlKk5?=
 =?us-ascii?Q?U73S7/S1BCEkDY0xSxmz91t9tM8WkJ6AWRfb9i448h3Yl+q40tUCAoxoAW7Q?=
 =?us-ascii?Q?mvlBCBSlqUuy/V5DozMBZIOe1Zgnqmg70wJzR8dUWU8qr7cc1VHvU6fFGzGR?=
 =?us-ascii?Q?WKI+ZU8lcHe4jy4mI3COMDWbiqpty+x0HK4Rxf2qDmpSi/3zelUYLWSyTgLA?=
 =?us-ascii?Q?VcwbrdoD+1c3IzHJOOLBlP4qrRqPvyyO7PVJTWFcfk/Uax/dS6D8ImISQKtr?=
 =?us-ascii?Q?s5WcM7tkofNOa9I4nBh2rAZOSkEdTqk+brCrSPO9R+3m7P1xqNZPV4+qD7i9?=
 =?us-ascii?Q?NOcdlbUD6gSmh0In3CLwA/pfGlil1THpB1K0yWfnmjH0egOXXKRbBBHlyObm?=
 =?us-ascii?Q?TnjrHQybovYjqXDLm9xxR7BJx7HnHLnDl88wa+Qv2Oxg/OiMLMhs8srjtmdf?=
 =?us-ascii?Q?otNNPgz4LE0uEGBt5H8G4fg/MO3Es2aD2gRHT5AfuVgY3o8VE4HVI7/l6KLR?=
 =?us-ascii?Q?aW93/nXkbl8gb9Y1UeQ3FgH0XKvEV6rsLHQe3dCX63pGwW2LwyoUtSzHBM1q?=
 =?us-ascii?Q?y0bCLwGXwtRzlloa/04zvhHsRRgu6IEMAZ94yrt2dm4hebRxktGJ420jSw3d?=
 =?us-ascii?Q?FuwBRin0P7yfgAeexAZRMbVTXqPTqkqFhIZ/KlTYbrLpS1I3pG8KhqMskMxR?=
 =?us-ascii?Q?/TQ4VkzGFY2bLlGOWXg3D5UBodSX570LKx314OPp+Kzj+a6vt083CTRarbnH?=
 =?us-ascii?Q?3uNwAv5Tittm2+nXoWfeuxSe3/kM5Syh/z8+7qtFkuszi8lQK+X6HfROh6jm?=
 =?us-ascii?Q?9Gq39A/6jd263dARj04G4SkXFOcYmRixWhPV3CL27ttrb9hY4ejYhLxRgecR?=
 =?us-ascii?Q?3SLTY4m3rWbzbV7VqFEfejVrHC8Nkb/6SRIxIP1lz6BGGJKOEJW94F+BARFN?=
 =?us-ascii?Q?+Ol0SFiwJzk9476zMMFFIIlDG5OxJz9r3Wk0bWd19rgCllW0PsI9jqIDexyW?=
 =?us-ascii?Q?93qdRRW0F2BEqUnlbY6epG1zUvNsp9WMjaL6d+YSt+bTaJcXfiO/D9TIYRFT?=
 =?us-ascii?Q?djS1KExDHXR0KE8bJaJ/2ctx3QUUK7jBtbCVFWP3/rrsr/x7GXYpm7/DdIsu?=
 =?us-ascii?Q?ljdAeZ/C5w5Z4S3NJ326xoctmHm1v3gXMLCjc07Nv24TKHNbTfhIFdL8GpvC?=
 =?us-ascii?Q?aixyBSFlqP9mlES37gXVPHef6306+sRUrEJ+z9zVCf4UUU9AV1mxQd9VEQNH?=
 =?us-ascii?Q?CBIvMl7M1FNDrDQonZTCypEOxM/SmrE5x/EvsNm6GWn8/lzL/HWBJuVs0311?=
 =?us-ascii?Q?YT+DHPe902E9V2g+2mOIj0kb38k8+DktkXbDeoRk+cjIT79hscuLWZVZg81q?=
 =?us-ascii?Q?RmXw2lYTT28wvYkpGmlIUvIq+0mu+GdPhx5dCfYz/0YpOYtql0I7hLmCMsM1?=
 =?us-ascii?Q?Q/wkTzG6Kuzx1Wd95qt0jDvAlbJRe4Ygiz2YQ7XRdSkA5vBzyY2q84C4Frzq?=
 =?us-ascii?Q?yBmVIpj0mw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	TN740pZ3ij+071mXpK069AkA70nMaecw4lpaPastQRktvzosk7AiStGHaNztYRLbR325qkkdUHTLfz5EdtnSCKhojNmhB3MFKEuMgScvIwaxds8C6rFfiW9oKSgMcXT7PuenlOXA2X8HK1qDOUND15A+1KbkaEKIjCz5NoTnGZZ0oYx+cQlvT4FHmnsCNs4E/jJB83ZlHA0e7/UWlfOmZQxhT6qUFB6x9Tscd+lmzyP0z6JfBUJQ/k2zu493wF8LLRC1tCMoH/3bdd6La8qXcZpVGXeb7Ep3McEsmLy2+ij4lURxEE/QwKOoIqvEqQOZCCT0umAbuvlGrEDIBXz0EA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	78RfJNsYnpmN34BvnVKU7pUxOtspUmw/M+LHqU7CKN5A5Yfm152JsXRvjeBj1YL/Z9dncpnQ11OMwa1jUu+WEfE0eX/Yz9Lzpa2NV12/tdO4rNVsAhANZxYyWIUif8N/RCERplhCcZ9FXlw7NqP1XWUD6ZkP2UnPLzUp5lhVdiWpG8g3nMe/335oNtw/vNE/EnaNRm1RHAaklRiXOY+CCKnbuKLdF7UUa8xoMLcZNIyp3dWfmXSlHmiYRAhE5i/YYnBOrIH8f43okw8C6pa4p8dxx66cK4ffzgKuD6rWM232PW0p9JKdXC7M1sjVVKgQjIeL9Dv28ltTIkW8Izm7Ro7l+aibLKEmkKRAjLwyYpdFh13uIOuMGS7eHFg+bQoT4uGr8dLuRT7xwPpxtiX5GJz7VkXPZNA6WY5pgZe7HdBetsShKFWMdX+b5nmzchmQbn9JFS4qjctQ71IIpe4Ncg4k66ZNaEbBMPaJV2c9QFzp7mZzvlyRS7V5b9kb+LRFhy23H54bU1lhp5nrL2pzQjvAZ5IoDVRhChBbvQgdy33nE+yLMJqECihFnxqk13fChr5RwqIMJxG8FS4wr3v5Uwdzx1jE/7D4uOkeTSlUqT0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c97b86-11c0-4657-dece-08df081634c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 10:45:57.9671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxjJvSWh6V25fy0+1Zzi0zyqIAdMz0L5YlFIyzJGEsGXfpIEf52Fs9LeGJ6OL4+y/ruIZiWFL+8oU6IVJdyvnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609010095
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX+1lj65dU2a6H
 Gf5pBu0LYr6A4fTYMJ9mZobJ39cgu43pUuwXFWflSP6q3+ANewIpZl/Pau94cAd9j0TziXqwRvj
 I7V46nC6fdxG3j6oPUHx9Sx4EQv2upF8fN8eWFuzRoSNEADbYKNR
X-Proofpoint-GUID: eDfybbCq5v81eyyQo3ssNjJ_B8EV-GzE
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a96aceb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=VdqzKS8jKosA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=ZbQ-JUxe3OK3M8wTWUQA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: eDfybbCq5v81eyyQo3ssNjJ_B8EV-GzE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX/mMu2lCLFmJF
 Xd1rN5Fq7ij7xdyewJpdr3XuPTxOpULoo8HBBZLWk73LM03Yn9oZ2GJOiJZmYftozHhA1NyzAYS
 GiYQhfe+n7/9w4TsDe/9Vx6LTImAs2Z3nWbBxxFS2jd8TolZBOjLk3C3ceelfFy6qCJDJ6c54V1
 78fBz8QduR6hWBANkZ/shtkHBApGojBkfqXzSW10NZOofPJRllX0NOP12oT7orUVFIQEe6kp0HW
 vXSvj9F9weA5ESpVbb/zHUQziy8hrGzHj0J28DmAMoRQw5I45RA/GLxKEXi6Mm6ivaZGj+mMUGc
 c1CFkBtMANm9yVNYRooFuCp1zw26BWYdJCDACRLDSlbL4qyfcvs2we63ZNmHlyUP+9sqP64UEWi
 czpCn0MflTmXqKvzcB0Z47RcmZQZy4QR2WzUNLt88rIe5F/HIWNO09Yb2fZ+RORoT2Wp2GcDZmL
 LBwunuvADOopXcKCvDQ==

From: John Garry <john.garry@linux.dev>

Provide a link in sysfs from a scsi_mpath_device to member scsi_device's.

An example is as follows:
# ls -l /sys/class/scsi_mpath_device/scsi_mpath_device0/multipath/
total 0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 8:0:0:0 -> ../../../../platform/host8/session1/target8:0:0/8:0:0:0
lrwxrwxrwx    1 root     root             0 Feb 24 12:01 9:0:0:0 -> ../../../../platform/host9/session2/target9:0:0/9:0:0:0

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 43 +++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_sysfs.c     |  5 ++++
 include/scsi/scsi_multipath.h |  8 +++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0fd4347725134..1c04947d906ea 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -114,11 +114,54 @@ static bool scsi_multipath_sysfs_group_visible(struct kobject *kobj)
 }
 DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs)
 
+static struct attribute dummy_attr = {
+	.name = "dummy",
+};
+
+static struct attribute *scsi_mpath_attrs[] = {
+	&dummy_attr,
+	NULL
+};
+
+static const struct attribute_group scsi_mpath_attr_group = {
+	.name           = "multipath",
+	.attrs		= scsi_mpath_attrs,
+	.is_visible     = SYSFS_GROUP_VISIBLE(scsi_multipath_sysfs),
+};
+
 static const struct attribute_group *scsi_mpath_device_groups[] = {
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
+
 static const struct class scsi_mpath_device_class = {
 	.name = "scsi_mpath_device",
 	.dev_groups = scsi_mpath_device_groups,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 52eb87b03cebf..fb7b1add17990 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1444,6 +1444,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_add_device(&sdev->sdev_gendev);
 	sdev->is_visible = 1;
 
+	if (sdev->scsi_mpath_dev)
+		scsi_mpath_add_sysfs_link(sdev);
+
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
@@ -1496,6 +1499,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 		if (IS_ENABLED(CONFIG_BLK_DEV_BSG) && sdev->bsg_dev)
 			bsg_unregister_queue(sdev->bsg_dev);
+		if (sdev->scsi_mpath_dev)
+			scsi_mpath_remove_sysfs_link(sdev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		device_del(dev);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 50d422798d835..d224a15ce9c2a 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -49,6 +49,8 @@ void scsi_mpath_remove_device(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_get_head(struct scsi_mpath_head *scsi_mpath_head);
 int scsi_mpath_try_get_head(struct scsi_mpath_head *scsi_mpath_head);
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head);
+void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
+void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -87,5 +89,11 @@ static inline
 void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
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
2.43.7

