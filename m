Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61AF1DF987;
	Mon, 16 Mar 2026 09:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773652368; cv=fail; b=O5pttZStcFgun6hvB84w27Fb3pr1H0rAkGKkVXeMCUtVrWQH/W+yLi2mC6Ku41/YmX33mCO70DgXFl5PvWTl4OB9AsR6pPcgZvsb10PXoUn/MmtZcCKC6m6V14VLCOVCbLb17q5ZS/Rq9PY304TfytC2zdHdrwDhwr+MMg8fsjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773652368; c=relaxed/simple;
	bh=oYTW+DdiOeQXkSndZT524nU+yLfJDg+xiQNATu/Uz+s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fwl/470cxJTM/1Kv97nMxMqnieEwPzjmz/5Axg+Ljzg/PegpHrl4ozuP3fYifcmZvOUrFiIN44+imW4/bvDHlaoVQ/RH1fhsoYzuWFbX+WuqCDQTE70qyt2jwetjrSW+q08LKltfJFcuhqdbzeLEM4jX+Omj76fiofaA5FIWFKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=krdM19mi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Eol3nbHj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="krdM19mi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Eol3nbHj"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FMSMn81159088;
	Mon, 16 Mar 2026 09:12:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oYTW+DdiOeQXkSndZT524nU+yLfJDg+xiQNATu/Uz+s=; b=
	krdM19miyq9zh60DRy7yaDZy8GGrTNWbNjSRtoUvtjDnzuQvilNsc3R15f1Zk4/Z
	TOR1vfkuhT/PTKYFfpfVgKyoEwKtRcd/jjNb88ZXTnHEiR/C3hWjLEjMyX3wpmH1
	k34wsGL0n1KmCVHCh9hoKWMI4BMwCae9zcOj3pJkS6EA/hhBDQZq301j0zqcI6PP
	z2a8HSfLmMJ/plyxWHBEzMz4hY1bS3ROOCrrCU1Ix184AS9vDE98wXHok12Sg72S
	NXHPLmm9P8wsNt+YVPSvQ8Bxtg4gv1zQoZs3BgqK6C42thKjsJgaZGUxWtDJuZ7T
	qWruwl0YoWvhYSvF+s1nFw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvx3b1utq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 09:12:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G8bl6D017918;
	Mon, 16 Mar 2026 09:12:18 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010062.outbound.protection.outlook.com [40.93.198.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4jumah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 09:12:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OffuPA8l5A0Ox8aVYKwwjiZC2aOkLR38j8O6r+RQ6cUPARWEbFz3ICAzulU9/7GoFa6eLbc8/NjhEWebHNHCKH4GChEdTASsveNaqiZK5GRzm0vXnApHRUIFYhwnHfjFdYYbExjfwG193IP8vPxKsSTHW3x11PDXNSLGdLCkbtVy1ISFLGhMzSPTAtf9IWc3unCS+94RGwH4wouQhy0UnVI5/gzDRFpPN7pUROlbFqDhnRrcc7kQ9XCzlUARor377vVfYUrwBsy5B13D1EPbHgPmn3hsxszUEJVtp4W8f0VtfWVBHvoab4ockF7W5F2iuIkGmiMsnSuM4dvRWc4/hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYTW+DdiOeQXkSndZT524nU+yLfJDg+xiQNATu/Uz+s=;
 b=ouGFiA/SS/Su5OJFE0TtWnMQbi6tkARjnFS/lcCkey2uq10kdQrfRq7lTI3y2nUJIwa5YhE4CwiQShdHGqI1lIoHaOsR3jtmLp9FKl0AtWBxdUEQSsRBmHKVXpUgJW2sa/Ix2SBbfSV4ycc5ELi+EFA0N7q2NOJArJPWyFH00Z4QOaUnWgsFEUQ71ABAfoH8tdcLoz87AsLkpQkqen13W3l0h+72o/6FGQ/hoqagtJTa4H5NISErxbpyLf1N16nGi+x7PNbDMFFDLTikVwkS0Cl/KxaZjGN9HSQpIMzyLBx5HaUzfaZd8ZD/mONMRXd7jSQvGoMLEv8sgXjiSLk0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYTW+DdiOeQXkSndZT524nU+yLfJDg+xiQNATu/Uz+s=;
 b=Eol3nbHj10zl6QPiL0Q6nhXxh6ZIj/6N1yrb5hv4Hk9f52MhcH+ubx68/MV72pr5o3mZxO+JjTDt3wVrNt7nHk3kJKJfsSSXmWyAdolth488HEtjK/xHGAKjkBIdJHX1t/pi8WJ747d16Nsz6vOFgcee/Fh41dDtlNDbXuifzT4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS0PR10MB7246.namprd10.prod.outlook.com
 (2603:10b6:8:fe::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Mon, 16 Mar
 2026 09:12:15 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.022; Mon, 16 Mar 2026
 09:12:14 +0000
Message-ID: <cf514707-8556-4036-9078-0b5c505dcd16@oracle.com>
Date: Mon, 16 Mar 2026 09:12:09 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] scsi: Create a core ALUA driver
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com,
        jmeneghi@redhat.com, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        axboe@fb.com, linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com
References: <20260310114925.1222263-1-john.g.garry@oracle.com>
 <20260310114925.1222263-5-john.g.garry@oracle.com>
 <abTlhI0nO94Ax6gQ@redhat.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <abTlhI0nO94Ax6gQ@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU2PR04CA0197.eurprd04.prod.outlook.com
 (2603:10a6:10:28d::22) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS0PR10MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c0289f3-eb4e-4b89-228b-08de833c1d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	jd72XoIWs/3hSjfCn87mHXnIfJWcuEu/8xJirlPC3R8IvFg5mxd4wKaNnYuEW7L+8f9lq7Y4CijQck1US63ne00Wg06+ax2rNl5rEajfkAD3nE+ghI0JmRMUQVNqMX46X3k9PJjBrLbmtSnhBZEAm4NqNYlV3eGBY50/S3p73n/1gmlxnKbe2IFZHEnlCpxDfLqMCT6Z1vGfTBFhiWETEqrXlQgTj0nwyWwfd2+DKTPbaPKedy0ghk6yAt3+fbrR8IBjKNdnezwIyHukqh33dO3kn4k/C+AWJjamuxu7GX1NtcXZFT5ZEJsuNvFdpRDPDtmRl08hvHsHilxwbHaDKpeXZ8d+v+ihrqvPrgxsjPqkSjDHzDgsxRYerU6LA44VKTEbmoUfXiOV8mQsQrNc6ZUk6SD7iU0NpTNvRZKiAzEwxeCMoGnRohDwCxsP4rD9ZI5P9XZ2expCHI3RbGrYQanvki01Q+i5H16wQTqBRxE4J6oZB0J2UDMcHxYrlxrPdeYIHRQbNuNZQtCqtHE8zX1cHAv5scHQYsELf/JlTig4arQMGO3k7RnPFX+wmJlLpz2k9GircAMJIbh1GPenBXQiFunu+J5dWpFm0NP+ZZJ8KDYbdkefFX7Fqy6YC4usM1aUh7vJDG+NvWj+6AjNUy1sJqgz/zHV41nP4QO7LOPqaG1Uq+ZKO/xgS8pWDKTv1JuBaIt71Nhpq0fwDcqUg4Hq+cq12K+nMLRSPxTCbWE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzZONDlTalZkREpRWFlSWFl4SnUxMXNNMlIxVk51eW5pM3k3aXVmZ20zaXJr?=
 =?utf-8?B?TjljNnlGdS9uYlYwTThmT2lKSnJTTXRvQ2cveWJyWlRSckhndUN1dFljT3dV?=
 =?utf-8?B?emg4a2dNQ3o4dU54L292SmVoMEZOblllQWZzdjE1VjB3aFV1MGc2NjdiQ3Iw?=
 =?utf-8?B?WitHSXFQQTRmS0htSHE3K3haNnF3SFBNeDJPWWlUU0ZBaWx4bW1sSXhJazlG?=
 =?utf-8?B?Z20xdFl5VklYM2JuUG02OS9NUGtqSDMrRCsxUU9WZnJxbTZnWlJnTEN6TEZi?=
 =?utf-8?B?clY5TTQxbXpRZFRGQjc4MDFGVk9mSUcwVVY5aElTbGxFMlp1T3dEbHVtWk9Z?=
 =?utf-8?B?a3hUdDAxL1crbk1wSk96TlpKQmEreWxKK3BLc0RwRHp4VDEzVDlFWU92TkRU?=
 =?utf-8?B?Tk01Szk5MGJwbkFPYklySzJiZnF5N3BleExLQkh2Ni96aFcrRlNCT3lITmlo?=
 =?utf-8?B?N21sZjllOUJnOGVJblorSmFGRTE3ZHg1b2VMMlpFbTNnT3NBbFBOT2dZN3ds?=
 =?utf-8?B?VHROQkJlMFFpYW9jOEViNXFvKy9ZTE1QSml0QmVXaHVON3JsekwreVdQTFFP?=
 =?utf-8?B?Z1RmdlFIdTFFUisySTFGR1ZPZkNpUnpvVWlEVlpwSjVHeVJoSUx1eU5NRjdx?=
 =?utf-8?B?T2g4N1poTWQ0WGNxZ1dwSEVNZVowYzZycUJ6S3doelk2dFJ3K2kzNkx3ZXhm?=
 =?utf-8?B?MTRVT2ZBUC8rUkFhYmxqM0ZuZFNlOFhWdHF5R2FOS0R2eVNDZWFxWk5mNGZF?=
 =?utf-8?B?TmpHT052dERndnYyVmNqUVJmSmpOMlVNVnJYZDMwTlQ5b1IrRjNmWWdHNlNC?=
 =?utf-8?B?emlzZStsMVRlOTh6cWxuc01HcmR5Q0o5NGlKbzBvY1A5Mll6MlpTbjROVThk?=
 =?utf-8?B?UHcyZUc4WG5kVEFNbEhjYjFySFEwaVR4N2pTUE5FQVlJUmZ2b0k2Ym12TjR3?=
 =?utf-8?B?VnBUbzV4TnM1aXo2NUpjdmw2TXNPSWx2T2E3eWphWWV0WlZST3dycm0vT0tk?=
 =?utf-8?B?Y1M1ZWtpSUNCRWNzZkpGUlA1L1J1MDRmNE96Tjh1T3oyaCtlN2ZhVEpjLzN5?=
 =?utf-8?B?YjVMTmpYd0I5WlZCRnZwUzdkQ0ZJVVZacE1YREQyTW9ySUpvVkY5bFlyUWpD?=
 =?utf-8?B?Kzh2WllUVmJ0K3VjM3h3bHg2cVBLVm5pVmc2a1I5cHJWQnNXQlZSaC9ST3FL?=
 =?utf-8?B?QWY0VXhTbjkxVjRMS0k0SGRTYm81cUk3MFJjSk8yRzhkM0U3cTZyQkdkVUhn?=
 =?utf-8?B?SEQxYWhZM3dmMTV0WmtZSk05UzUwVVhWM3hHZEtjUVJwc0pvOW1hVVlGdkZ1?=
 =?utf-8?B?SklPN1pUNWU3YjhSaHA1YnpOT25tZThUOGNkOVBzZ2Z2Sjl3Q0dSNTVQYXVN?=
 =?utf-8?B?UCtRR3g4NDEwaEFhS2ZScXhmenc5QjJUb3BCSmtCYWJEcEM2VmR0TmRZR2o5?=
 =?utf-8?B?NnlPRkxaR2RhL1VHZTBraWw2US9QWXFxNFl1ZnZraTZsSDZRMklRUk9iOXZ6?=
 =?utf-8?B?Q05HMWFpV00zYlBjMXNzTk5KZHJQN21ub3N3MGIxNTJ3UDRlVDR4NU5CTFBn?=
 =?utf-8?B?SUhmbW5yaGMwY2IrT3FEUHc2VnVYaG1takFoOUorOUZEbXRFN3FnRGgyZHU5?=
 =?utf-8?B?SlRVakJlcW1icnZML1BtNk94cTZtTmtrRHVzTHF6Y2hrTEV3U2VZWnRXREtD?=
 =?utf-8?B?UVVHRzd4dWg5OUNVL1h1T3ZnZy9sYzZTWkJuMUNFcTVDL1Ztay8rUzNhQzJJ?=
 =?utf-8?B?VHZTVnR3ZXE2VC9hNitwYzg5VU15NVJBTjVVUjZjNStYTk9rU0FqbkMxMDFB?=
 =?utf-8?B?ektDZSt0RDczQitYVGFyWExVd2x6eGVnTCtvMmZjdEtFRUpEaUxxbGNDUGow?=
 =?utf-8?B?bTVrNzdxSGg1WEkvS0xGcGM0Q2pKT3J2UjA3V0J4QnVGeDUrR0R2MHNBTk11?=
 =?utf-8?B?Y2xHMnFGeTZ4Z3g5ZmFaVjJPSkFhTmU3ZzZDQnh0SjlTd09abnRPczFsajBk?=
 =?utf-8?B?SThyc0NPbHNWdVNTeWlRU0Z3SFlFRm5FNFFqQ3VabCtXVTgzejhSS2VLOHlO?=
 =?utf-8?B?aTZVWnJBc0QybHp1c2x1WTlvRVZQMUd2ZmxsM1pkVlEvWkpFQmVuVk5ZK2NY?=
 =?utf-8?B?QVFCSllEa0FTck5MOE8wNHcvN2J3UFRlVldlNzg1c0YrUmxzMGVMNlU5czNz?=
 =?utf-8?B?K0l4NThkZjFkMkpGZG1rblhEaENNVVFsWjdKMDdBQ0NVRzBMYko0Ylcrc3o4?=
 =?utf-8?B?YmJLL0EwbkI1b1EyNGhSRHdhSlE2bzA4WUNIUHNJMmJXK0t0L2ZyN1cycm9o?=
 =?utf-8?B?QVMvNmVIbzM3UVlOTVlFdTQ4bXlZWTFUVXZ5bG1GYWI3c0l5RlpIZz09?=
X-Exchange-RoutingPolicyChecked:
	YLtqoDP1Bs4O/iIe5DPBJPpEOKHPF05h5Kz3yUYpT/W4ju7wIrMbaZuBcIHa4kJfvE9RPWs3jB8tWyT0mw8UQmku2OeaYDmB2I+/0tkikk06nj6FE/gLeiNpui/MTzKLA9qdxVtLAEg4BciYD7rATT+uXviOwTOJR0//oKQVkvYkIf0EXNI25TxQHmtI3AxTdUYZ0F4281uaSQaPuJP0pxjcrZz52SmmTG7iMRZJHlrImw2ywrdachiml8V203YjqpDI6mttz8L+pr82mx/qgm3ffd5IsSk4oHPQ6BsYf5k+GwnN34vGwuOOfhgdfuzZg1LFS+Iel/pM+VMrLJ35KA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8pGHUeYA+sdmCE4nYzMLkVoSLER95wJYvukfaJGpoOsXXAyhAgAHr8nl9HPtLCUNKaDZjSA1x5WkRJvnHvuP0EBjCZpeJD5CoPVdMjw/prpQYZQTB6kOXg1VBt4GKQKbKY6xWbpZlbMpOcA0DWxW8OGkBKza4c9TpQOAk3u9Em9fEVhClk5h9b+HfuqiFdPxf1KisTQVdOjmTIe9aZNbDmC43mimNF5rhOEMh58z0yZeWpB0GdPOEJOB9Wkbi489IS0NJhB6X4e2uOH+9czMGyiIHC3KTtD7CPPhRDJ2+YAQrhstQy1cVMRLlZaSBPHpq5qfp9CwlgkiR9LB3JNumk2PeC85NqJba83b6mz2xyRDInDKdX/DWUBi0SGbTZ8AAjrQIhg5SIPZiY++EYp+yM4C5RM9z4ZddOTSM4LK8ppS8xqDu6/NKDkOT4joyndAiksWGQy1iJexBIu4AeBZ7jJhGcm3k6+F3iGvwUDJJRGqSBZUJRWqMkvXvxvcM4RZ7fV1ALJLMDEW9A45SvD6vygHyrIy57JNWVEcsulnpEAG+apB3494w6MTzBwXDS/a3cRZg2bcNywRSsh8ilH7ZSiv+dRJMdrpwozKiUPEnD8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0289f3-eb4e-4b89-228b-08de833c1d4c
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 09:12:14.7777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1K+qC688W7LZ7000Jv5+3E5qSdk9dfTdmpJw9tamp9dtW7g5huWAqP1fnCXqW+4RHtKsCMVFuygZ493hhYCSHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7246
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603160069
X-Proofpoint-GUID: gUI7yEpO-p3q81WZqzmJvb7BAOXJi45k
X-Proofpoint-ORIG-GUID: gUI7yEpO-p3q81WZqzmJvb7BAOXJi45k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA2OSBTYWx0ZWRfXzKCeDpYnlywI
 IliggbjyYwmK5foowoi4mpecPjbNzYWbowH4bfbzSYsKjBv2083gQPK8MxN/mNn2dA5f/fCIYQQ
 Y8u6P6NmJPlL/7j0FP5ySS0h+Dz8u3L8lkNCSwJ2gM0AGxoqVKYl6Q4q6zgXzpVc8/3JHOA2fw8
 4oFFX94qTxderRLhY7jRIvfI6R//zcv0z0J0CB5jIYdyIKOVvWFxyMr0Wk5uQQv80MrOAlP/UOc
 6+PTlaXXjfM3SRxiYbRlYL1CjHN1vdi6cvpkMr63O2U1FgoPeCrfzXyZnWC81nB2CTxdzjqnbse
 47HZjrrxZY3+Gk0E7rmPG3Jp9dFUF3jjNo1GgKBsHwSGUOKS142R8oKCh0QMpDRHX0QANNsfgq6
 KCTRYgwyR7H1OmxlG/DOxm4hUMQRti4Brb5aZx4EMbdEcJBxEidZ8IFut4brWLD7GlCw0KkRxnA
 JCAURJDNzNrj/YPZlX9ekolI6Gphg4qaBvnICcik=
X-Authority-Analysis: v=2.4 cv=IN4PywvG c=1 sm=1 tr=0 ts=69b7c973 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=DEtBOpriyx-DtX9qihcA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272

On 14/03/2026 04:35, Benjamin Marzinski wrote:
>> +
>> +/*
>> + * alua_tur - Send a TEST UNIT READY
>> + * @sdev: device to which the TEST UNIT READY command should be send
>> + *
>> + * Send a TEST UNIT READY to @sdev to figure out the device state
>> + * Returns SCSI_DH_RETRY if the sense code is NOT READY/ALUA TRANSITIONING,
>> + * 0 if no error occurred, and SCSI_DH_IO otherwise.
> Nitpick: The comment here still references SCSI_DH_ values

Sure, I'll pay attention to removing DH remnants.

Thanks
