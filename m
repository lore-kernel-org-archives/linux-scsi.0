Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DE8425CE2;
	Mon,  2 Mar 2026 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467071; cv=fail; b=Y4gvMBv+cNAb39JtLkFMRRvcoE2ekOhwMCcPop0QscsSZmeZfouLUQudeRQfTQ5LA9uVN+alwvMS6NpbPj52qEU7006JBJUgZAaj01bqPh9RmMgiidkaEN49B5wvut5m9FRwnBqRWlwXJD6JgIUGC1y+mv2Ad9f2Kx7VJcKg2Ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467071; c=relaxed/simple;
	bh=70IOadzwAH03f435EHwpc/Rh7Lxd/iD96jOr1G/UU/w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bO7cLUqKnz+xDQFPJgK4UL53IYX6d+hVRZe52gjaV8gO27HNN+6TWJNnfqImfAarbOmHqwkOynbcRTWxtj2UQ9GpKlaC9SNSCEg1wN9JMPutLo8a/urRHV1jdaXN0EPrNoff51CGZLU9Vie2JjMimShPJdErB4M1HH0nJp20tUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rgzeaOQ4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Hq/7iKp6; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rgzeaOQ4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Hq/7iKp6"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622EQhJ31326635;
	Mon, 2 Mar 2026 15:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YrFuyYBQEoqvbczGfN9OHX5EWFR0rZz8PthunaYmquI=; b=
	rgzeaOQ49lSW4kumuLjJI8fEr/rnISeZWo9KoOGCah3zStKELlxdFX2yDc6LWhk7
	KikxJGNl2TGik43yEAXIdrEF28Y+ymsmgDg9V8VpbiafzzJN/M5Jq9qMhiBVzc/8
	KA0gQmFhRCz6bN2zqivMdyYvAmppI+g/StsQCZHgQ42QUWmmUQbK3dvDgxSTyM/B
	W0e9xp8kk4uBNrh2R1e9N86Xwq89rE4ABdJKEBYHJD1c4/yoyiloU3ZCLXqIxg8h
	TBMc6f6qAn2ONma/KPobtakby9zZYFAA45pVEFKt7QhmxuwGm6N8jaIu432rGb+N
	tjtcH05jvAA8HWO4WUS2Ow==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnbw307j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:57:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622F9dpC036969;
	Mon, 2 Mar 2026 15:57:32 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8ugvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:57:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QeXDC51fi6nG/zdIbKPhLZxiC+6fUhntEQ2ngFP/76+A1Wp9JgVxwPMtnCJKdN+N3UxmpLy4ICLapGCqL9L5C+1+c+Vtx6B0RMq/w1a26vdfw0EqObcI7pcs7D+uJPIDhdECDh1wof8S6Lm7tx2hFbXsjzMyIr9XLyBX36wG5H3vGC0pWqU/jWR7MYPx024B7nyJggTuc2W8bJvNBSLC6vDLNUnzk92i9gOPdZuW9HPLrrsRpmOdLT+TH1fhu2ePQNgHgv+XNuy1vW8z49DqvQVP1EKrrspk5f4uElxkYLAVXbW2UvAjH/8ZZ1xU2/sumyTieicihtTZF57q+r3KBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrFuyYBQEoqvbczGfN9OHX5EWFR0rZz8PthunaYmquI=;
 b=cK3D1YfTtyTGu6bzjpoNvNDEMlcnzP3IsxnrQrmYF9jTI6VK7hufrmkun3RjL/Gd068y/IurSnhkfTPxk7WCVL+3Tm43+RjY25RHVO5OEGEbzEliA/a4XOvfA8F/dS47wiidQAZ9cJDtR0wUrRNAkgI9YCH1yQSlfuO2p0Sqdbuxe8XoAXn0OHPodj7+eJpxcAXC/jU1E9EkTADQDRhcv9DnoqGtZXBqmEsPtFjvz1dd/lLWQejuAapObDlVBbKVj/e383dqfHj9tkhIVlORUZ7YgAOx9vjpBQJveXJzwsr0ER7JRfHd//h0MjqBvIsIh9ie3H47SVDMHxmgtVoG9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrFuyYBQEoqvbczGfN9OHX5EWFR0rZz8PthunaYmquI=;
 b=Hq/7iKp6+ICA0rT+0bQrXH44zanqKFu1EDCWJb9k8isCh/x6CED226IZ3h21T3fyxrlLZaUBvDWYMCWK8SDngLSUrRJ7+h9fP8j4g82znKgntSMiVN6RxOmN5dH/H0qbhYhOLAIpWGJfNmc81YnD+ICM8JzzPgSXtCMAuTFMc0A=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by DS4PPF0D6E81A30.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d07) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Mon, 2 Mar
 2026 15:57:27 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%4]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:57:27 +0000
