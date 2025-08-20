Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F19617DFE7;
	Wed, 20 Aug 2025 02:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755656319; cv=fail; b=frLsbhvwcgA3+/ayWTWCHdJTEc7cVSeoSIHtBDbhqeschHzMAc3PN74k/kui3F6dP1PGa3BgCylD1zNGBkgwDJGEjY42xpxUQmkJYo8bvN/35Zgd6kGhp+Ngth85OSn8kNdmBHqxcACh+Wfpl60IX1bRn3QzKIU58BMBBRML/N4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755656319; c=relaxed/simple;
	bh=EITFNwOGAr1r4qWvKZZYCWZu+9xIpunlTS6aDkrr+Ns=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DjyGzdOj5TS/RhflrESVkzJnFSe0yA0uq3LfGNCziOiZWzkZkpq1CVbgtCicz+R9ifBQiFn0cnO2W8YdkxVJplgEPQnLdNROD9ZE4Nxinb+06R+0eY3+HDwtGlrdqbxA6xl+IxwpfX/lxMkvsGZo6UL84QSrMKFkBbpIppZCN5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=evCa91He; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ALFAlKOX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evCa91He";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ALFAlKOX"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBq53005456;
	Wed, 20 Aug 2025 02:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RagXxQwkuGWMIaFYFw
	SEFWfaj3nZPdLc9rEt+fmwsbY=; b=evCa91He2Ql51qoPrNy01jWntGowFQvNxo
	UVb6RfVMKArSZ6vtm7zf6+7twsPkJbF/0oByI6Esc3lxR9nwfJ4L3sYXhK2J/PG+
	kJ5zzIP4k/FGVO+3eQOTc4oVSEUrJxAqUwrgkfPQbVwUMTCRFQaPlNsPRvak69oc
	Hmwy1lPRklGSQIt5gIzrwoUp4qY65nqTtW8TkpQNkw3R0w+kHDytwsB1qCWcGh14
	ytDSEz7LgqT0AwBPKidbuu5pjGEDXr4lQAvoFq8zfofkCLWyYbV1FUoMbwtpILCY
	rMugYBJ3/PpeEwI9GMQp7guTOVuzkQnHmRhxdiTHofJJxDuygtPA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0w289ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:18:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K1wS2T007232;
	Wed, 20 Aug 2025 02:18:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q3sjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:18:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XNjZHPEVhfhRLrLN0y6mMxdPHkGjjioZyDn3FoAfQCFQ9D4ahGVX+JogM/OW3DzvieN9UBIU9cjxWQvTe+hNtd+UTJQgqNzZK9kKLbw9gtSql72VUctVPlz1CfH6ZOscidG6uYOhsvvxZ79DQAO4/Y6V7rJUXEo2LNHjpo+yYFakToSZvo3QR45JrBG6oCXx/mIHl0xt2pVL6/ikVamYCzR2AHP24ztaiZIp0UlkSYNk8jRUVV4FskRUBC69GS693qpeKgm/2nx0MnAD2VnltsFaiKx+gOyRhkaBkGhHXu3heFnbTDeetBV2NlSkr2vMtjTh0XMpIbK4VntDfdcjOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RagXxQwkuGWMIaFYFwSEFWfaj3nZPdLc9rEt+fmwsbY=;
 b=c3aLdOK6xlAyJxmjBDWgzSAshBDf8hBK8hpugs9ikmDU/g4QqiC9z+vUYGGyqepA607sAAf09v5DJLwD9ufGauqh4Q/52/uHYF0bWt6JA1s+3Mj9Zl79Z8SR2ekrL2lpT1ji/tNpe9G0pw818rr2IpiVlZKURD0AfFG+3fkUVbo+7LQzM+VcN+PvHmTpo9itXC/u1yvzEMSGQCq1aJ0Pl1bNqItaV+IKFve4SfPsuaNdkEwWgUkcCiqxpbUFHoZARI3o4IpyGb6mK4FJhcZQTND3JR7X7GjDxmZenpKNxKHa4Nq+sAiZ7t5k+1p1jX0cQ/4GgllrKaYLXtwio4w+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RagXxQwkuGWMIaFYFwSEFWfaj3nZPdLc9rEt+fmwsbY=;
 b=ALFAlKOXNnhLlh5ojI+VWhKxy1zqOum2iOwJXvQd0O+f8wWCsgqNDw4oxx9BpISCV41g/k38QRfiJ46104+AS5krbml/2FsV7iM2vVHS/pHaRo3x2crDZXZcRYzipnAIi5vP/zffQUMz6gQwWeNEKMYiZOPYGU1FjefSRX2FlX8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:18:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:18:09 +0000
