Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A78C3A545D;
	Thu, 21 May 2026 08:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779351268; cv=fail; b=cpra3rX0sKlyVoncaq9/PlMxmzzH6N5dotiVKEuCeqIYQ3H5Cvep1q6uwYtIa7l0HPNk8+k6Iu9gJKbjtEz+qNuvXfNYUa6nIh5zu5BDlUQUjq141cnQbtJ174sUDYmsoqDqs/T8PkBPkffFU4HDZEAZQt+ppUA9C0ziqKrXVzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779351268; c=relaxed/simple;
	bh=5HbrtBTWtyyFpkUqpwwByxAz3Zmc9FPzCsccgBt8Qa8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sJRzbP/5d5sL0XG0WNVWS9p3xiYScxVUzoh27mEhqQlAV4TrdqxHSFhVN6HIhJ3OK7NuUkjCtWLSGpjoEXKw3vYAY44pNFKStKNH7PoASnwijOCPL/gWltFBjEZMKuxYEEqrf7Js9Nb4qEOnm6O9vmCffjYb+yUe63Jr0Hd/qqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qp01o4FY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bATws05b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qp01o4FY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bATws05b"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L2g5fQ4025081;
	Thu, 21 May 2026 08:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WorwkDOk7wLU5vjDYISMhLKvVf+5MPTNnWu18698hjw=; b=
	qp01o4FYYiRE+3KrIUPBvHF2mEfZ3+iDCkz+aEWCLG2vDdjr+R92V8MaKtmEasnl
	wrH3DK6J6rBaAyF4xb5x7+tYM7Tm8ej9iyGkwSBkBc0jqK0vnPaFlRu2urebG93b
	dCkG89hGQdGror1cu4dgPo0vjgNfJXo3skWzgr3Nab+rDL4lCdBrEbs5ilG1M96s
	w/ykHPYKgb1RgSapa1MPIKE830zrjBiFeLHA8Bucy+/EEOyfyv0OBGH4PrbpG9hm
	btjrSVCGmzXY7C2rKYeA9CHpp0JyXn/y6vVLraSPDC4Aq9fWRYBJQuxwqnH7lCk1
	32vU3BLuHkHiciXC331i0A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h4q8wtq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 08:13:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64L89o3D006398;
	Thu, 21 May 2026 08:13:58 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012020.outbound.protection.outlook.com [52.101.43.20])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1jc0m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 08:13:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVORlcH59TL/bce5cXkhNmXilGjgEX7HbCzE+WthvuYqc2kPG9i3PAD98NyWXTgfyIZ69Xpfb75NXfDUvLJ/UKoq84cWthc9pbrAE5ZCURAe4bTToxsmhLz582ZpFd1kntP3oPH1X21AvffNLiNjRw/XKax/lrwWPJI/3NP0ZUWGj8dQnpTQQNND/fh7NScaKVYA75lcjGvMheLUux/VqGZxWT0UUYxgdaw7CPH9ADOTT5sV8vZrZCSiTQ/CPw46KlrtPy60FJY6Nt2AaN5xjeEDGhXbR+Kuh93W544ZC2blxww80W+nKNnFroRgLin2qo2qdXjkOO9BFQAs5LDmRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WorwkDOk7wLU5vjDYISMhLKvVf+5MPTNnWu18698hjw=;
 b=fVY1oAjsrQK64s3Cb3N2TFHJkxxo3NDQ+mTGbJrSmUKGWqU9K/EDRxdItVXUmPlwADB8ia4q/qGIkcIqH5RjWgmrE/LLnaqSqqVvUBbT8WG4YumNZV9H8cNpyV6DjYqhvh8JFjHTkfxshMoLiqhJgFsboKDubhpULSGiskQ+wDTSBI6BtGi+rLgEIsUx3YF+ZSuhSmHY/lNX+d6SuY/k3ZHbWGEm8Xz2hZG8rD3ioPvUDkIMvHVtCaduFv3QqvSuUqvHsVr94tEsqFimQ/at5FJhKg+plaA5s2fI1qdBUxtBVJOvVU0ZO/x8xk6r/QrrEffV/i9m6uUPERm/2qqZSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WorwkDOk7wLU5vjDYISMhLKvVf+5MPTNnWu18698hjw=;
 b=bATws05bZ0LW3BotFRrzTaLylFYz+DIdxPpj04KdrRBpzblZLrId6F3WLesGhb15xHXWcUdhs1VGDKrpiHwvD3FaEvgQtMJziRVbKudchdKYaItIvDBCmicP57ZY4gCly/VmPm53SWFi0OvY3+98ugAEZdnR+WFzpZP04xWu/QM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4552.namprd10.prod.outlook.com
 (2603:10b6:510:42::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.34; Thu, 21 May
 2026 08:13:51 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Thu, 21 May 2026
 08:13:51 +0000
Message-ID: <b18e1085-1d77-4b54-ae4d-8ae5a50a79b9@oracle.com>
Date: Thu, 21 May 2026 09:13:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
References: <20260515084531.866259-1-yangxingui@huawei.com>
 <20260515084531.866259-3-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260515084531.866259-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0139.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4552:EE_
X-MS-Office365-Filtering-Correlation-Id: e23f3d47-4b08-4a4c-ce21-08deb710e476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|4143699003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Dk59jWpVTzTOzjGmzd2NLxpzPMP3trs/J3qklngtiBZjx8KAGd4rr7qyw/EnygdjjxaKAeR8/EWUnBt8HRKY2cZsBwT0c5FDTxO3Mrsx5c7FeE60hx9aVhq9V94rlftSA4QUItMzqmEE5PyajwF+Geom5wU38CK+w7YkxcYs4CStMsPjhnWCKXsNpX8de/Bu1yr/MOWj1JmH8DyJQNxPC4zEswOvGkvWs2cdu19HvETqP89ntogci4yJNYeaUvoOrlbnkcas3jhPBHtEMLUA3lFLB0OEzKAxgc6w4zpqU9aUFqHqK8JnHoti6/2hHJvT6V+4DWZsy77EG0TVRMAk2CNVnlCtuBhsisDQ7Bg2sgOTemVWsWTbVPFZ+vNu67Ee44svDeSYDA9LI/7X992k2lJRWO/0xWIa16IgedIAJrU8MRw7wMAaYfho2zFRFsY6Mpo3A4X23BwbITgjL5fGjB9MrLm4aZfwtXYUopzgjC95miqYI3rD1ogG/PfrYreZ7x2wo8Eeh7RUaL7ck8ZTnvw9n2GJHGf44ldtmZzqzLP1PnxFtKXwp5BewgaPRiw1R90lKgRII9k7Wj4a3Xr1bE3RXJEpCRF0c5SenI8d+UU/egRED+TOEzUbCRvHSeUCQNSQKEOfZqR9zlbSWIR1kjLcLDzZuaHJ35kVdqgZMUNLiLHPqhvE69DirUClYKzb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(4143699003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVJ0MlNuOE5PY21kMEtmNkJzZWVTc0lxcWZLRXZkZzNRSjRWSENzYVI1Qith?=
 =?utf-8?B?NDV1cWQ3eG9md21LZ0tpN3ZJQzZNbzZXWnJscU5Sbk8wUnFocWNLWDNMZjY0?=
 =?utf-8?B?bDZQWjhuTGdzRWVOaTRMZzBaREpyaTEvbFNjQnFNTis4TjRwKzNoemdZbER2?=
 =?utf-8?B?SnpIQmgwRVRvVXFUUkh6ZVJjakpOWFVVdWR6TXRYR3hDZ3BkMFFLeE5DR1VV?=
 =?utf-8?B?di9tVExGbXRWOEVoRjlibjNQM3pTUTdEc1Y4QU1YTHN6cE9jOGRVcWlxUnU2?=
 =?utf-8?B?M3g2SHpIck5IaWNHejVBSGZVaS90OVVEWHZWeCtOQUh3emFienBlTUlLM1Zy?=
 =?utf-8?B?bkpsZi91dTd0OWVpY3FQN0Rzb3NadElIMlFoRW53VTFacjRMcVF4dDVUOXNs?=
 =?utf-8?B?RFJuS1lMUHI4L2NEUjF4Z0dJZGNMeHdoa1BDV0JRdnNWbWxxdi9JQWl4cGJY?=
 =?utf-8?B?c0ErcVNXbnpJUExzcldhZG9VbTM0azUvaW1wUW5MMXFLNUprNmJQV1FERUUy?=
 =?utf-8?B?elc2aURBUHNIYXdoeWpFcm1BdG45aml3bkVZMmQxVWdsMkV1T095NnFTVlFQ?=
 =?utf-8?B?ZTFOc2pDNDMrMkJZTytmc0dDTTRnb3VFQXdtTEFuTHNXRGU0ZFlhN3p4VC9i?=
 =?utf-8?B?dzg3ak51RGhtN0VhUTdjWThBdWpuRWZ6U3MzemYxTWFaTTZ2dExhekJWQnBv?=
 =?utf-8?B?OThQQXBsT0xZTy90emV6UGNQSHBhNlRweTJQdlZuMUZ0MFB6c2JmbFpKUWo3?=
 =?utf-8?B?Tnd1V24wQW1IVnJTOEhBZlFkR3N1aTVqQjdQeWhsS1U0dFU2WERVeXBIeVZL?=
 =?utf-8?B?cW4yMTBiNmxJczBYeHFPNjNCeUR5QnhHMjBKUVh0R3NiZURtQjI3ajVGT2Ni?=
 =?utf-8?B?QmJoM1JVbWhrekJrOVB4U2pIclpXNVJjWURtK0UyR2F3U2Nva1NteEZ5NnFS?=
 =?utf-8?B?Tlp4d0NVeUNPbjIzVWZCeVU3dW9pc3d3SG1qcU80Q3N2cW5uUHpJNFNFa05D?=
 =?utf-8?B?M0lYYmtyLzJhaDhlZFJCd0gySTBPbWtKM3dqVzM5clZLbmpLT1BxL2ZGWHNV?=
 =?utf-8?B?QlhzQURkbFZJdlc2Vno5MDZaelNlOTMvdk9Kb05IREpueFF3OTNmQkFTdDBP?=
 =?utf-8?B?SlRWSDBNbkhKdjRMS3hCb1JGbU1JRi8wc3cvR2t1NDhtZXphTGdvN21Mbkl1?=
 =?utf-8?B?VjVZMHhvMWxiZUZTT1gvemQ0K1VtZ0p2TVlRbUR6Ri80OW1EcEc3Mmd5UHdn?=
 =?utf-8?B?V1MyYzBoaFZKa2ViTlMzYW4zT0ZuL2hkWXFMTCs0Y01Gek9IQ2JHajVQdjhz?=
 =?utf-8?B?QVZSMWxNR3BOaHJaSGxqRmo4dEJRZ0pOTFA3MDU5MW1mL0twZHdIamtuVDlv?=
 =?utf-8?B?akxQd2tKTDdTWDJldkxVbzZTeHRJWUJ0MmwreExUNWZDa1ZsREtxT25xMk1C?=
 =?utf-8?B?WXRQRDlvMzVyNTZiVFdOV1V3MHZiYXBlMWVlaS94REYxQWJ1WEFzZWI2RHZN?=
 =?utf-8?B?R1VSVElTWG5ncHFWbzFFN21wQ0VYR2trQVJWQ1h3YnZ6QlNXc3FpdmhIQWNi?=
 =?utf-8?B?bjVFTnloM01iQVdPK1dCbWVRSzJPMStWMlFsOFhJcldvSzJza0JSdTJNQktw?=
 =?utf-8?B?V2lGMmtFVklqNnc3QWgybnJVOEMrd2ZjOFg1Vi9oc0xoaGUvWFVkK1JaMHNr?=
 =?utf-8?B?ODZyQ1ZQNUkzUWZTNGdQa0hSMEZVWWZDUHZ1c0MwcXJrS2VOc0JvNGdPWXBG?=
 =?utf-8?B?RzFkMm5KalVMb3FxSkJJeDVJcHVXUkhpdndCbFUrZW1NSmNqNDhjbittRkZK?=
 =?utf-8?B?TlhvQjFRVnkxUGIwdXJxWGpVbkROSnRrZGFWMitVYlRkZGlseURGTDRySi9N?=
 =?utf-8?B?ZkRrL1NVdnhZSkdEVXhpTE5ZUnYwWEdYcDJPMXlid3dRRlJ6bC9RTEV5MHJm?=
 =?utf-8?B?TGlVdHdMdWE5UUlQVHNsZXVWVEN5Z2p5VU5jTWJjY1N6Zm9TRVBaM3RtT09u?=
 =?utf-8?B?UmZFSWxPWVFlWXZWYmtNaDMxeWl3bGxKSFRkMGk4OXNDWGFkelJGSXZOREJi?=
 =?utf-8?B?WS84cC9za0F2cEtoYlh6OS9nTFFoUEpEMFZIMDRqenMyODk0UEtTeHNZbysv?=
 =?utf-8?B?YWRBL3lVKzRPc29zNDFrdERMNVBhYjNQc0o5VnpDaEEzYWkwNVdlclIyMHdz?=
 =?utf-8?B?UlBrWEhZMkNRMGJVMzNlMi8wUW45b0NVMmE5UDdXTEN3UG9DajF1N3I2UU9y?=
 =?utf-8?B?eldYMWZjVWFXejZkcVJyOVNCb21YZW9PMitrdmtUWFpsdkh3ZERQeEc1WHZx?=
 =?utf-8?B?VDFhbDlJbTFDOUlwVGpjWWdZY3NVWXF4NFBkaWFXYzNkQnJGUjJnUT09?=
X-Exchange-RoutingPolicyChecked:
	BwxbaLFs6E2RkINjv7xgZwHXaN90y0kB6w5F2q+37V2ULCt+Jg+0A1jS9gybgQVVeFWlGAS7vdUCfWkiFa6TrdOu8b/0IWqxfOk1iKTcXufxV9dKpJEgtuY4NITrFjcRt+Y8fWA+XxYfWzaUCYx1ZMn6wzoEaHsNVHQ1LHbtN+67e2t2RdhpXJAnEtzff7zEsVAHMO++Hp7bq64aRvbHZEGUrB4I/sjY0XehDwoqUX/TrMiqXCToClH+UTvGSoXRdZEvvG+19X8qh+WSMZOQ6SPxetGsm+7ugxGWkD2fVIUzZmQ9rsVPMlyc00M1PeWlieLvgJMcq4Bu0LLUoAG48g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/CCVBgepY7c8/bzO5H3Zfngx2yAl+soH9B3YqKTEiB5McrH0R1Kc9iixITV+DdNcl8e/gyHw7muLL178fKJBuId9FW03axYmRIxWM0DNXdSZoSOWeiZDk/zON6bLZEj4HlLIwASLNVtCjCqBbIRSreZ8wnv/Rit+uI80+qgG+JfV2nAhTbiPsNB+0/JMqHo41TMbt3UYKQSwceXfY+vYnoLmVyY4TWhX7gTiASErWb+YHV+n0vnNG+yT+pCYfvLWxFTpVgWkLqApDfoKf9JrCdjMEoMgVqvBKYiR33ar8mO1W6Nd63mdubawyJ5KA+hMY9s0zn8BnKXgrh7lGqfdTogsjNVjcaUlidRr0q4SIzbrGfV9JJoWw0ulYellbJUMykUjpBfXdtGXhND2qT9e+tL0VV5eWGspC390Gl5Hw4j5f558EC9wp4j7RlhCNwIedAh+sR4YxarO7Svn2W/OEANXwB0SnrrHR2siENrHcIqZIfYPN4wzyqMfN5UqOW6CDi29DGBA7azPZgawAIeuO4wwVvUJa3mDdJNgk+hrb3zQAqvd/Jg6IgtdMoczWKKneoktuGLf+LDkEmv0USBOEgWUjQ6w8OkS6EJigo4wGbs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e23f3d47-4b08-4a4c-ce21-08deb710e476
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 08:13:51.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ujjb/SM/T19qo7YaJBqPNST5UVdM6jniAp29QR5/3s41bm/676fjC5pY0KTN+utrmCOBabrFEmrWfiBPQm4sCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605210079
X-Authority-Analysis: v=2.4 cv=NdnWEWD4 c=1 sm=1 tr=0 ts=6a0ebec7 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=i0EeH86SAAAA:8 a=TXL1U-ptXNZlRRcikFYA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12299
X-Proofpoint-GUID: eYRlFWf7y0rS1PxBMDYcgRsHbtGisRJo
X-Proofpoint-ORIG-GUID: eYRlFWf7y0rS1PxBMDYcgRsHbtGisRJo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA4MCBTYWx0ZWRfXzqgNkK7XjIgy
 w1+lF+QNe6vqK5Pf4YXj/PvIMJEWpBnYLS3XFvy768L4xDbBOA9Me2ObOIeYtBoSksEQ5yoNKoX
 sfmO3lPjbNH1CzFJZK8oav44FlEb/fzouABIQJ2btEcaFLtEZjTZWZddwUIHAmbMniJgnkdWwR9
 9OO0N/Wfa6xwegJoa1z8Fo6kMMXXSsM19Ndz6zb3BeiEFab0os9W9H2++IEqg8n1vG4mhzGXw8y
 ePPq/Z9HxrFtZ077aLieJ+ZzF9hugi73WJRNttlnFtIMRK/UjUrhLZDQhqSW6GG6F7plc507Y47
 x49xwflHHhgVOig+CQmD/zOQVfxk/c+lkNoyFCZTO32siHnEr28rS094H3oEGlZk9mxw8ExPXnQ
 nQGu1LU5ne+skbCUBkv194tL3/QGy/vnYUlVIZfgMBeK1+XTpYOuMCX9ozxN6Kh5mZIAwsgk7Hz
 yVYCrPIxP09JZi7EATk5dkSwI9e9JXy88SWZ5FTk=

On 15/05/2026 09:45, Xingui Yang wrote:
> In sas_rediscover_dev(), when detecting a "flutter" condition (same SAS
> address and compatible device type), the code assumes the device remains
> unchanged and only handles SATA pending state recovery. However, this
> approach misses two important scenarios:
> 
> First, the flutter detection only compares SAS address and device type,
> ignoring potential linkrate changes that may have already occurred.
> 
> Second, after sas_ex_phy_discover() re-queries the expander phy, both
> linkrate and attached SAS address may be updated. The current code does
> not validate these changes against the existing child device.
> 
> Add validation checks after sas_ex_phy_discover() to detect linkrate and
> sas_addr changes. When changes are detected, mark the device as gone and
> schedule rediscovery via libsas's async discovery pattern:
> - Set phy_change_count and ex_change_count to -1 to force revalidation
> - Unregister the device and schedule DISCE_REVALIDATE_DOMAIN event
> - The old device is destroyed by sas_destruct_devices()
> - New event triggers discovery via sas_discover_new() since
>    attached_sas_addr is cleared
> 
> Suggested-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 32 ++++++++++++++++++++++++++----
>   1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f55ae9a979cd..720db4128727 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -2017,15 +2017,39 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id,
>   		goto out_free_resp;
>   	} else if (SAS_ADDR(sas_addr) == SAS_ADDR(phy->attached_sas_addr) &&
>   		   dev_type_flutter(type, phy->attached_dev_type)) {
> -		struct domain_device *ata_dev = sas_ex_to_ata(dev, phy_id);
> +		struct domain_device *child_dev = sas_ex_to_dev(dev, phy_id);
> +		bool need_rediscover = false;
>   		char *action = "";
>   
>   		sas_ex_phy_discover(dev, phy_id);
>   
> -		if (ata_dev && phy->attached_dev_type == SAS_SATA_PENDING)
> +		if (child_dev && dev_is_sata(child_dev) &&
> +		    phy->attached_dev_type == SAS_SATA_PENDING) {
>   			action = ", needs recovery";
> -		pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
> -			 SAS_ADDR(dev->sas_addr), phy_id, action);
> +		} else if (child_dev && phy->linkrate != child_dev->linkrate) {
> +			pr_info("ex %016llx phy%02d linkrate changed from %d to %d\n",
> +				SAS_ADDR(dev->sas_addr), phy_id,
> +				child_dev->linkrate, phy->linkrate);
> +			need_rediscover = true;
> +		} else if (child_dev &&
> +			   SAS_ADDR(child_dev->sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
> +			pr_info("ex %016llx phy%02d sas_addr changed from %016llx to %016llx\n",
> +				SAS_ADDR(dev->sas_addr), phy_id,
> +				SAS_ADDR(child_dev->sas_addr),
> +				SAS_ADDR(phy->attached_sas_addr));
> +			need_rediscover = true;
> +		}
> +
> +		if (need_rediscover) {
> +			set_bit(SAS_DEV_GONE, &child_dev->state);
> +			phy->phy_change_count = -1;
> +			ex->ex_change_count = -1;

the current code has following:


	/* we always have to delete the old device when we went here */
	pr_info("ex %016llx phy%02d replace %016llx\n",
		SAS_ADDR(dev->sas_addr), phy_id,
		SAS_ADDR(phy->attached_sas_addr));
	sas_unregister_devs_sas_addr(dev, phy_id, last);

	res = sas_discover_new(dev, phy_id);

Can this be reused (to lose and find the device with updated info)? Or 
why not good enough?

I don't know why you need full revalidation.

> +			sas_unregister_devs_sas_addr(dev, phy_id, true);
> +			sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
> +		} else {
> +			pr_debug("ex %016llx phy%02d broadcast flutter%s\n",
> +				 SAS_ADDR(dev->sas_addr), phy_id, action);
> +		}
>   		goto out_free_resp;
>   	}
>   

