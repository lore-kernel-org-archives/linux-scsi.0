Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EA9189528;
	Tue,  4 Mar 2025 02:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741055386; cv=fail; b=k5nSlT4rptlZaYO0LLkLR7MyyFyQdP2N7ibVPgnG9FAoYAUBRjjTWTAV8pBs8iq/9A82kjYw0AiNmjKQW8uQKl535uFNQXYd3yRqNSdkh4qEB6jg1/EJ43UPj5jzsMTG6Mjon1EHkTBnNIv9gkScn9iPjOy0RYbALGXSj4o3SmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741055386; c=relaxed/simple;
	bh=lqsGCgsICuxiOAKLOkRXypcHlTUtJGUZFlKFONXS7PA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=N5T7joyyou+BjCgZWBK2D2wqG/7v40bplPndsU69Lrwl8+tS+j2pIeSkS+QuzGLWHtQxanEC52kHHYWx7ZyTq0LhAgmuS9SNd9YlO0AQKEkgAjBAZqEd2Ut+J56aHk/Ga1PCG4GmfIXD/mtPeB01fUDQ63LxOpmMy8m5mRe2mNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SMjpAE+6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fKqQHG07; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SMjpAE+6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fKqQHG07"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241Mf0p013437;
	Tue, 4 Mar 2025 02:29:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=0/trVVNJvTjsSSX4Db
	x1GslRyOaNUrvmQx8fYSPulZY=; b=SMjpAE+6nj1Fx7UxoE91wvpSdNjvdjz3Ee
	He38VKPP91TshDyt8O4gN4VUqbY1OGfZimK0RS3dg57XUYkV762J/htEkCPySCnJ
	9Kug+pH3QfzmFNanWkBAeGyI2FP95+c9NLX+kA3mCHcWF0PLz1XhmjCUUH2RD9BN
	4lqH0B9En6fiGVfzR66syAkuJWc40Dtl4l6t0CGuKT2hwQXgSSremsOQ13apTyBq
	JdAUkpKDQ4f3snciSQCbqTxZundVvLkRYgoPNYVHnO+LPtkDYtozzKuaaVANtNUE
	U8FsAUOle/i6xLuPR/B8mo0NnlTmAltbbvVwhQk8bxVwPSnuXhpQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453ub74279-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:29:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52400Jb9019915;
	Tue, 4 Mar 2025 02:29:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9j58t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 02:29:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EjwxllUaxpoBjHyWRekgpWoS33wKhZU2iHgSsc6e7tlqqaHMbw0Bk+N/0xwxtBafnzj2iTTrmyJEMQYPsj71yh5xm5BljY9n3ZDoUQOQooqb47CR4IY2DM5KJ4pxU5Ybj7wXMSny6mXV29YV99f91g/pfxWkv/irz6hQyqAZSkz0mkHhYBlYrzg3wiPXaSZYgPBqQubYgUlnlUi4HRr0gxKSGPYhYdvITDqBQGcX82VgUMt8BTGO21Xck/TKktS0saTIaxSgKQQ4mNq930llotxISY1jyT7uzWQ+vu3HaGfPxFhDeHk6irkbGRgh7yG8JypEYfQYff9TlyynRE/x5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/trVVNJvTjsSSX4Dbx1GslRyOaNUrvmQx8fYSPulZY=;
 b=GGvbytOjGL/JtjlIBYt5YpoCWbeu0sp5FWhtRuF7dHAFQ4x1PWCrowXQhDpoS3NjJmTa838DFLfRQBiAABVd9bJLluwwNoXeKYIOTUzcYej/LplIemolmgB6ZpqyORZhJeeusS9sl4UeDd3DtNjDDjcwHYYrlBNjmO3DYStQ0z2RHT1l/ZD82FIH4ZzKjsy3yqcykTuAAJceN8dJQe5gCwG62g7jzMFAAAjyeijcMY6DCbfknfYAC3tChImzNKTeRpn/6vi+r3iBU+MPOnbDmnG20pa94fq8yc24DxX+GgqjcER4mLORSNAyfLkEqAmwJnC5JWh9i6kH9ejIW1HYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/trVVNJvTjsSSX4Dbx1GslRyOaNUrvmQx8fYSPulZY=;
 b=fKqQHG07IxTpQpV5Ofzss2/xhrLGTgQXZdi+ffqbpBKrYqG8xkkZQfYNXG7sphekqH2nyJaDSqtJXtLQ+uF+RNol0g9f0tNq6FsagAXltg39QkQmnKO+ruSh92npUVKA/emFyWtno8d9mgJaoFVE/ua6yIQwIMg4Mp1eAAIVzQk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7258.namprd10.prod.outlook.com (2603:10b6:610:124::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Tue, 4 Mar
 2025 02:29:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 02:29:37 +0000
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] scsi: mpt3sas: Fix buffer overflow in
 mpt3sas_send_mctp_passthru_req()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <02b0d4ff-961c-49ae-921a-5cc469edf93c@stanley.mountain> (Dan
	Carpenter's message of "Fri, 28 Feb 2025 12:37:28 +0300")
Organization: Oracle Corporation
Message-ID: <yq1r03dtto6.fsf@ca-mkp.ca.oracle.com>
References: <02b0d4ff-961c-49ae-921a-5cc469edf93c@stanley.mountain>
Date: Mon, 03 Mar 2025 21:29:35 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::38) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c6e14da-d90e-478b-b535-08dd5ac468bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ftPZkc5UDX6xuzLLhAC5rxlYZP/AjuEnpDcNN5YHOTCnyOdKFI1SAgNTKdP+?=
 =?us-ascii?Q?IvNyUAcfGbgoZL4MzQrY/TzhC4fA7Pw18oy8vl66HcatPZ1TT80sdY6WKtK7?=
 =?us-ascii?Q?7CU+ACoqKfY80RBGGzZoqZe9Vbn+PhBbNDzK7GHJNpTamrhMm5wntxd4AM62?=
 =?us-ascii?Q?eFwRfuVDC4BK8yzQIENLtTOJfeL6j2kGCJxG729qDiOuTwbEJLs2yvw1knW8?=
 =?us-ascii?Q?5X8t5BBbF2+QvYv1My2HvvHDt8IMortCEI0Nx8GbIWJo+8d421c9WLb8q6Ea?=
 =?us-ascii?Q?pkyo7XOzU3EDu/RVRwBhjuynuPdC5RA62mUEqfBK8pd4Br2S5JXNhhgz2fK2?=
 =?us-ascii?Q?iYCC+xMJlicj2xLuu+kVt/jVaC1TwoISHv2zgAQl6TM0sReoVMFYi/kV6BkF?=
 =?us-ascii?Q?gsHQmmULuBTBatyDY2CglHB8xmfnqOuy8sihKyUDacrefhbx2SUY07Uwb2QM?=
 =?us-ascii?Q?bO1bX5rhp3cdOmfE1l2aG6aRYHstTfnD1YluGxJ6cWTOaCnRdPCVKtyG9Aec?=
 =?us-ascii?Q?TDvA7o1ZXJ44i0ghunmu9E7LP306MyWGJ97MJYUN0CT7BTFUtyy+eg5u0SzE?=
 =?us-ascii?Q?mmoAHN9HEOBi/OSvH6xuBnfoTjcVWducB7s5D7QunSxoFAvjhXb3WB8ljezw?=
 =?us-ascii?Q?82i4eSoRetfeVz3sh4XmKZ4o4WOrF5w6XKEWf3DelqATDUWfWaMrew69uwUJ?=
 =?us-ascii?Q?+BgfAjG11Qs2oHz6RJWw683x56QgDjKytiWOR5mi2t3FV3lBRp8dBZKrdePq?=
 =?us-ascii?Q?pFsCPvWZIWI/tjZwvPEIkdCQOGN5u57lz1KOFVrmSA95XVx6kWu/KYKACbqL?=
 =?us-ascii?Q?Xvt6x3HjEUmBY6VBce/zPghC2dNwM20ZMpjXrfQ56EqlwtNFxkPCoP/juoTB?=
 =?us-ascii?Q?ogRjxdcAj1ekyAF7ndTG9XYNpKIrA/O7D7VKYyZ/n70I6JBkoWjz+CNc+NfB?=
 =?us-ascii?Q?hoY5NGANNkzU1xr52WFz5THJK0umBoKMPJpe3Rsvl5UUgouAfqYUfRxqnlZT?=
 =?us-ascii?Q?ay54D2P6QnA68YxcHIof6ot4GVLmiQqNa/XiYzuTc8nKzipMNubBnRqvejHY?=
 =?us-ascii?Q?e4CEX8oJEFAJGNlgwIDabCs2+h0cSw7ox9kPNtpBsFfFA+l0wW5WhbMVfzLr?=
 =?us-ascii?Q?kndgQUKX/oTI981TKzm2ICfOcAs2jKy14LVuAxpodnuvLQRUqw2oLVByQcIQ?=
 =?us-ascii?Q?QMp+jKUxPDL0pjgvI1JZFpU94+zZp34ecUVXzR5rkwXVt2oIRXOfTxU1gWxg?=
 =?us-ascii?Q?SoxozDZz+6r4vSwf7Jzq/w3sh94IpxgnQyzz1SD/57xqLR6rsAyAKP8QG51N?=
 =?us-ascii?Q?QeVSTMlAonj9VwZMGhOa8e9MvFBbEGsl3SgmsA5oqWQYm8Ue2clefk0w5hql?=
 =?us-ascii?Q?IUexTPe/9VcQh/Mc37bv0di7rAtf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KDIUmfqZsA61sY0ZyHS70cquoScqNzDzH/3Y6J614dpyM7XgenwtFbieepur?=
 =?us-ascii?Q?SEVeMKGipUXqOj1s+EXlzMAwAQDBswQVvTLC4rvU7iklbL5FMBvBrqlI5YyY?=
 =?us-ascii?Q?TcNUQGp9Rdy+QC4738Ng96yi9ceR2sXQq5ikR4Qk0OXxt5P9nmoYUOjIq5lL?=
 =?us-ascii?Q?qMsLOi4Zh3LVBxPg6FQGeaZMT/V3bF2FlDd8NUzhYsrcVGcorKj6GFTb8AGp?=
 =?us-ascii?Q?CtNo7MYRLu1jDa6+7JvfwGZHTmmOUQ7aXDTBar57ZiJedbxftZ2aLoGjTeLc?=
 =?us-ascii?Q?2Gox25cH5yYkvki5urZ2bs8S+0y5qzf+jbGnUGC/6ihHw0d2+95q7hTUB11X?=
 =?us-ascii?Q?XhJPaMkU4274xk7PD/vp+mUUkbmuWs0b13LAkr2Z3V+8MVu56gH1rpf68biy?=
 =?us-ascii?Q?dTt2CfppJptbRnPyGGRmVlJDNE63KPgOF+6sJ1iL0y3HsMBgNpVTU4DkI8QK?=
 =?us-ascii?Q?AMSSdo6qi54MLL8Yv2AAEqlScDLYFMvQ0Zok+2ihnaD8LH1wrhXrPVkrkvzi?=
 =?us-ascii?Q?OpLfBwyQ5XQZpQe5zXb6krmhnq/9JcEtAHd495sZFHTVE3iB3KLoeE1OnB8v?=
 =?us-ascii?Q?lr1G3Y5Qd1fhjPAXLscETGRWa4Y4t7P8r97iVLQGVdIAHV2rdz14x8TdTV/e?=
 =?us-ascii?Q?w2/fgzNnTiHySQ8cdJxH5TozuO9Eb+GZL+wl7/rUfGPt3aeyJSD7AUerZoM6?=
 =?us-ascii?Q?BQPfXSP04H/+FnIYvIcOouZxmmHGzAVwC2fiLnT3H3XD/bBFviPkBKm7E4mS?=
 =?us-ascii?Q?f+dn0KYRnCRh7dXO0FiRMC0hq0R2AbY6yM9ACX98VQPAiHEwuhXVIBaxtMQj?=
 =?us-ascii?Q?Ir3mHw0ciShsU6tEP+DD61VdEFvwPHk2tkFMd2C0ZQJczbByeB3lHn+kz7wM?=
 =?us-ascii?Q?aDL9f7jlUXw5gcSaHFThsqYw9VymuIsQ1MfngVtqpTTj8lOdObTVXLlscjNI?=
 =?us-ascii?Q?FZW1cG95L7xGA5TgAKABaoaUJk3mSwAGL09REBC94loNgy4CVgbd+bA1JoxS?=
 =?us-ascii?Q?abvBXm2CmpmlSKsNoIAY30E1Xjtcewy/v8AWLG3NZNP9pjQPBPz9PGiFK4QQ?=
 =?us-ascii?Q?UYIfHqwI6MBWWPKlafW7qefE2vtEdGRZsMTEudUmSrBCA1Z9L21SOiKWc9tV?=
 =?us-ascii?Q?8UQVGE/KUAkke6DxgncwTws/k/iWRElw/MlQvYTGXfbTM2DUB6lbWDQKIMhd?=
 =?us-ascii?Q?N6+ieQdBcnhhPzyG+l32EIBR5LPZGAWw1tIDuFIHkZf4kgZdnuvxWPHTJsfS?=
 =?us-ascii?Q?EWcORwErsY3pyuqhI3zzTN2XO1etrwhg4Hs8K7J5mEEw5YafAnHUNuufD6l9?=
 =?us-ascii?Q?4Ol1VxEwrKBJezInI/dynbqPFGpF904/OaAGxHIIMtDgdiU8njcfhLuQIn52?=
 =?us-ascii?Q?cjoYE2JA6zUutc2Gfr/zEielS5YgZVpEKZYNHBAV7CRQNkQwFaKoBwh6+QNN?=
 =?us-ascii?Q?xerygc6XVtHk5q60/YUKL9PWrgoCguRJDRUTP2FG1+I/Jg5ZcNj5t51lBcDw?=
 =?us-ascii?Q?7/H071+/GKFGXNe1xlnUUyeEmwOEf5xSzTvVlfdHio+xqMq5MSChp3A1vQk9?=
 =?us-ascii?Q?Ag98cc9j2w0wnwLFajMCEDNOHBNmIRqoRXT43UTuvpLY4vFhf7UV9EB+LgRU?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FPYxaWLgm4bVpMCBxKNOjKsrprbDT5DvBneL7LDjFHqPSrzt0PJmki3TC5RDRcE9wWs0jwIdxZkkCpGEWEqVnvCzVU+spC1YbidAOZ8cCUP1wyWLwS/xSUDDHNztKkqJ8TWVD7AxIR61FLEyRkmre52TqnSG0Bgtv2Wc5FtQ1gpnNUet3f7ftAgdzpRLeksHksANUvBiZEM3slOKmztypvSm1mw8FOgMJbwwIk4t5vAHOhx2PYvp66EIm0Pzrg/zZPSMEIBtHL7vRzZDrOxSuNrd7kgIc24SnF99kB6jNsN/6tTDa9f/LFqgqGZSXAx4xirgZNclkIFDPFTFMaoVJ017g5ZLKL+uttL9ub8VErN5kk2GDFCw2twwTWvpLDrHuZYeBvC6rE3Stv3zU0M5DFUzJ7yATV9Cg0v5aBKSA0qAz0k8UiE1XWFyWhN1A25NrSV81sA/vNkhvvyalVU3K+u1E0pjETzsNkmushFVlZbgaGWncPmLHli+QE2xMcHR5nIIdja64H5WyGititX2zFsoiv6uWxbsg9KATLpOLr6UPuZ+wjYzxZ303z0/M+FhobfEeOFBB+ROoLliDjgCGoCMO5Zq3gtAqOvePhhQPVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6e14da-d90e-478b-b535-08dd5ac468bf
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 02:29:37.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCo8UU9/xbKoidhjOTdh9fN6K32pZdZn4fsRpcwCn1gPFGpbBfmmXjQQfJp7IunLLlFSOwTmUM9rc4U+X5qUsbfjHczeWf6Ujy6rzQgdeNc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7258
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_01,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=842 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040020
X-Proofpoint-GUID: jr9s-4fxfph_f3XS3Jg33woN3qgz6PcV
X-Proofpoint-ORIG-GUID: jr9s-4fxfph_f3XS3Jg33woN3qgz6PcV


Dan,

> The "sz" argument in mpt3sas_check_cmd_timeout() is the number of u32,
> not the number of bytes.  We dump that many u32 values to dmesg.  Passing
> the number of bytes will lead to a read overflow.  Divide by 4 to get the
> correct value.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
