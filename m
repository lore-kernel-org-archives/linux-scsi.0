Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B5A28134F;
	Wed, 20 Aug 2025 02:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755655724; cv=fail; b=NSjx+ZLyRyMvXYG1wkE8uq8W2b5lxnUHUpGy0XgEhyyN1z7IE0LCANCDUU/oliCUh9LgXCMpgE7vIpb8YqYd5Bleehq2V3R2/yvATEZgHAyehP4Rc78DqEWo4MW7eI1ln0yA08AvHvsB494xsfkcSMd+T0t10kNwfsHooRTno7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755655724; c=relaxed/simple;
	bh=PPkwys5/oc/NFe5c0PZhMSvhyXoPHz3ejqfeXlD+YHQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GoO18b9dJZ8ZSrCgzhMhXMsPCwfTDI+bELeKjKG4Ai1ZpIsjaXqM3wQPxgEOV7rOugfqlpxMoC0F4BfRTFJ3b4RHUeDDz5oqA7X7vMN3VUuAK8Z0SOhOI+PCUjusnOYHKiQ1DV3v7gbDfpMAXx5nGF2k+/f+gj0m9WslXOsdBoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SHqCMrte; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UpbvcPGb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SHqCMrte";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UpbvcPGb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBmB0005364;
	Wed, 20 Aug 2025 02:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xuxY07361AOSgoMkH2
	wP22+rveHLg/Mlkxm8DRhZTaQ=; b=SHqCMrte+/sx3mLAHzeaYy7iHIWNL3YICC
	iaklzW6PkXosyieBnxFCRBSq2M1KnzQ6j8/cVA40j+0Xk5j5SZ+KPv9BBgp5F3+e
	U9OHxhrr15ZcNAP30hw+1T7H4QqEba9IhlxCFIqhtgJS2JRCjSfIX1nWoS9G3bsI
	ULF1RqIk4olBrRSc+VPZFv9l8cHOAgMR1T80qmp9iKZfzsvac48tIYMNLpnS6a27
	KtKRT0l833yN3EzWU3FATIdmHOETzb/6LAkrYaH3dFGTWpf3b7GpyXdoVhzxqngm
	vywe42vKtHAgAa4HiF1kfBWoXhyk8S/UmHo9t7ZhGAe5Og4qls9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsr9ku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:08:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNUSCD025385;
	Wed, 20 Aug 2025 02:08:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my40kqcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 02:08:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GIJDvJmFKB9NA3FtKP/A7g6b0Qk2g9iut2UFkQSOxiTkQ3owtCC24sv1TCwp6d3ZGDXAaNrHFmTNrYBQ3OIS1AR1piA1MwOhuSyR1u90AtH6qvL0VbndtXMpGLFbQYXNkc9OadNjXVpRRhGpZhWSJHnr8YXcs4/a3o1iK+oCsUXxwoDXgokWMDQUA5yK4EZvKXOVwwol9u2njqMnPnC7sf2PDYjqxvGSCDWgJjPeZnbVe4xQAeb8gKkWwj1VSjf0GcxDtpn37RuxqYfWx0ehJ9i0ugwFEJTBzX/uHGZKiPpLtNRzHJoLQVXIZ2fIH7PwNjZOMy0XkBraT06YYqPDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuxY07361AOSgoMkH2wP22+rveHLg/Mlkxm8DRhZTaQ=;
 b=k9PAcikDFUgTZKkvCtpk58OQhRzeX7zDyGXWSGn+3rbdHYj6Fu+m+FQc+DNEPMFz+a5KecpRuwKlAXyoTwYh62Bc+T4hLmOUFgEjtxkLlwBWBDyrkgzh7PFjF0uusdW8Uep5QQJhgB49sF4HZcgoBUL1zxw5s+v5s+8QpS7kM7D7LRTW8i6X1HqAS0JT2I6EUoeiDlQY1GzfmNteFvFi5oP7uRMw5AlkWi7glGYroFVU+exl/oL229huIVxaMVkyaOC07AD6pjUPk9R8WuTin/9DAb3MSIN4IIAffQY2f0YDgdu4ASxWBo8DT9BbYuTfAA6ZxZRkCm5w/2/DveC1vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuxY07361AOSgoMkH2wP22+rveHLg/Mlkxm8DRhZTaQ=;
 b=UpbvcPGbVv21LsW11EWS2HUf8tV0uPNLLtIhL6DO28osmb0OSK7xTPzS/tQcz/kZoFhYqXsYsn1MfmboYMrYoRZbL0IwXsSC/1wNBp65a9rVHUH7b++sTZ0Gx+cjHEbIQGbfwDA+zUWjesin//xzD3Jhr3TZwz4WTXzfix1QLcg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV8PR10MB7966.namprd10.prod.outlook.com (2603:10b6:408:202::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 02:08:34 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 02:08:34 +0000
