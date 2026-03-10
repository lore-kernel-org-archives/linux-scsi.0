Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E6C2E1EF4;
	Tue, 10 Mar 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165963; cv=fail; b=Ju860I97AzQOsKjgGG496LXRDjG/bX7N5pEqOAaKIpF/jfWyDaJaFvGmDcWueXiHGXXlU/tvrYAOrMfjl46MM5uKCUGb8eAlk/9vkUjOP5PwnKUF3mkgNxG3f+bMyqdc/2pap2NXBgIO4xrcrO9zNzwsHQc/ieMSUCQMj+RJbZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165963; c=relaxed/simple;
	bh=E5vVZ8q/5A/xdt2AiV4pl0NPukOkdhF+yLRWz3ue0WI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=avROt2KfZhU4f2nKL9C19zYs+WHkPXWaCUf0SoVpZnI56+56rs0I9VRZ0tCNkWVojHwHxebQ+QRPlJKxjZRS6VbQ78wb/Qfdixj+GYjMOLvvQDCiduEyuscyL+NDGCsrPcndp4SqURbdu2+DwW8sMSPo65urThbDO6s0nRu3dY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=joTQ0SCh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gnSl10JR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="joTQ0SCh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gnSl10JR"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A9pcW3094181;
	Tue, 10 Mar 2026 18:05:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gSf2bwJ52W1tMS8WyOYB266O5iQtCkEijLhyj+Kc88s=; b=
	joTQ0SChFBH5IZladdI2eOu6R5rTte4JgjKGVRSLqLGreWpUX8rcFixzyTlRwwQ8
	dhe3vZk6JpbfxnOBirrdPwt+t931nwtBJFAdW+BobAuQYy+/MfdfRJewQ3Kp3Zlo
	w9v8CjWReGBEU+s/f3QMtyVFn++MnH566r6C/i/4kwhAKWDJRPtO9UehbgEduAAQ
	0Ep8Iu4tUDKBYov04naxzn5EgxQ1h/1LCne6tiyNlSRpeYrvwtxKajueLPjlbVJN
	QDdlGmvqynBg7TR1LCQQIQbeFQoRKqNvv1VaF+CtmMEbsb9mtD3yjA41raR7lLGW
	XRZuM/GRypG5ke5ek+Z7pw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmdkkd09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 18:05:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62AH42QY007745;
	Tue, 10 Mar 2026 18:05:41 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafaeu00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 18:05:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GrzXK5n/3ZfaEWoAks3QhT2haeRM5oESoKjGozQKC3MGbgSQ9NqHRk1qM4RRDHVucsIj2//z1K1DmAzJ39lhk7IoYhjYmVjuZW25ElGlqkdasHQSPW9nswCIHW7QhJ+oqatCuhWFX2T+Cg5JqJOnrKfoCJrqc+t7nOcSPYXCMPC3W5dlUBIu+R88RIJdT8+EeXviVBhEOfQiD0KFFD7o6zsoS/nrE6tA54rA0hZOBgR7cX3N2OF1y8NK74N/qy5IqDfIDIH+cdVW3JskNmtevsk1QiOTY+Dvbj3aYXx6tvBs/G7ODGD9/ai3Tg290p61qg/+OW6MSrasYsd8lsenUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSf2bwJ52W1tMS8WyOYB266O5iQtCkEijLhyj+Kc88s=;
 b=C5YqhB7NSobVjWQJqdAA0VB0u18bos9G92r3mob0eMKIc3qi4tFEkxDnUePTH7DOXUxg++JOCNmqM7j9OJ8vfIwzGTuZXw186MRHM4l2CVcCbwN0liGeLzJtlX1qeNubJnRPvYXb2Ys8GSTDA0obxgbXQLjg4ix1E03PtNs2YY1LrDq+OqsACPK+4rbJligKjERcb52NG3sK2H7VO4GuEU7sUB/+3ohKyp9wq6ZsnpDt9i8NVzAZpPn2jeXaUsn+LMfbcTO0nYzqIuPtX3Se1PY6uFrbH/QGd18pcY+s6Gon4Z1VfyUCmphpKnK9/rxbrsSunoRj2Lffq8sLHwpjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSf2bwJ52W1tMS8WyOYB266O5iQtCkEijLhyj+Kc88s=;
 b=gnSl10JRmW5RrKAs7DNctpl64rEcg8A8AWzYSqjrFm9Cup0jRxASipyZDtv+9blGhS93O6kIDa/r4ormqPi1IELAv0KiZo4GZ8GIkt7iYhTye7MN7gSqKL+07VBlKExc7pVtDYabMAcqIimjcdXFFRqUXFbiqUJrNsXY0F23wsM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by BN0PR10MB4887.namprd10.prod.outlook.com
 (2603:10b6:408:124::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 18:05:38 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:05:38 +0000
Message-ID: <949c3319-1938-410e-8796-8e8bbdf59103@oracle.com>
Date: Tue, 10 Mar 2026 18:05:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Native SCSI multipath support
To: Ewan Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, lsf-pc@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
References: <69349b51-72c2-47f9-948f-f89843af62e4@oracle.com>
 <aZnuSC0qYfw0hiwM@kernel.org> <aZ5GbVxDT3gcS6WE@redhat.com>
 <0a6ec8d3-7623-4809-b275-3eccb94419d4@suse.de>
 <a1e5c1ac-fb5f-46f7-ad7c-e21a545e128d@oracle.com>
 <CAGtn9rnreF=AjejdZ_66Wicc6dhQjbjkK3BY4wdaRm3_bgC8tw@mail.gmail.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAGtn9rnreF=AjejdZ_66Wicc6dhQjbjkK3BY4wdaRm3_bgC8tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DX0P273CA0016.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5b::6) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|BN0PR10MB4887:EE_
