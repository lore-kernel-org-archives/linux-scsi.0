Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7108E63A9;
	Sat,  3 Aug 2024 01:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722649263; cv=fail; b=FIOY8EEFdeH5bXbVDNn+AKqXOgrMrUaJxNv3LSvf9ffIV++mjcuouh2ysFfevkK6Pc6SB6dV7oUemqYftQGcC+SNADzihQ/WAinGc4FgW5Ez6r0oysnz9CMSo340MQanJ2iE8f4gAnRQow0Z0BDuWomfYz26zO3h4oWodZP3+z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722649263; c=relaxed/simple;
	bh=xpNYWJn0l4DrkFJx0G60SvWwanarGrtbkkeuaQ95KmA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UhPgJFz7OrfDd07JqZHvxfu5v3/QQHEn1WKYA+WjA8ry8KdGgmpvpEvdWrcZfp6qNx+1K+Wz/BnBjYuunjXFba5nuwdoor73jxufOp8weWcQwPwcKpRL+jlmrzSuEswubRrrBNzzuLmCU9Ol7r/A7Ql/lj/GmU8Cti1Fy98o+U0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eJCAmfAm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e9MbguZH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eJCAmfAm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e9MbguZH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472GtVXv010160;
	Sat, 3 Aug 2024 01:40:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=7Kv+uulpOMjTzr
	3y6zY+VZgqlUw84BBgc1mIYDQKTvo=; b=eJCAmfAmjPeeXZBDWI9Y60n9Pk2PJD
	IxR4vXe89v2nhisWbSm7BZj7YE4eT7OB5VWjfn1Bnkq5xkpURcDWXmIPRjUNeoML
	tQevBU8kZC28EUCFPwV+jbXY9JKeHSX+rKVbc98ZH2nErWGqQXiRkwgfpc29ZIEH
	ThfvWygOek0aI19aunmcxgyCrADZPpsXE3A+SPZYSyprXBgNt/OpLSsecoFo1IS6
	d1iJnuo7dchXlp6f61wGtOAAA0GnfOv25iqYFcaQB0UYwcEhIAKBI3pJSWNy6mnh
	UuAO6oLwHXBXm9nmWPG55WMUluiu9axv3nEmz1nzjcdvi9bU8uAl7FXg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rjdsafj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:40:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4731XgxV019687;
	Sat, 3 Aug 2024 01:40:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb05g2s9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:40:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/Gp+UPajbKG8CD0eYN0hJDdQoTMwKwgoPqyTVEf1Z/rVgBS0jo9V7sZxvE40HeOCeMT8Bo5pcBBjLIKUpKlzoDz4eiyHq+p8cFiDFBLFzsWqVfbBBreIqzj5dWPxddppSdrUcrB5Z6CxOJXLaV23JLU2te/lENEmt8AbKnA+rc+pHy1oTbQAscs5P5esIEjaHc5wwYMD43QT/qRxMRIvhRquv59NAQNtwY1t61rut6q4PBY7YpgR5Z4wA7ZNZS58BNTXT4rIBmrVDVu8/1NCE4sgjRKDGAzXAJLi79qF1Qel3M4EE9xnnYrthZ0wpKDgaJHQiIpKmVNsBEtDYXVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Kv+uulpOMjTzr3y6zY+VZgqlUw84BBgc1mIYDQKTvo=;
 b=knlA9XqzHjBTryiMG8VBU8KFLPm6Y1tb14RUS4JGjIJw9T6XawcyS0inM7yOgk+WljqnIkP7rW+gxtSZGn5sjjvHVn1V3Jkn3MDTZhBK8K6xEVisayBVn/bsszz4RE1RV5j4QEVA+1bMJCWo+aRNv5CrXq7Uq6RZsujhj/ZRL7OksCCSotWwsY7lo3D5fOw1/cQCSsP77r9KrBXOHXrmt56AwKPkfUAbUQeW5zsuU0CSs1X8/LAq+PQ/Ooehb10AZ6brDBjRpbGxCVb9+9p3qPl2N057GN7CiRi2O4ELPyGQYtogdZUUIUfnCmh3buL7YUkNHGGLk/jlPVZ8g6QDGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Kv+uulpOMjTzr3y6zY+VZgqlUw84BBgc1mIYDQKTvo=;
 b=e9MbguZHK4ioWjlte7QasXmMsXQSrGkzlUw9TaIRkhyE4gp9UP1JIeMc1Uiv5tAqNc3PAYzLSSMqZMhCz8NDX2qVO8/7+LGoVdkEnjGIjap11yQEb/43D5A7r3TEmpjUFr19a0rCElErQ7YpzW5wgSiNAM5WH9ex3/RFqIDGjbg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB6747.namprd10.prod.outlook.com (2603:10b6:208:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Sat, 3 Aug
 2024 01:40:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:40:53 +0000
To: Kees Cook <kees@kernel.org>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: aacraid: struct sgmap: Replace 1-element
 arrays with flexible arrays
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240711212732.work.162-kees@kernel.org> (Kees Cook's message of
	"Thu, 11 Jul 2024 14:57:36 -0700")
Organization: Oracle Corporation
Message-ID: <yq134nm759g.fsf@ca-mkp.ca.oracle.com>
References: <20240711212732.work.162-kees@kernel.org>
Date: Fri, 02 Aug 2024 21:40:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: 241c0fa4-5c87-484b-f266-08dcb35d4fc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jqEFDdk81Yw/QT5bXk0R/W+RohOaPT6RJcKPhLNMOFjHAP23luUayaKFHesp?=
 =?us-ascii?Q?TcfQtS00fuF7Qq1ECilLy2qm7CQG9f1po4sLcq+jRiN9+hVenOS9rLWQulHZ?=
 =?us-ascii?Q?eqFkXF+AGlHZcQv8ts1wJKg++7Yc7gC/GDg0rz6yka6kD0pH5pV1cKOCmN+e?=
 =?us-ascii?Q?H8iNaIpPt0O9pD3sVSTL+jSzraepTtP7lF6JjZggqO9c6iXOTxpq9zx4dIlS?=
 =?us-ascii?Q?ZK2ld3IClT1ppCcS3FwEIrnbzWwRDmc0qi4sh4UmSRL9QOgBF8dgZNY1cNuB?=
 =?us-ascii?Q?x9FRd9h2eOdVVgsD4x7LEB9GU+02cZZv/2UAyUR64ppXe9tAWVAPDeIrgcTR?=
 =?us-ascii?Q?8G3ZN9CDe91V+BdXPP6rL1fXQYpdUn3Kbb3GgMJv9BHm6UoKIAd7ec44YVtN?=
 =?us-ascii?Q?iPllDMa5Ek3HbGzbAig7XypySvFky+8JztfAYdVLkYeJNXTPgiYt/ns+xZnv?=
 =?us-ascii?Q?hWpCOofifDxd4K1em8fPY2hA4HPCqeGrpasgGHLiMYNSkjNIC3J/+lzvAWty?=
 =?us-ascii?Q?/2eJBsYwRlWblbazq1T+DEoBj3OjVe1rCJ7OabSDIreINwMW2UGxd0gqS23q?=
 =?us-ascii?Q?AP67AmvT1M9hTUpPT7g0uAPlzquTV1x/CKdyvy6PUWvtj5hXdOI76CnUhTL/?=
 =?us-ascii?Q?ueKBG9sBkxv4Zm11Fi+9vVOg8WtRimAGV8h4dsqgm9VYJbPhgS3cFLkYx/95?=
 =?us-ascii?Q?bjaDed5KTh5V2FGiNL8CH/B4efeogq0qaDNG9mhFQysrha+L8YYh4l8NfEZI?=
 =?us-ascii?Q?vxI/XG9sReBledK2bAd002Eb43Z+LZvDtJGq71q3Y2jGO/mTuHP0b7eDpk0r?=
 =?us-ascii?Q?8XqC+qACM51ES3Fs2h6yUIoCbSm4umMrcM6zCJqGo/jCiAfXCIUKtOVOC/qN?=
 =?us-ascii?Q?zK5ESdtV4Kl7+hG+M17VxJYXzEjLHvZWbUoEDaiz1/DLs9k8w0GHl5vcQ1d8?=
 =?us-ascii?Q?C60TCHn1P0r76+nFkpJmEALpopmnQBTxsfJPVNEPhd1Z3PekMqGjQ8651vls?=
 =?us-ascii?Q?A1kFxy/aAEFmKRDIkU6f3BPQPSxPwFjePD/p6xF1OL+xJDSBtDkNswNtfuqT?=
 =?us-ascii?Q?GWSYy2ZEI4WTD4f9+SFU3v+Q4I9NFBMHfyqZIUpOrX8xxVE08deGj52SJK00?=
 =?us-ascii?Q?ogFm7LX7P/mjZtugc/aMFfaXjsx4ThNX+RJuRYO96tJmW6QwxqhBtlPg9Hj+?=
 =?us-ascii?Q?pfzwiWDzS2+yjsrsOmyeoaGMvPuTwsVlXUaBCsMXrGcyWAt22S9oFgeIkVmi?=
 =?us-ascii?Q?PdY97/d49RSAHFmietIReJVksO0bcH09yRZVUAcYVVZn1D+o/WOkaQs1GTqN?=
 =?us-ascii?Q?eakfmfW+i+kzsJSiFz/AnyM3RObMPIBtlTYPJKeLubhYww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p7cqm49U5Jpeyz1VjollT4aLapx7IgoSpYktLpGT7IYq56R8lL2NgqDsQRlb?=
 =?us-ascii?Q?2iAe96mJJb9MaGVqMbSE17LM2KnC7tltFp4sqTsFpm0ugK6snsO0I3z8wegg?=
 =?us-ascii?Q?L2lk/TK7w0udtCpm42jvpafbgToVrOOkptI4V6fz8TLaq0PbXFNKQqu6mNZX?=
 =?us-ascii?Q?WJP3oDj1ienyGfcjLdIEfwYmx7Q2IfBmOXxud8t6ID0o1jOVS+1kELpmK/oj?=
 =?us-ascii?Q?xC4xvetvZl9posTA5PG2WhO1yH8suWcjQ7CaV79kBZiF3NFWSXdOm++xkcj0?=
 =?us-ascii?Q?88nj+nkLtatLUmN2bZGVm7ZL1NVtMXR4zr6CDM6VwZZ15MiKNLdYzhh/VsJH?=
 =?us-ascii?Q?1f9APzEe0zZ1EcN2+14tuo4UvUJbm1/SG5MJXQ1S7yQbiSVDlU4WAH+tl1YJ?=
 =?us-ascii?Q?mydASFnIeS8XLMpBNnokMQTNThGHXGDwZIsroAriM2/slaknSwbxMRKm+Tu3?=
 =?us-ascii?Q?FUiXcoNLesgxy/3AaR1qVW0HoJnabafR6t37CTw0VHLkDzHL984Op5Fck3Y8?=
 =?us-ascii?Q?64wvqI439kNQ5Lb0PCwHMqUX08rPcdYluL2wam0FG5V9qZKRxG5Oq+EUa7pH?=
 =?us-ascii?Q?KeUczXSC8HPF8k1FnNafzQpGQNBFcejvb02CQRKdxFhm/Ny6cYQOVgnde/4h?=
 =?us-ascii?Q?jm/3ubzngOWZTsaToT1q7s+2ndfU3M+yQ5I36WHH8GLitX/nYD7aeNW4ePLG?=
 =?us-ascii?Q?GZhmCGBljTQYgWbtXu0skGpzC6FE1IyTvRrBzd/Wm+OtkbAlxWwnxLxfzeZi?=
 =?us-ascii?Q?QDl7uDqVtzQZ7n0ObtOebSleYbEdaUyk6YRKV11ro55o5vrLEDBjqFPCJRWK?=
 =?us-ascii?Q?IH7XPBxQZ1bip4x8B0zaN/N422Q53VBjmrcl7DdHqXOQxkVaUxFXSptAWFaH?=
 =?us-ascii?Q?DIrsSkRD9rE17NihYVcFp/e7zw27i6QeLYSPeHM/45v6IRU5kN3+GxQ4X1qh?=
 =?us-ascii?Q?3sHFHG3FvtbF3N9FkWi7XeVHdqn39qrkCPYpL3YyGcJvADBGL/3NS3V5lPMi?=
 =?us-ascii?Q?fy3SoKl+B+vwnE+ipnJTCTUS1q+sMDBZTFHlc8EfO/OsoLi+yB1mVARDFaLK?=
 =?us-ascii?Q?iRj3VNXd1AKam2d83ExQ5haB1qwGj8Y03rym9Z8gAwOHOU7ku8iVeVU5HWbc?=
 =?us-ascii?Q?EsFhkRJpG+gsZ7I1Em4mkdO6kiZYAiusQmeKM04EFKoVwb7QvindE1eR8Twr?=
 =?us-ascii?Q?cuBf3OnCMamnv78dnvjnbo2hAee5DlCfB9cdhJf9tGmHPDkNjL1vfPn+6MiV?=
 =?us-ascii?Q?bajOeYzwsImF6j+hjrQWtW9Og57elwFAVjlIyF3TVpSj4A7NNiFFReQqwz/A?=
 =?us-ascii?Q?qpBKFJylXI3r4pVbXPSnh5klgxGBaLh6ISBAvLugYoM5Fd22bTjXDyPIDzEb?=
 =?us-ascii?Q?7iScKm6bQB43nFgQPSL5+uCLArDwALowuFwTNFwrli4gr503elgv3l5VdLWX?=
 =?us-ascii?Q?SQyUIiPMIbnGU750FICCHwrFbO8ofJZ0lXLz8HjrdzKV1KPPyrkdvZCnc7E8?=
 =?us-ascii?Q?LI6Pm53DBPJg9rm3HPqU77fWQD09JxkntdoA7+KxHytvVHFWLuRkNB9yrbpC?=
 =?us-ascii?Q?ous6wsOUGAydeRb9f41UDtQaA4NXM0KgdLJS03ViL1y/mIyLmeGC4/ratzzV?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ciEdmNPir/DivQHrQllEE+j26qzpKsHKQam6PsBJ72wdaLKmbE7BR2La6wgfGp9UvHNaCTt+Nl9XEOTBkiSZ6BjW7AsTlwryMQxISgR7xywgdzhXrE590BZhZFqPX/49DQxQQvks/md1GhNl+6to0l3o45V+LHmxWu7U/MsyZpfvayeu/WZjSq4SvhPJ3xbUaxul/pZdPsuL5wOljR3pAoXVDnXj6XHlMHyQVOgs/om746Nki++3bDDiiHsWztjZKhGe9ouBDg42tnpfMxCKszl9f+H7vVHeXGO5y0zifEbzS3gl9lZCT5RR+lw7v8AmC/PuV8xY2KkhQ1LQjJNqVXIZEJH4LD2Zm3m77YtfOFkjkXjVfBvrUIrJU5QnhGk7yMC1EucgrfdAWepO00/XNXDrzl66kpXZXFtdD7Fq5tLMVi+uw/++f8SrsqoUj5xEzDsiunY1xVEEOArNwecXFb6xWf8vDr1acXGwmnsH0u1CapmExIYv1WdigIHNrCsU04V2YQLUesRAn3ZtkGKNB7hLcnCejHQAF+Fo3m3BKC9FnmL1Of4Ay34cBNSD56hgOwYV86qxYZmx6dQetw+hVQ7wC3jc7x866uAYbDrk4YM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241c0fa4-5c87-484b-f266-08dcb35d4fc3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:40:53.2933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FFqsBlPRYne1J4KXY3/oKlVV/T1oIKAMkJ79Wcx9c7+Uf3HtYBKiL/w3O4j8UWWCBoCIevqIPsQG+jC+08ZJFXLJsWoMmfglPRtPpvs/1yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=490 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408030008
X-Proofpoint-ORIG-GUID: 5JnOiO-2i6u8xfmMP7obFt2hHkk2rhBu
X-Proofpoint-GUID: 5JnOiO-2i6u8xfmMP7obFt2hHkk2rhBu


Kees,

> This replaces some of the last remaining uses in the kernel of
> 1-element "fake" flexible arrays with modern C99 flexible arrays. Some
> refactoring is done to ease this, and binary differences are
> identified. For the on stack size changes in patch 2, the "yes, that
> is the source of the binary differences" debugging patch can be found
> here[1].

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
