Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC7D2AD2D;
	Tue, 22 Apr 2025 01:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745286835; cv=fail; b=cNpuLZuloG3beF2+kRPG8ayXO4+kJE9tpiQJAzTVHndMPzI5nca7ZsuXIlEPdQaWhejc3slMkG6rOEoF17LVoR4skAVZvA22MMz2QmuBGkXJsXMqCH3RaIHx4nKCYpczmCpfzGSggH10IyWmHpsyUNBNm8+jyFL+EmBHMdrX0ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745286835; c=relaxed/simple;
	bh=EIKCUQSMjhPDVLudOXY01vrOogNz1bKNxqMjPcr4oMI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GGNrdUl1b5gsuY22y6+vhSvmOSajE0gEepJBmzqkDv1snJV05nXwSHFu87+JFA0abHj+n+RKELjpp1iQhiOvs9L95grF4Jta3PVPlgzDMx/KYwfO44UjVmLz0uFghUXSAYzXXnaum0b9lyuCvxwn2przN5oi622pihHK8AKjWD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FmMChlkA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nFyL7Yvt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FmMChlkA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nFyL7Yvt"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53M0fuCX018318;
	Tue, 22 Apr 2025 01:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=1jHUf820yNSkyfkiTy
	3bY0c69tF2NfX696eKslFLZQs=; b=FmMChlkA/9yoM39tVwQuK1OUmzFkDKK/k6
	bSAPVOmcrr7huLrUB7Q7nk2dSPLjB8F9zUKDe5mN7qUfYzOGFBm0a2S5woG7XQmU
	vcIot3hOY275UAASHipEPNaXTNbY3NDgw6WaxstU82qaDZAOd1rvygVSc+wLoXEp
	Zv0ianumKIHMyEhacuXSOAJg6K7lAUL7achhL1Vq/9ZHWxlL4/cavoG41FRD+ONf
	EPVrnC04mZcowJwVDZ9cyjT3xFlXnAqPCJ+9z161KpkQQ9D/UVAIC9T2q3dGzTsd
	1itzkhjVFN7BKWMuUKlAmks8x2+DsZzHkPlbvreRnVQ3OIrmFoFg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4643vc3kvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:53:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53M0q6gE021146;
	Tue, 22 Apr 2025 01:53:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46429f8045-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLbG823U8ydnrAH4RyCN+sHiXR4EQ6htL6WLWQ7zO1pnIciHzUZs5nJCZjdbfWeDd1E/7Mr+A4SSzfVgKDlYfhiIv5onougIHTDCjbZCfr7agjFs2EqM8YPSj97XioF4uPodunZaIcbodLtYV5alIXfPH9Q+Pk0aLwEkFK6BhjEG2UI9aB9wkUlg3fjQ0TfLTTDr6Nwbxo0C3HlAjCx1ymAWtKjdSh5TNwy/4eFMu7LlBl5Ku8FrvxQCh2FnsAhMPhqs2d91t8oZEj8tFLcD32O9cxp8GqTyLVa7HG//ZSoR2psk/lMK9PU2rKeB6hTOfbPTWFHf2dVX1QEfHt7Bag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jHUf820yNSkyfkiTy3bY0c69tF2NfX696eKslFLZQs=;
 b=mgYvk4IzKYVg3+s9BxtlgEGjzO93ZZdP5tPH+2BRxYOebdfavnHY8CDJvTy8X/aNHUXQ63YoHsfT7mnkB/VaYN4sizLRZ8zmOlj12IShmZ+J58ZmMDqLpnxoOtM7ymrN7Ib+icmHTrq671EbVQwLp3GkCZGRFRxRzBdK9gtz31PX+puWb82famSS8hwLOV14NHncj6MR1Ztjd1M/MgOOgozVOg/yzHo59Zr9s0v8V4mH0eqoBYtMqZwrhZSEZHU0echG4LqINCTcRuC8/T5seCIRK3H24ln6mJx002RABCe5C5TDcj1rPQ32HlITnD6zdCdduQ6KMkR13Hiq3F9Z7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jHUf820yNSkyfkiTy3bY0c69tF2NfX696eKslFLZQs=;
 b=nFyL7YvtCPXvat30yX/SyfjjN3v28i3vf6/a6K7Gi1vYO7jpVbrFDTevs27EuHbNmU8TBtxgGQqqMYbqJ6Add+Q3U8Yyv+F8lz61LCEqy2z+07KTKiDU56PuU4EtjeNjhZblqAu6gaZqUkPgpJzpHkX3jEBfdxhzfCmH0ikW4tI=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.34; Tue, 22 Apr 2025 01:53:47 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%5]) with mapi id 15.20.8655.033; Tue, 22 Apr 2025
 01:53:46 +0000
