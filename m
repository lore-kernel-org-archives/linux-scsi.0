Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24919183CD9;
	Mon, 12 Aug 2024 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723476746; cv=fail; b=g/+R2EbDCv6Np5PpG4J3tED4uaujEEHbYH7J5ZdJQeok1LPYQT8yKQPLJrsG8YgHCSfDYL8bpWQW+dl7nZB8Rll0l1FtzT5k/s8BeUaUc4qNiaQwa6/PsRSnxph5FPdurGYE0A5GB+2aouzPeEntfnUvnYpMM59By9fEgjgIyNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723476746; c=relaxed/simple;
	bh=bNhg5+agyOtP1kD8hILznj8l4vZuLlMLFp+2jleWgWE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oglvyPP/ER1bU3gLKooCHOAD9bxjADS+HO6XgiEVqXJXoDzvIi+pPdBeh/St9DN6ziosit3es4u3aaNs3KjeZ0oFnMyyDXecwbQbWk0vFw5gmz0lwzTPzicZmY/8w5ayF7k21ny4e83eyrE3WXW8ZgH26ahLbpZOVu7u6p1YS+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ivhIBd2u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VjIDM8Zi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ivhIBd2u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VjIDM8Zi"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CEtZCh016214;
	Mon, 12 Aug 2024 15:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=helsMiJKvns+Qj5t+nfqXmlrSPbn2Sor+HRi0uyPLQ0=; b=
	ivhIBd2uTOmNXIhuahllFvgj2o0iSN6T7q8aT82Z7j/pwODI7zxZ2gaq0IWRy7+j
	MiiwLciPo8pn0C/vy5nqahvEtnZrMRnM2nIv/+7q5OhkQyobglGtz/W+n6c+Lwxd
	BxbpWO/1vdaO49uClKTvtd+YDodGbk57mYjXmvI/AdNwVGEEwlBsE+G9Sk4y/2IW
	eWA9K7OA0Al+TQ/9fIWmTlnjfAMg9vtOrgNqTEuldTzkjuAyeDBbR6aOu0y3m8jL
	9vBdGJCugyGaSF4G8qoI+C9CkhzYhSnSFXA6m7TzaB6dpZ/92y+xrl+gBBE8aoRx
	58Zfc+gyIjD0wDFNSoRp5w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy02twre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 15:31:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CETaBB000661;
	Mon, 12 Aug 2024 15:31:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn791ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 15:31:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2S8nudV9YTckMgGk4le0TVD2bpkHorRdeBbZXEaC/M6gE9/0C/Ax7yu3AGYlewKypMKPGN+SQ9Q2A8ppAfYpzx0OGZp2YcP5EtcrII165s0T1IzirrJLeB3DFYTgkvxcsvvGtfVFfPEjeY+fX/RrnBb40lScsOIPBUOoGHBsLnvGz+crVYBbzcEnNfjWOU/ouAXj377JnMq7T68IX+XdkUpez1CnN+Gy33QHeZ2kAXG3yprKaeESLPMJ182qJxQ4WnN6cQut6RE4NGwzV3uIxZR5loAhaxGF0mGiz9aQeP4IonMMl1u898dxOg5ZKAhrmmjKRokhWFHr6KZZZmJJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=helsMiJKvns+Qj5t+nfqXmlrSPbn2Sor+HRi0uyPLQ0=;
 b=iuXMUWkTmJNl3h6Npd0qat27t7cbSDkm1f7uvG5Zcc4NDGfy619zKeA5rOiUHHW5aQJDBVF5ftsqeFTC40O/0UalhPDdGJvLlMPkpq5fLGM/KYweNj6LZcQ1eTHpVcA1VNp9LI5vkqjOk6FKQmoBzdo2NDGdagZaQ4CwKtIntrABbAMaOOhRTdmue2n7lUQplPBE5FtnZkf9ubD9fTfstizFMSNQ5NY2j4s4l2iwL6SXxNs8tP0+wQPeFdJoEedP7H2w5nfJWzrLovtkO2uEwfx5/Qlg0izirs1hK/xdsz+HpgLQWTs/1vAJ0bgeOEgxHABWVX7TEoDWfbj404YuwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=helsMiJKvns+Qj5t+nfqXmlrSPbn2Sor+HRi0uyPLQ0=;
 b=VjIDM8Zi4Wwa4uZHTDY/DMdpIqLPr9zO2S4arSYfhrQOcI31Yt1nE2uvxnEGSSJDMS8DiQROAao90WXRS0nvcvo4UIWGFNPTMX4X4+Ikc4EHoVqG0Vp4ZttTi+l1PtChwFGe2snUY1uQXk+qGRqZGUFR5tH7qWXHW/I0GRjNsAM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN6PR10MB8046.namprd10.prod.outlook.com (2603:10b6:208:4fe::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Mon, 12 Aug
 2024 15:31:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7875.015; Mon, 12 Aug 2024
 15:31:39 +0000
Message-ID: <038a3990-6ca2-4260-a36e-b5f0c16d8f76@oracle.com>
Date: Mon, 12 Aug 2024 16:31:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/15] scsi: replace blk_mq_pci_map_queues with
 blk_mq_dev_map_queues
