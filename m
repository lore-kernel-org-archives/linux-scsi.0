Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5FF3F7A96;
	Thu, 26 Mar 2026 12:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774527402; cv=fail; b=rgzq4zPBtk+Ol9bAw0wW2BUHe1Yc/nW9NA3xzlS9w4A+yt4Slj2i+JPATPiVDGko/Niu5eeYPopajQulPPjFByj+gSQniF7qR8LCfULIMVWyfmFQK7xkfO0lTrVeNUafPScsOEUOobJDGg5Rzoh1t+4mfswk55x94+r0x6Re2ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774527402; c=relaxed/simple;
	bh=GtlLuTDyzpjIfWDsYKpASBSqM7E8omd1WOU+i2urPm8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nMUFWDvZfgopk8io+0bzhTXqXFY0Gz4voOU9PBbcRn6JslucrpvsGl7RyvbDbIOARiYj9/cdTX0zfhlAClH1HRT4PT/b5/X3kKoPZGstZuXgfbTOoDxEg1kfTwzvHPiP7n5n2QhIJ7FZNU9pmLhnjfnjEtT3HYmMFZdQbpvPpSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g7o34dOo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=f42jdphh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g7o34dOo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="f42jdphh"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62Q6Jt1s3464388;
	Thu, 26 Mar 2026 12:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tMzW2ZT2TVRDjKdNBmvhDTUhu1T+EG0t4RmiZLj+2OY=; b=
	g7o34dOoX7hDTlHaaNGF5aUxOwdGlHxEFkPosSM4977URYFYjnpmAmAXZCKNQyfi
	mmwfzvdMyjJWJ7evck8ieyehj+8fTufsb6aVmyVBm9eisFKribDgbXfaSqZpIvjI
	I3XZVdfYdOly8SnmMfYou8q5rItut2PRyIIEZsgBZZJZtb/3J8YvTW9/rlo7X4xs
	3d5fLvMTlJKTQBOcvGi7GCtimPSHPX4fR9PERJMAXgYLReTZeQHY08O+SYQdwbL+
	kYh4dQvy8ckwTFEZGvZwmCxosiot6INHpLUnT9M/rAjeYO0pppOdwGtQsoLu7yqb
	3MZYrFHC3LNpnRHMzxgXKQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1khf84ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 12:16:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62QAF7H1012347;
	Thu, 26 Mar 2026 12:16:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010025.outbound.protection.outlook.com [52.101.46.25])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsjxb7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Mar 2026 12:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SlHJ5VArPvAZnXKy9/dr/ISHQ7FfmXfjd6fCcHRKN6OC95of3vS5IhG6hrbLHfs3c9wKmtdk/0Mi4SBPlHmxf4OuH4DOM7LKJynRSIiyf5zdNi9jJL0mM1E1xczqP8MLA32DnErUrBMjHjrmok7bsYNI7mZfmGdz8lTxmZOWF5gyghm3RTGjaVSPvlME/VK9euVsgr7nTYuhvqpJmpDnOKNJ9ckkr8eP0qIeQC+kI19h0StzvygNX7kzT1ifopjm/ubu9ZOO/Oz2tjJK+sSAB5yJlsUtcFJwRC8ADfF4X/H6KMK8Gw/QUOvxmMnUKQ+7XU4eLRqANs/2wO/vLiovpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMzW2ZT2TVRDjKdNBmvhDTUhu1T+EG0t4RmiZLj+2OY=;
 b=Ixt9WITZExKzQeCiQJjwgDe75E1iyTZT+WynJ8A6k6ZWS4ZeuTl5WHNZfL5DOSXn9iicpPcTQUf8HpHpHIogouZ6OezUBTp/3kOnFzH5Zhs1tgMlkcmnsQEyILk4LfcSs5Ykaw6npQXF9eFpnltB0ceCbsPpkHrYmTuLwPRDoLhAuO+6TJHzJNYGVKW+4nwUCPe6DwBNGoGFDg/bU0puXG/lLFVPhYXuBRDfMJG3VORrt8c1vDsI+JKe0TQPnwvTWsR1hcrYgCGky06+8JCqFY7yMrwFa43Ye6vvh6QgKqsCg12reA9/w4QSw3YTpA5mtcqZJgVVhzEZMQLdq3cLWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMzW2ZT2TVRDjKdNBmvhDTUhu1T+EG0t4RmiZLj+2OY=;
 b=f42jdphhR9Jy7co3c7krTcNU4zxdxumV5sdmPaeOYbJc8hubWAUiGYRupiGOYcuYzK+es5/MnMdbKANmw1/gVlK1zI+WjNIVkvxg5kFuKbO0pdb1+ToCrlU6EYgtiTTDejXugFwATSHV3x4R/njUQwX0iul9444TAnRAn1CZmQg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ0PR10MB6397.namprd10.prod.outlook.com
 (2603:10b6:a03:449::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 12:16:22 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 12:16:19 +0000
Message-ID: <7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com>
Date: Thu, 26 Mar 2026 12:16:10 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: Hannes Reinecke <hare@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
        michael.christie@oracle.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
 <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
 <ff1d65e0-bb5a-4dc1-8bbc-dc781acb341d@suse.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ff1d65e0-bb5a-4dc1-8bbc-dc781acb341d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0056.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::18) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ0PR10MB6397:EE_
