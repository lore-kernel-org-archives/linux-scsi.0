Received: from MEUPR01CU001.outbound.protection.outlook.com (mail-australiasoutheastazolkn19010011.outbound.protection.outlook.com [52.103.73.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBD6326D51;
	Sun, 19 Apr 2026 12:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.73.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776600537; cv=fail; b=qeL6udNEJbWdKBy3pALCZlw09/0v3TmtXyJMQzo+uPR2Hi8miebGMt5dc72sxOnu+H8TmunheiJgKFLnV2VV7gwhc5JVEXXMOe45ZJhqZ5xgT12gOGfLZvQLOWGNK70ixvmkkIybGzkbMvK+xfAbPhWCayCN0Zov2XqXp9mlC8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776600537; c=relaxed/simple;
	bh=cPkCrafoiUImJT1YWsnNmFfPhkvOG2iRuFHPITnF4a8=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=Ebm7ampzX7RZZWkCHSV/xtwwxhb7ltLF816DbV0IlGdnusmW+gbJ0YGanLWG/vLyWzz8oMkXxE+jVTcjaCh4QLEPcnjjoRJZ2WiwKMFCVlzbUVemNvdabCxTx6m6+pZOMNEUBBfLMGOg28VxZRXg1fUESj6mZ4u38tjJt2dn9FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=IKToO4yx; arc=fail smtp.client-ip=52.103.73.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="IKToO4yx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EIgVhg1rx+Tet2J+VkSAPqpcQ/4wuCad+WNjahq0uhVa9zOy+uyFIkMeBQCnkaWj4J3S0ITj3QNA+DP6LyOpeAmhHYhbnj23HqAxYm31C5eLL5z2v9QjpYTo7qlpMV3uMGyWbdgExEbrSxN6cuN2Nuns8iQdSYWadUq+LghdZvZrkGvMEUGXBoQcnf2/CxSd0ctobSsGogfW5jPrQnfr8i0jMliSQoD+4S7Y/nq5Pn5lGlZkqYUFxvb35nWHEsiGrO/FPLVIozmj2RIpavmG2riTVVMEKC6xKsvzrhwymptyvPBA81QqYIJcehkLviezY8VRxi/3B0anWK4i7XP6oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjgPpXgZO1LhLXItaf2Xu2QHched7kr5U2O/a6HKwRM=;
 b=HtCd4UPNQZGI5SELllKSInBbJQ4Ijm/3qQ/Vv0/52NnX2Y1/2/G7I0iHiKtVW9BpndOT+yiEsyflq7QYAX/EfbyJo+VLkxjVaMNTjymgMxWv9vVAwjC0P/SQSA8psuqRwhhpSxHF6so0moX4jeU0fg8rKQ9V2aJynaBBy4QYXqcHuvwhwBGb4W0xjQickPI2QM4alyzjtrRYr4qn5lfN+tpn/XZr5pFUCz7YcF6J/xgnCtEjYTj80rnKvs8JFduh8Fo+rBm3UD5ArrMMIYTTSO/XVRdTwDTNw6tgctgo6cEXE49dt17l+Rcw4C4icTk5fny2kPYlBDzHVQ3U6GAQ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjgPpXgZO1LhLXItaf2Xu2QHched7kr5U2O/a6HKwRM=;
 b=IKToO4yxfQPfcOi5Y1Y/15TYwL4v1SLqqHHZPjZBYOSKBliuE+dVzfDwd/0eWRBciD1KFaLUSio41lZtopDpcOJ23eBlRK6EE0+Yl9V4YwWOMt/9RJhcGJ/duyJRzrF75hsdpClEi9DwBwstykCGmk0VBIu7RrmoXtmhh6g8h4HSWogJRi32ZF2Tvmw3fFTT++8Wz0ziq+mEY4XVSeHg3U9EKmLgALA9SjdVDVTcH98B3S8m4/LLC47qvqti3voFGB12XIWusTP9Pt6SdWOzaXX5k3EuD2GSaDUXkQnczyzj5JnZsr5FDBLcsUKauE+mrDRYflp38QtqieZLuuwxxA==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SY4PR01MB5577.ausprd01.prod.outlook.com (2603:10c6:10:1e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Sun, 19 Apr
 2026 12:08:51 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%5]) with mapi id 15.20.9818.032; Sun, 19 Apr 2026
 12:08:50 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Sun, 19 Apr 2026 20:08:27 +0800
Subject: [PATCH] scsi: mpi3mr: bounds-check phy_number in
 mpi3mr_update_links()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB788162EDBF416DC5E714DFEEAF2E2@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIALrF5GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDE0NL3bTMitRi3ZRkU3MTCwNDgySTNCWg2oKiVLAEUGl0bG0tAKZj7rd
 XAAAA
X-Change-ID: 20260419-fixes-dc5748010b4f
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Himanshu Madhani <himanshu.madani@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>, 
 stable@vger.kernel.org, Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1855;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=cPkCrafoiUImJT1YWsnNmFfPhkvOG2iRuFHPITnF4a8=;
 b=owJ4nJvAy8zAJVb4wiKgu++DA+NptSSGzCdHdzk6H2ETLb8tOpn7R+iTSVxyv5N/icfus/y8d
 qGFR9N0tk0dpSwMYlwMsmKKLMcLLn2z8N2iu8VnSzLMHFYmkCEMXJwCMJFHfYwMU+pOXHZfoCZ+
 2Gr9v4i7e5wLH9hq9B5UaLVvzzLe/vvSIUaG1g1Ju9eX5bqo99x7JB9TyBHhqTXNddGLN9H8czW
 9WGWZABCoSq4=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: OS7PR01CA0156.jpnprd01.prod.outlook.com
 (2603:1096:604:24d::17) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260419-fixes-v1-1-c7cc01d6cca6@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SY4PR01MB5577:EE_
X-MS-Office365-Filtering-Correlation-Id: 975440d9-0616-430f-701c-08de9e0c6af6
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|22091999003|24121999003|5062599005|6090799003|5072599009|461199028|19110799012|8060799015|41001999006|21061999006|15080799012|12121999013|23021999003|440099028|3412199025|40105399003|52005399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjRyQmFXU0Jtam9DSXkzcWNOaENVUUlOcHlCQzlYbW9GZGdMZWZGVjR5UVBD?=
 =?utf-8?B?TG9QTUNSRGg5Y3VQdElSYmZ5UU5tTWluL1UyTkF4ZjYyY0o3KzJOQ2xSSXB3?=
 =?utf-8?B?Wmx2c2RPaUtycHJvRldoVkZVcU1iMk1DRTBNSXRhTVE4S21aa2hDVW1TQzcv?=
 =?utf-8?B?NEp5T213eGhXd2l1dmdFVmhYbS9iWklqYnpJeTZ3S0U0ay9YbWRGeUpkQXpI?=
 =?utf-8?B?YXk0Q0Z0S2oxK2Rta1BPWXhSQTVuWFJ0bGtLSzM0a0lxYm5VRHdwU0FpQjJ6?=
 =?utf-8?B?L0pWS1JGa3pMTllGbFJoWFVOL1U5MmxwQ1V4V3gxaTV3ZjEyTHRlWG9XVmNj?=
 =?utf-8?B?OUtiR1BvRjNmZ1JFSkI0WHdkMVNaY0JUWjZ3SFY4emd0WWlJeUFoTEFlMGV1?=
 =?utf-8?B?K0JMMUNqOE9FZ0JQa3Bqbm1Ib09vSko4a1diZzNaWEt4ZTBEa1hsT0swQkxI?=
 =?utf-8?B?ZldEbWFlNy9hVEFkWHRISzVZY3lLQ1hPUHZWcE1YVnlMeDA1eFQ1MDZydHJW?=
 =?utf-8?B?bE9zNG81ZXJvcS9SZTVPUnM3SlVQTVU5ZSszTDFIWXFYdFdDcHFLemI0MGtB?=
 =?utf-8?B?VTVuRXc2YUJvRE9EN011SVFmcEhZcElTOC9ITHFtV05nUTh1ZW9pbGM1a0th?=
 =?utf-8?B?WmlNbGFMZXBMV1VWWUwxVlhWNGFtR1NDR2hjTi9lTTNqQzAvZDJrcFJhcStD?=
 =?utf-8?B?SHlCaDJVYVdZZ1RYTVFPQjJBd0drZXl2azRQZGVIT3ZSSlRyNFFzWUk0b0Y3?=
 =?utf-8?B?NWtwOGFkZDZDWFJ2WTJCTmcyaHQ1RVFWZXZlMjVrTmt6QzhQV1Bmdi9wNGdZ?=
 =?utf-8?B?Vk9iTTNzVlF3aXBZN296N2EwWUo4UGNwWHVXL3dJWUhSU3ZEcWZaOUlwa0cz?=
 =?utf-8?B?clVybjk4aFlYTkRaUUdvb0l2Y0ZVT0lNZVVFZHlpV1hTd1pQSkFRQ3U5Qy9D?=
 =?utf-8?B?RDZHcnppdmZheXBMb2VBNjV4S3BtZzB1aUlTZ3E2RFk3ZzlSbjdyWXRwWkVp?=
 =?utf-8?B?THRwWXo3Q2NHR3lzT1lVeW1WeGxQNTZGNVBIRGlqQ2Q1RmxJNTA3OEpQMURN?=
 =?utf-8?B?bnFxa0p5c3djUG9GNm92anJ4elJzVUVzRU5YMDM0NXRDKzF5NHJmQXpQUG9B?=
 =?utf-8?B?NFJENVEwS3o0OFNyWjhRRE5sUDJKMU0xQ2dpSWlsaDBuNEJRa21FdDBsTHFV?=
 =?utf-8?B?QUJObTVIaFpBaUEwWVNnd0kyaTRiOEZKQjhxRytPVmdxQkRzNlZrM0p6eVBn?=
 =?utf-8?B?bnp4VHNZQWp5T1RrUkF3SFdQaFBxNWF2UE15RGxiVDlLOStIR1JXME91eGlF?=
 =?utf-8?B?NWhIUmgvTFpSL3V5SnhYcVZVSzNyRTVmY3F1SjVZVlZUSDA0WDlpWFNQeUYy?=
 =?utf-8?B?eHRTcXgrY0pEV2FjamVCdWJxSHdNZUlTRWF3MDVlVFNWQWZNYW1KT0VtYVVK?=
 =?utf-8?B?M1hSMEUvMjNVM2RKNkdzYUVObjA2ejdUR3RzNlJqOFZTc2NlK2M0Y3FGYTZU?=
 =?utf-8?B?a3VJeGx6b25iZHZ1bm9rdDRPNEo0NmZ0elpiYUVGQ0s0WlZJaDlXdXRDdVlL?=
 =?utf-8?B?cWFaQT09?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qk4wM21qZEl4eDBYdEpKNzhmUzl3RjUwVFN1OU9aK01CWGR5b0Jyd1hYaG9z?=
 =?utf-8?B?djhOT29obTZWck16emRSck5KeURiTWJJUldCeG5JRzZZK2FRcjNrNXN1RW9L?=
 =?utf-8?B?aHcwc3IwNElEcHNacGZCTUR5N0JIVHFkRDM1T2N0M1ZyWXQwYjlLNkRXWDQz?=
 =?utf-8?B?Q3dPa29RZjdnSExCL2NIeng2VTVvS3E4Y2JJZWxrMlc1aFpsWklEY2tZRUhP?=
 =?utf-8?B?L2U2enBiTUc2U2RDTnpScXo3ZGtBSk9INWhicGRvWXJKNjc4c2sraDRZdzNL?=
 =?utf-8?B?WTVhNlZzRU0wNzg4dkNQeDlSbWNGNXFZNGl0amN4MW40RzYwL2FvdzN1L0tS?=
 =?utf-8?B?L3pHNzR4cnVNMkhkZ28zc3pWdG16ejY0cHFIci85WGtJZ2c2dWFZcDd1bVhq?=
 =?utf-8?B?MEJOVXhibHNzWXM5Q24rY0VBaklLOWdlYWdrYlkyUCtPbjF0Z0VMcE5YQzll?=
 =?utf-8?B?QloxRHd3ZnJaYVkyL0IvWlFsdlhxNHJmeVp5dGZEeHZDS2IrYzhiNC8zU2Nm?=
 =?utf-8?B?UVovcG4rWHlSSE5Gb1dYN1ljcm9qZzhqekZtYktqbThjMFJpUk8xclVyMDJM?=
 =?utf-8?B?ZzVBaVQ5Z0VjMWE4eWMwMk52OFFzS09vWUx1OEJGbWlCYms2VWRVbWRqMVZl?=
 =?utf-8?B?empYV0JMclVaTWFZZ1orSUgvYWRrdmNodk1DMFN6SEdEbkhHTk1LRDY5TXZ3?=
 =?utf-8?B?Y0tGTFZ5N2JRUXpwbWVWZHZLK1ZDN0NKNDc2ZjE3YkFieHZJQzE1dzdXNDM1?=
 =?utf-8?B?NDNkbUxzeHg1WlpINkNOa1Vrc0JrdEVXb05ZQXM3SmUzem9mVU16WnFLR205?=
 =?utf-8?B?TjBiUFJ5UWlrY1l3eGdQdGlUNWhRVHBUQTJ0Z0xZZHcvdWluVElNUHJ3V3p5?=
 =?utf-8?B?OFlwbVNLU090Qkh3eWtaSTUzbnRJSU9ONEJVR1NDS0MyKzlxU2ZtQkEvMVZl?=
 =?utf-8?B?a1BESGlIaWxDMUgrQ2gxaXBESDNRQWdDSGpDUk5KSkxIa2RwYm9mWEx5bWpw?=
 =?utf-8?B?TXB3TGlqb1JpOGFhbm9EdUR6dU1hRTNvRkF3L2FMNDlNajlTZEJUdjFablZw?=
 =?utf-8?B?OEswbnhSYTdrUXE5aENqMDI3WFdvd0hTOC9hdTlNVGtnSmQ5M2srZW9CRnVi?=
 =?utf-8?B?ZlpleDhDbXgyamJKTzdDU2l0OUsxSVRVbVIxY0k2UUVMdFB4Mml0RHp5akcr?=
 =?utf-8?B?bmlXU1VlNGhFNXJieHpucGN3dGRXVHV0S2gxUW8vK2ZBVlk4VmFacGdGLzcy?=
 =?utf-8?B?MFJzQTE2dUczMnhsT0gwK2FIUmREOUpTTDBJRG9ORDRZSWE0Z3UwYTMwZ2pM?=
 =?utf-8?B?RUtUMnByUktaZmVKNDFpNklRTEtsR0RESlJiZkVzQ2tEdnpUT3p2MVNyRVVk?=
 =?utf-8?B?SmVYbU4ycDlzTHpIa3VyRk5wOUZLMm1mU3B4ZFZpL1FJbGpEVlpjMnhISHRt?=
 =?utf-8?B?S2lLRDJUY2NsT1loVktscjF3bm1mWG5QbXVweWtaUmFwZEVITzljVUgzQTdt?=
 =?utf-8?B?WDY0M1ltYlh4bzBjUDdVL0NqRzEyelRjbXNGR293ZStzR05XdFBiTVVRN1Nk?=
 =?utf-8?B?bWFhRWpaQTdpMWU0cXdQamJjUm91ZkZ5cnRlU0VYTUFXcWdXS2JJaERnNDhT?=
 =?utf-8?B?RnFaYWZ1VEdnZUdJa2FOeWNFUkx0WWJlQjkzcVNCZVFLUHdlcWdtd2tEUHN3?=
 =?utf-8?B?a2pQUFlxMW9mczFjdDR4TWxMQ2hIdERhckZwazhuVEpISDlISjd1YUJLWGEz?=
 =?utf-8?B?cDVkNmFTNlBNYjNwQXcyZVRMYXl0Y0ZqQjRPdHhyUUF5Q09hS2pLakdnRlRD?=
 =?utf-8?B?Mjg3QlZ1NE1WQTFFT3dQaUVoYlVIYVE1anl3YW15MnhYWWN2eUhSTWZvS0g4?=
 =?utf-8?B?ekx5U2poS0hucnJiV2doQWRFZGptMXJVY2l3MnBBdEdraGc9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975440d9-0616-430f-701c-08de9e0c6af6
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2026 12:08:50.7674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4PR01MB5577

mpi3mr_update_links() dereferences mr_sas_node->phy[phy_number] and
writes attached_handle without verifying that phy_number is within the
parent node's allocated phy array. Two callers feed phy_number from
firmware-supplied fields: mpi3mr_sastopochg_evt_bh() passes
(event_data->start_phy_num + i) from the SAS topology change event,
and mpi3mr_report_tgtdev_to_sas_transport() passes
tgtdev->dev_spec.sas_sata_inf.phy_id from firmware device information.

Since num_phys is a u8, a stray phy_number can reach 255 and index
past the kzalloc_objs()-sized phy[] array, leading to an out-of-bounds.

The sibling mpt3sas driver guards at the topology-change caller by
discarding entries whose phy_number exceeds max_phys. Apply the
equivalent check inside mpi3mr_update_links().

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..dd9d530de6f9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1090,6 +1090,11 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 		return;
 	}
 
+	if (phy_number >= mr_sas_node->num_phys) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		return;
+	}
+
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);

---
base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
change-id: 20260419-fixes-dc5748010b4f

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