Message-ID: <452aa2fa-fceb-419e-8276-0fa6cd7229b3@oracle.com>
Date: Mon, 2 Mar 2026 15:57:16 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/19] nvme: introduce a namespace count in the ns head
 structure
To: Nilay Shroff <nilay@linux.ibm.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
 <20260225154007.1033735-3-john.g.garry@oracle.com>
 <e4ac58e4-c649-44a9-a6c3-3d027834c464@linux.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e4ac58e4-c649-44a9-a6c3-3d027834c464@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DX0P273CA0054.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:5a::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|DS4PPF0D6E81A30:EE_
X-MS-Office365-Filtering-Correlation-Id: f076850c-1ea8-4816-8766-08de787466ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	RrD7d6Vd4Y8J38GiWYZPXj8B4WHjM+QrRVkBzu1zo6C2v0I5V9nkbx7wnva+Y9H+vyLQdQ22GQsfRhT0KBYyj9+6WBZV9ecjZ9wxgjF6i5D7lFjnhvhfJQX7Cbv/fwuZuQs22toEyM6olRjOP0U71xFhB2weQVOSFXxRzSJM6B7azIPJtEXoFqtZDWHbKY52goiTMuE7YSqokKBJV87c6XWhaBbs9Lv+R29m1jDEjLXxT1lkjILSN9xVzPrC1IOyH+dprZWgmytb4wciajOc/9LkwUHhXHf+EWCPFNDFa6RbGaZ4t9CbGQPRBaJm9XCLGYpvH6pAQ8Bbx7xGgkwnFbReSXF5MWv95UPqG0w51NUxQFovkan4iv+rowbHMLI4xMlbp36C6EQsqtjzu4xvR9lPlVsMscLmWOYZ1m5WLp2g0DwSNyD4Lf9M+7bed5S78/9iEvzlieTj8XhfXmUA6f9St4w92ZcjewTkT1iDSea64We3e985tZbyXxYPIBerXTyqlt6772dAjRP8TraGJy9Ey9mto39NSexD0XI3p/5IT/I0y4gEP1SJkeuxSv9KN5rRpiOLQuSB8NrKJolsFLsIStEj2eYyOZst+r/QAJwCeTJwJ5pZO9jvu8SIlceNlJ0LZQhpeFT5yaZTy8PW3N+Rw0x66QXztHh/+i0/xnkcJzoC1LvC0JIWrOxcnHdJizfAbkhK9Eev4TyhQyvLbbbZtgFQQST6xmPNjfvvvVs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGJ1a2t4MHQwQlhuVUhXVUpJYU8xbzVpVnZ1UDZ5dDlpN3E1MC80TjhYYU5T?=
 =?utf-8?B?dHI2ZnNuSWpUbkgyclg4VTVtL0wxaDk5YU5NMVNhRmV1amo1VDhjZXYrMnNp?=
 =?utf-8?B?dk13K2NnRU1XMURKdWdTTFBYUWNDMUdmU2ZFZHExTzhJMWc3OXc1ZDBlTDRS?=
 =?utf-8?B?M25yMXNTYzVFUWp5L1lETmZENUN2ZFRKQVpENVFmMlY2N2RLaEp3OTVvNkRR?=
 =?utf-8?B?UGhpMjRacGVZYUlRczI3cXlGUENDb3VaUHdtRFFKaDBxZnBHZjVKME9xTG1E?=
 =?utf-8?B?RDh0V1VyMURla1hPa0NlVHRhTDBJOEV3eEpCSE1rUEprOW5MbW1jYXpRc3cy?=
 =?utf-8?B?SVhNY0hNRC8vcWNFSU9EYnJTT2pVWS85bS92R1o4MW44WlBIaGFEKzg1MUEr?=
 =?utf-8?B?cFZRY29GT0hGVW02ZjE1endqMzJ1WjVQRnVvTllXZUphd2FWSytEVnpxTnZT?=
 =?utf-8?B?SC85VHNVSXZtVUJyYTN1NzliUnQyaGJkM1dRRFdFWDViOXVBSVB6VGFkTXBF?=
 =?utf-8?B?cjdFemxYY2VMS2VONHZoNmx6WmF3emNHT2JoQUpXZzNsNUkxQ3ZyWHVmUWZv?=
 =?utf-8?B?bUZZS3l6UXRnVmZ6UTl3dXovdmtpTmlLTWUyclBETjY2b0poNGRQcElYQXVV?=
 =?utf-8?B?aW43UU5PY25RNUVkVk9LeFlnN3pyc1ZZbjNWSXE0WlVET295QVhOcjE2Rk9s?=
 =?utf-8?B?VlkzV2RqOGtaS1B4aFlDQTQrSkF2WTVaZUFtc0VmMFNxWlRVRUdseUpZdUZ5?=
 =?utf-8?B?bmNXaFh6bUMxcU13SjhBd2xpQjl4cFFvZ0dpYzcxNVhJUXl1Qmp3ZFRRZEtH?=
 =?utf-8?B?a1orUE1VY0hsaGlZTzVDNzdhWDRScWthaXdyYnhwQjZaT0ZXZDY0bTFtdmpF?=
 =?utf-8?B?Z254Zk5QTys3L2p2ZTQ4eiswMHhXUzNnekNpbmczYjAvMWJqOEI4eFJiSG9s?=
 =?utf-8?B?Tkk4VlBJcURNa25BUW9xREVKRGhFVldTQmk2U3ZwQkZINHg5bnJ1ZEN1TDFV?=
 =?utf-8?B?aXl4Y1Zac09hczlWdnd5a2RJeUpaNUpnZ2xBdDhoYzh6am1wdW9ZTGdpendS?=
 =?utf-8?B?b041VHd6c1Ftc3NzNkpaSzBGemZYTSsvL1dtWDVvM1p3TnZ0dmNFV0cvaUFw?=
 =?utf-8?B?QWdQLzRFdHlvdnZHdGZhQVdQUnRVL3JoTEQzMHo3UUpiZzlldHhFcmNQeFlH?=
 =?utf-8?B?aXNpSjM1TXZKU0hrNmVzZXF1aFBIYTZwY2N4b3NVOGl5S0NjeFp1K21YMktO?=
 =?utf-8?B?M2lRRHpWK2RRWFV2VUJIcDloZ1dBTzh5N040N2Z4cUxrMXhMeWltNG9qV2lO?=
 =?utf-8?B?TW9nQ3Jaa2RCL2VmM2RUWWxEaFFYRzIrRUhSMHpwWTE0Y25QZzRGU1gyQU8r?=
 =?utf-8?B?aEN5dzNNMEhnQUZpcFFDZjZoeVh5dGFSd1VWODkrbzFia2xFUmQ0aGduaVBn?=
 =?utf-8?B?cFI2UklybGhWbDE4bVJ4a0JISVhqRklzTmxNOWRRTGtRS0N6bkVPNDMvU1hu?=
 =?utf-8?B?VG4yb2ZRK2d2RzJwM0lnVnZMNWJEM0xqeHp2enVqSlpJME5QVTcxNVhBV3R6?=
 =?utf-8?B?TFAra0s3QmppeWJKTHo0Z21pZXRRU0tPbXkzNi9FRzF1VXhNZ1gvdmpPS1Bw?=
 =?utf-8?B?Q21DWkZaUTBGa3FaeGFwMG9teG04RTcwMFZnT3RDOTVzNUxkSVhGV0xnb05E?=
 =?utf-8?B?Z1pSQm1EL0RIVWo1N3d1dFRPeFdqODBnT2Mvbm4zTmcwQkllNGdtWk9ZbGlJ?=
 =?utf-8?B?VE1JVGFVcnJTUGZpY0dRNEVBSTZBekVxeis0QTJZNG96ZUFJNXc0eXRYWUJL?=
 =?utf-8?B?bzA2dXpqcTBSd2pEVXJUcEFSa3NpVTZFQlZxbkNSWkZYU2xmZzJNd1NYenRG?=
 =?utf-8?B?UWJIT2FmK1pVcjgybE9lclJkWFlCQW52TDZzT21XK2hSdUdYMUc1dnl1cWd2?=
 =?utf-8?B?K2VzSTdZelMvWERnK2FhNk9PdTQzb2FWVjVRNjFHU0l6eUNlRlpialJEUHdZ?=
 =?utf-8?B?YU05Rm9YcmF4OW5qZmFJd0xYM2VYRDd2QXVpb3ZGOW1aZ3NZY3ZZZEw0SEU3?=
 =?utf-8?B?NFF6cDdxeDBzRXVkUDFIaFF3cGdnS1BXZk1LcnFZNUtsbjFUVHZDUVNsdXJ3?=
 =?utf-8?B?eFliN3FjMWpjRjFudnFJYmMzKzFjUUl6ZXdtN2IrWVN0Yy8zUDBZVlV1ZThw?=
 =?utf-8?B?VFNzOEpkTzF5WnllQTlGaWFLalprR0lIdkVDbkxBNG1DNG5tczdvNG5BVVhs?=
 =?utf-8?B?VWdOemVJOGJFcDhsdHBucTMxYUxDOWRxbGM1MC8wVXdVekp0ZmZLY1o4SDY3?=
 =?utf-8?B?aldMSklhVU5ET0s4WEhwcTRvSFNqSjFRZnlWdXlDdGxVRHl4SXUrMmZ3OWpu?=
 =?utf-8?Q?U80GX1gdxktYya7k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iW6dcdOzHKpsWLF/sjCPGjy3C88z/ysNy5o1mmd+cO6S51fJbIeGyzYoyUCBD9z3H7qmITyqthuC3Ey9k2POJskVDinihWy1nXVM1IClK6e3paGAaR270DwJM2c0l4DF7Wwd7TXK8ultzNhUpi78nolw44X81HLuZmbkU0O1dJ5jg9jw4W3+dQ6lt1/9ibTaLH7Ja33wIXVrlLRYCSPhQ6CBesnDp+bnWw2ukDX6EvyBgG8Te7cjp1CGmaCt90VBRQ8cHnfLEWT1pRmGgr2U8VR7b/J5ICcwUHpJPQxjERTZEsEfdEsJlWIn5lESrB65+t42/OxMZQS/2VktFN46WWm1uHzBtqQWXgUzZiwWz0eBobq4onugSm7SG2zmiRcw23WkwSjK6u2axZcgo1Kt/gNdVzDDPdiVDy6QVzNST0jE8zF/YC4WPUhZV2tEU7cPj+P90sZfHCu5NYSGyEL83ID8rWYNOTiQz8wugRDXAn/WFkBMx3bgONaGP3BkY1SXt3+EFbzxq7hCDdXWB3yIvXBlrluzQsaoYnWdbG6U/EEp+vyndguzjQBev0ZKJcJAD+iY//L1DlWPWTN4oEqVR07vmNr7FCFl6VFNJZ3OFdY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f076850c-1ea8-4816-8766-08de787466ec
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:57:27.5430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ngiCLam1nZq72HBdzSMVLhvh83BqvPF8i3B6l+gT9enlhqFYA0zoGPppB1NlZSkVx7/GvGxbtnhGo7EyS8cMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0D6E81A30
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfX2/nqRZwIexfY
 9Ykv806fd4LUf+CqEO8EDXqhcC0iEbUynb2556wlwqijo2+TjjhPW25rRLDdUY20ZTA60aSu4HS
 C/QiuRC56t97aq7m9uvGfCW6Lycj0ZVsrobb/mjGUf0CjpqX2DGzqWBdmlVfSDXqOdc593GYSeI
 3yoFMAsOVCdeCO0MgqdmeEiqmtp+Hzc2ihH/1JIp/yZXnAcEJL9Dc/0e/6rplDwVndiWPbJ4Nc6
 cKg26fSyE2IJJWo8O4Blma+qe2IKeEM5aRACkDR9argCgDxAE17rCY/7IIqWdBfsTKFSTBJq8yv
 V9lNDM580g+1rXie6QRAfMBhkB+h6EQXwFTnEQtA9TYp0ayT/HPQOY+FfJTAZWqAxCSiibzyBAY
 UrZAXGkH9huTC4g1l+9+eX8v4aAvbyhwoNMWuZGEgUTyx+yzbiqMGK+229zLEaESGtSfZ0qtNVu
 zGkLOLZLiHz/G0b1u1Q==