X-MS-Office365-Filtering-Correlation-Id: f8f649ab-bce6-4570-dea4-08de8b317c90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DIPeaIevgDMFCoWwJkkJrM4rM5Q7Z8cSlKlIk2RiXn3D/HhHzNMdPUQEFcV+GFLiwxpjeRxQmGsS5csqg2tu/Ds9jXbA17FbLMWXJx6/CvDNLGX50Bdb0+fl1aJw8Us+RJ/VgTa1VAW8xWa6KEHK78e0mQPhOO7gxktJUGAyYTz5K0BW77BBKDY071M/REzLB3wICQwxr7J7OKLwBkt/u9iRNwzEqZ37GAXponykVH9m5qXf8rpLTET10pZ7TGCsKuD0JX94Y34l00LGggwdjVDrPXlR7JwUz6ttRdpXShm0LkzDPZitoU0S2VP+Emsfd+w2Xbf/CsYfvSSBxtlbflXFCEGLeCm46IHGrXoYqptYz3Y1+KtH/SkRdSCg+exxu4BO/tLvKirNyv/rt41hpdLUvyuRQOV+6GOlFS86sYVepaJmgyacoF1BSVnprpol2VqAdPXwqv1FB8HZYRvjD2TjmufuiU2g3PqohoNS2Gjqnn+lm1hd18Z3L0nnRE1pcKlEavOLZdDO/EjBJrAF1FKhfD7RA43HzRiXgT5kzb8/uD9XjX+L9QLdH7956HWEuGMeGxtRzLsOAR/iWJ14X/JR5rHZJzIjzP2m59+sSLuQek3WbExmpnjWBoOthA0gbS9LuZT8iEdOpF9K3HelChRhxbBDXCkb/SR0il0jQmviIrdjQTeoLZ4Zxr8CSyri/c677QEvs0VggloLi+Qo9G7pskGaIpmhinMR2XXo1bI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3hRM2RnOTl1SWZ0Vm5NTDRkNVh0YXVRdGZRbjFtQWNQYUlWMXVraENpL2Y4?=
 =?utf-8?B?RGxGR09yYVE3WHh2ZzdYekFkVGN0MTZ1ZmxhTy82OU53K1FnQVk5dVdJcGc1?=
 =?utf-8?B?ZC9CYjZFUVdVR1ZMQ0VlQ0s3b2h5c0g4NzBiRlRnckdzN3NYVzBDc3owTVAv?=
 =?utf-8?B?TE5MUjBxK1QxdGlJb0FJamduZmljUWhDNEdCL0J3a3AwQ1o1bUxwVkk1Kyti?=
 =?utf-8?B?ZW9sc3loQW1DZTBid0U1M3hHUiszOEV0L0NnUEhkZ0E5Mk9ySHdsNnhMMlpx?=
 =?utf-8?B?K0xacHovMnJYSTZrUUg5SDEwVkpZQklqT1FoREk3V1daS0dRY3BDY1VSQkZp?=
 =?utf-8?B?QmZLa0dpczVVbDdnMEpoK0ZwQnlTNjhlRWJQb3lRV1l5ZmZtLzBaOUQzMko1?=
 =?utf-8?B?VUVxek9LQllrOXlBbkYzdGE2U3BWN3c1MjNMMU90OXIvMXQ2ckdPNE41WGwx?=
 =?utf-8?B?bG5YOERlWDZ1YitZNXBSV1VRSklEb2Z3c3RJcURMN2Ewdll2aWVxZ2N2dDBH?=
 =?utf-8?B?dDhqZXpqeWZjT2g0R1htQUZERVdhejFsZ1ZNeGpaTVh3VS9QdlBKTDVOa1Ux?=
 =?utf-8?B?Wk1oeFNCTVBkUnVxMXNaNmNTMW1CRjN6eGlSbjhsdGJrYllVUVlOUFJBbEFr?=
 =?utf-8?B?RE0zVzFwUEJkekhHSlEvMis1RCthY0t0TTJZOHU2eDVNYytrWDFxT3dLaDZR?=
 =?utf-8?B?RmR0WC9oeGJJUkgrWFIxK1RqWndlVjhIWS9TQXFMcTJpT3VjcWRFWWRQa3Zo?=
 =?utf-8?B?L2s4b3pBMC9IVUd2cEtra1grazlhVkJ4aWNCUzQvK1REU1lyT2Y4My9Lemdp?=
 =?utf-8?B?dkJXV0t6NVczajFETlhSK29ZaU9mcW9xZjhvejZrQnJyQUp5RmNmVDVMN1V6?=
 =?utf-8?B?clk3bEdrYURPczFxcXZPckFNN01WUVdYWE0vSm5UZ1NycElmOURuMmk3a3FW?=
 =?utf-8?B?N2lPL0pBTFN5RnBlZUxMMVNuN1MxWTRyZUJFUEtkMm4waUpxMzdsRTBqNHpO?=
 =?utf-8?B?OTFHaU90RU93dms1RmtVam9wdUx5c3BqWEtmSU0xMHJpWVp2aWxmdnQzeVZn?=
 =?utf-8?B?czQ1M0g4WGsxelhWNks5S01yQmlXQ1l2WjkvdG5YMVU3RUJlUHl4ekdyVVpD?=
 =?utf-8?B?SERBTTFIeEFTb0NaYXh1bzB3d0lFOFJ0cWtlRDhlL1l4b1ZEd3pMSXdleXdG?=
 =?utf-8?B?bWJCNUNkMHEzK0tvQXBWUE5vYXNRa1ZtZkEvTkNQSWhTbjhrVXdRUTBnQW04?=
 =?utf-8?B?bW1NbzY0cU15SEd6N0JNMVpXTXNUSGszNVNFeW1jT2s0SlZZTHRQSmRCQ2Iz?=
 =?utf-8?B?ZWJMNlBONmVCYlg5K3FZWXJnaUhrS3FDc3hqeG5zVVU2WEVCR3NGWS9nK3Nr?=
 =?utf-8?B?Z1NCN0h4NzFOSERuVENZM2JmRHgwMWtRVGU4SnRvaDcvcDVtbG91dFVvc1lT?=
 =?utf-8?B?ZldVaEtrSHFDZUp0enlmMHdXMnozUStBYlJxVm1qNkVsUW9YUGZEb3IrdnNh?=
 =?utf-8?B?OXJtS1I1RzRUQ1IvV09MMWR2N1RFVDFxeXM1eGswcmV3NllyZTdtYnZJT21p?=
 =?utf-8?B?UzBnT3JVaW1FTHM1ZDNGUTV1ZDJ2NFVBSlNLc0Z4Vit6czRVSDk4alFOWnE2?=
 =?utf-8?B?UTNId2p4WnVIMzh1VTlBL0xLQ1lpRlAzLzRPSk1HYTJLRm1LZkVVT3FDZHhN?=
 =?utf-8?B?TG1ETmc5QU5pbVQ3MFg3Y0hBOS9NS3hWU0x6Ri9sbGRQdUYwZjFVbmJsM2Vt?=
 =?utf-8?B?dyt1elBLWGRmdC82dUZYZXgrcEppTGlUdWZrZ0x1eE5STnNscXoxUTNOOStL?=
 =?utf-8?B?QWN0VzRKQkpwT2VNNzZSNU5kSS9zOXFmT2hVOUZRR21KRVU5cFBnZWVndDdF?=
 =?utf-8?B?T2M2TndrZTNpSk1nSmlHNWk5TWNNNTRXSE5vSURIOHNuMTVjcjdWN2ZtOWRJ?=
 =?utf-8?B?elUrT2tvai9VNnJURnZMNVpoU0JZUncwYnZUK1RZLzJ4UTNFTzNMK1FyYUVI?=
 =?utf-8?B?OWhjTFp6cUpKWHVpc2NicFZ6Mk9YbU1SaGFtTndGT05WUXRLNHh2am1sSEsw?=
 =?utf-8?B?K2dESmhUZ28zVEV6bTRsNkE1bCtvZStXcFdVMFp0VUxnc3dFS2RpQlBFMkdi?=
 =?utf-8?B?NVd0c3kveU5EUEdOdHFmT1FnRjJqaE1uaUhHaFFhM1JoU2EyWGNiT3lHQUNO?=
 =?utf-8?B?Mk1TRUp2U0tXc2NKQkN3cnBIZ095d01MTGtGUTFycEd4S0VTZ2FCd090MEFQ?=
 =?utf-8?B?c0hhSzJxVGtmUFRTaDljVmVzOXRwYTJXWDg3a2t3anRPUnBPRzRNTHREZGxt?=
 =?utf-8?B?bnVNZXB1bG5Ha0ZRdVErT25Lc1Q5MUszQXhzMUNXU1dEblFUTHk4QT09?=