To: Daniel Wagner <dwagner@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Jonathan Corbet <corbet@lwn.net>
Cc: Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Sridhar Balaraman <sbalaraman@parallelwireless.com>,
        "brookxu.cn" <brookxu.cn@gmail.com>, Ming Lei <ming.lei@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
        storagedev@microchip.com, linux-doc@vger.kernel.org
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-4-da0eecfeaf8b@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240806-isolcpus-io-queues-v3-4-da0eecfeaf8b@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0153.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN6PR10MB8046:EE_
X-MS-Office365-Filtering-Correlation-Id: 8363909f-73d1-4c68-d404-08dcbae3dbfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YTYydjdEK0szRGpqakZVY2o5RlBuOUVXNlkrOFA2ZDUrdU14M05ISTBQRnpG?=
 =?utf-8?B?ZlR0WW5QVmZIUERSd0QrN0E1dzdPS3B3UHVqeGhlNUVSNGVWc0hWVGdtSE9p?=
 =?utf-8?B?VXBGTCtYb05PaTBlOTNBaC9FQ04zVzF5R3ZmK1JmYWtyS29lZVlaUlVyalRK?=
 =?utf-8?B?ZjF4bnpta2doaFlEUmVFL0RlaSs5MHRKWEFENkZ4MHJoNlEvdXlFSHFSMnEv?=
 =?utf-8?B?bDA2NzhXTHhyTlBzNmt1cFJnOUthazBEN2VKL21CaVA5bTBDMTVSMUpPS0JO?=
 =?utf-8?B?dmxocmFiSlZ4UGYrY1pLNnBjcjFoZjdVdjJXOEJsKzZPUzcwU2lqVDZydW8y?=
 =?utf-8?B?OGZobEtXQzE3QjM5ZzhGR3lGZ09aWDg3eFRPTDVHREIxeExjUE1menIyRlNU?=
 =?utf-8?B?WS9WSFJkaXNPbUlSSWxhdnNGVTI3aWhhOGkxM1preXBEY09rbWN0ZmhDMFFH?=
 =?utf-8?B?a3lWaDZ4Vyt0STJ2MlQyNklWVzN4bHlkTWhkcElzWFdPeDN0V0N5a1NGQ0VF?=
 =?utf-8?B?ajZubEQzOXZmZC9Da3duWkR2VVQ3SFhGbFA2VjY5bmJLN1k3V0F2akR3N2ZK?=
 =?utf-8?B?WUhIMmRDWGxhL0k4OXVwdHJmeEdjbEd1Z0xlSU1jYU1zTUU4c1FwMGJsNU5M?=
 =?utf-8?B?cU5XdDAwbytWTzJLVlpobThmR1FjT05tcDRZVzRMN2ZSczk4MTFPVTZUZUdE?=
 =?utf-8?B?YkQvT2tEM2p0dGtGSjhYbENvR0hpRzBGb01tQlY0U1VZa21reDFlYlVyNFBp?=
 =?utf-8?B?RS9rc0FGNzJqeXR0YWkrYy9RTXdVSW10S3FpQ0RjYnpSU1NtM2EweXRtdFVl?=
 =?utf-8?B?OWN6bGtuczc5YTBFT0ZpTjVFWFVuOE9tMGV0YnRjTUg3WWNuMXpEUFNuNDZY?=
 =?utf-8?B?WVd4aHZEZzNwT0RMQ1B6R29oNkx0OUwwRnpTRXg5SndaZHNXTk50V2x6UC9m?=
 =?utf-8?B?MDlLdnNDQ3pQeHFSeU5QWjBRbGxoSDE3NWZqeVlYTExnaGxlRWRPMFVoQlJI?=
 =?utf-8?B?N2FneWFob1gwdVI4WmFGY0VzdVdNVVlrUGVqR0UyL09NckxBVFN1bWFmdTRW?=
 =?utf-8?B?VzRTYnhSQTNlVC83K3htdU9MZE9IT2t3MW1FTklhUmwxakMyemFiMFFwS0ZK?=
 =?utf-8?B?T1lwSUVQci9nb2tHMzRmNlU0TWdkUUhJTmFxNkQwMUQyWHVERmFJTy9jK2xI?=
 =?utf-8?B?OFNJTU5hWUhoeTRFMElFaEM3VnV4N2c0N0pXRk9kRFBCczN0WUc5VnZlalJ2?=
 =?utf-8?B?eFVaZlhyaDIvN2ZlVHVHT3EyVjhhbFM0dmcyYm9IZnZ3Y2dUcVZTMWJGYVRO?=
 =?utf-8?B?L2tIMHNYcWZvelNnYUtHa1EvUm5RZ2R4cjhvNUtYR2pDSlVrcTg3M29PcExv?=
 =?utf-8?B?WGIxNW9QK3JwRDJ5U2R5aEJLSnRhQ1NKZGZIcWw0VmIvRHVqOVE5Y1FQUzdm?=
 =?utf-8?B?U3FYa2JuaWRQZHZmck5mVG93T05xL2Y1dHMyalJUaDBNbjlMcGxOaER5eUpC?=
 =?utf-8?B?eEMrK0pUSVFHN2lBY2xlY2tYMnQrTkVhSUNnS05OMXY5L05WYzlvSGZnN29p?=
 =?utf-8?B?U3MyVGdnSjVGNWJjTDkweXphNkdlMGhtVGExdlZ5VTFGWFFvd0VIWWMzZllD?=
 =?utf-8?B?SDhBQTl1WGpEakU5ZmFmYkpxcktzc2k1WjNKalMwOGpMdFZwSXMrMDRSSVBt?=
 =?utf-8?B?eXVCVDJqUzY5ZFJYK1lZdWhmbFYyVlV2dnZ4TWFsVEI4OU50c2VicW9vU0Fm?=
 =?utf-8?B?M1NFb2w4c1RmYmRxT3F2SEprZFdCd01VZENvbE1HRUx1WlJqOFNJc2Q4L1Zs?=
 =?utf-8?B?NkZ1MU0yNm1JR2VyTm9CK0diVDMzQWxBNEM5aUhleGVxRU51VXdYN2FkVGNx?=
 =?utf-8?Q?4m68yGPOP7hMQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzhiMVFDSXpkWGNuc1JyQ09MYy9ZV3M0Zzk1NE03UGxzQmgyM0hWTmNmaXFx?=
 =?utf-8?B?UHVRSW9heXVtTzFNVFF2amRxU3FobVFxRkI3cTU5WHA2VFVEL2kzQXdZQmRo?=
 =?utf-8?B?cGVzUTVCNnpLTzRqSHhjdmlVSWd6bG5QaHhtUDFFUmY4bGpQQnVCRXZabjl6?=
 =?utf-8?B?OU9zcUwxVTVLRitLdDRCd2pNY0JOMk8rdTNMU3d1QUxKdS9RMHFRZlVtUFUr?=
 =?utf-8?B?K29XekhSVkMrcEhZQVQwWGJUK25JeXgydnptY2pSRGVXZEVtSVdTblJiOTMz?=
 =?utf-8?B?VWJudWgzRzdCT3lJMGs1ak1hQmdBdGtjZTRzd1lXOG9FdE9LZ0t2alNRSGU5?=
 =?utf-8?B?MEtGYUIxQ1FrNFNUdndoRENNWmU3U1RISlE3QnlJd0hybjJScWxPdXBxZUE2?=
 =?utf-8?B?Ty9YbTdQbXQ2N3prN1pmeDdNRm9zdUJiVVNwNkNWV1NOdUNma2g4TEJXTm9v?=
 =?utf-8?B?Snd1L2ZWSVdSVllRU21seTBRdVVzZk15emt4NGJKRDVEYnNsYS9Oa25oeFFj?=
 =?utf-8?B?aHRBODV3Z0V5SWM2YVBGWkFkQkFkNmRxOHU1d2l3ZmQ4WmhvMTJzRUIrVWJT?=
 =?utf-8?B?S3crM1RNSVI2NHFLMUpVQ3FvVGdaSmRyRDMybjNQdU45SThvY1VqdW01QW55?=
 =?utf-8?B?NkxjdC9DaUlMcWJ2YlAxT0wySGVjQmx4VHQyZGticnhhaWU1SnBRM3ZNUnlj?=
 =?utf-8?B?ckVtS1dWSk95dkdUaDg3OU9VWmJRRldKTnZCNlhiMXJhRkVGM0VPRG4xQmtl?=
 =?utf-8?B?TDIwd0YvWHh3RU1qRU8wR3lHOHJrbTUra3lQcjN3RVBVcms3TkVtRlBsVjM4?=
 =?utf-8?B?Mys1R1FaQmU5Lys4ZXZWbkJoaFJweW1WUG83eVd2NGxWNVRBSHFzNmwycVNL?=
 =?utf-8?B?ekJPdVF5ajhsQjNvb0FWQlMzSG5JL1lMa2Y1bDMzOUNJMTVFRmhyN2VacEho?=
 =?utf-8?B?Z1E4VWs5V0IzWTJITi9BdXJ1S0J1T2ZsWlMzTE9ZSE9yTko0UkxTc2syQk5Q?=
 =?utf-8?B?T1hHQUpUSkJPajlMSENWYWVuSkFsMVVDWmNVTzhndXpUSW5NNjBHNnQ4SDIw?=
 =?utf-8?B?NzNWZnFuRmJjVWJHZjFZNElnbTRYTmlYOGJJZFhRaFo2Sk1HWDZkS3JKMDVN?=
 =?utf-8?B?ZWJFdG1yUXJVV3dsb0hnZnBzQmU4K09IcHA0aHJheXA5QXRRRnNoUFk4elEw?=
 =?utf-8?B?YnN3ZjNPTmtxTjBTUHlHNTk5MEI4YWFqMCs1VnQ4VENuTjFPUzA4OVB6bmxs?=
 =?utf-8?B?cTVNb3pPdnFtaWFOYVk2ZWxMRHBVekFOYXJBU0VrSHo3d1FWQ0tJeFRyTzdy?=
 =?utf-8?B?UGdkeTVsbzBkREZZQmllOGNrWXhXNllMMVVLU3NkWHR3bzhYN0FuOEIyS1dv?=
 =?utf-8?B?UE95RVBMeUxzeHJmQm9ibm1JNmUyYWYxeFZrYy82a2p3VU1JVWN5UlpSTmNr?=
 =?utf-8?B?Z2NpVVArWEs5SFIrVkZxK0VlUGkvbUY4OWx3WEhxWDRnVWdLbEU3TjA5YUc3?=
 =?utf-8?B?WW52QVBsN2ZhMGxyQXE0MDdvaTcrVXdXVHA2OHpwQXFxWG1XSFFtNWc4QWd3?=
 =?utf-8?B?a2plZGw0OGZMYisvZ1Y5b2xQSUFEaWpuazlQakw1N3gyTkVqalprZ3BOKzBz?=
 =?utf-8?B?OHVaQTZQclpEZ2JmZm5aZkFzV2ZLeit3Q0NyK2NtZ1M3dHhVa3ljQU5ZRlBX?=
 =?utf-8?B?R3g0ZE1BZlNoc0V1R3oxK0RxVDZoKysxNHRIT1VrSXNaeE1aUTB2K21GSU5F?=
 =?utf-8?B?RUM0eWZPQUgvK1FtbTk0aEFKM1phQld5K3A4em5TUXBteVR6eGVjQUY4RStp?=
 =?utf-8?B?K0huYUQrWWd3UFVTL2daenR0TjcyZ29LRVhXeHUzVlQ5TzlFelZnM0Q4WFR3?=
 =?utf-8?B?Q0lYSEcrUkE1VTczZXY2TmR3RjlocS95UFEzYnFxUnByN1JtdVFKdTNsRkR0?=
 =?utf-8?B?bi9SaVR3RndSV1Vzd0tGdUtOQW91VDYxWGxjcC9FZmU5bHVXV2dQakVybFl4?=
 =?utf-8?B?YVhkTGYwK25WVzEvT0lvNDNwd1UvRk1JditmRGpReVlsU05FTUVJZmVpUnF3?=
 =?utf-8?B?VjQ1d29sbkhaM3M4ZEpQSm9YcTVBZGxOWmN6cmdEK2dLNm0yWDExL0pPc0Nu?=
 =?utf-8?Q?UNb0BR0N7JtKoLHxLkBpaSonV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WMcMQLLmAkCeoDJDSN8anTZ6JwbKy1ir4xhXnNgxiFSvOTNosy3/hnIGmgH4naUVjnKSyEZUbzP71RrZGQUhuSLWwbXRQfdPuNJbfzWSwafXh0A7GiartvNu+yFwgutbJ3SJwFPiphJbwXtI0l7sqTHVIXXL3pOBD8hErq9XnKmrJXo8riNoTgeRUkx8G5kX0NC42OsoYreBkEIgOfF1hXqzyOIcWi8ArMpPJflO2XDP5cGIP1C9aGtkOT/s7FAYtB2WJ+6LSNbqoVtychzBkwjUzNF8r2dGNJxikT/2hQF3bzh724yI2A4GRnHp+uQfe+6jFGx2xSX/SSTB13vedC++fkdqumz2aswnU+8jaCap2sGr/Ou68VebtoNh7h1aa0iE5wYPeYsJqERURd44ACihaeRrV3dIaIomuwp25TxEa/SoDytfYwFTvA8gbAhj8kBV5wDuRzSxS1PstSjxtzziYJajey0HVVYofmVbh5fcjMNXKrsYAAX2s0ZYEL+1uW0MAyukTqpZ4MkZjfAIHJALAVrNniWsuO8/E4WIhL1Pyx1spwQGsO/mA4BE/3RSOhO8uXlb5E/SWmNG7yvInBrxASOC6KUUNNlEVEWASdA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8363909f-73d1-4c68-d404-08dcbae3dbfd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 15:31:39.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDge5RCK8AHgrw0Q+5SLcBnph/DdysM0pn/b2LWTRovGF1SVWtbFoepeGVqTp4uB204+uh4BmjTONt97QLt1qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8046
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_04,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408120114
X-Proofpoint-GUID: rQcbAK-zoY32svGpL2OzREBmNiKyOJTx
X-Proofpoint-ORIG-GUID: rQcbAK-zoY32svGpL2OzREBmNiKyOJTx