X-Proofpoint-GUID: PUtUVtyUl7tt2nXY6i_GvPQkSTnRFvxZ
X-Proofpoint-ORIG-GUID: PUtUVtyUl7tt2nXY6i_GvPQkSTnRFvxZ
X-Authority-Analysis: v=2.4 cv=DcMaa/tW c=1 sm=1 tr=0 ts=69a5b36d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=G8kdOzr9GyBP_5pLsSsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 02/03/2026 12:46, Nilay Shroff wrote:
>>
>> Signed-off-by: John Garry<john.g.garry@oracle.com>
>> ---
>>   drivers/nvme/host/core.c      | 10 +++++++---
>>   drivers/nvme/host/multipath.c |  4 ++--
>>   drivers/nvme/host/nvme.h      |  1 +
>>   3 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index 37e30caff4149..76249871dd7c2 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -4024,7 +4024,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, 
>> struct nvme_ns_info *info)
>>       } else {
>>           ret = -EINVAL;
>>           if ((!info->is_shared || !head->shared) &&
>> -            !list_empty(&head->list)) {
>> +            head->ns_count) {
>>               dev_err(ctrl->device,
>>                   "Duplicate unshared namespace %d\n",
>>                   info->nsid);
>> @@ -4047,6 +4047,7 @@ static int nvme_init_ns_head(struct nvme_ns *ns, 
>> struct nvme_ns_info *info)
>>       }
>>       list_add_tail_rcu(&ns->siblings, &head->list);
>> +    head->ns_count++;
>>       ns->head = head;
>>       mutex_unlock(&ctrl->subsys->lock);
> 
> I think we could still access head->mpath_disk->mpath_head->dev_list.
> So in that case do we really need to have ->ns_count? 

As mentioned, if CONFIG_NVME_MULTIPATH is disabled, mpath_head->dev_list 
is not maintained. So we need another method to set NS count in the core 
code.

> Moreover, if
> we could maintain a pointer to struct mpath_head from struct 
> nvme_ns_head then we may avoid one dereference. What do you think?

I think that it should be ok. I was just trying to reduce pointer 
declaration (as they need to be maintained).

Thanks!
