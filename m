Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0A62F6920;
	Wed, 17 Jun 2026 18:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781721566; cv=fail; b=P2zkphlMsAUmb25O6zPzO3eHu1BF1tmNw2B4A9pU49CvUw2lME9oZfFVu37yMqfdDEa7xofBIhVCXyr0zVlqhSdfvHm5gvLLIt9TUswnLYmj8Ca1lKSjq/0p3/f24nHAD622zZGf9A6VzlbWXmS3Fm7nzKZQ9MO++M87eVUTY9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781721566; c=relaxed/simple;
	bh=U0efma6nP/DBYvX2IRjCMjF5J5phGaxeAQmvt3lODSc=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sPV1Y0tek/peYjVb3R4u45t9MpPAY6Oa9kg3RrM+wIljDZsRrxLlPI4kjuLTzkO2dKLGJxJV/lelRlIY1oA9XIi4xXFDlgq4QjNaHBICWN4bbfbUuQFez7TeRuYvSP4Z9yI32VcL0MSfZs6jNZidXFiZKOxayhRqFAHIfdYj3TI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AVcl23gO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mlBjD8eJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AVcl23gO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mlBjD8eJ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEsRCW2367894;
	Wed, 17 Jun 2026 18:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Bs9tHnGCHTVs3Jrk/XoZOIRNIVwp0s/HTVnmLYfFCWs=; b=
	AVcl23gOV7T9FE/E1IoXT4gcAdaDDbZzDDCbrOEcWzDTf5VtmovMuP9aryUSQzmV
	YEgtSoVWG1uAeE3CjDzH2NeN2FIxzUYHlycRuQVl8IxcCILIx/L+b5OaoA2XXpZw
	x4cIr7OcETnDZZ2zRSf4UpPrW6QZt5ed4ecS9rUpdvA0m6FBDZrwJGtB3akAz+tH
	/lW4sDbo8C9FMMXHXHBs+/txnFxvujzw5QsKF/3h5PBtNfOvc/XQwveIz9Tj6n75
	HAYo6hx12vx3b4WVx8RKmMHBUrpKV1aoML6o5iJ/YOW4123YN7MuKHr7UvJ0zAfn
	vXB7u5qSV/NuH8Xp2UxUSA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg31feg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 18:39:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HIX8XH024193;
	Wed, 17 Jun 2026 18:39:17 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012014.outbound.protection.outlook.com [40.93.195.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4euduxttne-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 18:39:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S6KP7OFCMeBjQ1OpBWscLDbvBH26bXuelG4DTfaTHQh/245j70ri6zHLA31NB3Sb4WjW78kp0YcSknoO0RWZSjcEwDdDN5Lh1/DNhfqEEMosQAy34AG5DogWlRtP1BYWYRHqZiOrWOQfOTa/ZAlTVExDGZKVI6IfsEasUmZdb0wfqZp7s5B0pUf/Vj2UKj3X1eJ8IQ0hwcvfateetqCJkBf6WrHfdyeisZl4DKnkzyPkCkvRGCXcr2cjTVRMo+RVDMqBuRVlnrE8E9c/nlotRxk0DpfMdStswqO70Vm59QtZ23kyPiMCFT594Vh81p+EmcylcTXnJBDfK4/2DlqBIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs9tHnGCHTVs3Jrk/XoZOIRNIVwp0s/HTVnmLYfFCWs=;
 b=kqVs5hqz1YBKMya/E6rXovYvzCoCAk2LijV3J4N5744VNYOPHTBGjtZGJuaiRvZxyO1I2rjO5n97Bz9Z46WTV3KZW7N+7HQr+ySozc05cj8EwEvDUBDv52b6GRGOJNh7rxgfOcRhSzPlIc/S4HuNPhwTH6JISSICD4B8xImZVDZXGQIq424LKDa/+5rnBOo5dhWf2U0wUl4xJkJRapU4K5eRQWBjKfu3iDdgLabAcHIZYi544t6U0DPTuVVQuNWrHWVLIbEXaBcqAt9pvy85dxoSgLYZlPnbnG+6/JBU9ENISy+8jA/wziCkfmCQo+W22sTWKJe2MIMIidFPNP5BkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bs9tHnGCHTVs3Jrk/XoZOIRNIVwp0s/HTVnmLYfFCWs=;
 b=mlBjD8eJEXPpXioD1KhquvSvP6VgiPHYAAfv8WALPh2DCII52KKLGZY5G05w9zFPeEkzpeEeECVEQ7Gp0m9cvVw+In+t/poQ115QgJA/leHDJxAcWganZG4IOIiS8IZ3rDA76UtlH4VG2ipkcMdZANMPgQsycdjAt5qA/HIWds8=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by SA1PR10MB7740.namprd10.prod.outlook.com
 (2603:10b6:806:3af::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 18:39:10 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5%4]) with mapi id 15.21.0139.009; Wed, 17 Jun 2026
 18:39:10 +0000