On 06/08/2024 13:06, Daniel Wagner wrote:
> Replace all users of blk_mq_pci_map_queues with the more generic
> blk_mq_dev_map_queues. This in preparation to retire
> blk_mq_pci_map_queues.

nit: About blk_mq_dev_map_queues(), from the name it gives the 
impression that we deal in struct device, which is not the case.

> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>   drivers/scsi/fnic/fnic_main.c             |  3 ++-
>   drivers/scsi/hisi_sas/hisi_sas.h          |  1 -
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    | 20 ++++++++++----------
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  5 +++--
>   drivers/scsi/megaraid/megaraid_sas_base.c |  3 ++-
>   drivers/scsi/mpi3mr/mpi3mr_os.c           |  3 ++-
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  3 ++-
>   drivers/scsi/pm8001/pm8001_init.c         |  3 ++-
>   drivers/scsi/qla2xxx/qla_nvme.c           |  3 ++-
>   drivers/scsi/qla2xxx/qla_os.c             |  3 ++-
>   drivers/scsi/smartpqi/smartpqi_init.c     |  7 ++++---
>   11 files changed, 31 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 29eead383eb9..dee7f241c38a 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -601,7 +601,8 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
>   		return;
>   	}
>   
> -	blk_mq_pci_map_queues(qmap, l_pdev, FNIC_PCI_OFFSET);
> +	blk_mq_dev_map_queues(qmap, l_pdev, FNIC_PCI_OFFSET,
> +			      blk_mq_pci_get_queue_affinity);
>   }
>   
>   static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index d223f482488f..010479a354ee 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -9,7 +9,6 @@
>   
>   #include <linux/acpi.h>
>   #include <linux/blk-mq.h>
> -#include <linux/blk-mq-pci.h>
>   #include <linux/clk.h>
>   #include <linux/debugfs.h>
>   #include <linux/dmapool.h>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 342d75f12051..91daf57f328c 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -3549,21 +3549,21 @@ static const struct attribute_group *sdev_groups_v2_hw[] = {
>   	NULL
>   };
>   
> +static const struct cpumask *hisi_hba_get_queue_affinity(void *dev_data,
> +							 int offset, int idx)