To: linux@treblig.org
Cc: njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: qedi deadcoding
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250416002235.299347-1-linux@treblig.org> (linux@treblig.org's
	message of "Wed, 16 Apr 2025 01:22:33 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ldrt9d28.fsf@ca-mkp.ca.oracle.com>
References: <20250416002235.299347-1-linux@treblig.org>
Date: Mon, 21 Apr 2025 21:53:45 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0019.namprd06.prod.outlook.com
 (2603:10b6:208:23d::24) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 323dcc31-64a8-454f-f507-08dd8140851d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QJiykOwZZoDZWe8vSgpcfNlzf+62JxIRbbaXxkinN6k9Gr9ck7GQfRQ1K/vq?=
 =?us-ascii?Q?lTmqDX0/r/7DbvNA8WCk0aLHcaD2PlEY5bWA2LuZEyDC1rVp5YC739RJpPdC?=
 =?us-ascii?Q?+okYKjopUzDNkA77IfEh/YI1oMbWqoIBLtuUXh67Szv7mUK/yUiz4r7S3hPK?=
 =?us-ascii?Q?MtkgUGnFCRajZf8jUGYcPL7NH8qMoHCE6bdOqiDLJ1z6RDuCcP82wlxtmWRc?=
 =?us-ascii?Q?hJl5OHKu/XU+oPzpCBNVZ+Rp7Rzo7i0viQ2HkFvAmOhTbUATQ7R0bHskoolv?=
 =?us-ascii?Q?kqdMHN7+dHhsXApgjEjfRKhSmxZE8RsW4WlFDPao9tJY0kP5DNyH95t167G8?=
 =?us-ascii?Q?EF0emdcU0xGnROx2Wt2LQv8ePRNeUwZFCf0pZgbSvwbRHFe+5mxy/KjJZx/b?=
 =?us-ascii?Q?WQoExq0fB8iGmEHV619oZQrmxklkc6q/LVJhqRwffmG+lSecBXyQkJauUMGt?=
 =?us-ascii?Q?nCK9f0hxg6By6GCBu6qO1oOJOGW8AZ9oC9Eha0hLDORDb0fuxKsxPPVJlyi+?=
 =?us-ascii?Q?iJJ3DBPU/9SPXBUSc9qAXV4DVLayvyumwPwjRatQMTOILiGdZ1vtqCoOO8eI?=
 =?us-ascii?Q?GrjoJ7PFLuhkZQcya0p9AYWss2/lxs/73CmWmJOVP5H5boVxNXKwv3yXq3S9?=
 =?us-ascii?Q?whKhFddPGXEagEeO+x9wTN3O/ZbBJcaOoasRSjpHWRlfjZLaf9g8FHwhRyDT?=
 =?us-ascii?Q?UJD9+kUW0LMleCge+/RqTQoMPVf1SKHlVuCveRYDHq61C1leU9iwlOZJWI1A?=
 =?us-ascii?Q?D0s2q3Jt7N3aB5BnRsOwHeDseJgUagWT1YOb++0mcIEbGGEktVZiQ5PgH5dh?=
 =?us-ascii?Q?q0Mzb13nc6Oha/OHMUW/+m6gFHawn5+JycgcQ208IhYwAMqHp3brj+Meurev?=
 =?us-ascii?Q?roKAE3aZ02uK7v4BHbz2o/njsUxsFVEMwHNrKiKePsvTlZ6jOzjeV0/+RDp6?=
 =?us-ascii?Q?SULTXYF7QCJLMyrYYOSFhUMsD7MNg72n+cz5Gic5qtbkXdyMuHYdJqn6cKjB?=
 =?us-ascii?Q?NvBb5fH9v/6vVzwOw2rCX5tuhGMSXEYPcK46/+u+VleLA2GPCIQim1JA8iW1?=
 =?us-ascii?Q?EskIt8GjlHnZqN6mGUinUrV0vz+8LpSMeaiO0Ev3kp+JJsoz5WgtJHhLe09l?=
 =?us-ascii?Q?LUy1gncpzgPneCoMWCCzTOhUCPHuSkA56ccRv93wlRbANdKaX4VZTuRil399?=
 =?us-ascii?Q?cHIe9IN0ICD68VebUUngxJPNyMXjOHu18H1ta3CwxuTiu9QkXPnCirTZ6mF5?=
 =?us-ascii?Q?kHA9CvuiKbJcjqbgLuhdgVWK2AXqVLDtsbtIvypDrg9YAWkoxvbcA+vcyQxG?=
 =?us-ascii?Q?L2Pmp8NQgZi/deLHoxYSGVWn3jkPaEJujEv/NCGEYcqjskV5V3c2W9Hfnurr?=
 =?us-ascii?Q?gOwR/M68/BmmbkAkBxGGIZGKIYOLHK2OY36vnD4l1HIRxy6Okg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CyQwDjXPRu8fr3oK8lKSmixa61CXnqflGatP2xiGtSvya598PCRoTiPtfXCT?=
 =?us-ascii?Q?+ZbPoL6O9eaY9TxySJ60Vn49Snl+YCAXmDj+ZL76YbU1WXrz1MogwDK4pgqY?=
 =?us-ascii?Q?4R3vNPLqvK+f5CkDvmSEDwA31GXQ1FqJJ7pE3NtL1lq/yehzZi6eBRhVGrP6?=
 =?us-ascii?Q?1GY5FWfEdFEwwJ664rf8I3FoNtmalSErNWSD461VFz3Emc783+wXWH+MYWXy?=
 =?us-ascii?Q?iVTEb6TbHjl1YFId6WuJ6IxofY4KBPFuk17KH3V6uBDeRFXjBe4Yd/eo9CqE?=
 =?us-ascii?Q?qW39vNsIBJNx9byCKyMwA8kRYVEzdcPN9kzA0BEl6hI10fpRDmfXmNntdW+w?=
 =?us-ascii?Q?jsWMdV4Z3EDeX2QS7MOOfCdPPNS01hhL4dygncVAW0GxVFDF2ZgbTezX+yiL?=
 =?us-ascii?Q?wYWWbEgumXCtjosjcO5hpK6gpzLrqD8vuCoN4Dq/4pp6vg8XLVFmeWQuFcXF?=
 =?us-ascii?Q?2sVfZToj6U/DtwdtO7XrNuYJfTJk/sKurMaxourPg4vG9CUoYcbcEFBqWG7A?=
 =?us-ascii?Q?LLvOSmIkhBBys7tCMFyBVEXWSjf3ScjiBNmchgo1D0wEjBb2fwCKb2kjv0gO?=
 =?us-ascii?Q?WdXHFCti7A/6x7gcKBxsp8Z7nip0EP7FnCbE6x8WVAGD57FVCAE+kudoq1Z5?=
 =?us-ascii?Q?RzEaq0UYfDPbwf+UAZQgJS648K8V0fe/I4a7QmlhGB73WVnVg+GQVhrkJyp5?=
 =?us-ascii?Q?lY23CmZop2jGRk8z0y6j2m/csTrqsOcQviws7ki4pGkwH5Eja3rLoYZq2OWm?=
 =?us-ascii?Q?rd5UvQDoKHC8kuqJXxqsU7grAG2myL+wQiePdAJ6+dQqBvce/65Jc9HlqXLR?=
 =?us-ascii?Q?+/0XqRaQ0D/8RVNDd6N9OThJc1fm2ul5zrw6uMlZe+7RbbIDyo+YskGwA8bL?=
 =?us-ascii?Q?Tq52nVDwh7x0pMUmGrQcNx2h/ek49uee6dTnopc76c6lJrj1Z3Y1JeSuxfLE?=
 =?us-ascii?Q?LkyY7UhSCQ6HNXb+maLa7dcl/MG2C4WUlGMakMAnLsnhFmfqYwKACM4cZsW7?=
 =?us-ascii?Q?t1xQPEywnSHKCVLz0E3YSOQhRfo0efLc1u0OpOCkDGsCsWPOs34FRz3tIHJo?=
 =?us-ascii?Q?HRvg8JwUxovswFtPgs0oOt6qhm5HMZ4tMdpXQEl+PBk8Ztaz41NfDaJdLXPg?=
 =?us-ascii?Q?pAWXUvzu5XDSx1vNVhp+lxZqF4gyibXiOtHM1UxM0iilS+eI0qH7MTJvv30b?=
 =?us-ascii?Q?kTmG38iUVEq7wnNsavzH1kM6c4/B8ygqojZHDigtm+0SAnPDv7YItIFNWKbh?=
 =?us-ascii?Q?PNiPC8uNeYHmEqOdKVdWErDxpDQ0PiD7w9yWSnovsaoh8JEVMWVqwYp2pjHF?=
 =?us-ascii?Q?N96fLoMVLZGYndJNXVSafjCE6DGdNtMTmlZdbH90xxvuifVAoCzo8RClLlOV?=
 =?us-ascii?Q?VV1UaSLh403Uh9b9F0MXEToHz2NZVeC1LO3mlDrYAxQQKMm9s93KaluFcQyw?=
 =?us-ascii?Q?KoihQkNQGIjj0+y/UqxMD30v8JvuXhC1zWiClBnpOOwWjy+klzhdWTKNkhWS?=
 =?us-ascii?Q?TSVSsI4JUh6mPM+DNddcPEvBmnfo2jhgfK/oZ3esTAEsyULJ0/bpVbiLsK15?=
 =?us-ascii?Q?yeJRA+epexQ65el1Ly1/0721fSgyVOXmbaEPYv2XDEty8A7fwkIzmj7DXl7K?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jiS20r4wgL/YpnF1F6ibhMJy864y3o9972/ThVaHS15EkzGDD1qZ2iyOgBiBrZIbpuSLwaLvo0AYjYVFe6OvV8t3MQg/wHHM4u9MULaeiZnBUHIVb8DmMe+vTo9L0S0/vnK29mIV96Ujjak8wej6GnhX+9X7TruwDgeckkOZRdEjAcS/ay8oUVuBGuVXeaXE5Q0nH7IV9atzF8o3+2Uyb3OazvtQVX+HutvP5AX6JqCdMVEdWcO6YDEEu8KMvBYB/tg3mD69z4X3R3LSjIU/oh5d+Gs1cSazYPOS6Ju5JaR1YvwYGpOLWA1nvWhwjuhRswCcQG4bM3vd580DUkHKe1rWyToUEpj6yWN9JFsTVN+mcUqGcXWRcbC2RiUTpNtHHUWnviD7FGgds79jvVEWPCIX/HQXmXc83OZZHWlHGbT7xU1iie3bw2ox8Wzn5wyxV66+igAR55xMoY3z15Nll/pi80s7yIJnGEi3X8QMsdzglcJYdNU/cEO+Bma7sIe8Qk6QOS9gSGi4pLYnnXar4B0aqE4CTo3ZSU0ZQeVu8VjLiKUxGpQmd+P29M2uU8rw1ANLaDrnUZo0SUxpi7zGgqeWkIUjA8HC3eUzq+yH3vQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 323dcc31-64a8-454f-f507-08dd8140851d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 01:53:46.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWK2GHnalyfT3zp+a3wvm+TkkyhXOb1RK/vmcWN+NzGgi6ibVDRJDf5+B1NgORcfenSZX6Yvh3oAe1a72OQHrlX0h7YHaDpMcET0Ply5goY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_01,2025-04-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=712 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504220013
X-Proofpoint-GUID: WkIXSzNFf0Kg-tPBSE8oqoLzOQvqhDeI
X-Proofpoint-ORIG-GUID: WkIXSzNFf0Kg-tPBSE8oqoLzOQvqhDeI


>   A couple of deadcode patches for the qdi driver.
>
> Build tested only.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
