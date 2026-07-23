Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738FD38E5C8;
	Thu, 23 Jul 2026 10:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802822; cv=fail; b=PNeGRE6SvlVun+Gbvm+z9a0ryHtHCN8amZjMunoJVZKBhL7CvMVs2GwFPkJa5nT6xepF796mfOHJh7+cLAL9DWVjFyl9Pqcc6v4cabNx3tGLbAQa6ftu4Q1mSJ3g/0eFrUtnOIi3Q6X2nNxmdg3KBSJaJ1ErHUiOj/aR6G3WN+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802822; c=relaxed/simple;
	bh=ajeVZKOcyo0t6BYI839kyQGNYXDXvove6ewOMUqbUfQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SfBr0/dB0MiEs6KHX9Mp0VZqm1yng17cMaH7+kOFKIgeBeRbovWL6/XdRr7VP7C2J96WPoZo3QK5E9e4g2vJEEG9agr+EH6R1T3e2MBuAq0GpEQMB32gz+i6ow9WgC+DD+tZMYHJcu0hVfTzeD5yEtGZK3IymaqpJ2wwlKNEh34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e+QJl1GK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KGG2MWuQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e+QJl1GK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KGG2MWuQ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MJti3c3573969;
	Thu, 23 Jul 2026 10:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dHUKbgla7nzLrO6O6E0f7KaEeL01rbWsBdS3l5Lf+2k=; b=
	e+QJl1GKdqq8RwKyeJ0OFSb8OtMhpc9v9SissXEatBTEHXKFCUVN+xdCqY9/7Nk5
	apzha+0oB1b09/7+eQox9d3bCKUF0IvEkdHpzgKa8Ugc5Q3v03ugZihJvJVh7HFJ
	01XW5biLaVpD5K/g+ld3Z79jDRaPoJoN/u6Y2LmEHVwEbesQgmMiALJuDSTqt1+8
	wA3eKqz9KDN7UUGbwMipbUfHXd8LxSBYetudC2JPC1DjIRhEPZrxxUA1y2feUmMp
	uR//A4H4AEysXdGbvpdJcjAsCfIU0Mz+0y1hvO/7nZdg3ZR082Db+zEq9fmU7ToU
	+iHiIEMtMr06b9DkQqiA4g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1sqps8q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 10:33:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NASbC7002856;
	Thu, 23 Jul 2026 10:33:38 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010067.outbound.protection.outlook.com [52.101.46.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs7bey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 10:33:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wCW9bcAJ0Ko0meiQFkt0hAJ9fKd0AexgjJwAXvzyqDN2IcCLeeKnzjF6aBTJY28ek0ii1sapqk/IQk1c4EMcc37w1loDCtZsdKnWL2atXEEb5Sb+Arl+1hli6Nq4bGOLGc8yj7hLb2PGebcqE8eSJIa4uKj+zmpw6PGUKgqfGiieF3FHOou7uYFDbiNw0mR5/J9xzYyLOk7pLgqUplrpYHPvPQstZWXe7Cf96dGMnsJc5VUCitza8ZYfTeh0tXSt0H8r+jlFPtI70Wz3dF19RZriV07OmlkK2gUG8Ebd+Pwdv8w6zPL5hNJPxRyHh8J5KuOBmsB62YeSz9h6eK0sMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHUKbgla7nzLrO6O6E0f7KaEeL01rbWsBdS3l5Lf+2k=;
 b=JMrucqOcCzD5uR8xY5/+SiR1Ue88Jxeq6qLHubG5cFx2gA6lTwuvG0Qn8FKG31d8kqddzzzFuH/Sv1P+rrlHEyaa0K3ZdDYYMk4f/5HNRoPqn9MUF9lpaMJ8CyGzF3jdWxM4N6HGKHqW1fF/oP8GWteNcI5ZxsgG9YBJQMmvcKAZD035KF+ai5/79mrw8tVNHpt7qNf6t2tnlpv0bmnDlTIfUihy/g+0mZadDQ6gLveLGQf7rcGE3n2C74H3M+T5LlczS35+UUMbk6iRBVjURPC6QbCA2kEKEC7qYFhJmePVGl7byVSbu5flDY4fdQCDY1JIpFOPDxBpHeKRiBkZpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHUKbgla7nzLrO6O6E0f7KaEeL01rbWsBdS3l5Lf+2k=;
 b=KGG2MWuQglhn5HCEwVBLSidtCncBSp2PST0/w9j/kO7DgcDSBuZY9MmDpXKCfvN1GGBHCHaqvixt+37hHF1g3PmIiKfAy9Gd8mBfc2oaew3IImd3Kt7Q/Mpmkipv5V1I2z/gJI9Fm8aPcZHMsf2affJwxasdBaeeATLxTYjw+04=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH0PR10MB5593.namprd10.prod.outlook.com (2603:10b6:510:f5::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 10:33:34 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 10:33:34 +0000
Message-ID: <9b82ec15-0a9a-41f0-b58d-b5c8dac4efd3@oracle.com>
Date: Thu, 23 Jul 2026 11:33:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/28] libmultipath: Add delayed removal support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-7-john.g.garry@oracle.com>
 <20260723095713.5BD361F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723095713.5BD361F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0039.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f3::18) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH0PR10MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f08dce-72b3-4a05-ef24-08dee8a5d8ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|10067099003|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ezECDHubpK2fg+dAf7fFpH14yQyOCUfCnqV2rx73bkMAfB9buQ9lKccqA8+ikW3VoQwwfzIOAJ6chZpeyMYP4FTLbRa9wSvrH08J696INPemjAebWNpKS1AupSKRbTifYf6xhJU/HPQwxTZpbYbpDjRiv/1QVLRhvoVsNK986qQvGFsNuVje6qi84ciM+HgpM/FaRzvOuZJv2tnWOOc7Sv1Of3CQgms374Rin0fj6tPxGz/Pyy5VIiGWTwpAYNvh0bOrDdZYcTPqjNah2t6Ld9JBXXHTjTh14yjORgavsPiXjdG6R721lHXnhUD2oj6S+mkxJT5PUGH9+HeJFjQ/qhL8FLr0YhIi1IhQ/zRI2OTdoGR8XB1Eh4Op0472OXz1qVIrZaDlvgNDGUFT8gB0CcPPlJTxys+99fWaW9WGck5a+bGkAtWn59ELgyIRbpytHcM5UwRchCCnm8kwXbf002TQa4yAG7Yq9l813+0jygg/RB/70++FQMvnV0DD5N+v6c66TfXL4niv794BnOVK0dIwvhordlTrpXYlq8suB+UUzzxIuErsIZUCOUJDK2EPVjMZyQIKVJEjSkiFI/E40lLxvZhjSi9P++4Emh5nCxt1Ip+2PgQJUC6TVdFaO1Xy3xLNXk3TigvfrbezCiuDa6p4r63U8f6EK9q6CY+8IEg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(10067099003)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnZXa1AzY3p3bWpOcFdvSndNRWFoazZtL3AvTjgrZ25uWlE3S2JzdW9JNmxW?=
 =?utf-8?B?ZnFoZU5KWVUwU0FBQm8xTGpwVy9CMlUwaDV4ZGhpU0NjeGVrcXlnQm9qdjQ5?=
 =?utf-8?B?dGVtUHdFRll4UDRoaFdoK3p1aGFST0ViTVB0Skw2dTJtd0xqeEZ4dCtibS9z?=
 =?utf-8?B?UGRkTDBLY0JNWlcrLzlXUU1nTm1DKzlzSkN4RUlxQnRyNklvU04ycmV2TmFZ?=
 =?utf-8?B?aFNyNHliSndySVoyMVBxUVFZa2pvV0FjRG1abWpJVnJmK3J3VnZwMWtLYTRY?=
 =?utf-8?B?eXQrV2tnR3ZONThkZC9vMStMNkhzVnJJa29Fb3NIdlowN1preklQZmh3eEVv?=
 =?utf-8?B?TDEvSUVEYVlDOEZIZ0NuNjJyZHZEcmg1YU9HUDB1blU4NnZTU1JXZmlzTjVr?=
 =?utf-8?B?cGpEOEdoNkZwZ0J1Q0NIN0xHZGRrT2xGRUNNQXdBWklzWWczUTdvUHBjMUZW?=
 =?utf-8?B?SUtCbm9IV3Z5VmJPQTl1SWo2TzliQXlnY2V1SVJ1T2dJcnNtb3BtbzF2QmZW?=
 =?utf-8?B?R1lyRUZPUzI4NnBEWUtYODAzRkpGS245cm95dzB4MXM1RitPSFNjaUU4U29y?=
 =?utf-8?B?YzVSNGZuVVoxcWFDZTNZbzNhREJSTDFJdHJLZ2R2anlCSkVRZzNBQmR0QndQ?=
 =?utf-8?B?blNrQ3dLVG5LWEhLViszZFV4a3ZoNWJoSmMxNmxSWjVwTHYvdnFSbmhzQzZZ?=
 =?utf-8?B?YUhkYi8ySlpVK2hkeFErUGR4eGsxaEgzMzZ3RTFhSGdUYlkyQURRbHVURStP?=
 =?utf-8?B?d2lwQVhoaXcvQ0FBM3ZyTytnRy9UWmtqUFRwdDNXUDR5QWQrcjJQSktaSkVm?=
 =?utf-8?B?bGI3UVdFUEpwT2hBcU1rblNia0NoeG5WZW1CUnNTUHV4N3U5dU1TVFNRTnEz?=
 =?utf-8?B?OXlwK20rN1RMcDQwcXluU0NHazRqSWRhR0JyenpzZFE2c1VFZ2YzQXlwWjBt?=
 =?utf-8?B?T3dpTkJGRE1XRGVyOG1tV3lqRlN2ZUxFb1ZTc1l2dzlaMjNsSS9ocC9NZWlE?=
 =?utf-8?B?bXJ2ZjlFdU54NjFPQnZtNHhjN2c3SHJtNG1QSHBiTG9NM2tiVHdmQmxvaU8x?=
 =?utf-8?B?enZyeVNHeWIvTkpENmZjL1ZMajF2K3dpci8vdCtCSVZYYlZ4dmF4ZGZ3RG1O?=
 =?utf-8?B?WSs5Vi8zRHZYbGhwNm44QWVHQm1IeldubU90TG90ejNaZkRCUUF1UEhQL3gw?=
 =?utf-8?B?WUk2emRFcUlIdXlORk5sYnRMV2tXNVNpb1Z2cWhMZTVVU1YxektyNnBQaWEy?=
 =?utf-8?B?VDlQbXd4WXhsTDd3dkZOaEZNRy9BaEFRTFdhdTRJUHloR0FYSktqdlFuWTE5?=
 =?utf-8?B?OVQwdS8yNTZDcTNuSkZvK0NGTU4vQzFGa25XYTUxM3Z5OWNjaEdMTTQwUHdB?=
 =?utf-8?B?S1FOOGk4Rk1GZTVXNVNnQ2lhTU0wOVBuY2Qrd1VLL0NlM1ZLQmU0eTFMY1kv?=
 =?utf-8?B?RzlhejExMWVKd3lvL1I3SWViMkVabnpOQ2ZYVjNLdGRvQ1o0bTc0RGNFajdZ?=
 =?utf-8?B?czZoWm5TZ3k4aEticS95VXJ4S3lmalQ5REhLK2g5V09qb1plbWowSE5GSXpQ?=
 =?utf-8?B?TXIvcWxNbXYzbDlROW13OUNQUTRRN0syd1dqNUpRZ1Q3TWJNSW50cGJkS0FZ?=
 =?utf-8?B?NWZWbG02MmRvemlaOTFhQlBBWHVxK0tVOThxOTRnTlltRVc1MjBuWWx2ZXN2?=
 =?utf-8?B?dE5OZFJDSjU2dXhqWmtPSlRidm9pSWhEcGluenQxMGc1SE94MFF5RXhBTGlk?=
 =?utf-8?B?VXU5Y256eTFrb3I5WkFjMEdCTXc3eSttak5XZXpLbmY5Y3RkRnpCSW1mSWVQ?=
 =?utf-8?B?Uk42ZUJxeHFZT1duMWhWNjAzSjJ0U3hDTFgxQUZwaG9FWHFzNDB1TEFGajhi?=
 =?utf-8?B?ZDJvQkxLcy93VlhBNFF6RGdBRm9FZHFaU1NxOHRmSVhxQmg3aktvOTV2R2N5?=
 =?utf-8?B?RXBkL2licjZLUyswVXFIQTdaU1VmSGczekJaK1poc3dvZDdRREZYRjE5UDRD?=
 =?utf-8?B?dVU0QjN5ZWVpNnJVTFFXZ1VsK0phd09QZDdPRDlEdXRMd0o0bytBVWlSSkFj?=
 =?utf-8?B?RHB3aUZoWEl3LzBLSkhZWHhHb0J4bDkyMkg5UEd0OTZjdTZONmtGV2FwenVX?=
 =?utf-8?B?OTR3TitTVkVuZTdJTDNPUUVmeDJ3ZVdOMlVmendBOGdielQzVGtWMnIrdmdI?=
 =?utf-8?B?SWpoemNmNWZmMkZEN0x2YkgwQXRQUUNSdU5nUWdvejNwWkJ4T2xjaUdEOUYw?=
 =?utf-8?B?cjl4TzlHbHdZY3dxRVhFYzhlVHFLVnNYc3NOVU1hYVdhakp4WnA5dVV0U0ll?=
 =?utf-8?B?ZndKaFJPNTdETTU2aFNqaXV5OHk5OTJma3hGOC96dE8xb2lMN25vUFJmeWsw?=
 =?utf-8?Q?8GMxyu7WZ0bhCqhI=3D?=