To: Bryan Gurney <bgurney@redhat.com>
Cc: linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, axboe@kernel.dk, james.smart@broadcom.com,
        njavali@marvell.com, linux-scsi@vger.kernel.org, hare@suse.de,
        linux-hardening@vger.kernel.org, kees@kernel.org,
        gustavoars@kernel.org, jmeneghi@redhat.com, emilne@redhat.com
Subject: Re: [PATCH v9 0/8] nvme-fc: FPIN link integrity handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250813200744.17975-1-bgurney@redhat.com> (Bryan Gurney's
	message of "Wed, 13 Aug 2025 16:07:35 -0400")
Organization: Oracle Corporation
Message-ID: <yq1frdmwxdv.fsf@ca-mkp.ca.oracle.com>
References: <20250813200744.17975-1-bgurney@redhat.com>
Date: Tue, 19 Aug 2025 22:18:06 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::39) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: 14fb25e6-1bc1-480a-2700-08dddf8fce2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mu5Ssjdfras6Ft3vo1fPxEPv6w/a/AhjrO/eSSeDkj/gSkNYlaGSiJnj9ULA?=
 =?us-ascii?Q?73A1NWtmsjHFDoWeqkp8YzgUz0YyAOoskO5vR5ef4f7JaZtCtpJmHPhxn+Ch?=
 =?us-ascii?Q?6JEFybT4Tq1/k2I4kv3EHH9/U+zttTcGyMBmW45iIn2ZkksSF+zytSBz/xZy?=
 =?us-ascii?Q?tDy0QFaL7/lHUyfjwMfmN3K//Ag+kRkOwPoN0JCIxTbZo9dAaCTtIirpi8Io?=
 =?us-ascii?Q?XTRwI3THFf0mE0iT/0vMTvpNmTLPugPHvQbiQLnTxF50bgyiupcAMktMzoDs?=
 =?us-ascii?Q?7Z2/o6DKLDGUZ0yoVVUvqtjRFMvPNwkno/nmg1NRuTDStgpchR6PxU0PNUYp?=
 =?us-ascii?Q?vsAeT9zXZaC0JtTjmnH+Zv6sByDGKLlf65qn6N4Ij2JEwTY44lYIY4lCAFng?=
 =?us-ascii?Q?UGPiSxWBC1yJXE7iYCtcV6p/XRVnrgMh3x88N9Dt4/hTrnU0CyMgrFkInp0N?=
 =?us-ascii?Q?dUWc9sGvb9ncV5QEIO0wRThZlkTyqT+YPsjBeM5sap7hmBt7+cdW4NeZakgc?=
 =?us-ascii?Q?csG1PMPjOdtL+FOXSrDpazSmO8srsgfFwdiluNq5Kw2OqMe8xDew/MIpZ/KV?=
 =?us-ascii?Q?rwbHBnS6i2ITf2KbPCWIr754wpiz2akRekiETqjGnm2on+txPceqftJ/6Xe+?=
 =?us-ascii?Q?Ryh9jeVd2WDo1fqiFLw9lUgjDLAD6bowMu7SZCc/lMJcdzLdlmmFxGuKC+Ae?=
 =?us-ascii?Q?HqEe6Wt3zoRhBxbOziXcbZskfjHLUSZEJkSK9rtP65zTMDEWiVNqIErPYUem?=
 =?us-ascii?Q?M6qRBXjAceRz1y6ShLs2dxDdvKMdjue729yipw+p1bq7bzlAVx8jGqkg2CLo?=
 =?us-ascii?Q?JIFWMsThSK8FQzesvMFmso5WJck3joy8iv7pYZOvZLkKyvJabFolSVVKO9il?=
 =?us-ascii?Q?fk5BN/WSy5VXScnexkh9bslyy21LR1GalP8lgXxzShOo+Bz84+/wwvfceQdO?=
 =?us-ascii?Q?thY38CFdcg9Pg64/KapLVJpuQrB/ofy7ap/irB+MDIeXOjIHqwCYflxC1Ye2?=
 =?us-ascii?Q?m0HYUEFalU5zwhD/cOusm5LsS6/YRNLXCe2uxo0hic7ahfJtLIbmSAQByx4a?=
 =?us-ascii?Q?G8LBmI6DuD+V7mD+a3BZZX4ID8CBnQU2aBic722xIUQ13aUddPPi0enYl/3m?=
 =?us-ascii?Q?QPXzGhuUv3W2p8Jbh+O3ssxa75IRIzmHwmDNj8i0T/AMrSeqltr2YZ60XiVK?=
 =?us-ascii?Q?h9KjMPD7bFaQO2QFk4s39AuWDErNDNXrXtf6Rp0Oo4Lng51ylyAa7Q5mW5DR?=
 =?us-ascii?Q?7O4AWIceyayCNTdYn9BlfZ0hGHOpTrO5YHvjZMBHXdprnY9XmswhwkzKPE1b?=
 =?us-ascii?Q?FQa3czttdpqSY7+fgjbHJgBDIDcNlEand4zNh96rSxlF0PEAWjmJD13gPuzX?=
 =?us-ascii?Q?vpOMj6uVMqC+HT1X0vHmpBOVwCoCxIPRDY6yD6iueXsDZDxJWnci94FpOQ35?=
 =?us-ascii?Q?21WS7NEzEiA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mv7Jwto2wIpXQQjOW7+ezaLZGmUETtXRK86eOea5VL+V7DzZKWmyhY9u5wFX?=
 =?us-ascii?Q?UL0UnlcwQjsXWAurpD2CSI4q3rOv74Q+racpYM0xdmk/f2htQ91+3qkBknet?=
 =?us-ascii?Q?zyat3meHcTZ2sYC9Ou/lzo/ELFC1DDCsEcVDRplJlORtEmEEleG/B9nVxiTT?=
 =?us-ascii?Q?q0Zf8d1fcJvjHx9vjKxLGVFX/s2B8PmnvjYmZK21nNj8/54kQS4812cuA6Uc?=
 =?us-ascii?Q?08uyJzBbd6XSiWmn9tlIggvVUHqY8/40JxgDxUyLldRiFzh36PSltWY8Nc6A?=
 =?us-ascii?Q?S2vkcVPbzrEP2svhVxA7I5Lapbgmp7fAauMBEI7VIOTkLlmjyWUXAk0oyphP?=
 =?us-ascii?Q?b+CKpgDmxHOKzDfodoTrWZkXw3Nfp+IOpVeeBvRcmdrFCufLzao0i68PD98G?=
 =?us-ascii?Q?a+k8uylaYk+oivZ8vWlJjHrKTgX2gmR3Qq7wyZJE7jBZf1Y99ubz0oFLaeIi?=
 =?us-ascii?Q?PWTcmz8kkYVPwo0+r5RKSXd1TfIgKY3+HCOFbZdZu49e692odWxAk8Qrbx3q?=
 =?us-ascii?Q?/6tsn96SakUcdb9mvbrvDLzP3xaiYju7a7239TfYQv0MiNacyS2DJoZHi4Ba?=
 =?us-ascii?Q?ja4rgqcHi3sl/u4xgDLYxGol6ZoEFpcr9rQC+LUdG9KGFnufvF4BG/ehGENl?=
 =?us-ascii?Q?GTj/GspH9tt6IqFOQJ7IJKzDVIPqYLPw6eEsRqEhF6pMqowx4j5toN/ImA1a?=
 =?us-ascii?Q?dTGphxE7p9R84klx3E2ioJyMMhD/QkZNFVzMnXNRRwsDPcd+vitDJqs6ysmY?=
 =?us-ascii?Q?nHTzP7dP01skz3GYLu3nYNf7A5JQWBI1N62uWgIBNfr5KilGT5wkh9L5h8cq?=
 =?us-ascii?Q?P5wclHXgnFqUS+G/9TVvONgfa62zYjqbV2GKsVopUBFMDv2qIy6IH865x/1a?=
 =?us-ascii?Q?O0euH58kh+eG6zkHqUPi7UmCYX0AfEEIXS+zuJMm7X/tibFRkvNQMuEPZdTH?=
 =?us-ascii?Q?Fz/GaGCUe3bllmVw7wYJAayhvKjArRcgo3voLxEmPHLVzwJ5cOsFXv9B3Uh1?=
 =?us-ascii?Q?3ALjkFhIMMNTFw6xj653vJArm04W8uWzftEt7k4Ri2P7j+KYNi08waU8yZQB?=
 =?us-ascii?Q?0d9xLt31UCXPYN5lv+Fa4UN+AnYC6a6zk2w9Z930HJ/5iTQW8fBVf03WDgZO?=
 =?us-ascii?Q?251wNg1sKMTOIY5YB8PYVTD1vofcTrhX6Emn7N5ca9zq9u7lwDpbeJhU+OxM?=
 =?us-ascii?Q?flhQO2BFyfGV67M3cLOePeIkBVxO3p6voWljwPz4D46Kzx3wilxfjOjtgp48?=
 =?us-ascii?Q?j9Ue9A1dPy9g4Gjz18P7hNbsfjThpgqtVl3wqM7wtNZEuJY4B/AfP2NDUZMY?=
 =?us-ascii?Q?A1/OuWaLLGi3HcanUb4fTPQnpZRaJN6QWUbc1DNkHD4T/dp2vRlHPMVdUt+M?=
 =?us-ascii?Q?Drupxl7td5I3tfmXoZ4klXbyqHc66MtTYM6UOsa0+fSOcJphWeNES+SSZJjW?=
 =?us-ascii?Q?mJNnuqfO6E+BzBNO86oSPfwsbZ7y6cIvEDvZTTtuYwK54dtnipCSbDRFtmWf?=
 =?us-ascii?Q?6jM5KLPQPc/Y+GXVJLhlodMfe5OEnROinl0a57CCt7sT1LI0WOwch31QPAGj?=
 =?us-ascii?Q?OpXRptB0tZyLo9yNbPnoLw60fyVSz5M+vSZE+inRShEbxAeFx+ihOfWmW4cD?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jK2VcNd6WAOhvi1KVWdbSWSeaTWazk3VDXqKQ/6gdnY84t3CwyyEXaS1GLiZP145SCxER/IT4tWJy6VoTzMw2/33qU3+hPg+mHrCOz5RhDmn6GtRk2vrSNvMczaDMwJDpYFb4KDThE0DLKAoIEqE4/3Qs3HCCYRMqkk2RWJHK+3TJrzK/2WqlIcBTtNtBBBYtBiEDLLHBLdk4wzui9n6N2KMAwTXjxexHLkw9PVOt2LdA6dTCdsUn+sRmELdnVKI/BnZyp4W3uUOh47PwMC1u1/2XC6Q5ySMpeUd4eG4CV5OsABCAmla56qQvbnDlspfGY4ffTyH/a8Y1FH5qfGd8yunQFXWyuXBCsU6SMB70H1mNYuSyRe9QlDe8jJov0JhqNC+SROnPVfTXDls6p6l+qA39OGbHzzX6hfMYKVDen1fnG9zpFiRdfh3W40jbKIJOf9v6fIX0rCphK3qC9dngTGH2v/T/Yj3G1GbeNOBAbEuGcwqU2bPDfhNnZgZtQhamy+wiSRpaBwywFohAEX5KL6wioa0QN8Qjc4ReWFYHj2e+3zy0hx+njPyvNdwh7nvc6aF9SzbSg70oZOgDW1iUnj1aAxxiP3GBoFvvVSsz8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fb25e6-1bc1-480a-2700-08dddf8fce2e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:18:09.0207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYIfPa5h8QMq6PwoYClucaAsO3wl2KZrFRA+7cXhFCs+JYZS9ZBv2cpeFJjuYDa6WOrvOPz5qcp9hp9z1i65c1jtSJIGNANwnIPEh430T08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=894
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX/BBNRRbIeGko
 R/VUpPmmsIE2oUE/eYsqP2uch4OHd8x9GsEHO3Pgnyv+eNAEamZa27mjfnfqpDTPN+WwRwyZP7z
 KffVjVTWQpLvhkw6cmV3rHxGGIvp7Pg621saQmD5vBXnzDlRminRZcH6j0C/JP5lf73Sd1xCsHy
 Z+Pq6893X/BiKPrqYTWB+2PT6UKEnA89xSX8I+LOi1XpYGy1o8gezcxqk7VpFbsF/JRUcSzDxcD
 KWDcIylrXNJDFKK1y86+oQkuYUhcQMkd58dcqVQ2WjU7uIKzEn+89+gQMXf80PQ5P3U35qVavZs
 uYvZuKk80IEhYDRMWSkTBiOAM8R7XAOg7ZucWvhxlB8Xe4eVwJT8rv/XW0WdSxjTeQE0dikSIQe
 Qub69G6K2IOqtwGFnes/cQhDmhR4Bg==
X-Proofpoint-ORIG-GUID: jhq6gEBWZOikaUYBeQmOe1T7T2TfXEmj
X-Proofpoint-GUID: jhq6gEBWZOikaUYBeQmOe1T7T2TfXEmj
X-Authority-Analysis: v=2.4 cv=GoIbOk1C c=1 sm=1 tr=0 ts=68a5306b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=d8hEFVV2BlwOszNezSwA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22


Bryan,

> FPIN LI (link integrity) messages are received when the attached
> fabric detects hardware errors. In response to these messages I/O
> should be directed away from the affected ports, and only used if the
> 'optimized' paths are unavailable.

SCSI bits look OK to me. I am fine with this series going through the
NVMe tree.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen
