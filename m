Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.83.69
ARC-Seal: i=3; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795004538;
	b=PyPDR3CeeSudF8IHa5a4zdf4JlmPVoxDZc46eUPZ3WLw3SkKuqS5bGsV+OrMIDhBiRrg
	 ADqzbQXA9BZuyXpXBpvBGgliErYk+E3PbG0aPvBaHW6GlasbHRG3pILpNCYJnQwjSJDWM
	 b3TvXL20Tvz8ZGsMwlDT4m7fFmdtughfpAad+xaA8Eu7W+HABggxY+Kl+hJDpBha2oq81
	 yhkAL0BFXHTa1cSY8SBFYqiMmhdscTZFwBdSttb9FWzzdBHzvaBhgOqm5cd7NQ84y/Jco
	 eepPW5/s86lYHt3HzXuvWyCuAlh26ZDOS3iCsjFwAyIzho28tn7vJNuw3xYtwFCWNJg==
ARC-Message-Signature: i=3; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795004538;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:
	 DKIM-Signature:Authentication-Results-Original:Received:Received:
	 Message-ID:Date:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:x-checkrecipientrouted:
	 NoDisclaimer:X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam-Untrusted:
	 X-Microsoft-Antispam-Message-Info-Original:
	 X-Forefront-Antispam-Report-Untrusted:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-EOPAttributedMessage:
	 X-MS-Exchange-Transport-CrossTenantHeadersStripped:
	 X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id-Prvs:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=sYQq/zYN9D9LNXH8TncznJDA/bK3hixO057UCHLVRGM=;
	b=OeRg7ZkFAPAgmkmlouI0G2ro4EYeUzsEMwL1a2WDy9DmXIv2N8eazkrF797Kz7q/SM8H
	 FyCrAZuNbEcuqsm15fsxhLnaBHrEwVt0zmWNtqcsU9yQxgsCRqdjLKj/NHQgNkDtnz8eF
	 Nxy/pgzTHj0H9Rly1jNt9xNcvYUTsNTYswiKvK5jAlHf0sc9ufdhrLq061p8QJlF1lAgo
	 3DXV38rMLBwEn0IJIBBLVvvVe19aVJ+0EfUAfab7VssBZ6UPBeCnyzYAhlaVEQRBI5Kw6
	 WC9LzQXo+EAmVf4yMJC+CQE+qSHNBU4+Aj+WqmsdThUQ30PXTbCoLjrx5uoOc7dpyhw==