Message-ID: <cf86320f-b5e3-419c-9edd-178541e6cd46@oracle.com>
Date: Wed, 17 Jun 2026 13:39:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: iscsi: publish endpoints after transport setup
To: Ruoyu Wang <ruoyuw560@gmail.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com
References: <20260617182135.957230-1-ruoyuw560@gmail.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260617182135.957230-1-ruoyuw560@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS1PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:8:452::19) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|SA1PR10MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: acdca875-4ee0-42a2-6bd5-08decc9fb8c9
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|18002099003|22082099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
 Viy++Nt3+aF8sCrFgbRnRJuFoM6f6gPskeZ+398yOT6ahYVFTQigk8cJru0ntsh34eTtN6l84Wb0bDH6QOovkpAlLdBzn8E7BwqbXsWmqIMESahkOmjusGrjsj+hO0Yon+FBsNqDjURhurd2CzU1uC7nfYJo1D2HVtMYSZi8o1VAI/92zSl2PapUKsqdV0DnWVkFK3E2OZ1Iy/SBFtGWLM2xWcSzZHfV34RinbfsLBWz+jDJ6z4jEheMxcHa3t0P76EaFchz+J6Cyb215on0JKG/zcO0it/sgJGBCyk/oKpq7aIUXtS9CRWTZPZcfcDUw6fykP/naamr5dzWmodwz9RrwLgxLgDyBdioJ2dA9datO7T9TWDnlSOBAtskAXJREd3J13DRyoIJFkgzFhjsWGnfcM06bQnp+6NJu+tOgKNd5IkKXwFM1g7rj91I9vofkAtwRHFQl5TOVFpNaz2ACLJ45/dv8do8dw6YZofYCGKBdoxns6WzQXZmoEoicf9AsHUcTP8hu/Syx7lNbdI4mvXT78VlOl5jo/buvstNc7Q2LBDaV2pl2FNVyHwIN/y1zvV8CCKbfARGIAgxezRK5od9Hx6LG/kUTr7HT9tJt4nEifSuQx8QEWSrkrBSTncbjUGqn+g6Uj/QydV76+t5+3cxYOeEob79Rev8yQOHKGAPBU0wN0v+i6+q8OKLmJwKanO/yeFY+q9iRIYg6kZUiY56FxmuTrPU6+mXu7lilQg=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WDV4VlU1UEllQk1LazFnQ3FrY0Y0ZENUOXZpNWRWa0REOXJDR2h3V1NyT1gw?=
 =?utf-8?B?aEd4OUNucVU2ZzFvbVZCVHNjTnI5Y0NaUEp6eVFPbjh6bTFOQk9VREJQWTFm?=
 =?utf-8?B?ajhVVWxTdzZLRytXK2FTZ2JvSkRLbXh0c1ArMkZLRUkwY2I3L21vN2ZiWjRs?=
 =?utf-8?B?YjluUEFVejJJckhURWtuUnB3T0dIdFhJbUVDaDdwUEc3UDJ0akliQ25CTHhx?=
 =?utf-8?B?NDkwWFIzYWx1REJYZ0JiZ3FLNDFVZWFKNWhKUkZKVFRFdmNNRU9YeE8vUFN0?=
 =?utf-8?B?cWpVTUhWVUQvUlJxenR2MHpjY3k3N2JsU1E4S1FtZUJWVi9vVjJRZ1ZTK0tW?=
 =?utf-8?B?dUNUdkJVOHNMaXJJa1YwS2d2QWdvMWszWVVOZjZadHpOd0NIdWFNQmdDU1hF?=
 =?utf-8?B?TG1RNEdSdkZIaWRDVjRialZBazFVN2Z2Zm42SXhRUnBqQ1lPUHRZdC9GT1VQ?=
 =?utf-8?B?N1ZlNmtTQm9SVExkd01QNXEyOVp0eTB5cll5WVM2aTJDUDNzeDB4N1FRa1ZB?=
 =?utf-8?B?RTVOaG5MQlhpcEh1cklETzVkM2dMeVVXT3dOUEdhZ25HVUpBRjFwMWFyRXlq?=
 =?utf-8?B?VkdlS2VwU0VuSkRTbXBlQkUxT1NmU3g5MkdBYUU1SWp5T1o0Kzczc3pHM0pT?=
 =?utf-8?B?QTNvS1ZZakw5c2lTekhoZmtqOWFoWFBhd2Y2OGJVbVIyL1B6WllULzNTeUx1?=
 =?utf-8?B?RlYyWTdLWHFrUmd2VlBjS3p6azRUQVhGRHBXcG51NFdHWnRhNzdRYmFCNzdS?=
 =?utf-8?B?SE9DSm5MR0FxZWNOYnNhVVBtUmQ3THhBd3FWSGxlb2NmNWcxeGYvMFg3anZ1?=
 =?utf-8?B?anFQYk16elk1SGppcmEreStzOXlHZlcxWnJYbEJuaUtmQmRvdUNkbjdWUllt?=
 =?utf-8?B?R0NEaUFoWmxrYWJ4c0EvNjV6UDViY1BHc1czYnduV2lEK3hPZnZEcG5JN05R?=
 =?utf-8?B?QTAyZy9nTTVwVkxNVmpoektDMGdpeXpQb1liR1MrTlVWN0tNSUxPdlhkZ2xK?=
 =?utf-8?B?TnlORnZxcksrYnZCbC9MVkVpRmRvQTBvRitNVzI0N2NsenNYcmlpenpUUjlY?=
 =?utf-8?B?ZkdIcXN6enc5eFZWUkl4Y1F1ZXViNnlINzRtbTI5VXYwUWZ0S0VDME91Y0l5?=
 =?utf-8?B?YkwzOWo4clVhSkpnTGgyR1RtTFlENzZtMkErZEFiVjZSYXVGMUMyeHNUZmMw?=
 =?utf-8?B?R1JWRkJDL25xQkhYb0JBZFpiL2hjcWRnSFlRVjV0Qml4R0dyOFgrd3NpQnVu?=
 =?utf-8?B?b3JqY3N0SGs4NGdsTXdMU1pheW50RWFFU3VuL3NEbVRCM05jWHZVQmdNWWdL?=
 =?utf-8?B?cjNybklpWXhmZ0xVWVJiSzVQeng5R0szREFQdThWMDFLY2V2ZERTMkFMWnhy?=
 =?utf-8?B?R3hhZlNsTUpPenE3RkNzZi9mSkpTRWo5UGdnekNYWjdoSmJ4T3paNFF4VjQ3?=
 =?utf-8?B?YXozekF2ZExKdUpVa0paQzRXL1RQd25aMHJ5TCs2eVJtVW9aTnk4K044aWpI?=
 =?utf-8?B?V0MrZ2Y2YlduNVQyZkdHdEZBaEM5cHJWallKbWtXVGJpQTNQa3FTa2tzTUJu?=
 =?utf-8?B?eTQyWUg3bEk1UGNsa2l5aUdIM0R5em1BYXRJR1JNeEJISEVZYWxUcnliNDV1?=
 =?utf-8?B?MTRDVXhHV1BtRm9vQmVEZkVMd3hCOEE1S0dSQXhTK1VzS0JCK3hZbXBlZERG?=
 =?utf-8?B?aUNlbVFzN2xoMnNheWpsZUhndStEbUFSRG83cFVWbjg2QUJldXArSlhJMWJz?=
 =?utf-8?B?djFjMjZJYTF0RnJ3SkN4OFZoU1Jqcjd1aDBiMlJsYkNMZTNiWTRORUx6MTNU?=
 =?utf-8?B?RDVNRUw0ZE1xQlBWM3BUTVozUVJ6QUJVS2ZtQ1JudUlrNGZsTEZ0c0xRbnk5?=
 =?utf-8?B?N2RsemJ3WGlwRVZSWmRCL0llZEY2WE1QRXdRSFFENUtsckpScVE1RkRPVzJG?=
 =?utf-8?B?Rk5oeC8wM25ZK1FIYmgvSTl1a05hcFhQbTc5MWNKc3dJTmJBUlErNEVocnNV?=
 =?utf-8?B?dW5HaHcvdXh5NGtsNUR6RDVNNksrdjZIamFXWHMvLytJM2ZkQXIrSG90QUV3?=
 =?utf-8?B?RkVBRTFSUEpSMUpBb1h4WnJ5MXZmV2FsUFlLVTZsbWVJN2ZIbDlsYlk0N3FL?=
 =?utf-8?B?Q3Vuakdqa3dZRDdEVE5odkdWYTh2a0hsRGtKdnQ4ajJkSE42RERiS05Wb2d4?=
 =?utf-8?B?a0VUWU5jT1Y4MEtFSjQ4T2J3WUtCZU5HM1dNWGw5QWx2MGlvZ09HQ2FHRXFH?=
 =?utf-8?B?dE1UZUFHcWFEMlhrYXl1MUlsSzVCQXRyL3E0NEJFYTltOW5WOEoyL251MXA1?=
 =?utf-8?B?am10dU1lNGRkbEwvVDdWYlc3bjZ6RU5penY3YWs0dG5NZXNvVXM5MzZPdDB6?=
 =?utf-8?Q?lT5l0qCPp06s+yN8=3D?=