X-MS-Office365-Filtering-Correlation-Id: eb51e7fd-7004-4f69-e237-08de7ecfa264
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	74eOvYnk7/2PCO+P0svwKZp84WSXrVxntlqDMKdXNrOcoRskPp8a9g5yhNoaXGC8+LNAdJdn2LWh84OdokpbJkRiPH8EDLfF8paIHh853541Toh8mBpcRp1khueoUvKObQDIUYITBMPAzUCe9GUZsyokdpHm6Ywc1uBfNkH1xSAVXYo4iVOMZCMiOnsF7IJm/MKsvTCIuORLTAI2MTPVhzzGockzJHOYPDSUlPbAPdBASxTgASSdff/oCZEWqbu/Acx9DNhSDxiWOCcs4HxyXXaZ24GfCM7mTgh8/i2ki7V88y3DhKcs1pKa1x2Fi73vWsXzjL+MsfZ+zmkSFrkxwsWdnPu6SBZQJuYlw0dgZmnVBdhVRNus6MGAvfZ5cenDefqP2yYyz5loMuUffQFkdnBmf9rLmxxAnyrTe43kDVC4yJfvo56G09sN1og3JJsspThwEVckWNxJbAnw9flQC+sL6ibpcsKgQWdAhcD7HzVm2tMQz2YuyjtBO4cO8e8gLmTr+PWmsbgt3JfzFGTZqi2nd77jsfNdryaqoHPlGNooHP/f3874Z/PuNsyMcjhRpUE2161drDNWwafyAiAjRxIQYE4RNJQvK7oI50fybFh8fYZh4amQGqEsXMlCMCh93+ZHt3DWPdD1WE/xjPBQy5GMMOz/58Zgad2vQludXq+Jqe6M0ghIDCHDJYyg4UmTRm43VDXygPjE0St6C5E9QOV2krNZsFEdnZaT8vgvqXI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXdLNlNnRGJhanlTaUwwKzRvNXg0Sk1mVHVHRTRNM1k2T1d6V1k5TUJHWEE3?=
 =?utf-8?B?ckpvbnNoaU91KzNwMk8xNmsrN1R6NktJQ2ZoQ2dBWjVYdVlaNjEyRTdYUHdX?=
 =?utf-8?B?ckNSUFNzQjhmNjZaMkxqQmROM3ltWGtiS3BhejBvajZNZjR0OG01dE55YW9E?=
 =?utf-8?B?ZWhOenRKdXQ4VW5QY20rbjg2QnpVRUNQTlMrUWJsR1UwZHR4MUYvaFd6cUxN?=
 =?utf-8?B?b2h6enFpQ1JpdGpWVzczZkIycWdoU3pOSUw0UUNYTHBVOG9kanFqQVNGMjNn?=
 =?utf-8?B?TDVRMTlCM2dsT202QjBoeXdFUUMvTGJSMXplVkp1cGVIWlMydG5YVUFNc1lv?=
 =?utf-8?B?QThJZ3lJNURsajhpVWpVa3U5T3NvVjY4U1k0MFFHd1hSajg2a2RibW8vUWoz?=
 =?utf-8?B?VTBhVUh2T3JpSlNuMngwQjJhVnJtdUkvTFVjZjBPRGtkYnhxTkFuMUY0SHdm?=
 =?utf-8?B?ZW41cG52Mm5tZCtVQ0FwWXIxS1RwRkUra2N5VXdmSzFWN0FrZnVPdjZ4aDB0?=
 =?utf-8?B?czFsbzRWUmI0MjZoTnZsUGtOcHNlK1pZMkF6ZXRHVnJlV3FVcTJqK2hlcldS?=
 =?utf-8?B?dndjUEdOa1Fqc2JuSElRSUhMTTNFVU4xV1lZTld4QzhINFdvcVdDblkwTG9Z?=
 =?utf-8?B?WlJlcEdQT3FGYXZ4K1d0amNNaUdpN0J5TG12d0tLZnJTSWFVcVlBQ3V4Z216?=
 =?utf-8?B?SDZjOUdxOWVBQXlMMmtmUnRKb1huVXZVckE5WHkyYUJKeUozUytyVHJJTndn?=
 =?utf-8?B?cFZXU2s1K1FMbEVlRkhHMWorMXJXZ0hvK2U0cHFKdDlHbFZEaUxTWStFcHpa?=
 =?utf-8?B?K0Z0SjRzdXdNam9pdXJHK1hVNlBIZm5ibkdLYUM5TXhrNWU1eW1IR3h5ZU82?=
 =?utf-8?B?U210ZTFGSnA2bkpTaFdhZFFodkVpeldjY1Bqc0hBWEJMUkFlZmFvS2JaSE52?=
 =?utf-8?B?UCtQNENHZ2FXcEFXcG1NYnRxZHNlSVlEVlFsYWY3dGxoRlBwVGJEendRRUJz?=
 =?utf-8?B?dDlYZFVDU2xxYThQMk9VSGtYNVMydGdCN1hEVXNEUHB4VXJ4RlVoZkFQbGtS?=
 =?utf-8?B?bHQ2clg3TjVCNGNjNTl6YzJQSGVUOWI3Q0NXd1pVRnFpdEd0SkYzY3luRFFt?=
 =?utf-8?B?L0JFTGhMYjIrU2MvZzViV2RYNGZPcVhIL29DVkhnQzMrbVR1MVZXQ3VKUzU1?=
 =?utf-8?B?UnNBZXNMTzUvaS9UK2JVSGJXU3plczNZUzdzR2NtejZsSXlIUjR5M3JVWUVi?=
 =?utf-8?B?cll0Tk55Nmk4WTVxUkZnejlRd3I0cm5tODBzYXdnMVQ2TkVFdTFFZDZIOWN5?=
 =?utf-8?B?QjFEcTYvSmpKRS95elJIbGlJRFVJa2pwa3AvZ3ZnMXVoTGRYaENhVmhHQXFO?=
 =?utf-8?B?blArRlFudXREeTllb0cvSkZLS3ZxYWdDV0lZNUMvU3Zzbis3bnczQW0xZmtO?=
 =?utf-8?B?eTI2V2hLQUdXaHF3eUxmcHM4cHYrNUlIRk50RmIxTlFjbTR1WGxKcENEL2l0?=
 =?utf-8?B?M2xMVE4weisrSC9LT1h4Vll2MUJEckpOd0Mxdm5yT1J5Tm5sclQza21HNDBm?=
 =?utf-8?B?dXpHczlnQU1iRlVnNEJwM0dTRnhMUWY1MjNxcTQ4Z2xFVWJ1MUpkWGp3L0Rp?=
 =?utf-8?B?eFAvbzEwLzk5VlBWSE9kLzEwWnRZekFYRWtXSnl2bjNPVlAzRmg3WDBOdmxo?=
 =?utf-8?B?Ulp6WFVOVkExK1NDS25xSnl3REVmVHEzZmpoazk3d3FjdUt6bk5MVmhXcVhY?=
 =?utf-8?B?VVdTV2tITjR4OTRac3VMWlJvWnZMZ0M3RXNHQXMwV2tzekZGeG1kQnVrcTlS?=
 =?utf-8?B?KzJBQ1ZBSlhUQTN5RGEvWWgyYUVCdSs4L2hGWHZZeHo0RnJjYytNSVJNTGM5?=
 =?utf-8?B?ZHRoL1NMQzRjT3FxYW95Mzk4aXU1cjJDWVhsVlNmVStLTkR6eW1HVnFVZWgv?=
 =?utf-8?B?WnpmR1pUM1pQeDhJTUdZNjdPTFdvenlPOEpQQkgyRTFYWXVRY0pQejYvU2Q4?=
 =?utf-8?B?RGpvNzRkMHJuaXlId3BWNDRPNHFZK0JlbmZXZzNLN3BCeWRJS2F2Ti9rbi9Z?=
 =?utf-8?B?Z2ZUdWp3aVI0cHB1bHhyTS9TdnZCQmZGaE4xR3pKeGREc0IrK3pndXVpVE0v?=
 =?utf-8?B?SnQvZ3VMYVNHTGFnSWZEWFdTelkwdXZ1cTJybTIvdkZ4OGt0dHQ2MG4zQVA2?=
 =?utf-8?B?WmVNeDZaK0tKaGx3QmFxVHl4Q3pzVi94R3RsNk5nRVJvVWJjSlhkM05Ta0F4?=
 =?utf-8?B?Y0hYdVpRMjlwL3hRSk1RQ2NMZW14M3gyQUtJRThrVGVETjJHYzcyYlNkamo0?=
 =?utf-8?B?TmZhSWNvSHV0RmtQT0R1NGNQRnlCNnJyc0RaSjlySEtzTUcreUZET1NjQWww?=
 =?utf-8?Q?nWE5u3a6EWDewwdk=3D?=