To: Len Bao <len.bao@gmx.us>
Cc: Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar
 <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K.
 Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Replace snprintf() with sysfs_emit()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250811170639.65597-1-len.bao@gmx.us> (Len Bao's message of
	"Mon, 11 Aug 2025 17:06:32 +0000")
Organization: Oracle Corporation
Message-ID: <yq1qzx6wy9r.fsf@ca-mkp.ca.oracle.com>
References: <20250811170639.65597-1-len.bao@gmx.us>
Date: Tue, 19 Aug 2025 22:08:31 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH3PEPF000040A1.namprd05.prod.outlook.com
 (2603:10b6:518:1::52) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV8PR10MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: aabe660d-65a8-44ba-1fed-08dddf8e7788
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?521hQxftwh3K8CSZ1ZlbrxHWhf9CCC6lt3rztg0JQIINOalwninri1zva06q?=
 =?us-ascii?Q?fz1b1uRoeNC5GoiuEQozv0z2n2xkbZ1wBRjynmFiOAJ7/jAHHPB7MgYhmF1L?=
 =?us-ascii?Q?2fP8JfX06q0MZY1tQ9puNDPWj4ZO3plSctMngdo2lok+l4DYkWMRfRiX9FTu?=
 =?us-ascii?Q?QOdRtjfsvzU1EHGNMYswXMv16mEbcuBHzd5WmeGVNKv02O9qz96QkXs4P3gi?=
 =?us-ascii?Q?OZmB8DfyqnsaQH/+7AnO+KXqK9fAJKLn+iYSpSMDjyGYpvthyhFvaiiW5XEe?=
 =?us-ascii?Q?XCqxMcNl0k2YiMV+vOEDS0PLT8NIMUPGyMnvnCyFk79gaN38tQQBda1nLv4h?=
 =?us-ascii?Q?hboAuzRIGKLCyqVbIxpEzLq2BuXWdfEyLy30KGj2KNPCKgc+0aK1sjrSSfKd?=
 =?us-ascii?Q?TAct/YYrq2RMyOJtkAdt5MGexB/vckRSgn1kilrB4cb0B3qr8bHA9lEQx4qt?=
 =?us-ascii?Q?mUiWBobyIz3wT2iwp3cpseKgyiNH4/JZOPU4yROO+InsUr/mPZmGBgcVRlie?=
 =?us-ascii?Q?nAHhtWdSZ7yi3N+Rbay6qi9XC1+DYkua/bozGEcJObB1yJXadlej9j57kiRh?=
 =?us-ascii?Q?nr/5JdzGHlyLcC0Sw8bZ1HXP/XHKH/Jf/T8V1RehNmowQHU+nyW9Fyc+zcN5?=
 =?us-ascii?Q?jFCngQIs16RqtfCYPlFoNLFYhnPxPNaG3i2dXThu9/0eENI7pHNxjA/kXZcF?=
 =?us-ascii?Q?+tUqGVeHk/o4+Sr0gQ1iWyT61sAxVL+cB92cLQ9ZkEtgqGCS4pRZiPkd4uf2?=
 =?us-ascii?Q?fKQvksaExrijD0btfK+EL3/KGecINpwWMwCcVwHlBNzJ91RiqvOH3GDSrKB0?=
 =?us-ascii?Q?AHUf+gRs3mvjtrQ8VILLEJL7+tEn4T8NqnU/3Fv5R5TL7FLmGg3k/iHvO1Tw?=
 =?us-ascii?Q?C5awa8yGmprE78JBck2PY4us1FW3iKFjcIpT9BaNrn/rR70way7IEHWaCTo/?=
 =?us-ascii?Q?eRaT1ekTMRC8jYLY7eboeLbvafQHeQwWU83pn3nAOipDp6CLT24BM0E9OxmN?=
 =?us-ascii?Q?Gizk+YI/NeHBiwkIt2AIx/pvvoJBAcs/QL9A640aMgAYnqhWRZwcWwrtTveW?=
 =?us-ascii?Q?qOOBpmZv7PAvmnL6ftmhoSmRzbbo7S0oTgxw65WrFO1nchcjzlyl8albBp9u?=
 =?us-ascii?Q?RUcM2Sel1QUINu248sDxuIjVS0ZPr3mtzEHP+HjWUr+9O/yTwy1g1UirMpib?=
 =?us-ascii?Q?0NbeXWBuF6GLtroOwx5aCLrE2ch1ajMvX/tCNA5w5Iy3MsfwSD8UN3kePcAB?=
 =?us-ascii?Q?E0BVJmx89SVBdGBnSjOyHB4c8HQfa3cfI7jfYTjYQN6v+lnZ425XxpYq/tot?=
 =?us-ascii?Q?8WfBoI01bsrzAwPM0ipnuyLR0rBTVRmSerlxe8W5FPN/oYTe5tfScHxBH+zL?=
 =?us-ascii?Q?G6Ku2zNWPr+yOHZMqep2YY+J/IHB774np+1TfxamWJ4yKVzXTg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8uZee/yt1M6R7DApd+WzSyKjHhbUp0H7yRhfsEc3lvDucCj5v82CLHuAdcW2?=
 =?us-ascii?Q?2Hfu9MLQTvWpibgerNjBMNer8XGCgyYIddRC30ZjBg+JlKTJPH2uWHWUXOKp?=
 =?us-ascii?Q?K+DOl5jSrEKa15sxmVARqCDct4X/+GcGRdSBt1wb5lVaqKzxZNvhOrwR1mr0?=
 =?us-ascii?Q?oFclijhSPJd4pvcfXSNRN0thuEEV8tkjJUKOdgKVvrWsXMrF/8WGRM75tarN?=
 =?us-ascii?Q?aGjzRHdrNuk3GD7Vyexxr4qgoLqh6Am7Ue8+RcHo1+++WNK8EOufg19Hbukz?=
 =?us-ascii?Q?FnJUzjORY/VcUbxCYMP6asKlKnPS9RVfcfpFtnUomGiozJ//D6iH2Vr2I2B9?=
 =?us-ascii?Q?Ug/lI6UxZ5UWWe80XYJZSVbjmGUx8g1/XyN+9RUEWuHiWq4O3Ce/hYTByUQt?=
 =?us-ascii?Q?kbiOErpyLXj7vT8/SF83AhKCrdYvUMXhLgv46tNlvFpclkPjWNQe+TWsV1qH?=
 =?us-ascii?Q?jTrfULA4T5bq6aaBicE7Fy8EovBpEx66yU2rLav1u0Z1OgVB39cz3ivQlkMc?=
 =?us-ascii?Q?e8Fo/AfBs47TA9q1w7TFlxMdrawygTIBY5vg41HrS0CvWv5yzI1RiHTipDin?=
 =?us-ascii?Q?bKnDP2vVrkEORnd76v/H2v3K6ejlyMH3i9ABCE9RKn8v9YNKEBQnL6OfFq4S?=
 =?us-ascii?Q?ViFIbLDJ1sFldW1uy+KYgjqbum1mEwD1tTIfZdy8U0Z8HcDpqb/1yIvmcItI?=
 =?us-ascii?Q?a50BRyjWco9iMpQq97lpP4gAKmd2J47A0rR9RG9gCRE11ZJHJ4P6D4KasaQH?=
 =?us-ascii?Q?K/+8M3Aq8yKIvpRC67QRbbgykh7SjO80McnMEt1GM1JEnYVSFReXpNccfYJo?=
 =?us-ascii?Q?Cvg6wwQCf+OIhFL2ltj3u+PYeLbOH52fo/ULChCpdYnVrMZ875obq9QqqCUA?=
 =?us-ascii?Q?yHyqZx+8Axw8yBxKSHgfqU//9/91h2wnJ2vWF0m8QWYjd6Vj8mUNZTJ3GLGA?=
 =?us-ascii?Q?4/QOtuEJ8zBWYS3HYjNYaj5B2NyNgsFMCxFD7nldg0OMD2mRlRXRBOx1fd29?=
 =?us-ascii?Q?ptMFbLlLnpFaJf2CfaO5uL1xx0jbMWJZz6SQI/ssuqk+fUYjvV+Fjjn2pJ5C?=
 =?us-ascii?Q?jwWm7khEnBlOAB8XHKQM3Z6sFfmsIFpMS42N+7lsKcj2NbN0rW6tTo2hGDzF?=
 =?us-ascii?Q?dL+euTG3/UNprLgXl90K3bpg/3KiCIf5YxdVKgif80j1A+l+Z/QBsdVgIvCY?=
 =?us-ascii?Q?I7T17eGx6UHR22CmJpJ5w79S06jlbXJaeODMh1CaszoJY9dXkZ1hFpapFooO?=
 =?us-ascii?Q?ejGaF3EpCUZN/tFLJeh58K1I+ywcixpd47U0U3HVEwcFSj4mX1vYGk4QRZtL?=
 =?us-ascii?Q?gGrpG+ihrS7zGMQF0fdFmEdzQpq4gYzHlLu7817nzxRc0j8j7qInn4qDySSX?=
 =?us-ascii?Q?uJ4UuN9CQavHd+B7JhsQ/qOJn8vjq9vTR1b6kjVNLO3ujdURSPMd5fTmlYIs?=
 =?us-ascii?Q?O9vGGc8E5YD3M+WShroCFkCH/KEkvfdqwJfWNsGaj7qfE5Ck96ZpqwnXQiMD?=
 =?us-ascii?Q?TV05DfP9/y38XDo9Lwbv6EGwBG/eps1sI9lvyVeaqT3S2JfM8r/9kTmvSoiN?=
 =?us-ascii?Q?oYDvPqgaxCiCBHX+Q01yqSP2GD5boo35n7NOGkC+36zV2GvN54//594U5S4x?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jv+EItAtCJu3h0EDXS+zgbLszxC5vNLGwFJYpBSMAoqnf3/nC8PRU1mCZeqtpXNiRsvrIqhqtlT8wMwq5trYci9Bmm3QIjEkpF40q3f/xXoek+3tr7XBB1DoyxJPqCQLJa4VCVwl8s3fiu634+uWR0XuIR3FSs15Xnhz/vmAN+9VlnddVrHcbL7AFNwd2/SfKrYunR+whms1nrH5KKsECia3d3Qf3lNTUiEepIPzpUCPnGxMsnOldWnjMIfaZF1a9ejdiEw/znDuAkN0wI0KzRovCjS7WOlicHKZceo6Wf4qWw61M73U+FhvME67iMuHPhcVbwl6rhFP9LgjRPosr73daUqTf/X/Bq0TShA+1CGemgkVCGi7z6HHHGJ/qJwTaq1F/MK0Zs7Dvh2kTwONNCkQ1ueWX9GLj+PjNoiCzgVn6Y2cZdEaFqvklLnkdWAP/vZcFsc+KN99G4L18QHTXrVoxZ910GDo90wYMPwJlc6hEY4NY5vmq/GoAtVL9Aj20Oastdu/A12h4PYyvUD8Qftxp1qd/2HCr8aWdM/RSYuDm7sZmJAmrkHWRPkS+o+iPkSc6vNR6m11vaQqildGWKNPaHmlVdDFMZumMMZkz14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabe660d-65a8-44ba-1fed-08dddf8e7788
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:08:34.1635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qi8zjHRHxkh6DY6thMm3ifGsBEHk142G8TpgSbiTg76yX3S30xTUWG+LY08h4JIepiA4q8SWSutfmFAFuSiNATBLNpeYW97TbAcNopumLAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7966
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=872
 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200016