X-Exchange-RoutingPolicyChecked:
	QV8hzKy9TDSH0pSK0mTO4xjsaXvHBuaAW+qyCjcX/X4l65YEqwf7LwI5D5E7I6061j48sf6PfEFZ8936e0eAMdJgaY4a33XqaaTfsyzOCKOy0bygk3IDDgPmYYuw0WV7SngeSCglwN1U1vjHUAFjCDFQ0S2hsjC4ekgPWmbFaXNF146+YYBeXAe9nozuFHAHnu2ObFfiRtfDS07MdNzYIsyna0byJEcv7Sikq8sBvMCZ0ByBIYKH/E+HV6Z7dt/UJyqSwhUiukuxaKEDL+Uxlz4YUMs0fMeyip5GKRqcTmW2EDs3c5jgnuLrARyrb7RFAvbY6XG0VZyAaY/aUWSe5Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	thu3qSAoEn4p0bT6jnK0M3sT4I6YpJukOnwP/YmVozKJ7i3hdao3eHChr5wBkJkor/3o+MFdsUnfCtkj4mwVKKZ/YvXBfmpNZOzFg272QK066QqdNDvJuKLTbzIOrf8llnfRYEkdEC9f5bxN5knOIVPONw9M5QyagRyKMVLldVppr+a6ghjZ0uPiiPyIAfGy5bIZLB+ecvsUiTCBl5n+A0fw17Vl0HmLDi4uHSZV+4r/TY4t3hNZW390DaKiiNLpdBOd5I2GgzdQ0oBxMghZokmBSSf0xj0pgjzrvJlHhVn95koNgro9GhVoms7Dfqccg2PQ1gE4nWZ7lglDULMLry3wC4EKTwFXEJmWLnopmL/gjMLcDXxSI4b9kOXK8DESecBKocMzR2LW6MvaNsy3KPPaRB0RDarBDjbthzMi7XtAvgQMYR5eoothHRjBD8UvH2dG+vfxVM1zspa26dkNYuoX3OGEi6PxCk9qgTXKp9tm8UNaJ1nQNYANMUkptZWJ6UBG781w8D0j1Fi+d4iXwXH8cjvYRdK15a6kd/aufK20O8pZsx20MggMNJjiWxA1UKKj96EkQfFmRFgmZviLS3BxLgZ5KadvGyEoUZ6+aYA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f08dce-72b3-4a05-ef24-08dee8a5d8ca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 10:33:33.9956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nclfbEZ2RpYuYpdI9T/QnVnFY8z3WeOpTDfj2BdeV7Iuqd+vkxAFEgTcX8Qqb0WduAmbDYKnCInJA31tDj39zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230103
X-Proofpoint-ORIG-GUID: 4_xzhCai1Q3p9AeswE671mNXbNlYD0Ss
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfX9iRKSyVqQb/7
 URBIXwJfGc2ZDj5PT+b7mmeLTi8VKQcC7uTLh8rSRWXzGJXYCuMtdDZRnb47gWABPSoO/AtZzex
 pZuyXd3cpsxvfXevet+t3OZfpKAejKg9tYsUQLi4v4MwBM+YDWSkuQvcoCDAR/Ic1FqM03A3pia
 wZ9UCC2MlvAW56MhwD4q4vLvjlqYTOesfMS6v/Qo1/+uleD1UUPBiXdsPepK0UNktuA8OFrnpvk
 qQDpvphBaPCWvzqw52wnZZwZ01CJRu3ihbRlvdhpWI1RS75TTGDXwXtW1mNSEsa1RYEtnL9rcbc
 DaX0Yxa8IgPJynxAOdfUKD+2eTA67HgGOEIUH/yagz0Q5RPxw2T8owLZ8GqlzpXK1xlJejQWcCU
 uxiUEW4e3pwg+s3Cktjj49JQ5BCk7Ixa6XCWiHRutRowQCYZzVoX7ZvSqfElGApYe4qjFNOJ1Zo
 Pbpy/j7a0E9/FR5NW3yKBkSwkorXElRhlBq8YuZc=