X-Exchange-RoutingPolicyChecked:
	D+cK4QALS2AJ5HSw2inOicBb2o3izBQ/m3h6WeN1LQnIBMT8wCtG0wnTkKZ5yA/ljx5fQqJ+rKoXgv9U+F3QnZ5mbdCp21deQXqxUarQxGARlrjg8DITvCLg7teOyECLHf+x9TWhvk2d1kZYLnNQqVKQ+tL/U6VdjZ4V2/QdAPhHpl8UYPUscy2tXCdjhjYV3sE4mqjvLD9BjZG6bgqvm3pGp+CEV0dPF8CXdpSlqld3VbrZF0xPoVznWL9Yvv7ckJQoQSpOHqLbG4YzEyKHJBwHEB4kIBL2w36m6yIJN89BXzKsqlyQIFtpBw7Nq9HrPZ2xhff0wZdBrpvqLg8ZGQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R+VhCYbgNA5UAddiOXBibRwOEHdC3eJywbggtxQEyOrQ8xNjJkoC7iPKKlltNrIaFYaVYTQLIx4YCEultomOomnMsccZxpXXgKZpf1qOEoBaWj1l9ZKFkKMiv/3EXEI8Rbr0/wj1t/aVbWLi2GfSDaXAI1qfIUr1nsIy4MeOT5vm2Bx/qnAcQBXL6301IPpRvR6xCmVk/HkZmi0Y70gVrFK1G5EgXd5nkPT/wr7L5cJGQ6LkSM9RKqmEZnPKaxwwCiyL17/ejn3jxJ2rjUj/fp+kiO25nkv2RhPU5Q0zn7mB+DQZvD5vP2NB1jKfA3z2Yd1ikaUf/W8AxaABX083E7BuR1qZuBz4ncG1iPfqcKgG3b2GudHySCu0+BWJNR3VzUwPUjOL8v9opuheSsiG5qEzSMcGqw87ImjRNrmPiTh251ESYuSKL6EjAke4J+Xt2tPDpukcV94JkEjRJzgmhHSfXQqiugLYNOnQErQh9ppdCfekBI87jm4Vfc6SDXedzU8HiNYNoKOwJyQmp6iSHf9dT/OozgfQlrTgg5SnOp4xhcW+ZNVOlBDsks0Obq7U/LHl8c0IAOcdbSyplW4yZtedUXN4p4uJjmQ5UOu7U/Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb51e7fd-7004-4f69-e237-08de7ecfa264
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:05:38.2225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BybTqmRjmrfpyaJxm0cGaX1M2c80+9ejP9bIZBcXwRI8Gy9BbBxAK06uya/qEcFrxY2FGsGMZgLz65yTsnkVRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4887
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603100157
X-Authority-Analysis: v=2.4 cv=MuBfKmae c=1 sm=1 tr=0 ts=69b05d76 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=ZAE0sEWiqWgrlA4TGboA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: mj7sKOcQ9XyeV-vMcSEH2TMagU8TIQx3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDE1NyBTYWx0ZWRfXwEd1Huri9rR6
 4V93HS5F6GiQrluqbDb4MWOPymvSAyruAtAdQnZ1uMwy3GzSf8+CT/epdHE9qLQOqV12MmOp+YW
 4qa68uAtPwgxQdPB2CZGErO1OZeqSFxeyl2XWRpuPB7NIctPhHule07pySVw6X2fqUlVr/tk8Pl
 orw5QNEmkiGGGm4Rap1f3g6NQTO+6MpUOlD/UUiDWZifxrpthXMpRmWlWjasXkhZ0Qwc7JWuExN
 rbY7yfvrhmjBwPuhk7wlzO1M8vc0DuTNsI2ZtpnOdkuV26fSVu5X2UNOJOq3DxZez5oCDoroCYz
 oFSKD1yFmStHYm+H+COHQKW47omb4od22Khw0g1G4kYNZ2PpW4VH9sDp9U4hq3YqJtIKXf3s6kq
 tPm0ENcIhfZyia3XEYDISeXMHJbA/PaSokDCO+EKBkMWcRy0dU89Ub+84oCPi2+WfQtQNj/l0it
 aImAnm0DANw/9pn5F8g==
