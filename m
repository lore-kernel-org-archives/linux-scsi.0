Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04912282ED;
	Sun, 30 Jun 2024 09:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719740262; cv=fail; b=qcw+/i0UVD8pOaqelxY+ZFLUDou9QGyKD5QSjN0RS50dcXX/bzKjD+xBI0WPavc39yRGC3RYCe0TL3+zG3uhiT8tVYuXD4fVIW0uQLbJBu9vCXp2SXo9laZpT3516HFBMdTPtdmCB9fIzHbCfnf8lrRPlIjBW0vQhfp+S7jJPXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719740262; c=relaxed/simple;
	bh=PCKV5S8ZgLsGfaeAH+d+7Zm3MIDUDNYScP+Li/Q5BW0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jB5jt66fj3XZ0Ts39Tjhg8Il/a+sZ24PLdkjz4Wc6yWIP+xb/OpUXob3IrMNtzSfNy2DqhAXydFUvauaoWwQ9+Sk286ikzOO1jrejtpUj6ir8APM3ACIGmW6k87QK/X/cEohiOP/GXZz2jTB2//kKAD56lVU7EiJWrclE4OVaK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QIUy/0LP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lxbpxW8Q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QIUy/0LP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lxbpxW8Q"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45U4mcKh026209;
	Sun, 30 Jun 2024 09:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=MdJ7ClK9NpU2mB5IcBzCUY+SRoiunPpl1vMIuhzlXdY=; b=
	QIUy/0LPSZr2ZpMod8XnXf0SXgX6wPxRsPMd3cXbipIXQQ5ZLcefmoM+Ju7jMn/9
	k1TDtbvjySE77LqTh2m8n8SVB9PT2Nce7Kqchab9wxp8ZUUobehalbv0wvxmH5cv
	VQmHD7B8ebvoDPaUlA33XMg49a1ALLtSzCuVAu2ury0o3s8BTRuVtecVTfV3Ir57
	kC+9fFPnZ7m91Pv9l6lK1kF7iLtnDYEK6czHyRhwytu2YAWkU0iT+QypK15TrvZr
	1d9gwRI2fKE59QjdmXrE4FKnTZxF8Co7cweDiHD7BdMHHjB2YvRGnxCPPwQ61wYh
	P6WrYXEnhm4YryxIL+UmwA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402922s5wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 30 Jun 2024 09:37:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45U4rQo0010005;
	Sun, 30 Jun 2024 09:37:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028q5h8u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 30 Jun 2024 09:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWOGBz/4SDZOSKPOkfXD+zb+Rd4V50ve26gFeBBEtDkhwalw4WgS0XUmVsbE43B1NnlMUn0hCjI4hP5c5qyr/Kn4C8h4ygRfcwbM0EXksBwypaLBoKs/965a0qUxtSXoVxfzg41BRJpmY4PWKhxvLqA3CoA0Za9fLxRAhsZMZ9vuF9ROqtSw1pCk6TO7ncGJ/twirh5PqpB5wJ0lG9JXncM8fSpUsLnPEoY/cZEHDwhkY+SsahRaV6YsDg0JNapepfsfXsCaoKfiwl+tTvigSDU1E1Wp0jSLy5jBZoX7Ait3noD9/gBGHpLaxZaln2kbglIZN81fZaq1ScGsrmTwbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdJ7ClK9NpU2mB5IcBzCUY+SRoiunPpl1vMIuhzlXdY=;
 b=ELeIWG4uWNd/CQovArIXgeKmd4zfFBKpWTdzzPKtFLcNtNQEExXfzkGtx0QMZmN6VCS2wE7MI+nZCC4A4xBevPM9t3ROu2rfgeZ4yXBNN9RDe0QsIsXY+HABKxZ0VFJQ8uV7/gFdTIy7e3+mn9NmxHM18CJ1Lxl9Mg8y8g6a7aLQ41y72eUK8Htb78kypJNEfuzM9/I/qpfThRjeM41ur9GEoAIIgg5uxx0CC1h5+byyLF0YeEKrUF15OHlQaTR6esDfAGqJDd6Gqz03A1IkF+JcELlrzsn/oyXsYXSo2/hdRQnGFRfk8SEIj2xMdW6C397On+3fw34bAKwn44jVmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdJ7ClK9NpU2mB5IcBzCUY+SRoiunPpl1vMIuhzlXdY=;
 b=lxbpxW8QiXCcGQfl3nvBTBdchs+Zc+hKNNLpqAL2uYa6DJtYwj368U8BAxzgYorGkdgisCHn1ZV9wGXuzSLOnUqepxIjup81QuOYCELPMdtizAOE4kr0YdsO4PntfTXDHdunKusxiQf24/iDdj6o6UkB1bY4WIdGqp2fziZW8lg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB6218.namprd10.prod.outlook.com (2603:10b6:208:3a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Sun, 30 Jun
 2024 09:36:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7719.028; Sun, 30 Jun 2024
 09:36:58 +0000
Message-ID: <b371ceda-bf87-43d7-81ef-f8b18032be30@oracle.com>
Date: Sun, 30 Jun 2024 10:36:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] ata: libata-core: Fix null pointer dereference on
 error
