Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72304C6C;
	Wed,  3 Jul 2024 02:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719973881; cv=fail; b=HjRq5eI5xIagQSNKHxfEINGZ7uQSSdOxm8Mvv/Dn7fWcIECNKeLXdkbgmeVrc0K3mW0MEc0qWmmk7AWwAjbR9yPJbZipfZKIS3mjNA6vzyfYjL/P8JReaHQgHKxluP1fVsDwvEoL20qkRzFg9MPxHlzWNPZML4ocvuy4PCfY2Ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719973881; c=relaxed/simple;
	bh=bl4m7AmVR+0mIuv5Hoj+NfZdj8tmH4M7dXJBPNQEiIk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=JlMrrBy+/+VKo3zD9pcORzuH8s9G1XPzp6iU6ZR+TH0ewzl6mo6kuE4OkFdro3aXjVl+piGDCJDxFlgwrkb4ukqMWXpuy03j6riCHQJMC9TDI8xOePEnF0cLPhL1eboONtvGtZz1t5gZRtJnkg6tjm8PJEzF5f6aikdlsKDNEUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b5oiIK0y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fk5i2aCJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b5oiIK0y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fk5i2aCJ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4631MWWq024955;
	Wed, 3 Jul 2024 02:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=BJd1gKgnliWhBY
	h+4rXTceM2SLtzOnmBukBB1qFP4CU=; b=b5oiIK0yAhjKvF24coLJvMrl+xaaSa
	HjLYbQ6HdiC8krxwi/HT3Si+QSKVkZem4v2f3H4KjDMI6TfUPeg+qtcuKnKGkdCX
	xQoJWqOCLIbF1O/I1gtZJcDe/IJAdjaI+8MzCNnpUByzTTTnX3xkXeLdmnylZB4U
	DSzx4ROREQ22PW+ebMgKLDPK6qjkQOtAQ6uuLq48KIhWWCuHNBF2f1V6oG8yIGZm
	uixLS5/uTbpy8z5svbWgpzsibeUaG/AnWpbFT5Ax+ea1OKgbB4kf4NjRFYeAjr5p
	MV13I3QtcA/zng+hRpzNXCcBm73blQQjLlj0ORo+gcaJQD3qnT0WkpZA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402a5970bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 02:31:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4630Rbcj024729;
	Wed, 3 Jul 2024 02:31:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028q8vpg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Jul 2024 02:31:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAaH2svX/sPLxKy1vNPwlD+SK22sQml4Nrdl5LQ9s2x11kSovijNjKEhAa1kscyCRLaXtBfvC6c52VUAFlbrzUpfSWFRiOJE3wAJgn/1nu5iA15frPqXPOBYOtcEHIzyW39ZD3KMXaiUj6jE3SwB4ahqYen3i5ydrQfmwYvVN/Ty73D395lz4ZVC9T5CpT6Yco8EbqJvd0tQpVMo+7O5/OtqzAKN13tLja6YZ3G7GfWELC1UX8ZGEBIopF+0u113abFiePRSBxaMIjSGOH89ZUWcJz13cyJOLnzlVbiQqijpmz0Vcq4fyZT8/B4cT94OuG6Rgk55paWBw+KCnzOxug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJd1gKgnliWhBYh+4rXTceM2SLtzOnmBukBB1qFP4CU=;
 b=Tfoo11RUrz++1mqWegQ8UZgAMOkS7nZEWn6eSNh8cBwcSOFR08/s9NvESWN/EHVC7QAGg+m4RsGvJrnG1mAacy7sVmdA8Eio/CMZe+sGYXTvdIapmNT93XRgQRqEDbzJ6QI66KtuHuHSixaAmazgswSCeqSBghECp6qrZUrmOvg5zSHW5hyzQn820d0WMpvmJ54nSdsOuaThwMFAt8gYbCEovGQX+pcZm5sHZS9m76sYy/KI0hx0dfcNX1SMqPJSTNnefo4RmJMCWFaWF6bVfKEmkIldy49xvIghfeLCl1MRbjQEOkra5m/qC3uNdS7O7CJ6uZnIN/cZ5mdh+MZnhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJd1gKgnliWhBYh+4rXTceM2SLtzOnmBukBB1qFP4CU=;
 b=fk5i2aCJ/iX9jO2cqbJh2hGU8lBhZcimGCYndbPpBmIeA1akhB2x97am5IZMV/RGz2CEsVwUC9Zr5YPESxqBLsAyIkzOsCF0QP0PduWYLk5aPx+I9DZ67c6ABguYBiFzs1U5/GKnf6NvIfcO5Yg+2fTxda/C8JaqloSRSO96AoM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Wed, 3 Jul
 2024 02:31:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 02:31:09 +0000