X-Proofpoint-GUID: mj7sKOcQ9XyeV-vMcSEH2TMagU8TIQx3

On 10/03/2026 17:12, Ewan Milne wrote:
> Hi John-
> 
> Sorry, I was out for a couple of weeks and have been catching up...
> 
> Re: sg support, there were issues in the past with people attempting
> to do SG_IO through dm-mp
> assuming that DM would handle retry on other paths, which it didn't.
> You also have to be aware
> that non-idempotent commands don't work right if retried.  My
> recommendation would be to avoid
> implementing it, although there has been interest in a better way to
> do multipathed "generic"
> commands (e.g. virt pass-through) I think that is a more involved
> project than you want to do here.

Understood, my current plan is not have a multipathed sg driver - we 
will still have the per-scsi device/path sg device.

> 
> I see the discussion has progressed re: ALUA support in your later
> patch postings, which is good.
> As Hannes said, a Native SCSI MP would be useless without it.  You
> don't have to support the
> older non-ALUA mechanisms though, those arrays are way, way old.
> 
> SCSI does not have the equivalent of NVMe's AEN, so you need a way to
> ensure that your
> ALUA info is up-to-date.  DM-MP's path checker normally does this by
> sending commands on
> which the Unit Attention can be reported so that the code can fetch
> up-to-date ALUA info.
> Hannes made some optimizations years ago to avoid excessive RTPG
> commands with large
> numbers of LUNs which we would need also.

Hannes is suggesting to not have a kernel path checker, so let me know 
if any issue with that.

> 
> It will be necessary for the functionality to be enabled via a module
> option, at least initially.
> Introducing this in general use will be a big change for people who
> have Enterprise SAN
> configurations with their own custom path monitoring tools.  I believe
> we put some functionality
> into usespace multipath tools so e.g. Native NVMe devices can still be
> monitored/observed
> which made things a bit easier for people.
> 

Sure, if you check my patches, we disable by default and enable via a 
module param

cheers
