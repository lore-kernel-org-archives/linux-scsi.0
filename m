Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A406AB8;
	Fri, 12 Apr 2024 02:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712887538; cv=fail; b=C5YmbcWI8w3NAfjaTYmIb5AP6krsD77Sfo+T3hrcMzewc01hwyDCpRd1M8qO3n5pzoGWHL5W7JKZuk+eI4bkB290dWSSp9oQfn3YXUZOVzyI40rapN4tHEbIAGcsDNctXAml+6D5FZADGkbz2mEgPuRyv/OyzFas08GmCrc03Kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712887538; c=relaxed/simple;
	bh=8CyA4AE0B6QjnFJJa5bvz/SryswBwApuzAnjdB2LNJc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Vm1uPwd48PYyW7HbhgikaqzaUW0Y/cJL/yKUse0mqZdIUWFUUB7/LWvuMcuqU13U52vxsWvdUCXIyNPUKkOWzl4NsZm47leSMlyWDwQNyTSnq9IbT7R1mhD765/tMuu8A4mM45jsWCy8SW+m5+89siEgVPLXcNZ0cfHNXWg/R4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IqtGGPe1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kbNuZ0xU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IqtGGPe1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kbNuZ0xU"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43C1l0pX014010;
	Fri, 12 Apr 2024 02:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=EdxnpfslDeoeFwVPDYuFuQCaIHs2QxB0LK1h3Kz26ME=;
 b=IqtGGPe1+Bu6G2MHn12w9IyMQjiOptwUcQ/I1Y+WNjOr/VVZB+6kkDEJ1MGXvKPrbmuE
 9RJ+L8b3O/yjhNXVwqUK7rZrcgaTwo+/T89B7kIvP4uKbPyyjXsx3yARRn0/AKY/jwKH
 xp/ooh6SRn78/ms4QJm66pV4OMwlGUwYxDtPxvIgCAEAraiyM2ZDSclBzMbfivZ9Y+wm
 olEyGl9c2Bjqf9vtNeMMKkgwdSEUIp6iho12LiiL+vGGiaBgCQCkrTHSyJO+o3n4/XHT
 ZTXwjGl7ULuJ425P2HnhmI0q2JLafn+mTAy7+uY/0zeRu+uOgUloS+/4ansT/bbECRaj IA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxxvjwfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:04:44 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43C11Lf2032952;
	Fri, 12 Apr 2024 02:04:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavub0140-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:04:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjS0Mj2OCueSiyZEc5R86TbkRvtlz1e3ZDShSURKyULgiP6P7rAHy9lUVNXLqf3y8VMv9kfad8M6NqC6DF2/FODz9FqsUw3GOg9d8ukW2uk1ncq2PFnVARyiQVJ2zxKI6SH2qhkVKSKY9P+xqNm4vDKtTjw/dlhZKbR3YCgVCcndhTh1LjQRxoBSrOQmetA7hgNmGopIG7t1Gvd8U95vpnKbHXugLiVarGO5ffkTIMBCw7j7a1g6Wo4r/hNuQqfKLBdgUneTBSRWlS8mbpKMPbAG3ikOVzKg90y2yyaifwhucd03QoAiR4QKFl1EOyg43/h+cLdiGtrIO62zRBd3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdxnpfslDeoeFwVPDYuFuQCaIHs2QxB0LK1h3Kz26ME=;
 b=E38SqoC7vWqtTbVrmor/rzxCTXqf5r1CN0eyCtIuGsKkM3U7wIrNOfFZIV8n7Mcop+PN1KL8S+SZvuQ7CVdf3yKiv1J/t+Xd+rlWCEQrTRCZ7tvWEZmX0zUPGYHEPWrQqGqrvzLFH7shs0cmVCm3mjyUebr9mm7TgX20AwEfozQcRdZYQtpfr9YBG4cuTb154ydg23fkF3KLCBrjI7XICgqfjdAQVoM3alQLNi9Z5tLqw02BFlqZHM11OrgTejg3iT+F3dTQGCrImd+wYJfG2XhTl8jy2joExHnn4sgck+eRI7n0Pacizxm0/+KvgZwLjXZ1e50hCh4KRoZ6eDDqYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdxnpfslDeoeFwVPDYuFuQCaIHs2QxB0LK1h3Kz26ME=;
 b=kbNuZ0xUt7UL9QfNdMAz0HTyAxllTJabktD8OcSnBQCIEygSbWQlBml5EBXJc3FVuKSgdIGrCov+G8Fn5yZuVNfeRS1mWfh1QZTXjBVVl3LmQLi2X9nz/mlZw5Y/ZK9EMUO9EdtUoHef+ulmM19I3/pA3cNjDkrGQAqm3zsh1/Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7235.namprd10.prod.outlook.com (2603:10b6:610:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Fri, 12 Apr
 2024 02:04:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 02:04:38 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        Takashi Sakamoto
 <o-takashi@sakamocchi.jp>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "Juergen E. Fischer"
 <fischer@norbit.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        HighPoint
 Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler
 <tyreld@linux.ibm.com>, Brian King <brking@us.ibm.com>,
        Lee Duncan
 <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth
 patil <chandrakanth.patil@broadcom.com>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alan Stern
 <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
Subject: Re: convert SCSI to atomic queue limits, part 1 (v3)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240409143748.980206-1-hch@lst.de> (Christoph Hellwig's message
	of "Tue, 9 Apr 2024 16:37:25 +0200")
Organization: Oracle Corporation
Message-ID: <yq1frvrjpzq.fsf@ca-mkp.ca.oracle.com>
References: <20240409143748.980206-1-hch@lst.de>
Date: Thu, 11 Apr 2024 22:04:36 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:208:32b::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b6b6c25-3e31-43b8-dd85-08dc5a94e8b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/ImLjsf07dXLYqrQPcSeqy68C+OvurE+gaiT4zHxC3YWUoWGXTgQvvHIfrhEEHY6NLPW3xLG7G4thG6UUZdCFbCTLp9aNs9wbtOmoroKRLnZL+UGb3fSAzuWDjwd6VW+5N9/qiRIJb5NM1ysR7xpAiv90BZwh2yC3k0x1avApch1MMJS7MS68K9QiuVmEQ+etdlgDDTujJ7YEttxmn5CRvCTAjbfarkJd3NSdn1Huh2pkL4mDXgKh/b97bs9/yOLs/+OekUXD9vTT8/p9O1niuYcV1u7UHUIa+ztB+VuSgALBon7mOVg9SeZRA4Meb8tC9LYCHp2SZAJc5o0p4tk3Cy5AdscW4mLTxKwRApY+21AX2ZZRTHTEJCogh24m8zGeiMjOAhK9JmQN/R4yuEIcPKmeNxt4H2yNovl+XB8w9CtI0TiHFvSU6NyOAX1eaR7zC3Wz9yJLPxT7IJIAXF8Wnlit+2IocTXshQ8j1EkIpX+VJ3Ezuz8if9lc6P5PZlbQHap8xkd0u0ciIPIGydnIvwxbbponP17Eah9HOLqipdHKRRm5X7oHLhr1UErTRINCsVgxhpB1eUeLbE1X+EkK9Qm4lASMG+bjP3NBA5vZxjqRZ9CN+htPtbWGJW5KKsWAdapeaE/go/JoUSekTNxZaj116mKFYV40Ly9R98i8Ko=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FbdWRDs6Vp3Bv0tGv/TISXCgi+vn3QGOg4pzhJbH7qapUC7KoD6u48mwR/q3?=
 =?us-ascii?Q?W9iqNCzuM+78meGS/GfYusX+NrarKNy231TJQRoILbRJfGGIBXUgRVM27+jF?=
 =?us-ascii?Q?3NUPQsWXAj/iDkITqIzcgMZrBZw7rwLyzlqGbdKkUOYGSxlXy7+MPI56B1XV?=
 =?us-ascii?Q?7F7PlrbHDIyw+eRza78we94z/TPdom4n1jRrFHK9mGQAmIvoBS+8hsT11wd9?=
 =?us-ascii?Q?EKXTVdnOOWjVM2s2cOgIbwJm3MiGrqSGMh8By994naD9oPD/U1NViYu+mTtJ?=
 =?us-ascii?Q?8irjjv0QrjljOsmabPD7fSHU5llHGduxcAi5PeaOiKjqV/afBP8uyvNlyV17?=
 =?us-ascii?Q?OVTS1Q2uJyHVxj3L6UPeoqSD2TBIdkH8don6Apsj88LZatWjkbbUQpgttpgJ?=
 =?us-ascii?Q?pB9Krp8EZNFdzkmuyNWZRL+0vZTegwzycVXOgGV22QhITqFTtbCnyJ2q2N+L?=
 =?us-ascii?Q?rh9AEcBdcCkpyNJqwYwrCr9dgU2zqFVN/Y2lypyN8YfjY202u7rc+DJPztSu?=
 =?us-ascii?Q?gk3YmPEAHzKOEy5k0n0wpC0e8o8EmL+vZHjV9u6RSxKXD91phhhxGsjWU45R?=
 =?us-ascii?Q?zgix6x1DdOw7h53+e1ZXgta+VRD6BuYpaF3FK6fCL+QFBpi88QWdft3A71P/?=
 =?us-ascii?Q?lVbTfiLVdwpHF1If9/0vaiQxTjW6XnXGMoeuH+t4Mql593iZvQpb7Hpo5Au3?=
 =?us-ascii?Q?RH/69/w6o3UwlQd/a5azi4qiDQM7eKA5e2njllc2c9K+QBD+xnvbVXa6eBk3?=
 =?us-ascii?Q?LZyMh4RryWtPWKxFoZwwrf0bUiUj/0PHA4whYic65WI0zEW/vE58qDP91Bi7?=
 =?us-ascii?Q?Rrf1rN6/yHyCimq/B2VoXO8MbFOmJ684LMHavDpBEMdwg5DNXbC3P3xDAC78?=
 =?us-ascii?Q?fLxyvOh5DXo7xryeB9zQ/etJVnizkl9bpA2wPPJIdjgOZiHfCvq26GSNG4l8?=
 =?us-ascii?Q?kzXYDa6EQ5raiW9SwWlUdt4EcDNeM9/ujl6oEFHE2iIiRIQQx2mdjaB6J1F2?=
 =?us-ascii?Q?esCaeyxtj3b61rbYyHUbxr5g+fq4NREiDi7invZOIPVMRmLx86lNrIUraX1V?=
 =?us-ascii?Q?DWQ1LNXN1CjNEYuDPDzaViTCdATWCAhnQJS8JShIwWbTm3PzE3McDinA3ktP?=
 =?us-ascii?Q?s4xTZs0yuRRNi8maDD/elgh2bET9w7w7tEkL/GnEiJB12zZgrzK71xSFz8ki?=
 =?us-ascii?Q?a1DG3zHDSVM4dq/6DRg+VebwKybPNHRTKmeBztqTStioHbnCgiGnu8VI1O0N?=
 =?us-ascii?Q?zVB2pzTYzfZuoUukd47OBZoulEBun7eMh5zYsPSE/a67CWZG8Tk5Icoa7iUX?=
 =?us-ascii?Q?0LyiJts2y636syMO16Ih3/XzArdTfPtELn0f2UAt6Rr0XzcIKwmBArMNJeX2?=
 =?us-ascii?Q?yBW9IWfebKfOgP2uQUAshKRgydnV42qk1uwaAVRJx4nFAweNndi172/LoxK5?=
 =?us-ascii?Q?bDE0+HiL5UsCRkbScn//SM9o/m5eu0o08EWqLoh+6WIHmvtrsxI085WM9qGX?=
 =?us-ascii?Q?rQaQrZeI5Z/c31AY2UrDqVhT9l+4bxomKFNSTxPP+up1FAgaCve/ekFz1JVb?=
 =?us-ascii?Q?U42bkAplJKnOKcrlrfEFxPBg9CgcZGkWSIJZP2U26UmkIYtx4+qeoOKinixN?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vGcnogD7ZUHR/d708OZdkKSk5WsDEiEmzfhLE92wNVK4+WKhTAbqhtiToRhXPWKQ4o8y03PkT53rjtYbqIDUQ0sWGmralKjJf0zPf05gTYHRj9T9z5eE9eWHqvCkH6Nsp+OOW6OnFmK4RD4jeCyY+1+VTCiKvZpFZdu52B5j9f+imjwoPhikSuMRYIkScMfl3K3xcHoyxMU0jIrIL7cGyNQtfgnIz7o5EzCClljiPS/8rZzDEiUufjL8JWPBDmArQLWAsylU9jN8v0zKTHSpc49UNK8dKzDimWZUh3LqWlIDy49E8wOFQCQtU6x3jlpRLyUTX+zqLKAH1D7kJeSdwSyp+tUAXbqMMFUn8YmktZLTHaaN+n3Xpr/ptQ/KLUY4ScokgupR++20nDriHzT4iPkhM2N7SOWBaQmfBE8I0sWqpxl+1Dacj93e4ItdTLTLPqFLfooFCXA96vv4gFgnu0U8gHtQT6nM660+4IYZYjWHeJ1gVfunoTfgdYLAx9fPGRs2Qi5N7KbYNmCFOhpsxnGgT8EcSaz8h7SbP1UU06yWm6WotbbEjsV1J+N6wMkz3N4NSH4zvN8UxhqLzNwQp9/lCRE2YG+BHBS+3zhx57c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6b6c25-3e31-43b8-dd85-08dc5a94e8b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 02:04:38.6865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCmk1nM+Tph4fAgqZDB3QGZetSrQrfzHKqD7YVOFOrsIejJZ1qHHdemuQQj6T0sKjK41KVn187GB2l+vs+8TAlORhVMm+O9c4NqQDGXrQuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_14,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxlogscore=890 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404120014
X-Proofpoint-ORIG-GUID: -TepMX39G2yArEx8qeLyy0zQpVF6lL8-
X-Proofpoint-GUID: -TepMX39G2yArEx8qeLyy0zQpVF6lL8-


Christoph,

> this series converts the SCSI midlayer and LLDDs to use atomic queue
> limits API. It is pretty straight forward, except for the mpt3mr
> driver which does really weird and probably already broken things by
> setting limits from unlocked device iteration callbacks.
>
> I will probably defer the (more complicated) ULD changes to the next
> merge window as they would heavily conflict with Damien's zone write
> plugging series. With that the series could go in through the SCSI
> tree if Jens' ACKs the core block layer bits.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
