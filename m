Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20F638B7A2;
	Tue, 10 Mar 2026 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143411; cv=fail; b=Kk2CJMIycLDaRIysS9lA/2UQmCCNlGojurQUbvRB8L0L83tJjB4LZtNtAhwGnSJCey2mJJ33Nb0KmC5lP70ZHM5FZBjxDADZsZA2UVGATI6+mtk4SShSuHkbqwdLveZ/tDQxCvfjSFgc7aWz/fR6+bPBYWrtZDDYApQ/a8xYbrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143411; c=relaxed/simple;
	bh=Gf+VFKEFWhy1azdIVE2ESqRHovNY0JtDccCUmagC4cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LWv6fI1tiEQ/tZSpMOlLz8c2TeMLysGeN4N3dQ3NR0kpb6i27GXGz6j0RCsUgvz7x1P960xZVsCXKmmpaR3phe68Yduz7Dpa0LHG91py1Qx4H4Ntn1xJxdTRcE4SXvDpT1TDd6SMRTHOAE9879N6xdhxiGCHmo5Ay4ZXAYsIv2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PEsh/i10; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kFrNuKAy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PEsh/i10";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kFrNuKAy"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9ovqX1719663;
	Tue, 10 Mar 2026 11:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GF1l2qhVk7tpbiedlk77pij6CLCQbocOLn5SYO93ZSg=; b=
	PEsh/i102WMifeLTXWNhk8lpPLURr6b1Hxhnk73OC29cll38Crfci7L6Lhbkk1ot
	2Kr8WlITDIhHRhhdPmKFVITpnODyBRtV2lAcZszrk9lMS6DVPcRFwiXjydle/RF9
	1Log8zQgxUIddEYIRMVDQOZnUT0vXjHFDiiYhogGU27Pyj0RRw44ecytudTpinkP
	HEH7mpui3v/zTIvok5FYKRro8fYRb3kgHrLBopGJeONnsHedbDvXQeZOQgurXDj1
	Id8USDnXT23RDrQKCQMdm/nzl2TY5j4c2LCY4yQhH5CU8HUXNBpdxD77bTjwDpn/
	E3w5ON9tjEZPwUxYsNF+vg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cskyp2nuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62ABQZDI007766;
	Tue, 10 Mar 2026 11:49:52 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010033.outbound.protection.outlook.com [52.101.193.33])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4craf9yfvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 11:49:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rORK4K33Jru+nnXPIhIvyTIIIGVqmMYPMHqjEdYQHAdgHyRjuFHlDXF2n3Dah9oc1TFg5lP2l5lgHFkNtlimQahy3/1HAIXu/tvrzmcc8IqjYCfSGjcyLH558jfz8ebs6nIHlWIh6LyApGfk4+AgDgpyZ5EMAdcJR1rBV6B07Y8XGUTmFMqWwc7LQthf9NY25VOqZWPF7GBJ96jqF08Ymw7/4AazcrgqiZGxbEerHjYqFRhutm62QJTRNLaZVNFgh/ZAIUDN4v0AKPlRr4wV40iNHcjlQloXBYyo9h+aJAEW7QJok0Jq9VRWUJfO2apXP7rnteaCWoXQymgaSxRQZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GF1l2qhVk7tpbiedlk77pij6CLCQbocOLn5SYO93ZSg=;
 b=uGv0oK1vf+a8D1DnGnujP03uHbt5ovHT7OZdfgEANtvtYRx2r4EQRr/+l/t8uq2qJffKIErAR2wLq8+gQa5ZKsUhqgUvYYms2yKYzqycriZvY3i7snKS+1rFPnlwN9fiZiHTQpGMkHCrIYKlr0n8FyHTy6SzmmHAQ4Lvi+HPj4+b4ElM+qgx/tECdyo38HS7FU9MhpSkpIiz/32G8Kv2rdg+Mp6Z2AWIadNyzgYtbwnpJq+t12SvasYnjTxe7aQvvOUD9gbv1nksHfQ4Eg76qyKSP1aVa2S6E/jxo0hnCgrV1QzHo8st78Eq4480UH2Yzl9t+f+4l3vLAC4dmBxfgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GF1l2qhVk7tpbiedlk77pij6CLCQbocOLn5SYO93ZSg=;
 b=kFrNuKAyECsCeXsJb3tQe4d8XCmqny9OJaneNDCr2F/vua4EGkk/aZ+X4ptuqbFpPMwQoNVW9Yce5qLJQPPoy/4Ov0NHLrkCcKNwvsgbFydzbjZCllBRaptZS7AsJHBjY2130AlzP84hZXLtdbml3JtW8563J6HhQ/g6X5tgmog=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS7PR10MB5166.namprd10.prod.outlook.com
 (2603:10b6:5:3a4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 11:49:49 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 11:49:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        bmarzins@redhat.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 7/8] scsi: scsi-multipath: Issue a periodic TUR per path
