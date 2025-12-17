Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B3C1E1DFC;
	Wed, 17 Dec 2025 02:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765937314; cv=fail; b=jlQzoywmW0bq9oI6x0Jwtav8BT40R6/gAMFDev+uPnOfIOPQsFn34JR+Wo3enjzDYqPNJY8icFf52nOIBrqZvad5nYLA5SeIxF1VTT7uBq7O5bMW1gHA/fxLMFioPghtFaSf3BOEJ6iOciCb06PtZ9050Wut9KDEz40szQg/VKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765937314; c=relaxed/simple;
	bh=XILc78Vl2yOqgbgK1SntCYaxUapSyjzFVnvmasL3Qu8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=SFeF/1fLLDZ0GKylAkBquLXlBgRiduPDbYP2RUpqyDb9EWq9Lxvcic/h0PR12AyljPrOPOZj2xcoBDG0xdKJhNCO92zkaRfDniHEMbNn+5eXOq3Rp4flSertnS7Ep971JnXCQ9IbeIUz8GJ/tKaJRyprOctjlvVRFVm6mnERFus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ee1DP1VR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cTcvBnqI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ee1DP1VR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cTcvBnqI"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH0up4r1485892;
	Wed, 17 Dec 2025 02:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9cZhTy9U01gfVoAtHQ
	/fqA5rFBCnx+wMMFIqKmBtGts=; b=ee1DP1VRPbKLxOs2ckVN/oWlZBF8fPpOHh
	UUtv4x6G1qYYk7Mn6f0fIfX/jmMhsBp+AlpO8wmaOBSOZdMycNlfLU9sFCn135GC
	x1oVmGXN5JuBeletDZz5Rrgi/y/nbp2zj3Nd9qz7J7ZNOva6aVzxeoEO05g6UNtW
	vJUJZoTMIn6+DiTrKteL8KtVIr9k8gIqik7S13YE6ayj4xK+cRKIaENZ+YqAi4zP
	s2d5CXIP8drg80BWghe5Onr5KDxmNYddUVbc5LzwaiEwx41y8Vtgb2PJPjb3RfC3
	yPv6iEPwazni1lQ/wWMHqjlUhusbIZdOWYJT8Bl7J//45WO1h6wg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxw628-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:08:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BGN7Cou024826;
	Wed, 17 Dec 2025 02:08:31 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010035.outbound.protection.outlook.com [52.101.193.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkay1fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 02:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sbw8ciR3/MaWCjvAz0WvC3CDoGgU+ljfPRciNJcfowUbVsXGXT5CJ8UPQ8832eLhqIKav6F8bvAH/la5eLLVeSYZFBaUZ9NXXftmJl9nVKEc1TsRXDeC7+2Mm77qD0IWHUGQhhat1ww3ZothmGTyP0Hy2X3ZRwxgv7RMa4SIo4ruW5F0VHPqIRJlYyhyJHwVq57JTrP9JQ/LhuB4VwZ4aoTRwurw76vR2ZBNfoEtIdgMk/LY967rtwlqVcd9esjsP/4804VI6m1XWlLGXjyziNVlEzaM2Ok4Ia7wPxBz2XUzMdvttLZP25+f4hVzGNZ98wzgfXUo7X3w/oh5Qg7+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cZhTy9U01gfVoAtHQ/fqA5rFBCnx+wMMFIqKmBtGts=;
 b=Li4C6BtdTWWPd9jSnLCQc+kJKIm0j+QbfWl7GT1C04bqyo/PZ+m+J52jYL0BNEkl6XXt7PQrCW7Tu347vIz6DTBtrYkv5CLMloVB0E1u6TI54XFXHbJLTPe5L9ZRG3vmhiJYaeStTO0OWxaar9sHvCZwAyjve6PDoDDdQOAyWm2R82TH3o0qaPt9NbmxxBFf1KwlFtl44J0msNqag/kAABMaThQkNn/5+lrU/umLl0r/1TMHPbT4Gex4aw0a9aIKWtU+kxhRxfA6N7O3PAv67ibEQs372gpySC0BlLxMdlaslK1py5FjwHzE9nDsZ/qlIRNoMsi6mOUoziEdc3pQgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cZhTy9U01gfVoAtHQ/fqA5rFBCnx+wMMFIqKmBtGts=;
 b=cTcvBnqIW+HCH+VHxpP8Me+tMWaKpDBqmnRIMpYaFlmxtB7Aarz0mjEfKDEmk1LnyhLLDYPxMW3OsMTeFrtAPj1/G8KFgIrhJ6dVlqa9c3Ja2xdadqKbT0icVrUbUSZFEeeGvh7htfIf2cQPiYqsSHuSTWAGxMiIfHLDZJH4zjs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6627.namprd10.prod.outlook.com (2603:10b6:510:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 02:08:28 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 02:08:27 +0000
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Cc: <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH V3 6.19/scsi-queue] scsi: target: core: Add emulation
 for REPORT_IDENTIFYING_INFORMATION
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251201110716.227588-1-gulam.mohamed@oracle.com> (Gulam
	Mohamed's message of "Mon, 1 Dec 2025 11:07:16 +0000")
Organization: Oracle Corporation
Message-ID: <yq1zf7h6ety.fsf@ca-mkp.ca.oracle.com>
References: <20251201110716.227588-1-gulam.mohamed@oracle.com>
Date: Tue, 16 Dec 2025 21:08:25 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: 822ee7f5-7911-42fb-0117-08de3d112ad4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mtPZ6je3Vni93wFlpSM9VEdiECSGfc8WeNqz9+LIpylxkHBU+Co9Cbx2oiPj?=
 =?us-ascii?Q?w2ycJNaw7LWD7WuON5MoPHel0Q3Yz7VuXvgW8EXJaqHenChIrvDQoG7q/Vxm?=
 =?us-ascii?Q?3bYEsOJN9CjE79wokBh7Jwjlfg2qNAriBPvad63mQIq7cHkdz9BQMI3+ckfd?=
 =?us-ascii?Q?xAIvrkM/eALx0QXmLW7YWaTWJnf5wKGcXIKmRkoeXjod89tlmfqeiyAuvyoe?=
 =?us-ascii?Q?mILmp4Ho5+Er0BmD70QC0gRs273kDB7acqTIGPm+VtMYMmH0/kRnQ4Du0iZ5?=
 =?us-ascii?Q?dFSjNs2D8mC8rzAEInb620vqrEREONh02Knzu/2dQa9x+v6CgvW1CFoF8OcA?=
 =?us-ascii?Q?QHWbXJKXHADfQwMtI+J2HPOY0FFO6H0LNv71yuyd6Z6VQq6G/a7ByZj0Oa3a?=
 =?us-ascii?Q?yAZIBThd0LN1Ei7/Y+m7+73DqU5oPrgcqZthbH0Yn+uk5s0xPQkN3ccxtVir?=
 =?us-ascii?Q?hpui2BHTbuPWFJqrLydGZDYsk0Avkjx658DCZcp76C8RNGZgHkrGRQOuOJOf?=
 =?us-ascii?Q?61+/NL/dNmR+Cl7rPpTCWX4UN1eaLEK883/odxi0PRhiX8XOFd+yef5DyHaA?=
 =?us-ascii?Q?gB1cZBtNdOCrCT5bzMoYAGWtXNorNfaO+UEOkpWYmB5vNYNQMxogKY1LI1K5?=
 =?us-ascii?Q?rW35V8YYIvy6TDqMx6BtKea0Q5Jmh4f40icrCG7YSgoqMI1cYKlAXQ+Z1pvn?=
 =?us-ascii?Q?RUyXRNCqq1PYlshYGnJQ++/3LLMzEqodh5z0uXj/DcPOpZ0skami8S4tLWg8?=
 =?us-ascii?Q?JnioxeyB/IrXhi+/6V/RyH+oXkJhyzT7tmE2LuXXTgetv/H5UzOQwoUZZaKE?=
 =?us-ascii?Q?5E3z9IkOEXbNLH41WU0KG4e4jySiAz4DrS/f6W8Zm4lL+MkCbaVi6sMeUIB/?=
 =?us-ascii?Q?BboBPo1ob0pNdeA1M5X+mRI0WcMf1oFKRSmSgpd/tNsE1khkYqGgO+figCzG?=
 =?us-ascii?Q?lsMqVARiFmt7r1GuccdzjgKybveEx4/SMkg50fjJj5YgHpSx3NtUrdwAnSiG?=
 =?us-ascii?Q?ODanCPWeCcZS7BEvtB8552e+gKa0gSB9dwRq6TZE3RehvOTUz9lT5+YOdOpy?=
 =?us-ascii?Q?ivXaHPerzMo6m2yT71RgqURIamRN6KUeD5z736DCZKKSQex4AB2At+QkDaNG?=
 =?us-ascii?Q?S5hbbRgm1VA6mLGl+w1JzGThIqLoXlLyrdEPkjrTJhYQ7m4KJMqFTUmO/sMj?=
 =?us-ascii?Q?PVrpDfmujttACePs4RbfPFa3cDAqeQsK64EdsV/eqTxN98inz3vMozK/ss5T?=
 =?us-ascii?Q?yGm7PWZsipmw9ca9y1mKVlfgKRI16BD5spYeVATelSwKfMPRHt7QM2hd8WLB?=
 =?us-ascii?Q?eSpjXLLxLy4+zHCNCufm1DzHc2eJDgzl4m7T8HcBXmCiv0J0l/T3QNfzbyaO?=
 =?us-ascii?Q?teseT8Tx1tfmLYq/DYRyxETotuvQFLL/MmgXvzfwrGCY4piMBZee64+PmJjU?=
 =?us-ascii?Q?XkMN4OHrFxJTp+5lSUF4X2lMNBtR0rZJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mLJ2h4gUaBddeif0gHwF5q+QzvBnd1RpVQVUkDIl5hqz7XCNEJVVPt5wbCb1?=
 =?us-ascii?Q?lUihTjsvPLU8vQs/ZONOS5xeiK0H7FFdh2PbFqTAKRq3cHjAHb63/I7d82HI?=
 =?us-ascii?Q?p+hLdZhMVB4/ON5hzW6Vkz+9e/C28jYBKX99SkzWtBHRHo1E8lpo6POnE7nF?=
 =?us-ascii?Q?cu3+jG+BBLtUoft3E65AizHPJZqU5+54PlZtsgG52HVs7zUOm//fP9OGzSRj?=
 =?us-ascii?Q?EkVW50dEtc5p/pzWDNWH14LFVHDdEis1OIDqcxulfhXgjTFRaMO3FAkHClPN?=
 =?us-ascii?Q?0p3Mq+HkZOpbaYGlMnedV/ZTjWbT/L8fmylrCxOI5eK/TGo/aj+RCeC8yEV9?=
 =?us-ascii?Q?kXAAIZsXzt9kNax6lllmafGLWJlRz+m1wM0b0/SrwEzkIsrt7yqwJRrprJIf?=
 =?us-ascii?Q?salt50nklXErHVbDnWTycpyDsicBWxeU8ZicLK6nC0zrlAeVWQcvitzK7My4?=
 =?us-ascii?Q?pA4um2qvPwYXWeogQRZLcG8aRFt4wSEGlglFjvXIEYf22YDQzOCOnQyAHP+e?=
 =?us-ascii?Q?DjKskZxUVGoXWTFXU0cwTqA5xZbS3SIaX+v30aniaEbHRIzGuzsA2iw6yeTf?=
 =?us-ascii?Q?WMHCajJF4dIJ9PkT7NNBN9gjdYNXawNZGYOYTbRZ/EsI+TCm8BeyfJ1kDptn?=
 =?us-ascii?Q?p8wcf+RHUnJkGCDPNhRlQGzzOVNS2z47QAhvugjtOeCJdOGcqmtj3PksgG1G?=
 =?us-ascii?Q?0u0w8Lv/GrEP7PRiUsvp5HkVsvKQ9hCGg+ew1rTvvsNixSA/LqCnCKZtef9a?=
 =?us-ascii?Q?lGVxXhOxW/ynYsB2U4ySTiu7kOB/ml9ctSPZiME7xucgDpNn1Ms9gY+M2oEn?=
 =?us-ascii?Q?aArewCYWONi/jvC48nYbUkvVKp/doGF08m6ECsqEHNd5AA4bjlgYV02FBLTu?=
 =?us-ascii?Q?UJwfqcsiKj2eRxonIqg1PcWdOseS6Q8Ppk7YcnIjSY4N3PgIB6nl8rs5X31q?=
 =?us-ascii?Q?+kvNM5VplbpjupNbSl0+ijMd9sJ8soHHR2M+X94rJyu60tngoGFIULJox5sL?=
 =?us-ascii?Q?fHslrLEAuxZJDh+z+O712NREpQjRSBFqbg05/wcBQgZe6Ha2j+Oe1sLXWBTX?=
 =?us-ascii?Q?G8y41wvMgQZsZ5xWKxh5Edj3zhK7xFRdTzVuxok50Mmj8kEXJvFAPgxEpnRw?=
 =?us-ascii?Q?nad0UEriMTdiYaXILbDr7r8RAvWj1sVIVZnjvvGc9vDfX5xH9OwBq33hm1Oq?=
 =?us-ascii?Q?2z7njoNT3p/l9y8Y2TgK87Bg+1959yVCPrTzjKAGSApX8PQ2CaY26cjCNgyX?=
 =?us-ascii?Q?RhnQbN06nbUDdz3T996UIKoiPXL+yl+ej+n5YMjkSWGS+q7sExLC6crNwDeH?=
 =?us-ascii?Q?9Evt+vAAOSyU19iNASha1i+C63Bwcra4JDICd2DvcXcTEanKrrV1rMzIzkw7?=
 =?us-ascii?Q?NMRfOdPqxXXPrczGuss6pBtBpFxCyhMNo2pKFPD+5eLBjBnif8C9A/X+l5hh?=
 =?us-ascii?Q?MiB1ezHxKUo29QixwiKfTEwtgmzO6Khm3AVHvC/13BcxDMc6OhSDzxhgUAEq?=
 =?us-ascii?Q?em/cdcRslmq1v1J56DL7iY79aXxhKiJ/DVSKbZCandgMUtstg4wOEE2M4L4w?=
 =?us-ascii?Q?HptQ3wTs5zG8bQbEor0oUuVoI+sOyIT/Jm5rUocL5PeAFbP6D1H7s7sMiiuZ?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tWgRLa/v1k2s8wzmcxeoEX5+tES/7usbieJwOTQX8COeVMbUDxM2SbXKXr9IxKJz3af7JhA5Ldk0ACjq8WGENk/eDwxwSibRClBbVLUO7Lr/0AaN4/Yl8YmEiysV7zefHaeD06D4tEXkF2gAwP3zXlM7vs/GSkgGfCqK62crPdirWzyeDoV/KobLzrooKpk4425tLmunn/leGgBDmq74C9a9q6HCLB1qQv7eLmk2Dqil6EgvDnocwoQW6L0o00Bdqy6UT2RTXjdT8mG0q95dhV8Crlm9v45keLAe8vlKUZJUFMK5FggX5JqWOAxvASNkosC6e6p9vuZHAWxQufGb82ljnxhWwFMYJfNaVDux6xHGUjnpi8xjEcEn4b3s62vF1wUKIZjyM5jngAaur1sSIIQxA3cIpSNOOFZgCN2lCcHXkhAE/OofU2UloZtwXoyOyU0EltdXTA3lAmQSH5Jw6POPy3/CBhK0iNUEaD+MjMOg3Hf1bHTUkfPh68s5M+9VlgIUp14+pmOgP0HnG6jGLNJH9bicAoMuA4lKQBLOOz080T5QWm7quMzt2PS5cI6qXl1/wgo3B3kwVG5CUPgZ32Splnigp3Tgg2QmqHD0RB8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 822ee7f5-7911-42fb-0117-08de3d112ad4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 02:08:27.6624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yifcNhL64/8eDISjQwxLa0+ehj4lvjra2f3+rTuP6n00wi4zK4u5SGuePhvLfKAhqsQQDWxUBtwniHRJbF1hpAFlatv/NsRK2P/Gh5ZhZTk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDAxNSBTYWx0ZWRfXyHt/4oCbS7JQ
 Sn7AsmmOA2e444ZcuRvCEeyhBD183x+EbWWwSqwdRRJUU18H3YHnrYk7HOfTMu61wDb8fwb7htc
 7VFVGx4/xIRwKLhrIxZep7U96n34Y/q6UDckuh0IMn2jZd8Wh1NBdrCGzqz/ohBNaxowLe3c3lj
 H8bEBZ9VfDYN+4FL7pZ/ywxF4BMo65R/PTF3rgto2YeFu7bkM1biOf+lxlKvrZo784520C8R/nF
 8bE+56VShV2kJ3KYLLiU/Ty/L786+4D1gwbM37e1fPMX3tPxqkDvnIJupqaRjTRuZZl2rVFD3Ll
 7avPlmrkLlw7HqpHASD7HDryPMo/oZzLeZIl5nqHpGRhM0p7jR5Of/1XdD8g3rH9PC67amC1j8t
 IG159mUAG0B1wNI/uehQTVouPqWxXQ==
X-Proofpoint-GUID: HQxs_z5BI5u3HNzg09pzOTJhKoqyYlVF
X-Proofpoint-ORIG-GUID: HQxs_z5BI5u3HNzg09pzOTJhKoqyYlVF
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=6942109f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=w2h7RB53Uq-13jtNowoA:9


Gulam,

> Add the emulation for REPORT_IDENTIFYING_INFORMATION command using the
> configfs file pd_text_id_info in target core module. The configfs file is
> created in /sys/kernel/config/target/core/<backend type>/
> <backing_store_name>/wwn/. The user can set the peripheral device text
> identification string to the file pd_text_id_info. An emulation function
> "spc_emulate_report_id_info()" is defined in target_core_spc.c which
> returns the device text id whenever the user requests the same.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