X-Exchange-RoutingPolicyChecked:
	WS4XzsxOWmVdvaawJpSd9Xp+SmfR+/haEJYr2NV2EPRmcS/uNzCzdKdQNs9fORJIkgxw0GaMuOjED9j1HqNZnvQXoTYo671GoZn+hEk7hd+wu/0GWcuVqgOx/KxCE6ATBWUOSY/hqOp1UvcAoMT9TSsrwXssJiloMh8kxXCK73R3hmomOvklxwTcSt4SZb0Yeg1joYft97XdY/YKprNVhkduoFQtEfR4f7VvPYzHRlalolg1/YEBxC7WvqpfWJh/cfykJ3kMu5+abKPRepfi1SZF8q0YX3qY58BwbWDxD5/c/DrM+j0YAoZ6PugvPLHapUcQ3KJESxQwML9OaEWXYA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jVAQiEgVDIPdpU+q07YB8taKiMO962SbFKxR9VlNboYuuri0/Q3pLS9Vd779/mJJwAMuczy7AMBS7W0zMwK5f6y37FzbDn1IlgrZviIg1ov73X7Z2msodyFz62uk4iPOYmgHpffxfkleYVGIBl/2+yHJBJ7K2lpCxpKCFcdY1GlKfVYxMQLLtaIZl6vFUPZRAnyyVdmwUNlLBYVYJLcDjSRKkI7OMZUPSvOwLZ/MNmXBz/dm6auwOV3aTcRmQp3rRQ+I77f4cCRqXQwkg4wH42YlAAiPfaqJKdJ9NH3rvbNRLdghVrtDo5cnz4NOU7ybV17EV3v3Zs1sxsH15h1RYELKH3z0/n8Mw7ca7D9tOlJjt7oKtHF/X0Aafsfnn0t8BX2B94WR397U3nWan+K+Wu/0RnI9Lr9BurYLSI8rJ5hrStxrQGHDttg9Ghgv6hYdvMQ163YFAkfGDMwx6cFJ/w+/gZRSp470cYB9MouSbU8712Vzt+ZwJ9TwsZZ8Ez+blAbKwVtpKCOt6VyE1SntmyKaUmArG2a6eOOV3NttqcT5/+gMuAG1HFagaDNXlA6/fLePNQ0HOwDaOSYRo7CSNOIF+4smEgSyE9/63fq4JUU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f649ab-bce6-4570-dea4-08de8b317c90
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 12:16:19.6301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pd4wtMz00M5s/fEane0CITi3m9gqnwj6kPCF74MngMvM4RIYiLMhiO+sKsCNCVSJ59wvW7BomYMS8+Bj9Wbqfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6397
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603260085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA4NSBTYWx0ZWRfX/S7aiDlVXmz5
 Uc9/gq/pwx1whiiBFEW+Eo06qYDyGCY7Ay3+TRibyTpXtXTKOQETT2vZCou4YhAflFEdFQTHDtd
 dxSvrCXWEd8xGja8P5CbPRvBEcMDN8ZinGtklJNrVkp18vDytt6ZAVj6yXeqOXpmzSiJ/54tXXW
 gfBk/E2lqOPQ2geit0LiJtfcGBWboZyAACM8bT1OzuXdwZj2H9cqwTL0q57Cbxpy2fo1yLDLATn
 ih9ejfTJ7X8k6G+DuM6XEL8tIokKi8qO/SusnaJKCbtGu8QDB7nQ+ex0bKf8KPDvPumDgptvWpj
 Jk075uC0slpEt3x/oAFStYJ3KzezJmL2Hzxt6BiPrEGLum2lv7y1WWKsANrHyLBU8YXTIEGTIVo
 xi/OCRTIYi5H69XoFbDgiTJ30RhWAPsFyEz7in2fZxqnuYYt45cKGX9ocmPyhtlZNEWV9HckYwU
 p5jKORjt1zpOj+9EzBn+rOZsugJwMEkUm84y6g7w=
