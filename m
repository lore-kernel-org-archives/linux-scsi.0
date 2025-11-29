Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60C521FF55;
	Sat, 29 Nov 2025 20:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764447655; cv=fail; b=iSwHCvSs0bin9HGtCB+2hdICuuJ45stEoZnKGisFUtEfvMKyTIsK9D0ZAGvCAGPhjZIjRGBXQhvgKptoikfzsw/VIngMONZ6fu3/dCBWbbIRzHUOC+7UpZ2RTwXVTxnzKLa0jWzUAAm3Tdff0b8+JATKOsu0n/+qbdD1RUIJ/DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764447655; c=relaxed/simple;
	bh=YZT1N9Am/xg9MxpRfKbc+l7nUx8Qj9+x4LNmljeWKFI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bDY8dUB0FpDUTJnEJuE+9rzpTAciush7WP4v4Mzu+zDeYuVUmf5m1giO1i77XgCSM8w9GI+2hr0WSm/3nwmnUqZY5LiMIBLHJ/1lMmQf1WaBXnJCbwFja9mIiHcHEgPrmOsmMFDds4ewHVLOSNB1JcJJlsLBKhpYaQCchdYG3ig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JFDsAo9O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Oo1Qfi3t; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JFDsAo9O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Oo1Qfi3t"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATDMFjJ1624002;
	Sat, 29 Nov 2025 20:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3lKE2yW1K3Id4pgac0
	1ren7UIGufJutmyh9Su/RfaLE=; b=JFDsAo9OJGaPNxln1ZJ4zOgbHMzP07Ij2I
	xKnNBpM4Km9B8szU8Erk6wKRZpH6BNNoPupaEQwA+90Qt0KlFEDjSePl2CmRcsgM
	Qjmw01/TT8+evGVzFbk51IzNGTzqMyAabUMMvVZ8QrvUyKAib49sqzzWExeCKUAa
	EWkFOhvj+MNVWYXD/NL5C1Pzz3X1tcVBAExPgWKGgiNSR7js636SpIo217X/nySj
	8IUYIhLUvPaObOoTesQ3Zdh/TqZmfQmxhsy3+fJr40mlIpr/pBULV/NpuQdNYTRU
	aHyxbJg2yMBNf0kcifpbE42Cultu/bI0pHSseiogC1BBrDKydnJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqscr8hm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:20:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATKK15I017702;
	Sat, 29 Nov 2025 20:20:38 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010045.outbound.protection.outlook.com [52.101.193.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9gqcr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 20:20:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d4Lj3dzlqREtcimAqR7yNTAMBYfO7T9cGtzZReakB5WQ01G0dhNZxE+457+T/w4fQoaxODLsZM4Uu5oOyKi2c1xmZsj0ObyidVFwzCEMKxaqJLAJOGbHeeXvLaedHOr0kpAlzQsL6w/Z2FWtKBLrT8ldWPsw9c0Upfbu4UwZPViO4Kjm3cjTEGQxrg/Nwitz+91G50SlssdKXmT8cmYcNuS2ZnbEvSN900OZKM/Km5U1yETbO/JHmn4W7tQdvDvekSzM9T84TWbY390bXccr8DUGXHZSgyq1/Xlj5DeRTQpfg9PPntO3naTnrgRKcdodUWoyQ6pcwdNeHJsU6Exv+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lKE2yW1K3Id4pgac01ren7UIGufJutmyh9Su/RfaLE=;
 b=QTSo21psHyjBLMiD0OoZxWL9l3gIl8cMShVcpi0XtdvDajUa7hp48EDFTEuUexTZbkKalnUzRhwSZULNAhSs3Yq5mUsPPoUoESuCNmJivE1KR0sp0kGCApY47tsWDAV2Lyx3q42US04t9UOyybC7E9n+M7kWnvmXZVaqWp/ZI9QwtyxDWGx2cLBg3Mn7Qp30BMKdto7ONfQ+mE+GwIWWI7j0AruA9oFWE9gymOxs6yqgewsUam3agDZfF2X2ZDX3ejovO1MAjt5K18UI8i/J/yVmYc8Zny3Qo11qVnhSpTdsaIgDQHnCH1obMnJfomdgFjKUt/aHmnjikfa88lDrUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lKE2yW1K3Id4pgac01ren7UIGufJutmyh9Su/RfaLE=;
 b=Oo1Qfi3ts0Gcp3EseTanbUgKPIK25+F2b/Ux+x1zWnGqf6PyAM74ctRISZJ0tNoUGSfVhGm5D7448LTLakSa5PNpEg2hRe4+2BnG7kHh5Wa019jH46HaBzjHjjSwfEkvOkkNFftZbQMgAEltzw63adpAWIpuzRFpXwGxzu+IDJs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CY5PR10MB6214.namprd10.prod.outlook.com (2603:10b6:930:31::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sat, 29 Nov
 2025 20:20:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 20:20:34 +0000
To: Miao Li <limiao870622@163.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miao Li
 <limiao@kylinos.cn>
Subject: Re: [PATCH] scsi: scsi_lib: Correct the description of the return
 value for scsi_device_quiesce()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251124075444.32699-1-limiao870622@163.com> (Miao Li's message
	of "Mon, 24 Nov 2025 15:54:44 +0800")
Organization: Oracle Corporation
Message-ID: <yq1wm38y4jg.fsf@ca-mkp.ca.oracle.com>
References: <20251124075444.32699-1-limiao870622@163.com>
Date: Sat, 29 Nov 2025 15:20:32 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0219.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::16) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CY5PR10MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d0bcc8-3020-4cc7-d136-08de2f84c074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xN1Cr/0cW82DDo0uEIVeqY1oNLFKxr4HNoVoY2UqrFpTFlRsLNijYiYncD42?=
 =?us-ascii?Q?6EZfopfhwdCm243zH7y1lvT1Hwhy8kg9M/Mx7ybY5zfXXjjed96AsW/HWYCy?=
 =?us-ascii?Q?SxsphVY6fsVyF5b4qqHRVZT0zGBhOVpHSnyDu/JPU7jDYl8MbpIw0z2JDVxq?=
 =?us-ascii?Q?fJ6CCIfhyUZekX4j8xSxxVNQPrcTZJcAqCyWMxYWXCc9U/gKbBKTy37MmqTy?=
 =?us-ascii?Q?KAKrfEN7jI50BOBJUBBcm2DH60K4i+9dHdeZuiEe/kqSjxSgycrXLUzcX28m?=
 =?us-ascii?Q?kx7gu3b1srtq/ZToZ3fqNKo0eD0RVPfKosutY4stWg+J0IoG577UsLY6dWiB?=
 =?us-ascii?Q?r6a5un60t266nHbqzt5a6mf93zaJsjwe2gdjvI5BhyJhsuVzKXYL9yxrdrJY?=
 =?us-ascii?Q?ssR0y8ESLekXe6gUhg2OWDDYsB5nZxtSCFgMVEI0PFrchEcLkRCIp5HVQpsB?=
 =?us-ascii?Q?w6ytSBlvCXSYhnsSBYEN24gV3xsbJ9x3uVL58TNgC/gflFNTlOqjH/1eiB16?=
 =?us-ascii?Q?o8nNk6LjZymtDso0nCBYXma4Ho64bT+wGJLhwn/t+yjdD8TL7LqKOocdNXFv?=
 =?us-ascii?Q?OOIApqjmEoW47dbKPyMBUGX05EKXbniH9LPJZBI9cSUfXbWpd+DYu2YaX0VM?=
 =?us-ascii?Q?TiElnYSAJ2XSkkKHpQWEhU2EuyVZe8Swp+b6OFdgbin0ruMSL8gKrJ9BX3Xh?=
 =?us-ascii?Q?pGGoyUI7nB2xbFrfQWGlk9Z2y3TZfJWkMDFcep3l7r6IzUdUBF/KdxKGfjVr?=
 =?us-ascii?Q?XGr143JBKFSPbafj/5TlJnU4k3NqRKEi2esk6x9kZj+O1yp/OqMhMILc8T4C?=
 =?us-ascii?Q?s/lIaQXCNUNYS1dx4g627hDFwz/LKFczRxq0NmXVX737rjnzXIJ1OubH67NX?=
 =?us-ascii?Q?qvd9mQTUyCRs8jnIG2LuxME4aBDWEG5EXuT4Qzrt331wY8GzWoDGcP6j7Nfn?=
 =?us-ascii?Q?kByHOpuItQRDVz3UwXDHkAWA3RuFTKcHLaJWfZ81HvqqA1iRG2eaJIq+jSHU?=
 =?us-ascii?Q?3NLX6lOxfB2O/Wg1yBvL8Vss182bsZN3RLuCJEGdQB4giwGChnHhakcv47NM?=
 =?us-ascii?Q?v1EBytZhyC2ALpUifoIq0MTXziATOiY/Z+CVCiiaWb65E7c9X5eAAz7m352y?=
 =?us-ascii?Q?cT7lKtX+c7kKqsExY7BuWQ7UolFPC7BPS7f9+2/5kdlEmXThbo9AenaFgZna?=
 =?us-ascii?Q?fwyP6kodxT1jKoP+33duzLowfrsWQ3b+903/Fx7s3Lh14NP3g3xi0JbUPOGl?=
 =?us-ascii?Q?5LAnUz97G9SfkEEyY1C/3V2j4n/TWh6ggqd/Ssyq9rBGGHY9tPcy7RkK/ysK?=
 =?us-ascii?Q?F9seln9u/bWlmxOaTvjhp/axVmVYzyA+813WJmzgwYcih2GSWpK1V3QRfr6P?=
 =?us-ascii?Q?Psqh+7n3OebMjepTNcGCL+E8nuE6Ldgu+IC3xj4p42ls+j7f/z427swcae5M?=
 =?us-ascii?Q?XYDa79BoODqw/AYbCb2f9du0tqUbUjpR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+HP2EKHZ58p3XCh/CpI7UvvN9jfcLskmqjlRN7Ki3SnhRp810fFXHJH8Gs6o?=
 =?us-ascii?Q?4H1u9ukLQqXqnLEqkOlkll36x3kjWpTb41acCPJ4CAVQMLdRFZr1SByCOCUa?=
 =?us-ascii?Q?+FgYAwiB84RtyDVwax7dOqDGfJBtCKwk+JLn8MxKOox1h0MGrXvrFbK5tfDT?=
 =?us-ascii?Q?Kz0cZb87v2d3JdxCO8fXOZLCZuiIAfufCAnG0zlgTAcQdHP5OiMP04GKOFIk?=
 =?us-ascii?Q?vUYIZTah3hYENtxSPsEiDAPvJm+3YtG/2NsuagpAsiq+pkL55zfvccvWw0QV?=
 =?us-ascii?Q?QL58hLkQWjycMjVb9p8ROIhA4iU8BeYnoKHnAEakfhnml+mDrxuhRMzMVJp7?=
 =?us-ascii?Q?AAiUNPX5VvMimTd/9J0zjm42FwUrWQhUlD24L3JAkPnrci9CTz5ZhZz7RpBQ?=
 =?us-ascii?Q?H5MwAebANCr+BAyipTNc2uLYWrzLNcl5JTp92pcucgUlNxIBrSaH2Kfi2SdF?=
 =?us-ascii?Q?ja+u2jcjxlCkfdyS5GhAXch0rEdAeF8fWVSYWxU2KzOOnY28S6r9Rf5rixkv?=
 =?us-ascii?Q?UtBJ2cm7e8MA2DGRQTiVqokMKhJI0FoCwLYyRC1NeN+Km3EtPqA3UCgO81at?=
 =?us-ascii?Q?M2tYQLcvXjB2d+lNlQg/Rbx5AtIkhjCwI4Tf3Diz5HHloHa3YI7Ftl98+1E2?=
 =?us-ascii?Q?KCPM4p5l4zIneCF5rhcpKpM8ZNp3gi2GjrfME2N8UwCuBXUtpD5M6K668XCS?=
 =?us-ascii?Q?+vHeRvg1xhb7giqtkrjb5UmGjcHEn9DK6xqX4ldYv8+LRYkTMJoBYBqBJQ9w?=
 =?us-ascii?Q?M3zzw0p9Zi379O0alKluv4ddA5lmEQ1/JY+Cn/O3pgqT6qMO1fv9R9xLlrAQ?=
 =?us-ascii?Q?DKA40zkAnsFZ7IHirvuhxJcSNR+CYVu2ReDIqTKT+WKimsXQSMOvV3KHWUlV?=
 =?us-ascii?Q?hdj5nCpA8csX+3aXPgAj5xNvKweIY75F0IQbxEqn3w2/ao2itliuPQaKgps/?=
 =?us-ascii?Q?77HmbPfu4dSezIjka8tvUrwhNnrj5ATqpL/R0L/0mYGfLgz1wuz2VE+Vf7zh?=
 =?us-ascii?Q?bpxW12NsTbuRTqaQtzI33iA52oMv16KNArinJN3j7CNDhL8j20DcwdVHpFak?=
 =?us-ascii?Q?NUBo0G2quCBOLpbRIQg48i4kL/3mMJT4qRTnIulqIXgB98ku/YJChCeRg5+4?=
 =?us-ascii?Q?y5bXrAH2qTYsGtrfQRfHer2cOl6xJ8OER3L1URmmgDVX10AoQpHQvU8XywxH?=
 =?us-ascii?Q?bgLxI97sgHxB95dxmYmZ40RT4NF3LJwKkpJEMu4zwGo0+iz5aD37sw7N1T0s?=
 =?us-ascii?Q?KGs4RMNY9xCharCqkTMthXrHXAtX7gFv/uhZFs/i/1o35gDXdIbPmKiaQDc5?=
 =?us-ascii?Q?7ledTzNv7MyPakXGYC3WhUUVyZSUuM25F3bh5kFK0b07bsPyGqjTziuseO75?=
 =?us-ascii?Q?yms+DEF+fczHF9oZl8AMRBHNRiJkJ3v6CsF4WccfinX1hPcBsw6WNZLp9H4t?=
 =?us-ascii?Q?HqLwQf6X01QBTxRtd/2t4e4IVnv0GUYry22Z3SU/CSCjHIY/DVo8cfaSiiWd?=
 =?us-ascii?Q?NKsWlQoMKEznnGL9U1JFenvZwqvc4MO+utZKsjcK5SD/BrZd/MTMIUJKnh6x?=
 =?us-ascii?Q?I+0XPngkggMeAj41lqw9g5+mdo9urj1YzkGZuFsecJgPWSYMc67bTAmHoive?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	unAWK18+DOmPVXHe9lomu/sD1/ahnXWwn/n5ILBnaHoTa8pNXnIjnv1Cq/eiU9m59mgXjiR5W7/589Wt8hEEzsvnORNlMZ0elkZJV07XU6Aus/QNSu5Ot1WXRn4eWwHXWhh9RUB4PziSJWseiroIVE+UC/bR2T509mO63yAbQy30ab7B/Zs4TjM29CPgkNq29Cc7boV0P0Bju0iJDSskguR/f1CbNjDhlhJQ+dKAre3rgSAUBrntMSucCjj0TglmkJ/pXfUmVLXyAcTnrQubRmmuO2Y+9faUNp9Cxyg52YpeVYQJ37KnGbkgSMvkAlescHp2l70IbjGFnhE39/jc5VqgP6jLuGecQMYdNHJLBeCs/AreCYaxH1ESoQmOJSUn81MEdDCA9CSMSxq7NGuX5dKca0ywy9tL7+E1qBzqLQTRvdcu55d8LFM2Ttmav41GDw07/ojxrtU0Y9mpKPjT5P0WJyZLilp/QnxDVu88gEMSSwRbxaWlXjBF21rg9vSLksG+ttLaJkiwcvD6mazSAVUG0mh2KywkB9btUfcId8CDnhexOdyuxn2KiZm002v4Udf5i0+tuk23Sa2PBnU9qxVNpVfuoUFpPfaqGNLUGLE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d0bcc8-3020-4cc7-d136-08de2f84c074
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 20:20:34.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfXyhwDraR8W+PmU5PdIisp5lpm80fUMxCGVuQ8zfjR4npVeQ+9mdfabzUa1qjWV0wCXQ4GnNb7S+BmPaCLAZhwBQGCbhjbvQHksV3dCo3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6214
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=895 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290167
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE2OCBTYWx0ZWRfX9Yy8XJxxcaKF
 vGdTgHiabBVwb4dvFekKn8JQ3LF4OAH9PZX6rFYaCGckS5TxNobgbucNZGWcZSyWXz8GyzwewWU
 QfzppPHMxgY2wxThkwxwYF4kSi+d1MJ0yrCzuH4G3RI864Dg0MPn9P3ShJvgZu3oqbFKD4sQXRd
 +jz1PqZHH9LciRETeFUxGo5rDBBz9/yxb5HUlKFv1/6+CMIkUnIaeu/bIGy1HsU7tFk/Rdk5snO
 AF6Xxyv00toOoyKjUxBVp+cKR+YkAMMwA9NGlLqwUlLgYVy78fmA2Rzk/xuHEmxMNmBJ5kKA3jL
 qeuweL6lwMAle6FAwZfx53vrJwbg51mob/dl5uVgs9zDL/a1T15BsLR6RTIBUhlTuw+4NoN3RBo
 29WITKKVAEfWvU8EKd6hC5yJuguSjlDaLLkNEWvl7aJfepw1yUU=
X-Authority-Analysis: v=2.4 cv=S7LUAYsP c=1 sm=1 tr=0 ts=692b5598 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:13642
X-Proofpoint-GUID: AKIRuUHKE1gA2L2vrb9qxtlw6ys748r7
X-Proofpoint-ORIG-GUID: AKIRuUHKE1gA2L2vrb9qxtlw6ys748r7


Miao,

> if scsi_device_quiesce() returns zero, the function executed
> successfully.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