To: Niklas Cassel <cassel@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
        Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        linux-ide@vger.kernel.org
References: <20240629124210.181537-6-cassel@kernel.org>
 <20240629124210.181537-7-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240629124210.181537-7-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0456.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB6218:EE_
X-MS-Office365-Filtering-Correlation-Id: 318de881-c4d8-4b8c-29b5-08dc98e82fc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?MVlhQVRSNEJ0VVBUbkxkQ0UxUzhqcjRHdEFmN0VBbFFVd04rQVAyMXVTMFBS?=
 =?utf-8?B?RmRNQUc1WitJVWlNbndwNmJnODBKY0JjMnhiVGpuZi85d1NCVG9XZ2F1RmxC?=
 =?utf-8?B?YUoxQVRhWWg5ZzhrL2M5QUNNYmJ0V0tsQm5mVS9JeGFhZTdZYVBpZUdKaGxr?=
 =?utf-8?B?QnBBQzBBOG9ZeW4xcGpRZnAxdlpPMVdacWRIcWFnM0FRdi9CcFZhcnhic2hn?=
 =?utf-8?B?cTNiNGFaWXVGU1JxUVgxRG9ybmxodWgzZGRyWlRYT0k5WlY0MXN5Q1NCVGFO?=
 =?utf-8?B?dDBuSkRqaEFqSlczNUs1ZmZVaVppcmF4V1JzTWp6TE1SNUxuNGJjM2pXWDhK?=
 =?utf-8?B?dzJxSmhuTDNodTIyYjdYOUQ4VktFOW9yS0pIWVlYempqY3l4WkVlY3A4ODlm?=
 =?utf-8?B?bXU3Wi9nbE9NVWV0SGptQURzL3dZYlR6M1AzaU5GL1VMTnUzOXU5clBTSmpK?=
 =?utf-8?B?TWtYNk5QMEtjWnNPVGdYUWtjb01FNnpqNUwwak55Q1Z0ODNZTEZ5S0o1am5B?=
 =?utf-8?B?cHJ5bkFtOHhyazZRYnBnS0NCMnlQVHBvejhLcTF5cVZmZE4vSkpzV1JTcG96?=
 =?utf-8?B?NGl3RnB2UUhENUVaUWRmRFdOVTI2VUhkekhmZGhCcTI3cjBKUWxkUFBwd1hW?=
 =?utf-8?B?bWl2YWtqSmVDOWxCclBBUmRWUXFFM0Z0Z1JHT3Vxb1Z1cG5tT2R2MEhFL0pZ?=
 =?utf-8?B?RTBNNDZxQmlwNXpUek5GV3N4TmlLVDZ2NldBY2VuL3h3N2tJbldBQlUxbEcr?=
 =?utf-8?B?WTUrWktiMG5zVVk1UWRJM25laHZDZWNMNVVmVzhpTFo3RFp5c2FOZWM2ZjhS?=
 =?utf-8?B?RnB1Z3JIKzFheWV3NllMbmcwUlNiMm5zaUZXdlllZDAwQnN2YkVCOXNSY0p6?=
 =?utf-8?B?elIwSWpIY2MybEp4dTZCRlJjUUNPUS9aZEVxVXo3Sk03MllpbzZONUZEUy9o?=
 =?utf-8?B?bjh1MnJCblVIaUFsZmlJYVJuMDFDOWF6ZHdUYml4WHNmdUNCZiszTEVpWERk?=
 =?utf-8?B?UXVaWnlYZmRZSHhQS2J4UThBc1JTL1lieDlUMUx4MFA5SDdkbjI2NHZsWHdZ?=
 =?utf-8?B?Q1Z2L0lOUUh5QmRSeXRNOWRoZEQzbG5mOVU3djcwNUorMlJiblMwT2piMWFy?=
 =?utf-8?B?VDR6aE5XaEhwNnNIbXZMd0RtVlFQUVVuNGRQRW1SK3M3bStaOUZsUzJzVmw4?=
 =?utf-8?B?NmJaTnljbEwzRWdiVVorMklxeHNKT1A5MFpVNjY0Rmkxc0doTW1VdW5SNkRP?=
 =?utf-8?B?OCtvVWhYTjZpZ0NlSlRDOXV6am9KQ0dCVEpoYUQ3YTJDd2JvbmRmS1JSUGdL?=
 =?utf-8?B?cFJuNUpvcWRZWEtKRzVRKy9rWUdSaldHNTRTdDI0cnBQcUlFS0ZmSVNlN01Z?=
 =?utf-8?B?VWNDMVkxdE02TnJiRGtDbFFlUnh0a2dRYzFaaWRJb3doMkFOQ3c5SDQ4K3l3?=
 =?utf-8?B?VVAxUlFvWUp1eWFadnZQYnZtSXFaWDZ4RlRpeE9KWnhTVmIyNlYyT2tTVitx?=
 =?utf-8?B?Q0ZJOTNSZWJ5d2dYdTBBZHFLVVEyRlg3TTAyV3kxOUFkZWZFSjRzTmRoOGZx?=
 =?utf-8?B?MVhDNzV2VjBscnNCYmhrcm82b1V2UkdVdmlXMC9TaURucHpVWjNpQWZtQXV6?=
 =?utf-8?B?R0trQ0VHK1c3WE94N3A4VTA5S0IwMmFKSnd5UER0ZmpuditKT0dSV3NFVnhK?=
 =?utf-8?B?dStFbU5WRHk3OHBmSnJuK05RS0hPUkRVVm10RERQRjR3QTVMQWw2Tkc3SVRk?=
 =?utf-8?B?Y3Z1cm5XQ1JYY1RkbFVHMlE1dlJ2WnRkN2pzbGVGaVdEZUtWNm5wNUptWmJU?=
 =?utf-8?B?cjkxSmdLcmZFajJ3dXZwZz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TkgxVWZIenN2ZWVZU1d0djQ1dFVudzAycElndk9HVlNKS0drN0VNamF0bzFz?=
 =?utf-8?B?S2pWVmtwUEFCZGpqM0JNeUlHUmFKK21NMkNCdTFxVG5CRXNGMmpVQWQ1Sm10?=
 =?utf-8?B?V1UzNXVmTVNzVUIweXNjL3h0MitobjVJblpsdncxUFRaeUxkUkd5dnBmeVhF?=
 =?utf-8?B?VXpUeWp4V0FIckU4NER1dm4xOFgyRTZxTXpWMlZSWkV5UWh6M1VWdm0yODJ4?=
 =?utf-8?B?Y08yQkZJKzJDVEdRTmRJdm41VC9Kb1JTMWpHQXlBN0x5QWtoMWMxdFFiejlr?=
 =?utf-8?B?ZVRZL2hZZXpOb05ObXJiK0duWEtlVUE3eU1sLzZFMlZLcVFka0tiVDFKRlUy?=
 =?utf-8?B?TUhzc0NaM0hidUlIUWs2eENJOGhaVVNzLzlheXMydUxoeHU3ZkI1Qk5aUjlT?=
 =?utf-8?B?Nm81VEx3UUZIbHdmUGVpeGhOcDkyOFBuWDJ0dU1WazhWQXJHUFZTd1BJTEhv?=
 =?utf-8?B?dWU3WVp4emdZM0gzUWNQMFFZT2hPYVRjOE03N0c4MGZoaG9oVEtvTUJBOW1S?=
 =?utf-8?B?WnFaZnZkY3VEOVEyR0FiWEphVHVGWFMyWjlFajM5MDJjdllyRzR5dGd1N2VJ?=
 =?utf-8?B?QVFhamo5Qk5XcUFPNGVCTTZlWkdCbjdqd1U3MU9zMVNtM1dDQUtrNUJoKzRV?=
 =?utf-8?B?c1hIWDR4MXQ1YVN6ZFZDVXBoZmVLSnBId09aRVVVL09MaUlCVzRXaUVXelJj?=
 =?utf-8?B?RFFLTDZjWWN1YzZseWtxaGlaUG03Z3lrdWNWSnhOS09Sa2JscDUycXUwK2Yr?=
 =?utf-8?B?b0FwQTRxelBVaU5lbjdwWUFsYzhSd3B4SlVQYnVYbmc5K0d6MUxBOUpiU01Y?=
 =?utf-8?B?MGdIRVNDVmlsWmxjY1c0ajBRN1lKb0RqS2xWUlRhSGhVK3YzOFlxdndKVm5q?=
 =?utf-8?B?WXNXR0JLMitBUzIvcFdnU3dySFhoY3F1SmlISWpOR2Flb0lOR0tsbGc0aEp5?=
 =?utf-8?B?VnF4dml3YXppUyticldLVHBiZHdHb0FjY0pxUlFuUnovdTUzK05nWXpXZUF6?=
 =?utf-8?B?Rk14ZWJNWEEzU2hkOHQ5VTloTkd2Q2YySTl3YjBWRGlraEhvR0NqN25WTEtT?=
 =?utf-8?B?ZVdwZitwTWtGR1BVWUV6SnIrRzJTekROOGRTMzA5ZU14Y3hzcGJlbmdZWVZB?=
 =?utf-8?B?UHNGN1RSTW5BVS8yNEVjQUdHZnduZzR6UjNkbmZ2UERqWE11KzBYUE8xUFZz?=
 =?utf-8?B?RDBEaURxbFhzUU0zRVdwM2JSSHEyOVRXTTdPT2FLRkF3aURrVjMxYmp3UVBZ?=
 =?utf-8?B?aXNIWjNGMVdHS00vRzNpTkZQMG1HeGtkbWEwdXA0TGZXZ0h6RHpEQng1NFQr?=
 =?utf-8?B?MHd4S01tbGd4cDNkd2dLdGZYWmNPSkUwUFEzakZtQ2hKTE5xby91WXBEQm1U?=
 =?utf-8?B?ZFZwVU1zaFpNRlFzakwweUNhNkJZK0gzSDBNWGYyN05uWFZ2RlJGTEdRY045?=
 =?utf-8?B?MVRRckpWV08zcURsZjhPWjZ6UUtwZ05rOWM1Sjc5UGxqK2JDektmV1VDZjdp?=
 =?utf-8?B?d216NVZzcUVVMkdySUUwWDBpcTE1aHdOaTF4aTlEZTczYWJWT3ZVSll1Zm9j?=
 =?utf-8?B?Y2N1bU9LaUdmeUpnamJDczJEbTh2Wk55V0E3RlNVWHJsbVhGVnRvQWhsakpE?=
 =?utf-8?B?V093WFpTejVHSTQrMHVINzFhTXNyRExaNTRrT3BRTGVtNnJtN09WL0ZadTNC?=
 =?utf-8?B?VEswT2g3M0RkV20vL3BJcC9CZjVWSUw2emlVZTdXOGllV01RN0p5Y2hZeTdB?=
 =?utf-8?B?dHIraWNIM0tYdmlXT0VGSlVtemNzYmlpRDFHWjFaK0QwS2RSZm00UHhLeERs?=
 =?utf-8?B?TkREdU03K3NaTkVIdVZ0blAwVnlvaG1mV1JqbEdmeWxHbVA3bDNWM3VUUW1D?=
 =?utf-8?B?ekNucTIySEUwSWJnQ25jcTJkekhPY3p6R09WRGhQckZrOUUyd0p6M09XYi9P?=
 =?utf-8?B?elBCOGNsdVlhL3pXWFRyRHg3eHlaeHY3K29KOFlvZzZjZ0hmUzdGa3U3S2kr?=
 =?utf-8?B?cWxoeEFxZWlkVTZkbDhTRjhRSnpoMXgxRithalp3NVRlZDBIUnRSM2QvSTJm?=
 =?utf-8?B?akxma25pc0dBVWdxYTQvL3UyZlh3ZGowMW1MeWNyY1hGc2lnUmZuTjQyT0VF?=
 =?utf-8?Q?pDwdyX7btiUiwCQU529TUp4Ig?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	be/gb1YDu+j+iZmD1yZkUBugII2CVMwlrgsT/pXgPpouX4cHHEDfXQxIXqRazrtuUTuQ72D7Sd8fDZQiE9QXbYnF331m2R2TCXQmoVvmuuYYw4SVjffGYrsxBXgR61xfVjeQf9BWiVnCyzpcni8dw35f+cQNuoh/ftWTpvQtJx3TxRG15PjthFhHONLlTY1Vb3wHRilNyXgcYVGqAb/Y5jf1UramO+T6CyNe8v/VKMmlpe2+HDhSs50XovQ3GHmGePzUeWUasW2rvk7ITLLr0H9CTcP0toIjQD5fP2Q/EKoLOcm0Jo7i/3KGY7y3p2kM5f6Zaci7gzsiwkXBRfcrBwHYtG2MRVXtWQyf9XXhFmmIekE6pESQWQIZImJAPlVTLRB+TuoA8hEY9YEsVqbDiN0gPX1V44w8pRPLFemniWgu3O4KiTe0Ea/5KgGCuAlGpwziZh9xAOuLz21Obe7SKWl+BB76tQtp/X3cSU+fFeT6TxOLIM51XECmRdu9NArI5/BJKhHnE90K8yLHKX/Qe8SM8T3tDzypPGiPcyOW9XtiurGsdXvYiuWVxH8C78EMMgaP3ar4BvZfDKshari9WpNJzPzDQCXEchuknV4bDQs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318de881-c4d8-4b8c-29b5-08dc98e82fc3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2024 09:36:58.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgQ8csuokv4x0uNea+NlV1Ke2xZpqjmSNpqLD47kYipo+V7v/aS5RVXpK4XTSSTaomgbnyR6oYZ+GY8zTFvlnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-30_08,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406300074
X-Proofpoint-GUID: tlvJ2ferFTjKmKizRw09m9pqdusCMooT
X-Proofpoint-ORIG-GUID: tlvJ2ferFTjKmKizRw09m9pqdusCMooT


> 
> Fixes: 633273a3ed1c ("libata-pmp: hook PMP support and enable it")
> Cc:stable@vger.kernel.org
> Reviewed-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<cassel@kernel.org>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