X-Proofpoint-GUID: OucMD2JAE8-BIvWpJ4coPDfdX-DkGVoe
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a52e26 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=LoKKlBUdbrPEpqnNet0A:9 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: OucMD2JAE8-BIvWpJ4coPDfdX-DkGVoe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX9FurvYMk62Zl
 IhqeaWCptQDsULowzFEkFxEbWzZs/r7DBjauRlviDMTVCY8bjs1BUg1mpqGStKCV1SZAR6XHW67
 6qL+kY/qRYvSx/zDs9nQYO60f9SY3yNBLdsifHzWeW/uhXmpRixNVg+UL6blsI4CkFPLaqPZzMn
 O9Qe4dZKPIQtDQAoR21cKVegRF7zPUFny+rbqPDInYZUZrbZb7AA/k+l+Uh+ds7Ako/utlIJVH0
 rJqq5TA+mRIbM7FhdPHW7/P3FHb3HuCro03ldqjP/BKBhaaGrBGxfitAYvQ36BIzJOxu1fW1nLl
 w2k4X4JdprGcCQTYC4/MAzv9ar8idFZxO3n5aN2j1evffPVfD/fDduqwzTlcHF/Bj6U9kEFS6Kc
 XZ5fWj2Du56JIvGoMXiXEBtg535M5XY5PdGULY/dVfNwW7aXR/Y=


Hi Len!

> Documentation/filesystems/sysfs.rst mentions that show() should only
> use sysfs_emit()

It's a "should", not a "shall".

sysfs.rst was recently amended to emphasize that this suggestion applies
to new implementations only.  See commit 2115dc3e3376 ("docs:
filesystems: sysfs: Recommend sysfs_emit() for new code only").

Thanks!

-- 
Martin K. Petersen