Date: Tue, 10 Mar 2026 11:49:24 +0000
Message-ID: <20260310114925.1222263-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260310114925.1222263-1-john.g.garry@oracle.com>
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::25) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS7PR10MB5166:EE_
X-MS-Office365-Filtering-Correlation-Id: 49054e3c-30d2-45af-9d02-08de7e9b2244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	+dcLZGJwwJ1MyL1jKhP17JwHz9OwMKlIG1fkFfOG1jEGKSL9Cj+Hwnn34EaJMY+xx/nqJVY3/gSN4Tc9xZA2cQ2N6mxj1vnaTSzDzkLSGc6zC13cVguo8t1ouEECFbCOK9jB+bN2nYieMQufcPHD8AjncZwWQ0SdZ6/pbfh0/yuxbBgQ6mbv+MImal0jU+ylj1C4PDgqMgr1e92x+ppMAoq7sZxG32sGG7YvAHxnGF4/t9kK1ViC93+tw87TkU232GnXf+yo2D79iK8pW4eSYXcUWtl0K/cIpWdA6GWaWyGqsdCMCOiyqDpPf+eCRqWx0PrE019OJR2WNfggktU61WmNJMYXtmAFJPK5D1LcWR8wd8yiqEhAJrk05aQvusYlKO3H/UsfHOFa0IGDkDAJE3PthwA/V2w6eSchy8VB4TEjHD5IyfQN27k2Mxq3Id6HocSjvs9lrHC5567Ca0DsHycfgV3RFKZE4WYd7uXZQ38bokc7+PoUosG9ZjcugYB9REsyy3++aitntjYQLDaGt9YbE0GiIXU3PDArL7XnYIQL/Wz3mxbGPgi5f0Mbu0cLNXY4ZY1+yHAf/Dib08GiGMjXQ4aBwUdWLPwQsOqns1E4GZfL/xOurAWm7iLPXixZXMMaxtVwZokt3swz4YXRTIrAuQb0+l4dikrQs8fJBZxq9o1UngL+S15g8sSQwyIXNIdFBPayKHVI2EDDx7B318nT2SvSD90t/Z4EQd4szHY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bjZqLMsCI3WBlDZeS2b75Dk0+OXGUnm4PAEN2+aX6Dfr5K8k3np4fmXzhyf/?=
 =?us-ascii?Q?exub0Z3+xMyw0lnGd/pdiQWrwM0Shp80Rx8hsPQ3xNvcOx9P5Esjga3zzBVm?=
 =?us-ascii?Q?/6hdFHaCOBBtgNkbke8XJW7jHc875CBobtYn4AjFaYU7p0tC+9hd5yL12YHu?=
 =?us-ascii?Q?FecYj0CVFceZuQUXFcfidbCgdINGxgJYNX5z+n3BXiRbTaYD7Kal08sDqLpu?=
 =?us-ascii?Q?jwy4iLT5eiGoROquB6HUNreN1yjEIsaAnKmqlgYxcnOKfZSEwuJLpK4f/mZ1?=
 =?us-ascii?Q?uV6cVPGaZ5DqXNGuBM5AHGCCaqhklTewW0G/2HNOk7aDQ2t3quo7IN6MDAsm?=
 =?us-ascii?Q?6IdjnlTqO5iXJUS/ejs/IF8vHCp53HMWs5yfGFQFVmD4X82Z0CQ+nBLoX+rt?=
 =?us-ascii?Q?DxGDBuckyFcFD1Yxj5+eqPcaOIAKLIEDrslK/HLiPCl27EtY97yGexifyu+Q?=
 =?us-ascii?Q?JPX7yXgZZqbxn741vwheQRaX9DVgRcwWr7qVzAAPQf211EFZf6rB4JUXVVW0?=
 =?us-ascii?Q?5mkAC0xGyODFodY/Uq8tjb2VJ/2NaE0Iam2InltOrOXr+AaY8x5jjSxJ/zLD?=
 =?us-ascii?Q?JNDwFUoK7m0oaWFKjonRdB279FZsXVKaJaDfxAcblf1SwSJhGt9rz0S4Jxe6?=
 =?us-ascii?Q?ZY/fmK8vM6CKjLMNqwGgCB3aKXuFELGP6Io7HQ2nD+mPFlS9KGusRlPv3ZmW?=
 =?us-ascii?Q?qcPxZCKLgGkjcseYrTsc3bM8gcORKO483AwotsEGrc9EWkxv/2jbljAc5Cew?=
 =?us-ascii?Q?Q/gbRwY1ao+tMfNchLsrcC5SlxlAkxhKCYdDmHPRI/yCf7n9vD7u056QOjYt?=
 =?us-ascii?Q?EOAwhv/MGjVX59Hz+32zmlo093SQptgT5KP+3iQzq/ObMnNOxKFoVWzhStl4?=
 =?us-ascii?Q?15PRWMCjtMCon8Gbh/u0isBuo8rPfvtSoiG9U+eg1sX/I2zL1oQy2o177Bad?=
 =?us-ascii?Q?jgujZZyDE2BtOpcZGA4qbPKMwDYiD0v6q/6t3Rvh+WUT/qU0LMTLSMtGHuPu?=
 =?us-ascii?Q?yRZ11bq488jQOJT1RHQu20Y507yhEeCoYsh1KhFD8HcjMoIbkP27zYhVB57G?=
 =?us-ascii?Q?ObRG4pBxLqS3a4G/v08oHncXi8GJf160G0jVOuOLQn1jDAPf4S/jEjK9MMfV?=
 =?us-ascii?Q?QdUIKgXP3jfuwnYtk4zdND0wanARqGxKeeTViB6LykJY7ExS6+fAUf3rMt1Q?=
 =?us-ascii?Q?vne+9rY65zSf+lmnwufXjJrrjX2WvII9bd+4HnK1C+va+5s/XTz+uti2Vfro?=
 =?us-ascii?Q?5iYjWqZPBqIB+SZEOB2xYTJzsDlt+XbuMsHuqsJUmX3NgAUC5mZ1vQUG7WbL?=
 =?us-ascii?Q?3M9AySpbSrsyFS0HHliEQ8G196mFY+oRXNvc4JgwouCSBb4MUQOdPtp/fZZ5?=
 =?us-ascii?Q?20I2XCVvQbIf+r7w+eAaF6PJqS/56IG5Uo5PAbXPgR7khWsrnARYMy4Bguyu?=
 =?us-ascii?Q?uaWQTLjL0jKUoGcwo7y9BVv/28MiFMrFFw5OIvr8rq1W1GquGBVHQQUoPesS?=
 =?us-ascii?Q?6n9raFwJeBAzaDdW7dBXN2nNdrLnzZ91BcRVz/yX2zKafTgS9XOD/8oNvBv2?=
 =?us-ascii?Q?Oow+IwUgu5N4roW0wbLOil6hPZz7sksNEozHxUL00Lwh16k0z60LNQaK4LMp?=
 =?us-ascii?Q?jHbE7qkJOxUyFXUR2J1mAOiVuGXq48zhpeDPWqRg0UuT2sh6hrgZvtGEjTET?=
 =?us-ascii?Q?PtnrNjCV/HYrEVXbmWMm8M1VGfMc3vEomi0HSV3hPF9l1MXfCEV2fKaVm4IO?=
 =?us-ascii?Q?7U+K6he1Wg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	YI1S1pg6gKE6/QeNWiRdiaySLQYcRT3LMC4sv2YrvWF3YYAcrU3GMzqjU2tOgSg1ptQiUMdTY0jUzHunwu6uY+LQOD016WPHYFDUUcTYUm0bRrL8CMBxn3nGJyC6gWykcgsM5lHBIC/ux3NTlHgCxXkyyOuJZVCjfQUSw7l7MWoWvHbawJGpOZ2bZMP6SMiAlMQCJuIeg2lPut0GB2CbzAVM6UtXnDqKDPmrRTXRqqs1aJtJnoakWj6dl3TX8mNHstG+EtjeipYfgpx/Hz4hyS2FBGV2tYdF8sXHCgDohdEHthy6RK6tFW80zSvEbTuONhkE2TUEaeIag6A3NVY6XA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i3jK0w9cxV+rnV8Yz3X0Wx/T6SsMYQ4lp9q9Q6hxL0faxQPpHcBsaaveJm5kw2EivLGnuhJR5m2wqINNcJtd6QGt8pYpTok1hkv9VBFPqgYIIpOfVxG2lS3ahygJJC4N21owUbxl/AkxsTYE2U5IcU0ysjBelcluDP/4fmH7WA5zePEhLX76Q61hcFbGsY9OKk/bXZlTO2/g16KLSuYD2ROBX7SQDTkrkEZCcb7t7FXrZcdAcNQXmjpQQJZN7ECpQ6mcCynXJxsDbL+Jpn+CCOBoc3C0cC6k6bbYSzxKi+HNnS7iw0qCqjxe1+8qaV4OFLFa4W3W+f27NyOEMsG0ozQS1zJOAziLzY82RYX2UEZ6Krk9Nbue2qIkepSAdLzbYdozIFsN77SrgueuAAjtuSQ0xSwueBKdNwQy7/i8BVAk07ShfszgIikO+NSGkzFgSmhYjxsvt1GRJMeZwvNmADboDPn21ccTq2n7EAJgcznyM674ChCDVJDO8/yd779rXVQxGL3x3D7gtYKaQ+yZyfcmZfcZJPBu+PkVgYgyg4bFBEBIa0t+IEgtpAUmY7d+kq0nxgLOdvEKgqADTfdmDaKXyZ+AfsKmRuSsoab0+W8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49054e3c-30d2-45af-9d02-08de7e9b2244
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 11:49:49.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEuXu4IvtYEeth52qAO+y65LrTLFZ1iGbkQpnH+IoqWnslt7J7SxW2zH7rnIamdI1f9jyZco6+MVGTvf/m6z9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100102
X-Proofpoint-GUID: dEHFXwj8NPrf5ez5aGazaQYL-TDAHe1f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEwMiBTYWx0ZWRfX9FVX5U7+h9dk
 Ffyk7Ms5pU2Erpcfb9PTb4zXTdIiVjwZVdy0deVlPGtA+Sdg5byPtN/LqMSiSZ39cpDHQ6bZwUr
 D19/VKy/vWkbsR1VIKu17jjLj2XWb1AiG0XrISv5ehEMr7LuK8ZPuhKNV3xCLcg9akRu64DLkMr
 oFbk8SIBlmCaS9iOUBUT945+i5A+wgwuO9+cRs/w/atssYb1AhCraABUkG6xYwcWh6An24vLwVJ
 st3GS+kzgxxw3bPD4AjBAkhKSU5aFdjA9/gPJ/whOZfRy9PqbDzN22BBSJg3/wFnxk/elHxrG9I
 jUzeV76AoAeHLppRHRkgWl39NrWnrHwFPzFo8KxRZCmPTzpRSRZR8ak7k42bl+0A/KvQuIizSTS
 8kQSSsXQFotLPV0G7TnXZBEgoB2BcEdxxLnT0NyqRcr9xKl57bnYIQ71FyfpWfQf/kTIGdBdyiT
 83KpkqyRuIrhVVRDHnw==
X-Proofpoint-ORIG-GUID: dEHFXwj8NPrf5ez5aGazaQYL-TDAHe1f
X-Authority-Analysis: v=2.4 cv=XP89iAhE c=1 sm=1 tr=0 ts=69b00561 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=437RAPt7mZHohC6A0YAA:9

To allow the initiator know of any ALUA configuration changes, issue a
periodic TUR.

multipathd does something similar for dm-multipath in terms of issuing
a periodic read per path.

The purpose of the TUR is that the target can update UA info in the TUR
response and the INI can handle it, but currently we don't for SCSI
multipath.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_multipath.c | 36 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 37 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 0c34b1151f5bf..2b916c7af4bd7 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -4,6 +4,7 @@
  *
  */
 
+#include <linux/kthread.h>
 #include <scsi/scsi_alua.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_driver.h>
@@ -124,6 +125,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = scsi_mpath_head->mpath_head;
 
+	WARN_ON_ONCE(kthread_stop(scsi_mpath_head->kua));
 	scsi_mpath_delete_head(scsi_mpath_head);
 	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
@@ -514,6 +516,29 @@ struct mpath_head_template smpdt_pr = {
 	.device_groups = mpath_device_groups,
 };
 
+static void scsi_mpath_cb_ua_thread(struct mpath_device *mpath_device)
+{
+	struct scsi_mpath_device *scsi_mpath_dev =
+			to_scsi_mpath_device(mpath_device);
+
+	if (alua_tur(scsi_mpath_dev->sdev))
+		sdev_printk(KERN_NOTICE, scsi_mpath_dev->sdev,
+			    "%s: No target port descriptors found\n",
+			    __func__);
+}
+
+static int scsi_mpath_ua_thread(void *data)
+{
+	struct scsi_mpath_head *scsi_mpath_head = data;
+
+	while (!kthread_should_stop()) {
+		mpath_call_for_all_devices(scsi_mpath_head->mpath_head,
+			scsi_mpath_cb_ua_thread);
+		msleep(5000);
+	}
+	return 0;
+}
+
 static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 {
 	struct scsi_mpath_head *scsi_mpath_head;
@@ -548,6 +573,17 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(void)
 		goto out_free_ida;
 	}
 
+	scsi_mpath_head->kua = kthread_create(scsi_mpath_ua_thread,
+			scsi_mpath_head, "scsi-multipath-kua-%d",
+			scsi_mpath_head->index);
+	if (IS_ERR(scsi_mpath_head->kua)) {
+		put_device(&scsi_mpath_head->dev);
+		goto out_free_ida;
+	}
+
+	set_user_nice(scsi_mpath_head->kua, 10);
+	wake_up_process(scsi_mpath_head->kua);
+
 	return scsi_mpath_head;
 
 out_free_ida:
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 7c7ee2fb7def7..d30f2c41e17de 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -30,6 +30,7 @@ struct scsi_mpath_head {
 	struct mpath_head	*mpath_head;
 	struct device		dev;
 	int			index;
+	struct task_struct	*kua;
 };
 
 struct scsi_mpath_device {
-- 
2.43.5