To: Haoqian He <haoqian.he@smartx.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
        "Martin K. Petersen" <martin.petersen@oracle.com>, fengli@smartx.com
Subject: Re: [PATCH 1/3] scsi: sd: disable discard when set target full
 provisioning
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240702030118.2198570-2-haoqian.he@smartx.com> (Haoqian He's
	message of "Mon, 1 Jul 2024 23:01:14 -0400")
Organization: Oracle Corporation
Message-ID: <yq18qyjciuj.fsf@ca-mkp.ca.oracle.com>
References: <20240702030118.2198570-1-haoqian.he@smartx.com>
	<20240702030118.2198570-2-haoqian.he@smartx.com>
Date: Tue, 02 Jul 2024 22:31:07 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0159.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4451:EE_
X-MS-Office365-Filtering-Correlation-Id: 8384e148-b519-4f20-c0c1-08dc9b0832dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?jFZSgzJJ9YznrdvKQ1u4quXGRrVldY1lN8SJTPMJc+ywu2aj4IQWR3ypg0rX?=
 =?us-ascii?Q?v6tJj1St1JMqx6oIhlCnNpmIIyv45O/qWGNlZOWkLOHu4A4cpgu0rS/Cyjq/?=
 =?us-ascii?Q?P9CcDKtzusWo+pvUJTA4VuuvHuLPEj2ctytX6ShEdQcFuauW84rsZHsyHreQ?=
 =?us-ascii?Q?WZhz2Wt2GmnljsqOVq0JZK6xefPywKlAxE+DJFKO/g5mTVp5BxVD8fu75MTD?=
 =?us-ascii?Q?GyKLgFR3uh6Zi4AN7h8gKg/BBVjssmaD6fjM3OxMzQX47BPqQVFnF+tubfYE?=
 =?us-ascii?Q?pJrgMoJA+1g3iOquyP2z41VC//pa2X5CDRiDCTYuycKcEa0l1DMob5L/s63F?=
 =?us-ascii?Q?2sOifBDs/8Ncm/y1B0OBwGagy0aSW1BKxXP1oeoCCaJvr2cla7BvWe6TJzuL?=
 =?us-ascii?Q?GwHVeISPnsIwv1Y1oshdUtpZUfgSymq0rr4WDivOQ52gSv3P3mKY9WXXRmcV?=
 =?us-ascii?Q?XBE7kQeDss5b0UdSL6MafQ8J9SihDvEzNLP5ELGp25YIxW8TncFiJkZmU5q7?=
 =?us-ascii?Q?YwOUXpQPQcOs2YToBOTTNsS6uGlsycem4Lxh70E4uPF8KHgEAadifqWV8zsA?=
 =?us-ascii?Q?WVFws/iMlYl0MoDGWgBzZig73Xh8Ut7pRhjU8mAcajTAnVGS5Yh/gH7V3av6?=
 =?us-ascii?Q?AQsS23mXvvi1bushts+YF6LrKXX3P4kEFCTIVRgLEGB/V3P6qOs3n+UYR0Oy?=
 =?us-ascii?Q?rG2G4dKBTsyOxuK2alknWZbc+IKmZynMM9sY4wrkxwBZe5lKEt7sT42aG3M4?=
 =?us-ascii?Q?ho70KmlOwI2zWIVQcmTZAu6ap2LRqnHiANbIsiTL3eCLY+ZMJ2Ox28IqDSix?=
 =?us-ascii?Q?jMqNLPmd7a0jL8veAnqXnPT8r8KS3Bw7VS2DRUZtQaSlSfT7d6QKmHLJGPjT?=
 =?us-ascii?Q?gTw7DF9uYDcnoTNVdKHsjMEEOt6z6ckT1nmrMSIPyzvSH2MEWaPnk8EXutWg?=
 =?us-ascii?Q?4ytp/rKhyPWOZezyU2IhCUSSwryE842j54WCmR3KyRmvq5pietpFJpl8Tg6n?=
 =?us-ascii?Q?nH6lfLWhwe4UFvFqWfWFZrXU8mBtqQY11D6LHx+hZiRL5drZugxVfxvz0/xq?=
 =?us-ascii?Q?6JSKVkatSpyCVcIqZGGCvPzJp+EiEMawcC0dRfiI72gYPXFwETLZLBpozYaP?=
 =?us-ascii?Q?eLlbxA9eFFW1rm9w0eEZXBhpN8KROOt7NnBLERaaQanTu+m131fcHDYXkBTd?=
 =?us-ascii?Q?uyFAnMAL2MObQiXKLox7h5rDBKnQC049RGCYhPphWCJRh+hc/epQ7ubILzWG?=
 =?us-ascii?Q?pcQb2rfBQTbmX9lLH0uBIv+Li3C6T0Bwe7WoXxVpkIGM3pZNal0Q4SONO0We?=
 =?us-ascii?Q?sSFEqDUimGOcK2zNg7S1QmUPJobMOkN2Bsl68OGXH0WH1A=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?EjmEFAdrBl8fNb/8lcXgGFVe+vR6ZTaqaFMo8P9+xnkG19Jk+PtAerFxelYB?=
 =?us-ascii?Q?fFZuI4u0f5mBd9WWyhvDKjjWhAv7hK0ySca1pcNruS0fO5JdlKJf/eJ0suwe?=
 =?us-ascii?Q?speGvz0lEAKVGNMbbdQlVAzah5Aamk7djLY9Oq/d0+5wwJLeI2wCZkJ91SgU?=
 =?us-ascii?Q?KajkdoDAdxMDQyv2G+t1Dsqv7En8rDMjeQCTbSK210mutPYuIQ5kOHvuzuZt?=
 =?us-ascii?Q?Zr2k8xjQMfkWdYcR750dbA0ZmUJM6+jmzJAA9n9X83LJCPvsM/PeOwZChIqF?=
 =?us-ascii?Q?rqXuV0VcDZrHDouv8v1RinCqRA+BQiR7E72qdlRucDTvzCQrBMhsw/5GmjcC?=
 =?us-ascii?Q?FEFfpAYtcWTr/nIl7WEjIJdl7qf8DyJa5WHJlsHZ+KAIuI4YUUfuYG85bDTb?=
 =?us-ascii?Q?XoMyPGtVEFoI+Gd5NWg1yxa+ljrptfe0jpAxPNgMvjB43UbpHdNMpHTXIwAY?=
 =?us-ascii?Q?sewMBaCNPVpU8B3ZQSgk/HaU7lZ9NHLGN0Yp+T1QqTVKOOWvG6rVIvABQcyh?=
 =?us-ascii?Q?RtKpkUdpN1dKiDtmLrh3nAADtU25b/IhYMjC8sD9Fn28ej5LprN0b69jULka?=
 =?us-ascii?Q?87m5OAk8aiSHIxX/gYZdnQU9wIRv7tzA1JI2AKUc84/wpR5d5IqmZ8a7w1+/?=
 =?us-ascii?Q?zwSW5PA+7d1o+9oCQSs9SJst/GI1vEpppRrVKVW/7NZ02vsQAzFyGxmCRCX5?=
 =?us-ascii?Q?201mYV768R6T5YQuRQp9Z9kn7tN1GbpMQGpi06BirEWwpVPQff4gtbxBTVcZ?=
 =?us-ascii?Q?3CvKRUz26Xo4v6xznZlW/hDvudirGhXstm7VLoOYLiSuXjTr/WQMJDLN+eCe?=
 =?us-ascii?Q?X28SxElh+aEAKIotyceHYGry2w09OIB/XMa3phkHrvPQB+RtLzFxAlyGj2Dh?=
 =?us-ascii?Q?8zFfznKq8Ld2FWWk32D7DBluOURxywCcAK1y+fNkKn+Lo/E3cPceZRWmgsBE?=
 =?us-ascii?Q?sJagUyuHjH8RiK2G7oesgkIYLoodz5t4P3VrNU6g4bNw//vEqHDzv7Dg1DMT?=
 =?us-ascii?Q?dkUyGS2wz76jfwvCYDn5UyvV/Srf0IudDcTdF5APE2X0nH/UCnN1CQboT8S9?=
 =?us-ascii?Q?w7PTLQzn0PoMgUCGYZ8fryDrJzXlDgEE9nOL5UBUSuF7VafqGJUEXrmnyXOL?=
 =?us-ascii?Q?IoRTl3DX8V8rMPWeQpRbcHllecUTdcdopHleLufD6XyPjpxadkcGDJOmAKJN?=
 =?us-ascii?Q?17wk1LZiphdTjXez509NuWf31CkqLckwgi7SSsGNkF2Rb0LKf9kbUWCSC2Ob?=
 =?us-ascii?Q?xWSxSWnplOkR2ltJ53EHn4TmDtP2aOD/NGjmccO5oB3zifRoQCoI6Ej6j0CV?=
 =?us-ascii?Q?qRv7cLYPZJpbzCuIGZu1xV/TKBx/pOEyaQVr1bAnS71UddFnWbHFtqA44sFT?=
 =?us-ascii?Q?NqMZc+8kOGbe72v88SeMJzbth8675NximoZ4ZaWiJMemFqqcMe63DXglP3bb?=
 =?us-ascii?Q?YOHgy2LuTFMOFB5oUe5GdzSG5Zy7TyFqjHl8IuuWGKDSjf0k9zc1tS2PTBdO?=
 =?us-ascii?Q?PzvWHHpEonAWPp/yKhSGUQzZXJzC9cJ9h1f1nzm1wn6fWL1pOlIOBiJ6KCFu?=
 =?us-ascii?Q?GCyAEoNZFIyBdLhlmLQtA0jp/iVsd2gNmGbjfF0fToQZ9D5XXF/HghzELvgi?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Z9i7/T50Be0RB3TgHIcDwByTZwSNMM1WEDdtPQMqlNbfJLoksxSI2FzbNVEgchIaklGDUa4rqG6rE2HzvI2jMEpPFXDupv9BL4igoWv+HQj+M+kXViOiTx7/HoEJ2jgMJw2FyLn1c4zf/O31eZZTWHwEnhWq/dqfRP+EQP9w7djqcenNu2am/ofYDlL7M9RcxgPMlpuB3rW94xCDAlV96HaaF/+XqzXGAlL169lnwZ1weZAAI42FoOArHGktBXcpyC6xtTtVRE3YR83UpqbImJeJXMLfPWT/qqmZQJXysi/BhtxV/jZWpTcL54QrocI4K4whFoRPZ9F+gzzKyVyBKR1e7JpEMJ9p0adNGhaPFQGf79WlhVGF6EkGPBlAQUE1V0/jWktrU1YZuWiFaNTi6na0gT/wKFf9xcKiCcjYeAd7NlXDwuL6UkBQ8dQ+oQopEIHktSmlqPSD4TvtasGCRa2Rm1n1XvBH3VKjQtPXm+Onv8r1wMYcMI5lw0XPHMqVAGeF5yauzNa/HYJm4yKMFQeCg+Dw+MaU4BjahObdsLR0e3xmcRtfRvRJKn32LXE5bHo5zT25Bzb73h3BWhl9gtzIIkFUkC13RSZ2NOGuIgc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8384e148-b519-4f20-c0c1-08dc9b0832dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 02:31:09.6448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jvs/JRT9tML3R+FmJBjcgPofoLhmVfOZJiNgV6u+I43kbFGyUBueM9Iq/wV3IHFOlayWBi8xV6nbV+N4ze4L2SGf1F2ueFsaPmCus2RGloE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-02_18,2024-07-02_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=581
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407030017
X-Proofpoint-GUID: tqhFomOljb9BUC4ckeHJTW9-bWuu17sk
X-Proofpoint-ORIG-GUID: tqhFomOljb9BUC4ckeHJTW9-bWuu17sk


Haoqian,

> +	if (!sdkp->lbpvpd)
> +		/* Disable discard if LBP VPD page not provided */
> +		return SD_LBP_DISABLE;

That is not a valid assumption. Many devices which support thin
provisioning either predate the LBP VPD being defined or have decided
not to support that page. The current heuristics are very deliberate.

-- 
Martin K. Petersen	Oracle Linux Engineering