X-Authority-Analysis: v=2.4 cv=AIvfpCdw c=1 sm=1 tr=0 ts=69c5239d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=fAlsz_Bi6W8l0rqB0TAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-ORIG-GUID: lqajx0ZMxcscIZWSglRcPDMfjBqjHBwh
X-Proofpoint-GUID: lqajx0ZMxcscIZWSglRcPDMfjBqjHBwh

On 26/03/2026 10:19, Hannes Reinecke wrote:
>> @@ -80,6 +80,7 @@ config SCSI_MULTIPATH
>>          bool "SCSI multipath support"
>>          depends on SCSI_MOD
>>          select LIBMULTIPATH
>> +       select SCSI_DH_ALUA
>>          help
>>            This option enables support for native SCSI multipath 
>> support for
>>            SCSI host.
>>
>> And that is even enough, as Kconfigs should only specify build 
>> requirements.
>>
>> We really should be also calling something like scsi_dh_attach() for 
>> scsi multipath to ensure that DH is attached (and running to update 
>> sdev->access_state).
>>
>> And I am not sure how the dh alua module is even autoloaded. I think 
>> that on my ubuntu machine the multipath-tools.service does it - 
>> something like this would not be nice for native SCSI multipath support.
>>
> Gnaa. But then we don't need this patchset at all.
> Main point was that we _do not_ need to hook into scsi dh for implicit
> ALUA.

But again I don't think that this is good enough. Native SCSI 
multipathing will read sdev->access_state to know ALUA state. We can't 
just rely on dh alua module running and doing what we need to know that 
this value is valid. AFAICS, dm mpath relies on dh alua module to even 
work at all:

device-mapper: table: 252:1: multipath: error attaching hardware
handler (-EINVAL)

At this point I am more inclined to just have a small SCSI core ALUA 
support for implicit ALUA, and allow scsi_dh_alua.c reuse functions from 
that but not use sdev->alua structure, like in this series - trying that 
is turning into a mess, I am finding.

Thanks,
John
