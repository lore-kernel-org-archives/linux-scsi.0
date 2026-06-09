Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD42C2165EA;
	Tue,  9 Jun 2026 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781013009; cv=fail; b=s55dvh/wisw0NwCDDDV1An8DmEeF6HNpFa14Q9xV+ClD4qBvyCCTWknKNAhFL3ShVLMFYQFcnfqEphZQoJDQS5dKj1owoU23fmb7IzjqLFyZ6HEEZtV78C1ESrZ6ElQwUdxzcj0a/9jXBRTNjFhE88Vt1teaYpIKDn6RDasEzVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781013009; c=relaxed/simple;
	bh=WBKLZd9OIjOoJDmD+6g21Ydu11Nya05J/mPzacOxFEg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DihcxYL+XzZQwpRjnhIzCPKtRzmMaXs/ax7775FbTsHb9rUbn04s4IhAHNpiH/+AwL5904aqU2zhfurm4j3+wV6VYqV3Zd8o44Gb0Pxk0MU7Rx8rarR4FqEpEcEQ+KsyvvL/b90NraJRVp1HpEj+UtvE2UMIweVPHXGeGiMmKUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eB4gzFDD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xW2izkgD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eB4gzFDD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xW2izkgD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6598ET1J429239;
	Tue, 9 Jun 2026 13:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/V3UdAEA3/pOxwuT972n9zVmqUC/cICGCYkn3KpLsbw=; b=
	eB4gzFDDWwyR5Q0cQEVL44nJMBj7S04Xrl1JKnQd/r0taFtP/gtfTvQ+jCwJw+83
	N3B2jxeLeYDAOA7M5+UfLBHQJpWglUTuS3NfkQUn5k8DGy6cDH+ef1rqJtsB1VT7
	glf+Bi8ji6j79jSlrS4pUUjzKGfd+A5Gai2tZnHsXAMgKtSL2GYvJ01XGrS9TuG7
	9OUPiDj1xqE+++luHcsRjlqzzRgQXw9+xrMwTlMAzzk+JwD3ura4PseVmnoxHCBR
	gnKu5AYueehn8WpoerbrimXdC9RJTrFRa+VYpTpnuwxXF69Sh/q3+qpHxGoErhwI
	0/LxSA3ECO7q1B6/JgAkhg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4embe7mbbj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 13:50:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 659DmWuv036288;
	Tue, 9 Jun 2026 13:50:02 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0q5sqm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 13:50:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aCo+DsBpwfHXi8q9PPPC1iM98K3fM5wRipNkqzp0p30qdNCjpBEbE64s4FJiEnYTe6bhQFfaRyWZOtgOZbwwQaFFHQ67xZqj9Rt/fAn4WPf58FjqL8eDBan4QGo2KJwBM4qJH5ia21df9VrKusakk2I3SqpnU5YEUrGF7v6UyyCUwqivf5GZkJmlvkYveluDGE/zkO2tV0UPgVTlII93mR1HOrWAN91k/pRi70KZ+kfLx89X3BMQpChshNTULzDvHCejq7X7cWHJ4ckLyGEKMw6wwcfAxOqAPJwlhUcdSBOWKGwBWkqe/JmegydbrD8bO3Ra1bxrhti5jKXiGW3GTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/V3UdAEA3/pOxwuT972n9zVmqUC/cICGCYkn3KpLsbw=;
 b=Vq5QE3oNWU1ONbJbS87U31geEDL1Dye3b6PqiuLESPnkskFzpzaHWj+/UYQD96n/Fg/gqfBnN0IJpmYn1WtCIv7CXOCqPMQ+YwGnOODCdPtPW2W3e2PR0+7frpLW/RoU0ee4WFCRIKyb5lpoMppDDjR46bHeYif6liF7R4Zm2/ACliHOk4VL9lfNtlaPfa7th2b6LkReL1C5+NGjufB6QKGQfE6A50YnDLm6VoldEkz2Yf3qvMcyBA53S0wB/SPE9szCyVSWx2rDScPJtZR5JIG7VR8Rp0Kghuv/D7EpoLJEHZaxeIpnvJLGWHQp/yDiDOnnvJjte8qlRtW/SiGOqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/V3UdAEA3/pOxwuT972n9zVmqUC/cICGCYkn3KpLsbw=;
 b=xW2izkgDB6grqWr4SQI1L3MZ3TlJ6bPHVianBnsT3SU+HRiAXFLyHDicQVYNO3NSu+BeYePLpkv0c6LWTzDjmq29y/n1PhV7R75YGdspmul5VdKMGo1A2MC3mYhTy7EOhm7jm9nfqVdiEdILSTombSZChnfKJYNW3F9zc2U3NOA=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SA1PR10MB6517.namprd10.prod.outlook.com
 (2603:10b6:806:29c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Tue, 9 Jun 2026
 13:49:58 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 13:49:58 +0000
Message-ID: <326c25c6-d51b-47b3-8b8c-e08bca58462d@oracle.com>
Date: Tue, 9 Jun 2026 14:49:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] scsi: scan: allocate sdev and starget on the NUMA
 node of the host adapter