X-Authority-Analysis: v=2.4 cv=auyCzyZV c=1 sm=1 tr=0 ts=6a61ee03 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=vwsY0OK_0TO7XXznzaAA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-GUID: 4_xzhCai1Q3p9AeswE671mNXbNlYD0Ss
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwNCBTYWx0ZWRfXy5zIiUSwSNu7
 k2CvvHiGGCBHI/7+9s69AYlbOUylIIjleYrQzBl3T2AwIbv8/IcAcIFDXRgzLh6UuNh8ABWXaRg
 8ci3qWoY+dsISp37ZEJqdN8gjCBtM5LecCIGkYAConHyu+aydPnN

On 23/07/2026 10:57, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Concurrent path addition and delayed removal execution causes a use-after-free by destroying an active multipath head.
> - [High] Missing synchronous cancellation of `remove_work` during `mpath_head` teardown leaks the delayed work.
> - [Medium] Module reference count leak in `mpath_can_remove_head()` when called multiple times.
> - [Medium] Passing a signed `int *` to `kstrtouint()` causes sign-extension and massively inflated timeouts.
> --
> 
> --- Patch [6]: [PATCH v4 06/28] libmultipath: Add delayed removal support ---
> commit e89d624119c3a1b6148c925347d05a0886a18e1d
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add delayed removal support
> 
> Add support for delayed removal, same as exists for NVMe. The purpose
> of this feature is to keep the multipath disk and cdev present for
> intermittent periods of no available path. A removal work callback is
> supplied by the driver.
> 
>> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
>> index 6915c2a979642..44e26c16b3dc4 100644
>> --- a/include/linux/multipath.h
>> +++ b/include/linux/multipath.h
> 
> [ ... ]
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 20c633ad7e1df..1fa4bd6677051 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -65,6 +65,9 @@ int mpath_add_device(struct mpath_device *mpath_device,
>>   	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>>   	mutex_unlock(&mpath_head->lock);
>>   
>> +	if (cancel_delayed_work(&mpath_head->remove_work))
>> +		module_put(mpath_head->drv_module);
>> +
> 
> [Severity: High]
> Could this lead to a use-after-free if the delayed work is already executing?
> 
> When mpath_add_device() calls cancel_delayed_work():
> 
> lib/multipath.c:mpath_add_device() {
>      ...
>      if (cancel_delayed_work(&mpath_head->remove_work))
>          module_put(mpath_head->drv_module);
>      return 0;
> }
> 
> If the timer has already expired and mpath_remove_head_work() is actively
> running, cancel_delayed_work() returns false and this function proceeds to
> add the device and return success.
> 
> Concurrently, mpath_remove_head_work() executes mpdt->remove_head(mpath_head)
> without taking mpath_head->lock, which destroys the multipath head while we
> are adding a new path to it.

That won't happen since mpdt->remove_head callback will ensure that the 
device list is empty

> 
>>   	return 0;
>>   }
> 
> [ ... ]
> 
>> @@ -480,6 +493,39 @@ static void mpath_requeue_work(struct work_struct *work)
>>   	}
>>   }
>>   
>> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
>> +{
>> +	bool remove = false;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	/*
>> +	 * Ensure that no one could remove this module while the head
>> +	 * remove work is pending.
>> +	 */
>> +	if (mpath_head_queue_if_no_path(mpath_head) &&
>> +		try_module_get(mpath_head->drv_module)) {
>> +
>> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
>> +				mpath_head->delayed_removal_secs * HZ);
> 
> [Severity: Medium]
> Is there a module reference leak if this is called multiple times while the
> timer is already pending?
> 
> If mpath_can_remove_head() is called multiple times in succession,

that's not possible since the caller must ensure that this is only 
called once, see sd_mpath_remove()

> try_module_get() acquires a new reference each time. However, if the work
> is already queued, mod_delayed_work() returns true but does not queue a
> duplicate work item.
> 
> When the timer expires, mpath_remove_head_work() executes only once and calls
> module_put() only once, leaking the additional references acquired during
> the subsequent calls.
> 
>> +	} else {
>> +		remove = true;
>> +	}
> 
> [ ... ]
> 
>> @@ -524,6 +570,9 @@ int mpath_alloc_head_disk(struct mpath_head *mpath_head,
>>   	mpath_head->disk->private_data = mpath_head;
>>   	mpath_head->disk->fops = &mpath_ops;
>>   
>> +	INIT_DELAYED_WORK(&mpath_head->remove_work, mpath_remove_head_work);
>> +	mpath_head->delayed_removal_secs = 0;
>> +
> 
> [Severity: High]
> Should there be a matching cancellation of remove_work during the teardown
> path?
> 
> The delayed work is initialized here, but mpath_put_disk() only flushes
> requeue_work and partition_scan_work before putting the disk. If the
> multipath device is torn down while the delayed removal timeout is still
> pending, does this leak the active timer and result in a use-after-free
> when mpath_remove_head_work() eventually executes on the freed memory?

This can't happen

> 
>>   	set_bit(GD_SUPPRESS_PART_SCAN, &mpath_head->disk->state);
>>   
>>   	return 0;
> 
> [ ... ]
> 
>> @@ -567,6 +616,47 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
>>   }
>>   EXPORT_SYMBOL_GPL(mpath_device_set_live);
> 
> [ ... ]
> 
>> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
>> +			const char *buf, size_t count)
>> +{
>> +	ssize_t ret;
>> +	int sec;
>> +
>> +	ret = kstrtouint(buf, 0, &sec);
> 
> [Severity: Medium]
> Does passing a signed integer to kstrtouint() cause sign-extension issues
> for large values?
> 
> The variable sec is declared as a signed int, but kstrtouint() expects an
> unsigned int pointer. If a user writes a value greater than or equal to
> 2147483648, kstrtouint() will parse it correctly, but it will be stored as
> a negative value in the signed int.
> 
> When sec is later assigned to mpath_head->delayed_removal_secs (which is
> an unsigned long), it will undergo sign extension on 64-bit platforms,
> resulting in a massive positive timeout value.

will fix

> 
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	mpath_head->delayed_removal_secs = sec;
> 
> [ ... ]
> 