X-Exchange-RoutingPolicyChecked:
	KHjozMEcq/EdNysKeXwiPDPmWuMFQSj8Uf9eGvSZUns+kaQaja93iDMbcQD716+sNU7mEZR0HUbZ2guD+bTPF6wSSEnygvV4mWcBMSfC8Di/Z6kow/zgqCavhJ9FWkQjA5gyNFTitAYSECwbDF8Hg8277kQveJEMPA2VRUW60o9mc324xQdevKtdsz7uut1cQtumy2L66DYt+dNCgmDXV7AWpQ2JNxlIdXeao1j0ahgoyiUEy/yyOpGTRA/R5GMVSQdHuO0+XoxYjfohrO+fbpT6YXgcVqKVfNYZuF12rwASEUv4GVkkj/u6SAujohIya7LwhpQy676sE/wRivrsGQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nWhn6SSXVHZc1+EJDfoo8E8I/LCumnyIUSbXyINH7MWeKEPdW2+LTasMU/soN+pExkbBE7OvQeIqtva0FZoJ8LBMvcLFPtZ4zIbwgHO9n3c0+HN8uK5H24hggmdEOLb30NTn0MvlJjUhJ4Clu7idMI6Bte1sFjk6nnp3hgqIcv+HfRvTWXwNvmOBzveKp4vdo4EH1+hIrimOoVHEoiAwugoQ37o39IxVkMrzoC0/0YCY1KrGQ4WSEVmAQ76IqoIsqP6+09alqjFXPW6F5VFAc2RG24hfK+1LdLQAob1eVznn/H514TCdVhEYg1NkrjBpWEHyov6lClIsNKAttN1cpdpCbe35JSb43ZBUM7uoah7vyVQbft2E0v4kBuyEWXx6SllkA2V0saU+2vYtSwDJiCFB3UulkJXnGbun9/s13MLzTw0b+FKCN+CWJEyoLvf2lA8Kcbz1GtUUmISMxW/lj7voPDKs7y9ohP+ZHF0qR8dg8XPiZe48Jqfc4L1++GlQkvR7WpRDu2bVhd0P5Rohk1NwAtUFxYcM6CxceMDLdjPkXYmFW5O9Ofq22FqIPHZZPNyE/REUB42QeDTUeTfq2fApq40NzDbVEFS0dxMz2KU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acdca875-4ee0-42a2-6bd5-08decc9fb8c9
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 18:39:10.6628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1KOjTUHylHZj8ObExTpA15JIZVmpDWEg+ryK0VKycDoQSKkXs64jJJB7vG7OEvq0RtO34IGFU+RKzh+JpSVOQ24nQY4W7GEZirkc8sB16k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7740
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=717
 bulkscore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606150000 definitions=main-2606170179
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a32e9d6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=TT8x5gRgtn8zgjpU9gEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: HzJJR65u3Dgs7T4a9Flk9e7b_Zw_Cb9Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE4MCBTYWx0ZWRfXydlXHzwHg3+H
 t0orbqxRtB/fdKHSPm16EXf22sKpfgqUwvSYYWfV113t93kNrlREKaZpF1HW6bkBcP0hL4VMWM8
 vwdv9sJEMEcHtPIQY21mN1X1VrxVMAJfSY8ezKAJb7xP0RLHg7mTbTt56IseWH+mqcrZaJq/cey
 xjt+sF3plGDk5tbLCOWoUd9veGLyCg0I0OXkKq2tQmp4NOwDa6Ve77BG33J+Z6b3Uue2I3qo8cR
 oj4ObXwclFSmokC6+WDL16xwbhf8Yqx0J8lywoaPkJhtAErgXKFgsdNg8gDSsmPq44b0hYhi0jI
 B8W7X+Zla5U2AXuH+aoYaTe9EkOENiq4RrLFyiOnpwdWl87pQ29IdLqlEKgNWlUUJ2fwfDhGjJn
 dGVOXJYFKZUEHioeR+sFqOFnh2g51kPh/VU7dc0OaPlPQJxDvhO45iUrZOBPj6wF/ag9XnNmS1Z
 zJmM9waAPOyoeQH4FbA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE4MCBTYWx0ZWRfXxo10P245zIW2
 aQkvmZanu6nwaDJnrchsmQTafnyOZBx7+HFFI6HIpNTid7+h3N6J8jlUSO8BZH0EyonTAPFOl0o
 GRIiuWfeh+6Nrz8YlAQZiyP3gR6vP2mjAvnRY8urrOnK4e3ekS0f
X-Proofpoint-ORIG-GUID: HzJJR65u3Dgs7T4a9Flk9e7b_Zw_Cb9Y

On 6/17/26 1:21 PM, Ruoyu Wang wrote:
> iscsi_create_endpoint() inserts a new endpoint into iscsi_ep_idr before
> transport drivers have initialized their endpoint-private data. The

What is the bug you are fixing with this patch?

We should normally be doing iscsi_lookup_endpoint calls from interface
calls done under the rx_mutex. The ep creation is also done under the
mutex so we should never see a partially setup endpoint.

Is there an async error path where we do a lookup from?


> endpoint handle is returned only after ep_connect() completes, but handles
> are allocated from a predictable IDR and iscsi_lookup_endpoint() looks
> them up directly.
> 
> Reserve the endpoint ID with a NULL IDR entry, add
> iscsi_register_endpoint() for the publish step, and call it from the
> in-tree transport drivers after private endpoint setup has completed.
> Until registration, endpoint lookup keeps returning NULL for the reserved
> handle.
> 
