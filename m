Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794045061;
	b=E7mqOndPn9uzAOkHT5j93oukis0SU5dn4zeEX9dEwA3mM1Sed9dtD6x1vwurVoV4ol7h
	 Ohs4d7lkkOgEZiCdKvJtbBnw8y1jfAbTY9ipOGcojJYc60iLwFvn8rT7bDnHsFiJnsg6A
	 uALYBjfntnVxVICK9hMgYmTBtakW8Ys5iprLyrP3vBIUaYUnS3+HANq/dvu0VQxNy5xzk
	 l0EfPYoYVIv4AlU30yr+Hw69TeBEIOQIpoV+y076vFWrRabCR+pbaDsLQ4qZ2KakI3pMF
	 Er1KxAmXj5m543tzBJPYAVvIPEy8oFXhmMuPF/CLpyv8yYrkxJjptqTBnTZW0yP5K2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045061;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=KPUHtdYQMbFgzpItn4i2pnnQ+aZIVOWjRB9ku2hYfEY=;
	b=ateT3hY+BYkTgcDJ6Kbk+i/1fH7USMcITy27ule1Y9iHIUSkdGuInDUp261nhJxxxlGm
	 oAXpaauyCEAzuPMBACigcgopq+DrDOOG1qIclE1IFHJC42HpKxptH++9zi0YiPlIU7qak
	 62rbNoXslsMKfRvPVWsOXuMA7b0EqN6bkHshu7uQu0nftlVh4ykiyyOIzsZyDJPfOytOr
	 3+FSyfqeC2iuTLimlx8LnXdoyw76myhZDDP1mXHa9Nidf7vSHg5aciv2gA5U9uUZiLksI
	 cz958+2WmFVKLsyEDf/g0wr4e8viJEGGNy0BuWi6WuFGzBqN1AglpMZvuDM+vIxjeIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=mhCQUe24;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.14.68
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012068.outbound.protection.outlook.com [52.103.14.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE34606A338;
	Sat,  7 Nov 2026 09:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAE34606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=mhCQUe24
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNRrTvQ+IYjqTwvQS4KS+5GZDb9hzQgZvToEl5O41PPMC3yqz+b9k020d7GvVUk6gGfMIAuNGRQ3chb19U6nNI1zkqLVrfnIVn9lkEbBKmVfHRRFQOsEjnv8x8JqKSM00AL8f06CbnP1UGfvpU5Bwjm/gwZuiB9zkMQFCFC7PS7ZocEzlSSbInykHJ/5eNPmt3UOQ2OjJcUHQnzPALCZ73pHPyg6uQmKQTQViQI8ggY/lSpZ2mJZLyKuF5XTtQ/ZVIm0QpyghRMkU7jmmSUAOZo4Ns68Nb1OjVRwSAnVjMAGhI5D3R3HWmqkPvmGHRE5abF+PiXsLDOt6zd84Z/Cww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=KPUHtdYQMbFgzpItn4i2pnnQ+aZIVOWjRB9ku2hYfEY=;
 b=PyRUDNw5zwHE8Jppi/hmCph4acBscUHbarnlBnEyZ58QAo1Q945q81hzL5+vddIjyedZTfRL2VvzRN/eiLTXr9ApfNPI3pQDsjZpLlWtIoT01NCQmr3Lt+tGYb08dWs9CH7xdGno/3zRjuTpBnibWh0dIK2XxTShl+h8gaMgqfdF0ZMC9MDdCmIoyKvpR0h2z2UN5T5C6Fv6PLIVz4t9dLTPA2CQCB/L/ilquMt3+kqzQYZzhe5EUdZlwB6nmDhGcf+6lir/T2zbDqKbBLBRt/mNZyVyiSl8GvrgijswLlZfqopXJzOAmI/w7F3ShheR0Tdaap++1+CsT9NUsss4jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPUHtdYQMbFgzpItn4i2pnnQ+aZIVOWjRB9ku2hYfEY=;
 b=mhCQUe24FCSQ64tqZAGfTpNyGTJruhQZTF5JvPuu//BW7BPwSOo/+OJKA6mlltbSC48JgKQSL0Q9m7Hp7IPHH04EnhFKGR1EuUfdZ5pfJlP0ZCg5cunNap0ClA3ZnU0WvNkUL4HiIIu6ch0UOm+LmFNx94au4QfXkcRfzOHDHESOT7cwF5/RhmxuBEBg7t4OLEnRYY4Ztr6DPH2JRYRm4P9aIxBK/pR3Ud6Sg01GTcf+/0gMPtxKeLT6COo797JbPXFfkjuv/22q+eB7dWib5W1TuqEstNzNztSEDQS7y88mx0SqSkDm3bXi71x15zxQtFGKawwiYwZD1MepQUjShA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by SA6PR05MB10700.namprd05.prod.outlook.com
 (2603:10b6:806:409::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 09:50:28 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0592.010; Sat, 7 Nov 2026
 09:50:28 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "Martin K . Petersen" <mkp@kernel.org>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
CC: Yingjie Wang <x-professor@outlook.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, Yang
 Xiuwei <yangxiuwei@kylinos.cn>, James Houghton <jthoughton@google.com>, Pavel
 Begunkov <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 3/6] scsi: sr: release CDDA request before user
 copyback
Thread-Topic: [RFC PATCH v3 3/6] scsi: sr: release CDDA request before user
 copyback
Thread-Index: AQHdbp1q1vE6iu69ckey8hsQlBqtcA==
Date: Sat, 7 Nov 2026 09:50:26 +0000
Message-ID:
 <c0b34c0ac4c86c46814643413a5cad86bf30eb85.1794045010.git.x-professor@outlook.com>
References: <cover.1794045010.git.x-professor@outlook.com>
In-Reply-To: <cover.1794045010.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|SA6PR05MB10700:EE_
x-ms-office365-filtering-correlation-id: 06e84a63-b6e0-4cbf-c710-08df3cb48df3
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799015|19110799012|24021099003|41001999006|31061999003|22091999003|24121999003|15080799012|8062599012|38102599003|4140399003|25010399006|10035399007|12091999003|1602099012|40105399003|53005399003|102099032|3412199025|440099028|4302099013|26121999007|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?bSs0UTJ1UmRpK0lDMDBRTDJ5QkFqaHhyNFp5b3F5Qm1zUHI1Qk9kZVJZdVlW?=
 =?utf-8?B?VzhKbWVrRXVuN3Y0Z1NuTW1ZTStCZFc2Rm9KSE50WndEczkwVXJ6SFkvWHE4?=
 =?utf-8?B?TFhUazIrLzVBWnA4RHhvSjNsRXlkU3VYMXozbUF1WG1sZmYwbktBVlcvQVNv?=
 =?utf-8?B?SENxR0R1WlBNWUhJUUVHb05nN2FFQVpYQ0IxYzllaGFDRW9obkpqNUJXTkZn?=
 =?utf-8?B?djVZY1JSck1lZkQxWkVaVm9RdlNwR0ZHMGNuODgwSkxCcTh3ZUJEaWNBRkpY?=
 =?utf-8?B?ZC91VDlwYW5FM2NZd0xlalpuaFpKcFQ2WUxTTGVSZUhid2czaGVhL1hheVZN?=
 =?utf-8?B?SW16YXJ0dWJDYVlUclhUc2FTU3dHVUVUTGNQdVZzMThoS2o2VE9tUG9SMjk0?=
 =?utf-8?B?blRNWm1WaTdZenV2Tk1ZN05ITGJveUNwNUIxeGVSM0xlMVhFM0lsSVZQRjNY?=
 =?utf-8?B?QUszMU9KTEtMVGZBU3A0cGZLbGF3YldZSWNRYy9QUVd5Z0Y5ZTFVMVBLKzRh?=
 =?utf-8?B?bGY5VmpPZko4eXlQK0xXeXNnMVBOVWQ4NHVPb05KTkJzUWNlT0VRMk80VHJz?=
 =?utf-8?B?cTA5bDhaS0MwRnNuemVUQ2puclRya1F1L2Ewa3hiMjd5R3VhSWRxQlkxNUNV?=
 =?utf-8?B?M1BENFUyNk5iUFRrRnIvMzliaDBUTjNsWnppbzVVOW9RUUZmNm1vanJWZ00w?=
 =?utf-8?B?cTZlaVU3YysxK25aY0dIcHQwL3NuV0E5anBYNTRVZ2RoTVBTL1gyVmZsTjQ1?=
 =?utf-8?B?c0JCVDJvNmNVVXd3bjRPTWNvVjF4VlNKK2ZjQVMvN3U2L3dsZ2JwVWI1V0p2?=
 =?utf-8?B?R3dMT1k4TllWbm94dFdPTU4wZjJldFQ5bjIxcFVmN09GSzV2VHc2Ny9zUnJx?=
 =?utf-8?B?RWs4WStyQ3RVcUt3MW1TOU9iT01sU3pCUFI0b0dMTXR0TUVtWW5SMmtJSFN6?=
 =?utf-8?B?ek45cjJudlJoaGg5a2xjNDN6a0RrVHZueGphL0FiN201dmprK0tNZ3diK2lC?=
 =?utf-8?B?b2w3UndBaW83NWI3dm5HUFQ5NFBjTEw5WGs4QW4xR1o0SHZITDZyTmg2Zk1M?=
 =?utf-8?B?V1Q4Y0dJbm1HczVaNnNVNXFVYmMzYW1iaUFhVGtTM1ZQS1h3UlRCcEU4TGMx?=
 =?utf-8?B?R3dNNmZXWGx0c3NxRWN5VDZrMTN5azJQOUo5bUJxUTdWSXJSZlFuMUI1cG92?=
 =?utf-8?B?QzZ0OEhtaU53VTc5SHUyQ2J2U0puMFAvS2w1WDJ4WVloTkkzVmI1SlNXMlhx?=
 =?utf-8?B?SDJhNlltN1IzMmZGb1hRc2piTXJ1cnNFM0VCU3VsQStiYzVwNE1MMmsvalB3?=
 =?utf-8?B?bnBxMUxDT3Q3RGNDR2VHTkJOenhUcGtyY3ZZMm9mT3hnci9LcU53TndwaU40?=
 =?utf-8?B?U3BxT2RaOEh4S1JBY0Z4K0xveFdqZnhhcE5Sc3BENXMyQTI1OTBGZWtwTW5s?=
 =?utf-8?B?ZDJQcldERXJpdFRHWTJ1VU13TzQxM3J0amRIaVNtZW8wRVQ5MXB6T3NYVWxn?=
 =?utf-8?B?bDZuOHREallmZHpSWFlTd3pVOEw3WnlkZnI3QkVVNWtnelZCTVRrUTFpTUI1?=
 =?utf-8?Q?I9r9C2JASTKUCBDDqIaZJycXWiqCayE3oS8huuT3xG6Zex?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cS9NMzJYQUE4NWJiTnMrOWVWWWRGMWcyeFJCdXF0NEtGS2wwT1VoaGZZWW0y?=
 =?utf-8?B?dlVTQ3FIdzh4ak04TzRtR1VxTFkvaHVJdVRqbHdsNisxMndCeTBLbU5NaVZ4?=
 =?utf-8?B?WktpZ2ZFQzZ4aUNVUGZTbjc4ZllFMjZWUCt0SUFBc0dMN05IZ1d0c3lzTVJN?=
 =?utf-8?B?dDcxSlp3RVh3TTNJSW1kNy8xckdKUjFsSSsvcjJpMHlvem1UOFA4dXNSS3F2?=
 =?utf-8?B?UWFkbkFtbkFES2sxUWl2OHJYSTV3amNtSUcvWTlEU3BTeDg5WFN0UWlTNHMr?=
 =?utf-8?B?bXFtSEt4UHZTNlBoUzhvMWxiOUF6WEFMdTBxTUhYbjNlT3J1VW9LNEd6VTNm?=
 =?utf-8?B?eGZTNlFxRnZncU5WRW1HdDdNMHZkbG9OUUxDbFVzQk5CTXY0bGJsUHpaejUx?=
 =?utf-8?B?ZGhaOWZSMWtic1QrK1ZJNFRpRHZLeVdaN1lQeHljN0xtTmQ5MGJOYWdpK0E3?=
 =?utf-8?B?SytaVzV3VW5EeGVNNE12QU9Jc3dwdFBXV0FoZmhrL2dlV0NHZytJc2xXNU5U?=
 =?utf-8?B?clBHYUtWamxjVTVLejhSREVEc2ZyM3FRY3pxeEtZcll4UENQaXQ4QUxHLzlx?=
 =?utf-8?B?WlBRSXZWNHdwMGZFRDY5eUtKZ2RodEk5dXd5ejdhamtuaWZNaDRzQ25lTVRC?=
 =?utf-8?B?eDEyYWhDTEF3U2dlcno1dFc1dnlXeXF6YU1DdE0zZmdHb2c4VERVZWU0MjIx?=
 =?utf-8?B?cXdDQjk1Vi9uZEFSVDBtTGh2d0l4WWQvWUdoOEYwUzBpeG80QWZjNElOb2l0?=
 =?utf-8?B?UmpuZmFIdjJscUNVbHIxUGdERmkrYUtyK1ZLbTVOMWJ3TjdQU2JtWnEyMVAx?=
 =?utf-8?B?am5WNUVZWElzWUg1Sng0bEttY2MrRTlpRUJaaGQ2QS9ONWNkczNQbFg3Z29Z?=
 =?utf-8?B?YnZFSm82MHhqSHozM2tqUFJIVHZYbU1rbW1BNXBiR1NseEgzdWZMRUdaaXpp?=
 =?utf-8?B?cEVWQjV2ZEdud0NpV1lQSnlLTS8vQTdtOEJqbzk5SWoxUDl4cG5MSEovQzFj?=
 =?utf-8?B?aHZ5OTRaakoyVDBzTW0rRHA5SGFsNW9odTB3WjN0RlVzUGE5aEI2S0R4MTFi?=
 =?utf-8?B?RytVWjNiM0pkY3N6UlhNMFljQVdheTV0RVAzdm5sQ1VFTWpjRWpINDRzMzAz?=
 =?utf-8?B?VzRSck83a0dTS1ljM0txejJ0UisreWQ0dmJib05kMVZyc0h1eWNpbE1JYlJk?=
 =?utf-8?B?SGFJTERHZEJXeUQ3aUpza1ladE1HSThiTGFJbDF5MFU0RFcyL24yS2ttYjVU?=
 =?utf-8?B?TnlBNmVlMXRsWUluVlFKcHMzQWRIU1hqeEp4UUhvcXcvSkF0N3l1OUZwemlK?=
 =?utf-8?B?SFFYVkh2enhFcERUOGtIT0gyS1RVM2czdFQxMG8yeWpmWmI3dWF0V1F0U3VM?=
 =?utf-8?B?eUJ4ZWl2VmFCYjc3S2xQUTZyelM3OFcrSFpuTlhiV09WMDNKYmVFVkhTVE4z?=
 =?utf-8?B?NWJ0TFRyNzEyMmRPUFdmb0RENWhrODdWQWM4WWF2YVg3YXEyL0pGaXBVOVVa?=
 =?utf-8?B?RU1GMVBwOVIxZWU4S2VUWDIyYU4vQ1VCQnl6TDNmWnh2cWJKejdWa09tMmMx?=
 =?utf-8?B?TkRKbGJvZ0JQVlQ0czFBTmFEdi90NElWNzVvOUF4WjZBaHBxMzA3VkdjWFk5?=
 =?utf-8?B?WmdWVkNFSzFNTGZKUUJ1WS9PZjZSWHYzRzl0b25naGlkYmdZbnh6YU1uQXRI?=
 =?utf-8?B?QmM3eDdwbktpRjZKVVdEcndmeEVPd2t6OVh1UTIreklQaG9ucEFhalZMcXdJ?=
 =?utf-8?B?elQrWEowRHVKRXdSbnUyV1M1M1RuK2V3L3A0VWo1ZU1VMUMva0N0cXM3N2sx?=
 =?utf-8?B?STF5ZUx6QXFpZGtuQmozTmllaUpJdzlZdWpmek1aNDZCTkxONkpaR1FMME9O?=
 =?utf-8?Q?D4p5h0Z+1VnBj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e84a63-b6e0-4cbf-c710-08df3cb48df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2026 09:50:26.5348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR05MB10700

RnJvbTogWWluZ2ppZSBXYW5nIDx4LXByb2Zlc3NvckBvdXRsb29rLmNvbT4KCnNyX3JlYWRfY2Rk
YV9icGMoKSByZXRhaW5zIGl0cyBjb21wbGV0ZWQgcmVxdWVzdCB3aGlsZSB1bm1hcHBpbmcgdGhl
IHVzZXIKYnVmZmVyLiBGb3IgYSBib3VuY2VkIGRhdGEtaW4gbWFwcGluZywgdW5tYXBwaW5nIGNh
biBjb3B5IHRvIHVzZXJzcGFjZQphbmQgZmF1bHQuIEEgZmF1bHQgdGhhdCBuZWVkcyBJL08gZnJv
bSB0aGUgc2FtZSBxdWV1ZSBjYW5ub3QgcHJvZ3Jlc3MgaWYKdGhlIGNvbXBsZXRlZCByZXF1ZXN0
IHJldGFpbnMgdGhlIGF2YWlsYWJsZSB0YWcuCgpSZWxlYXNlIHRoZSByZXF1ZXN0IGFmdGVyIGNv
bnN1bWluZyBpdHMgY29tbWFuZCByZXN1bHQgYW5kIHNlbnNlIGRhdGEsCmJlZm9yZSB1bm1hcHBp
bmcgdGhlIG9yaWdpbmFsIEJJTyBjaGFpbiBzYXZlZCBhdCBzdWJtaXNzaW9uLiBObyByZXF1ZXN0
Cm9yIFNDU0kgY29tbWFuZCBmaWVsZCBpcyBhY2Nlc3NlZCBhZnRlciB0aGUgcmVsZWFzZS4gVGhl
IG1hcHBpbmcncyBCSU8KcmVmZXJlbmNlcyByZW1haW4gb3duZWQgYnkgYmxrX3JxX3VubWFwX3Vz
ZXIoKS4KClRoZSBzY3NpLW1xIHJlcXVlc3QgcG9vbCBpbnRyb2R1Y2VkIHRoaXMgdGFnIGRlcGVu
ZGVuY3kuIFRoZSBsYXRlciBtb3ZlCm9mIHRoZSBDRERBIGltcGxlbWVudGF0aW9uIGZyb20gZHJp
dmVycy9jZHJvbSBpbnRvIHNyIHdhcyBhIHJlbG9jYXRpb24uCgpGaXhlczogZDI4NTIwM2NmNjQ3
ICgic2NzaTogYWRkIHN1cHBvcnQgZm9yIGEgYmxrLW1xIGJhc2VkIEkvTyBwYXRoLiIpCkxpbms6
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyNjEwMjIuc2NzaS1jZGRhLWxpZmV0aW1lLjhm
MzFhMmM5N2I0MkBvdXRsb29rLmNvbQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQt
b2ZmLWJ5OiBZaW5namllIFdhbmcgPHgtcHJvZmVzc29yQG91dGxvb2suY29tPgotLS0KIGRyaXZl
cnMvc2NzaS9zci5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc3IuYyBiL2RyaXZlcnMvc2NzaS9zci5jCmluZGV4IDRm
MmU4ZDFiZTZkYS4uYzY0YzI1ZTlmNDA0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc3IuYwor
KysgYi9kcml2ZXJzL3Njc2kvc3IuYwpAQCAtOTY5LDggKzk2OSwxMSBAQCBzdGF0aWMgaW50IHNy
X3JlYWRfY2RkYV9icGMoc3RydWN0IGNkcm9tX2RldmljZV9pbmZvICpjZGksIHZvaWQgX191c2Vy
ICp1YnVmLAogCQlyZXQgPSAtRUlPOwogCX0KIAorCWJsa19tcV9mcmVlX3JlcXVlc3QocnEpOwog
CWlmIChibGtfcnFfdW5tYXBfdXNlcihiaW8pKQogCQlyZXQgPSAtRUZBVUxUOworCXJldHVybiBy
ZXQ7CisKIG91dF9wdXRfcmVxdWVzdDoKIAlibGtfbXFfZnJlZV9yZXF1ZXN0KHJxKTsKIAlyZXR1
cm4gcmV0OwotLSAKMi40My4wCgo=