personally I think that name "queue" would be better than "idx"

> +{
> +	struct hisi_hba *hba = dev_data;
> +
> +	return irq_get_affinity_mask(hba->irq_map[offset + idx]);
> +}
> +
>   static void map_queues_v2_hw(struct Scsi_Host *shost)
>   {
>   	struct hisi_hba *hisi_hba = shost_priv(shost);
>   	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
> -	const struct cpumask *mask;
> -	unsigned int queue, cpu;
>   
> -	for (queue = 0; queue < qmap->nr_queues; queue++) {
> -		mask = irq_get_affinity_mask(hisi_hba->irq_map[96 + queue]);
> -		if (!mask)
> -			continue;
> -
> -		for_each_cpu(cpu, mask)
> -			qmap->mq_map[cpu] = qmap->queue_offset + queue;
> -	}
> +	return blk_mq_dev_map_queues(qmap, hisi_hba, 96,

blk_mq_dev_map_queues() returns void, and so we should not return the 
value (which is void).

And I know that the current code is like this, but using CQ0_IRQ_INDEX 
instead of 96 would be nicer.

> +				     hisi_hba_get_queue_affinity);
>   }
>   
>   static const struct scsi_host_template sht_v2_hw = {
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index feda9b54b443..0b3c7b49813a 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -3322,8 +3322,9 @@ static void hisi_sas_map_queues(struct Scsi_Host *shost)
>   		if (i == HCTX_TYPE_POLL)