To: Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        James Rizzo <james.rizzo@broadcom.com>
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-2-sumit.saxena@broadcom.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260609121806.2121755-2-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::10) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SA1PR10MB6517:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d6f393-669c-4559-9451-08dec62dfe8d
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
 zUmiXgTouE9zUnH7JTqQengoIGn4xZUD6fDzwM8FZD0Ux65ku2vGXO8r8hocnDv2zqyArvXC8pmqdXc448wo5LODVg8s9U/VRrqml7MdMwROiHoBBaTZifGBB/doOfcTvBP9XMMwDYI8u4sDDWff74KTOwetR0YHcH+9VsDVkbXyPGXllXRFXWX7qfknZygtGeSPiyBJl5F8Bx0vaj9ysgYjBAdZ7TYAdK8DYsLGUTxt59WkPPPlmaIBbXqElReawoyC7nmyDvdJtAKUpvtH37Ntw91cETrptVd5JMOmzuHMsu+sqit4vKk61oaOBVMpmMwHGYcvAKVnzZHrHHt4lpUdeUykaW7+CAKgPmgkDiKJpcZDApxBjqfUDA3SIE0IKvdhnwlhi9saIMWreYZURhF9DQomZ4H+Q7ymDW7iK1AFnxvJjOBX8LiKgeBSVZlpcFJTVUyEiN4ODVZU/q+cyqrreYT4FwT+qlIYH13xRyEkgnPFupZ5HEMgGRrtuIKduMDXY9yQALWefSQobbgRQjhQHNPx+EuhHHWuY4BuaFqXwsRWLLi4H4tuNMyu88qslUXuWPT96Fg1zhU/dg0ee0De0BNx8KEWRSNkBSbU768uIDdZAmMtd15NGUjhN8gBfdmOVfl4urB7klsvbKaD5G4AuGl54WEoeUd2Kbyc7z4w5+DEsMLzWvTZck/N1LKb
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WE5mZFpURHA4RUdOYzlwYlJGcVozaFdCT0JKRHQ3Z2NaVGNRZXZqQWJ0eUgv?=
 =?utf-8?B?VHYrUXRITUJEQ2RvMmRCSzNlRFBoTHhFbVZHU041Z0h6MDEwcHIrRS9DWnpN?=
 =?utf-8?B?VHpOcWJHVGRXSHpsS3lueTF4TzZSenlUdWtUNk8xemFYUFVJa2c0S3FneEN4?=
 =?utf-8?B?OS9YK3MvNFZHSCsza2NrTEZaa3pvdjhnMGo3M3R5UWQxMW9pSVBUNWtLa0My?=
 =?utf-8?B?K2drSE5OLzFTNFI0aDhMcVZMZGdwU3grdkM3dmFHK0VFSEtRekhROFErQjdu?=
 =?utf-8?B?YWR1Z2dDdGxWcnQ4aFZFUkhFMm9NMm5zcU9ZOTVtb3Mzanl0VHJZY3Vqa3Fl?=
 =?utf-8?B?TVBWR3ZXSDNHUmdaaUt1NDBHN1FNZDhRTlBuRC9TVUFYMWZISW1ReFpFbTVU?=
 =?utf-8?B?TW5kWXZsZ3FaSEVZMmlWRFFFRzU1L0Z1ZFB3NC9nL3RnVFcwTzZ3WnZjMEhH?=
 =?utf-8?B?djR3TDNsMUpHL2pFcnJQUHNoQzBnU1N0TEwrNW5BemRrTDVFQ0V5SXdEUFBo?=
 =?utf-8?B?VFByMHR4dVJ6bG13L3pyTVp3Tm44cDkxVWVsUGV3cmczNXk3QXJiMmJLaStE?=
 =?utf-8?B?eUdOcXpWRFhRVjdNbk1pQU5wbDVDaUQweGtKSDhoNk4wT0tBakxMNE1JTjdp?=
 =?utf-8?B?Wk53aHZ3a1d4SGZXUXJJaW5odDVPS3lHOStzczRmMHFaZ2tpeE9td29xZHd4?=
 =?utf-8?B?eVY0NTVnNUt0U2pvUXVVVVFPeUIrQXk5a09Pc092K1R4SzZ5aXNrOXIzYU9L?=
 =?utf-8?B?Y2hmSlh0dDZZNmUrRVhLYjFwaSt4b3FVM0M0dXN0QW42MGFucExKc1dGOVlO?=
 =?utf-8?B?ZnNUbWNtcFk2S1hRMkV0dTVsUXdGWTEybU9EbkdDcW1idlNjNjhhdk5oek16?=
 =?utf-8?B?ZUdFODVDMUVMS2pYZThKRmpQSWlDOWd2UzVXTkh2V213QVRpb3laeHhuTERa?=
 =?utf-8?B?d2xCNllBZDNkaUx1MHNCRW5LaTNJNGJpbDJTNFZEc0UyelZDWHo5VHkzb2hD?=
 =?utf-8?B?aDlCUTBsMStVTk5uTlpjOW5vMm5KeUtwdkJ2MHEyUjZ1TWtCanJURVo2NUxY?=
 =?utf-8?B?V0g2Ti9CdmhMYTF5SU55RXh4R1hEczhiL21MMGFqMi9Sc0FaQ1pJaEV0UUxj?=
 =?utf-8?B?QzdqOVVxbndhdHhrKzhkUXUvdEgvVjlXU1FWTjZkaEJmdGZhcEk2SmU5d3I5?=
 =?utf-8?B?M1ZTb2FQQ01oZkNhKzlWNWxrekQvOXprdmpEenRjblQxbVQ5RTRhZXdKNHVW?=
 =?utf-8?B?VTFrWHdZYmpTZzZtdkdGYllUWUZ6QUxZdmpxRDZKWkZvUDFESG5yVTVqV1hF?=
 =?utf-8?B?UWNmeE1LWWJDeW9XbGtiUzRIRC9XV1NlOTdYUVB4WkNrRWQvM0JKZVppdnlZ?=
 =?utf-8?B?TmtXUXFuMTRjU21KbkpSaUc2TWlFV0NmRWpjL3duc1pJRU9RMDI5Q3NiaE5z?=
 =?utf-8?B?UGMxbWpqNCtFQlVNcGgzVEliTzRRaVFxRlBkQy9YNlFweUhzL1pkS3NVQmJK?=
 =?utf-8?B?bFNsTkk5aHJlM1pHNmpxNmV0TjAzQ1BYeTFUT3VJREtEL2VVbi9PWlFiTTli?=
 =?utf-8?B?Sm1iQlNYWlZYZEZMYTVwVWlacE9DaXFieHFaZzZrSFhCMk5Fa3lVVUpQY1NM?=
 =?utf-8?B?b2UwVU9Ua25LcEVBVTRENUMyMzlEU3I2bjVSWGQrZXVaMyt6Q0Y1WE54cEJL?=
 =?utf-8?B?eHhKQ2lzRkpCQ2RMNzlCYkFML1gxTUVZQmZXQmVaTXJmNnd3K2ZxREFEN1VZ?=
 =?utf-8?B?MWVrYVpVbEJtL3FxRmtjc1VoMVl1V3QrYjgreWcwMW5INmc2L3RiYzd0VTZm?=
 =?utf-8?B?ZjJlV2FZNDJiQnRWTVRlaEFlbGlkN3JMVG1Ca29RQ2lLSzlQc2FhNmhrOGQr?=
 =?utf-8?B?WHozcngxcmZBOFdLN2FydDZ6UHhtSWZvT3hRcjVmRittT1dyRXNGTEx4SFpR?=
 =?utf-8?B?RllPTmFpUmNIVElrbDY4eXBHSDhYYVpFNHBOaFBBNzR1T29TdTY0WllPRko5?=
 =?utf-8?B?WUVpOU9hQ0Q2NkMzREwwRW9YejYyYVpGL1QyZ1VOTVQvM3czcG1yalZ2UHBk?=
 =?utf-8?B?SjUwNEh2NWdXbE1wYjRnZ2ZKSExRUlJGeHFMdDMxNy9QL3JFTm1YcldGUUNL?=
 =?utf-8?B?RmIvN3llTkNxb2ZValRRZlFGNHQyQ0t5bnZwWUM1SXVrbkg4UW9OUWVWTXFP?=
 =?utf-8?B?b0ZIRGpveXFsMmhTZ1hTdlcwaG5PL1lKczZRcDFQVUhTWkFRUTN4S3lQV0xD?=
 =?utf-8?B?cTVOeGVGR0svT2NzTEVSbEhRUlRHL2h4bUlob04vR3FpM3VGaG9uQUpOQVZM?=
 =?utf-8?B?NzJOM1dqKzBiUHgzRmdlYzBDVGJ1VnRhUHR0Q3dXSG1sZWhGMncydz09?=