ARC-Authentication-Results: i=3; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=bYMHEcgS;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=bYMHEcgS;
	arc=pass header.oldest-pass=2 smtp.remote-ip=52.101.83.69
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013069.outbound.protection.outlook.com [52.101.83.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2170A606A320;
	Wed, 18 Nov 2026 12:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2170A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=bYMHEcgS;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=selector1 header.b=bYMHEcgS
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=O6Ge3lk6CyQNQV31OvOp1M9fwrdZs5Wtf2PJ+8D3TVm7PrRC0RS9y043LvI6pzMk6dl2uyfEpOIbyt4Eeoetzx4+0UK9iNPGAoF2n97fUvq5Hz8cDNM1Bj60QETQfD9QreAg5dqmS6lc11By2v5JWG1cIwwfzK6gWfXs2bFjEhkjP7Sf+h2OczhUtUHt8m803dmRDEe/pZZEXRZ9ij5bBChldnTkSctQ7/CzrjE6pnh3jmeUxpVUeZ094/KQArv/kIDSWXhysf9e5GXCvWWuS+JzFoSnVK77ZbwV3VQ5CKQBeelqYq+7WsmR1HhDZ6gA6reCIRJIMANZF7pbtozgnw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYQq/zYN9D9LNXH8TncznJDA/bK3hixO057UCHLVRGM=;
 b=vCba+eKU0skw6pBcQZflokf6PaVyp0Vj5xuu5gaI2poaRl6+0N7O84HZ7U1U22B7OaHwwCYrAeH2pvklVb+FFp7vkgC8cVuPick8W4s9NuG5QbK5QDP0t498oVkdZYnjSkNg1NhLXwcneDJDTHlcLDShneROF4DJYUf3Q7Pgsb+/scR4qQEVYH0HuasixEUm77aQ/MB8mEEEpa/VaTHdbTc9zhAKX3HIgfJDjDQIazXibAB3x8uuyR77WdwJIvjDWGFeqKEUUQuTJLAc8eotn53uJFRKTkAgL2ikCzBZtUqUmuKKp8WK87dnTaA+NAkuu1isP4c7eok3XXcZC1BZEw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYQq/zYN9D9LNXH8TncznJDA/bK3hixO057UCHLVRGM=;
 b=bYMHEcgSvWDhLHgqE8DMaLDTjwtMpRzL++zW8KLc6KAyMqyqCexNoF3RdXO9Ch8pbAcz0xXfTyOv6yVmJpO08VOpsfrd7W8nRTZHtcw305tnWdizFR4Lm2vP3NzB1w96Qf3Hcmp9DgtHphfwruiN5FdfobhX0f8UuKSWjpDxWA4=
Received: from DUZPR01CA0188.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::27) by PAXPR08MB7335.eurprd08.prod.outlook.com
 (2603:10a6:102:220::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 12:22:13 +0000
Received: from DB1PEPF000509F2.eurprd02.prod.outlook.com
 (2603:10a6:10:4b6:cafe::8d) by DUZPR01CA0188.outlook.office365.com
 (2603:10a6:10:4b6::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Wed,
 18 Nov 2026 12:22:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F2.mail.protection.outlook.com (10.167.242.148) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Wed, 18 Nov 2026 12:22:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1UogV+tEPFi6hCB8EF1IeUk18PFkX5OY6SiQ2iSpSvAkC67TcL7DKw+tv5iR6k888k3aVrZC60o4UaBzFbzTszwgDtay4958ZAWGKEpKA0uek5aNIIaD7a4XRRu5I69+QXRfmuTdBd6AS+FJ/nzrQCUQiRM/k34VR8d/GYck314SDYf32wWumzVPsaZ+Vuiz28dVnn54rif9tMC+8Yu6Xb1UtAvv+pdlH/ehk4vNu9YZLM0UzFhECkfdPfOC1YO66M6U3I5KgGQjldzU5E7klQ+Hpqpy+mWmUs5UuTxcyFm35HjgGa9yXDO3ltyERCF4VtnqW9oF1wcXJ53cHkRNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYQq/zYN9D9LNXH8TncznJDA/bK3hixO057UCHLVRGM=;
 b=vGaMpLwsm7cN2awRXWlz+X1NYa++Z7+AmDbqwYCzQOB45c3IvWtQdltKq/As1g8zNnowhwLvhL3N1tEKGwyarkEQfrYk4anfCYsbOKSIDvXuqcpDZQiE3H8ua4n/PKO799zqTEFGa1i/SIiqq6Zvzo+pr4mmwcebvXEa0dyQiZm8euF1JK/sAHpfktY2Bxvrv/QLhAlp2LOnWWvIYkVtc0skDS8EAD/hes1EDYoVUGBsY2cTrMoENweNtVniIJeqmUZuoe5i/OqrHAgQzNwcCpaxwcq9RSsebGmW3iNSbM/foWjzErNxZ9es4BUkZqLHZCeX6iPrAdquPFi0z6JABA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYQq/zYN9D9LNXH8TncznJDA/bK3hixO057UCHLVRGM=;
 b=bYMHEcgSvWDhLHgqE8DMaLDTjwtMpRzL++zW8KLc6KAyMqyqCexNoF3RdXO9Ch8pbAcz0xXfTyOv6yVmJpO08VOpsfrd7W8nRTZHtcw305tnWdizFR4Lm2vP3NzB1w96Qf3Hcmp9DgtHphfwruiN5FdfobhX0f8UuKSWjpDxWA4=
Authentication-Results-Original: mx.microsoft.com 1; dkim=none (message not
 signed) header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15) by AS8PR08MB8660.eurprd08.prod.outlook.com
 (2603:10a6:20b:562::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 12:21:38 +0000
Received: from AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c]) by AS8PR08MB10291.eurprd08.prod.outlook.com
 ([fe80::9f01:508:17aa:279c%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 12:21:38 +0000
Message-ID: <082abd33-4e9e-4b7f-9640-4930a302c998@arm.com>
Date: Wed, 18 Nov 2026 13:21:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] overflow: Add offsetofend() variant of
 struct_offset()
To: sashiko-reviews@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-scsi@vger.kernel.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sound@vger.kernel.org,
 media-ci@linuxtv.org
References: <20261118-offsetof-v4-0-95b385c10b22@arm.com>
 <20261118-offsetof-v4-1-95b385c10b22@arm.com>
 <sashiko-outbox-220875@kernel.org>
Content-Language: en-US
From: =?UTF-8?B?QmVuY2UgQ3PDs2vDoXM=?= <bence.csokas@arm.com>
In-Reply-To: <sashiko-outbox-220875@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0327.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::10) To AS8PR08MB10291.eurprd08.prod.outlook.com
 (2603:10a6:20b:629::15)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS8PR08MB10291:EE_|AS8PR08MB8660:EE_|DB1PEPF000509F2:EE_|PAXPR08MB7335:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cba0086-011d-4f6c-fc98-08df456e9384
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|261028144727099003|10067099003|56012099006|4143699003|11063799006|261021121427099003|261022105027099003|261026140227099003|261026121527099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 KNexZoWkp6MZH0LSrjl3YroOi6zYIbvgpF0yo0AH2oTFKiFzlwJTsnyXCtUeLyLQAfzHD4mnsOMtWkHV/2naWcV8x57ZomvClB+w5cFNPFWISwBRCKIa/p2LL2LEdmIkx7NVEfZRFZz577enX3ucNUbeCFLoPtuEEUrzYD5N9p3zqODv446/PViOVDppdr1tTrC0A4E/PGswwsUOtfjfkqqwXo9eKt31WBeNQ4l6cBEM8leqaqlGR3fvz+aUJ+5EbgVvLt5T66SCMNAp6UXLyD9Sb7xkMglfaYKDmVMSqAEv+HpSmZuCbzKRKkLvIA1vcfKQHMygYa/90iHj2WUnxUMeZa7xt9Tr4IPd0Q4hqDl2bR/JSaQhceqE7+yZMm9Mb6qSwHs3QR1eixbQDGWQTaJ0xz9Q9WMvy15ksXxAEXlPsRZlE1AwFqx0SEBDzC0Xgerj63JlZ12byBD9NiyiTMEa5geWuzZUMEsAyRWAT5Q2y0evpA/w7e3hBrcV2erbqBUXhSM9o6qJgs5XROZF9Fp8UI4dOTJj2wYyucqtSjpERhIJzWnJ7LVpSVsW306lO5bLyKE8c3cBt20pXfKhGzBuedc93A291oF+3E5x7EZSgn8m0BjbzdmZhg3vntoFn5LXhrmePt6zjpHHRYCJNQDs4DfRSDzvjy30DZJLMsw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB10291.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(261028144727099003)(10067099003)(56012099006)(4143699003)(11063799006)(261021121427099003)(261022105027099003)(261026140227099003)(261026121527099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 MMssMCvVImnf/ibWi06HbfrV4cTkilCLOqIQ9EYK3rpU4sFbK+qTio3c6nLmsQqJ4xe4w/MKFWhXT/R9li+JJNtGNvbZo9OyRpf2396+W6rnJUVAZGMMigyoZQcHAVbRiLpe2u0QpAPyODP5VznFo1bcOpz5A4U4IdoSCtd60Jk0O895hl0jB5Bpi3MfQjyKPEftG91e4CiM/Qgou7N9B+0JWFs6oHNDv0GApeGCBi57yuQcLHYPUw3GaugjN1NqNE0be9SmtytQ14/IYJ677lvoThJTN4tP4K3CSujm2ta1sfyvfvR+qwwQseuAaqN+gXrlGVL6sx4LR7ZjO0xWdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8660
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	90127025-d430-486e-331b-08df456e7ede
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|36860700016|7416014|1800799024|23010399003|82310400026|261026140227099003|261022105027099003|261026121527099003|4143699003|11063799006|56012099006|10067099003|261021121427099003|261102123227099003|261028144727099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	iADuuAa8EyLq0pvD/7RUZpOxQ1DUrXHxfcQbrjGemDM92LS9LW+6RnjV4ougjl9JsRgHjdnMOluIk8UwmP7xSqzReIJoTNBMya4FlbCETAdOyHZuTdwhaf9jKj5omJycRT/cEcPoYYVS4ava2UXNTd4ZRZb3cbAL7BPBnD6W60eFGH6alQNdJPw5Hl1+99OTybWL2guQCpG31SKWuuyQzoL1O1zFkxi2DiBCAMS/kYt7VFTyNmAZbz5gpo+p09Yj0QRxbzCGUbSKdi4KvB/UPkz+wX2Brcpaq8CQBkBqUQiprpR9u10Zbxi3TbgiAf1KmtKdSynsy8VTCbuh/T2uSAzrnjTPoGmJZM7Yhdxo8n5eMw4Z9HwaWVafAYHsktvr2wuYGlKn+2gI43b4B1Jc9JIcCkvu5hdDK+rYQF34vNR5wuk8RRRpeg6UwvhzNMlmIJ3tqk70uLd9iqkLrwk9v+NSs95qQVru+Q/AUVP4VOxqAfOKWkI3CQV5IjOR4hLlcxx7MZvIF/f+C2uC90wCL1RUoYgqfllxPtzVWqZOewHtLtf/wgZlMZUMl+oqv1bgDIW1VBUTJloJ2rB9ESCPydF4TuSCAz3iehl0QZG4AjVfGHtQ4yBIBhmHJxMUzRRg/a0L7f20jmH8Q+xAQwc0M+hyD9fGy8YNGX2DIei+99f/z3rshlMxynirZowmGjff/fs4+vI5ywYnjkkKG3b2vw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(36860700016)(7416014)(1800799024)(23010399003)(82310400026)(261026140227099003)(261022105027099003)(261026121527099003)(4143699003)(11063799006)(56012099006)(10067099003)(261021121427099003)(261102123227099003)(261028144727099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cA6zqKuybLYAJUcrugZ8ZGCc19ZvdKdag2E3dEdtUpLDTsqqepoUGuHC4jUjODphzjhgkGbxpwwRRvY8Wmj+RtusfRhlRrXkaKXXGNdB2KYItwOhnm27rV3UPKEhGgVr4Q44ygYjqM4+4K6eiplcnNtcvTvqOEKy+orrwQwUUKBfcJl8aLaj13uPjm6znVd8GqnwJV8iW0aYNUO84BwL3heNCbXoBmHMb+mv+4nrwPx532wbMEy2hiRYQxvLZD7NPkZl1CulDuT33MRcHKSDq6EoU+b3GWR5Eq3RGuDAaq/yzJQ6tXYO46IFlrZNpSSWa2pb3CuJi3z5DNxWYGYf3XrBD5VFnMjW0BHpl0qBk/pbPtbZuD/6SodlD16JwlnBQsyzdwWhYLZpT1daEM13RIj6WNeCQR/lpEqXfBphnPH5TjrTZwyvUe6M75/TrMOD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 12:22:13.2566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cba0086-011d-4f6c-fc98-08df456e9384
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7335

Hi,

On 2026. 11. 18. 13:07, sashiko-bot@kernel.org wrote:
>> +@offsetof depends on patch@
>> +expression ptr, member;
>> +@@
>> +- offsetof(typeof(*(ptr)), member)
>> ++ struct_offset(ptr, member)
>> +@offsetofend depends on patch@
>> +expression ptr, member;
>> +@@
>> +- offsetofend(typeof(*(ptr)), member)
>> ++ struct_offsetofend(ptr, member)
>
> [Severity: Low]
> Do the inner parentheses in typeof(*(ptr)) prevent these rules from
> matching unparenthesized typeof(*ptr) call sites?
>
> In Coccinelle, the paren isomorphism expands E to (E) in one direction,
> so matching typeof(*(ptr)) requires explicit parentheses around ptr in
> the C source.  Writing typeof(*ptr) matches both typeof(*ptr) and
> typeof(*(ptr)).

It's actually the other way around. In fact, these parentheses were
suggested by Sashiko in the first place!

Bence
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