X-Exchange-RoutingPolicyChecked:
	XqIyCHkgbody7Uc6ac1JbA6Qwz6p3JGCeyFyd/Xpl9KP2RjN9lGleETU6cId5IqXIBe2rbZXIbfP7sQHccwXwtjwuAebJqqocddxee1P4iLQepc86waI53wBTOiEcVqnxfId7CUwT+UZuGIeQ8fysKVM5TOb3m8FkGB3dV8dWXW3UcZJdK8YGLDA8o1TgXcMAPbtY0IRGYiJ7L0t6jjTxR5P95cCdkrT7A4cuW3oQcpt9+v3GJuqyHwCnJLw1KRnpX/EtGyyFeXKu9fkTKrkjw7nv7jTi4uAswmhnu9iXBFfkDsihR5u/cazUTSd95qRWQ9IHyDa6zAbx0R9A2y95A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PywoaJy9uMBd8UXBgRIY6b9xDjNsvKw0S2T6uSTncbZE1L0XrogANgAibWUFgg1zJt2Bpgj7v8Akhy7cTBp+zFTGmNvEbDsAaCEhwj3a26V4iztpb2+cd+LLGRQT05C2hWLvu+KJsOBsMHmEOylu1hCkh4SQgPPPC8MYqEw4xKgIHyWutIz6X3ZJqitSNqRmso7Mm7AEWPlput/YaHTsbkOWNEvhHwEnC02L5i1odb9fGSoQjr4d48XmylmOjhZfueMSDGFOOZvExDhzg/T7cQS38GF+CVAcUhTKQJmBDgBIS7f1Tv8RntpzF3hAxuG01oGnCjXK2FYhYRjbq6ZNHFi6vAn2/+mUx7CMot/oyhiR1381mBHzdTaS6q180jm6RR2Fc48KDn4PvruIs/tUXRzYUJIgTRcSQdBn5vLmvzCFMgxmhFb/sDdlX/CPwVh46XZrS4PvJGaY3F66oiv3Z8CWTiVOyLiMxlZfjnFh03lGcAMYjJEljyAgvO1tE+WdDl+p4PBB5HIInMFSDfGI2cuhBTGZvYUUg3PhkvYw4+jimB4fGxzbibmr+aF4fWc/FJy0NhADLSsCd2HFxXTwZLTug31k/MOmN8Tl6Co2ALQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d6f393-669c-4559-9451-08dec62dfe8d
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 13:49:58.2799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgWimP9CZelJskP2c+AZKj5DFRGi9xFV/aBA6QWCpxpbf4A7u/L219sYY+DxHx8ppuepfyED6rT9mIqAvIS/OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_03,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090131
X-Proofpoint-ORIG-GUID: K97Y2-5WxpupPiHRGutoXdMwZyqXCsAd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDEzMSBTYWx0ZWRfXyv541DVKp7Ic
 +a3JYKDBhGSqMRIlBYCOGckXq4DP0TWuBukZG4cD9u0wY2E++GDecUbvHnO3Nfm1Lz0e4ED9nsG
 7MKcWNc2LuRv+sspgzTCBRTOCHynvxcVebY6Iq8QjENX8+8FGeZUahsWnA8lSdLm2wjQL3fPNMK
 pETEHs3MRyDn08lm190fzWkFnZEMRh28aSY5EFZBAlXK6srj+E07nX1uBCVHfeMxOhY9roiLRmi
 CrnNmDxDPOntkdH0EQCcg5ph06zwQ0nBUrWdbSjIgtgTJP//E6yvgwq67j+Q1FYkMp2YVjag7fe
 /lRwsNfx+hz+PwNv1DGRF3+CJ+6DOjdhWeMsYT4bpyhc4YcWfT5ho6ZudQIHIG67Ysj2PT8tiVP
 RuMQVin4W38zw8Bq4gCcrxLCtYE5HTM+Y4sYYymRuvIxuugVlgnsePor/2sb1wpIddEvsO63SfY
 b+FRn+T7Fy1gXtJqYt52w/WT+30EzJH21oLyhvuQ=
X-Proofpoint-GUID: K97Y2-5WxpupPiHRGutoXdMwZyqXCsAd
X-Authority-Analysis: v=2.4 cv=AufeGu9P c=1 sm=1 tr=0 ts=6a281a0b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=Q-fNiiVtAAAA:8
 a=yPCof4ZbAAAA:8 a=Z5kdbVacZpMcIZIxTIYA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723

- huge trim


On 09/06/2026 13:18, Sumit Saxena wrote:
> From: James Rizzo<james.rizzo@broadcom.com>
> 
> When a host adapter is attached to a specific NUMA node, allocating
> scsi_device and scsi_target via kzalloc() may place them on a remote
> node.  All hot-path I/O accesses to these structures then cross the NUMA
> interconnect, adding latency and consuming inter-node bandwidth.
> 
> Use kzalloc_node() with dev_to_node(shost->dma_dev) so allocations land
> on the same node as the HBA, 

kzalloc_node() does not guarantee local NUMA node allocations, only tries

> reducing cross-node traffic and improving
> I/O performance on NUMA systems.
> 
> Signed-off-by: James Rizzo<james.rizzo@broadcom.com>
> Signed-off-by: Sumit Saxena<sumit.saxena@broadcom.com>

FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
