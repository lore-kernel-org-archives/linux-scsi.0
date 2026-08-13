Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE693BE174;
	Thu, 13 Aug 2026 05:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786599026; cv=fail; b=tkSdQ82z7qEbTPkJ9WUyXMSqcesrTjhOrCAHY8G2K/X1H0DBEDx2YXeIU9Ss6tGkEjxt/zJSSHO9uel3JZ/d3wSMt2uyRXyV9FEuqoSnkL5D5EXH5z8jXmsgC4PNTQ1m0FCUd0RKFC1OxPZl9nP0vTPm1yLFFnOpWP9cLCmUL6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786599026; c=relaxed/simple;
	bh=R0szrbMASI+Zgkc5yUaUUMIABKzGAFOoTPzawkzG110=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=chsZjDy33pZGPekZiMqZ+OeZouIBA53TkZ5GBYbYKxycNd8nJ0GFYwvU+jVf1RBZshlw8ok3Ly8tMJJqvj5SuqLY9V6hbfcVntlpmIKAFqWU4HyzoGFINAc+gMS0bzCRMZdAsFgvbTYla6iQlgAVOgSPvoHghDW5cI0VFXZSXio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=aKTkw1kM; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="aKTkw1kM"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67D2KkVl3318619;
	Wed, 12 Aug 2026 22:30:11 -0700
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022113.outbound.protection.outlook.com [40.107.200.113])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4g14ntrch7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 12 Aug 2026 22:30:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvHMy1SEzZ7FyoOMWM9T+jLc6sKqGKsXAdwCaLs2agSQ+IHjUQV0jdVrhvQn4q/VnYeiE9N99YFujTHUra8o3QQHepeGilg0EmypK2w1JzWrQ8b+raWQlRJ5fZVW/geQs/tHAfFW0n/nEyiHjVWzjhwb5PsaISx5dtXo2oUza7+ditFYgZVM9WFxXR3LyFkquyC/hYK39HozAZ4ES6jkNygea75+z9PFDvAlY3RALE0fnvabuZvnCgHhHpa7Z82GZ+lbQEAuivxBb+eF/gqfHPn3aGQFwZX0B0Cqruefo4A6HGr2Bc8Um4A1vVEPi0rx8gfhIzIIRjdDjkI2psS/cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0szrbMASI+Zgkc5yUaUUMIABKzGAFOoTPzawkzG110=;
 b=gSXTsTJYLfl/ZaLVu49gAVKdCpwN/BSVSanyCGFynee29MIUTvzNCLsXH+Eo6vNhkP4BeHNBt93JNFdty9cxWzaQECU53yyZz7ODkO0QAEWxZP4IdZ9j7ToD5Z7oDhTd+hsiTcKI83QCuHc/wyYZnCOpYgwReEV09YkAfZDZQNqCji+S9jZs2IYAu6vW0AUsLNEZKc/hL23SS/nWM60k4SKxZdCqcb9V6yZXeoCVJCCXWzwFL3HrxVoBdMKYySHV4INEakQbvRvgLE8j7XWalED/MqcG4ey2EuvVZNdXvSK/kwWFFxqBMAiR+qH17pdv4sx63gKyRZl1X78GoDVzYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0szrbMASI+Zgkc5yUaUUMIABKzGAFOoTPzawkzG110=;
 b=aKTkw1kMqZeGd7MDKZoFjvXp0pB0ITTYDPnS4NENiueqIF8zvqNLqMoxCC8r+8tlWYMSIVu+bvpQQPRtrBSPdjHttoSshRkuDoAukezkj4YxD53pVR+HcXoq73r1oGYeTMBGWdbokHG17dFcQrnYO0fdahWpcWspYI7OjCTZkUQ=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by SJ0PR18MB4511.namprd18.prod.outlook.com (2603:10b6:a03:3bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 05:30:07 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::7648:89b2:ca39:5522%2]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 05:30:07 +0000
From: Nilesh Javali <njavali@marvell.com>
To: Nimal Prabudoss I <nprabudo@redhat.com>,
        "GR-QLogic-Storage-Upstream@marvell.com"
	<GR-QLogic-Storage-Upstream@marvell.com>,
        "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>,
        "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        "mschmidt@redhat.com"
	<mschmidt@redhat.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH] MAINTAINERS: Update QED and Broadcom
 maintainer entries
Thread-Topic: [EXTERNAL] [PATCH] MAINTAINERS: Update QED and Broadcom
 maintainer entries
Thread-Index: AQHdEqbqqKUri/7C8EyMAfpbsdp71babnuUg
Date: Thu, 13 Aug 2026 05:30:06 +0000
Message-ID:
 <CO6PR18MB4500DC2F76176C67ABCA41D6AFDB2@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20260713090100.126362-1-nprabudo@redhat.com>
In-Reply-To: <20260713090100.126362-1-nprabudo@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4500:EE_|SJ0PR18MB4511:EE_
x-ms-office365-filtering-correlation-id: 6ea9b987-c598-426e-a4b1-08def8fbef9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|6133799003|38070700021|22082099003|18002099003|56012099006|4133799003|11063799006|10067099003;
x-microsoft-antispam-message-info:
 btcfFdQ8A0uouLxn3mvUs0I2TMPBjlw6ZjpV0SrIaX5O7u1kcpM89HiQk9qooyglbHaBWehMM4GHYIyva8w2TO0ieFplaf3mDEp0CjAoeZ/QCZ9A9BC3fwBaEijkix+StVnmrHbIqPkrCVUJRwNenOecnB26xRtXIE27ZCj7JnTqFRMn53Ym+l9X8lL+ZDtPbUUisr3IMB5om5ZTw4dHpPLErPGJ3DL4bDAI1YPW1NpHQUQU342AZad8/5/Bal9hXgxA60D+hfK6Xus6+Mwx7ZxBGfajd6bqDRtdX7t1IRywsZTttrGpxTtl49BaIuihzNspEkFjQaG7y0BievYBhwuzdhV2ndQdmbpg1YTAmJrAidVASHLsb+7QiPbTM7PEhEX88gj+BLxJSzV1B6cJeyquLhB/cQqEBMe4bShSEIGh7hKAzeEGEsLVoFF6Ak48o7dgQkHmIfonQCZsrTzDYp7PVMEbthEXGLzugSq0g6UevmPcPwXJo2ljmabpbT7WTvyk6iWiJZXAoTleVen9LNqMvJtIsHvBYXHjqXerLAX6oVsELqoMhSKhjGae9eER2f6PIQrWqtPfPeBunzgn+yHt/dt4KT3JEFn6UalS+cZSpWsTewk8RtRczheflSePu/1ob1x59VZV7XX/RTo+v4dCTencxJvsRzr4PU7NGCrVXXKFw7eGybh2W31k/HhyAZOYv/GpjyWaRdBJM/gKeEK3LuMU/VKX7H40pGz9Tek=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(6133799003)(38070700021)(22082099003)(18002099003)(56012099006)(4133799003)(11063799006)(10067099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cndxNmdST0t2dHA3ZS8vVStkeVhvd2NpM1NOTWY0eng4NXhmcnloTUtHV1JX?=
 =?utf-8?B?aHA5djdmbEUvc2lsMDRKSkxhVEloUy9Sc05jcHhnVmlmd0lYOGpaaktIMnFr?=
 =?utf-8?B?ajVRYm5QTDhvbnRSQ1pMVndTUVRMbzNybVJWT1ZvaWFSVzNxS3hyWWZ2MUcz?=
 =?utf-8?B?YWFJZ25PdE9vN1hxdGtNdU9iaG0ydTU5eUg0QjlGOWlLTklkUHhmRFdHMWJN?=
 =?utf-8?B?OE1iQmdabThnTzQ3eTZ5SktIZUh4RWxtVGVEc3ExYXc3OE1OWUo2M1QrbFBq?=
 =?utf-8?B?NUl2aTlxOHN5aVhqTlJOSEQ4bm9RTzhlcGl2NjI0bUlNN0g0QUtUMUt1UnBw?=
 =?utf-8?B?a21KdTcrUnFMc2Vtd3hMWTNjd2dCT3R2bFRhWTZHZG92M3BCTzV6ZnVMUzhV?=
 =?utf-8?B?bnN2QUswaERLSzBCRVhhSVd2RVpOWE1XKzQzZVBnL1ZrMmllWWVmUGVoVDF5?=
 =?utf-8?B?a29vdTJ5bUd4U1QzYnZBN0p0dWxsbGlrNFVvZUtRMlZUNFJnRnVzeU9ObWox?=
 =?utf-8?B?c3FiRU1Jd1l3SkNZQnljY1pjU1Z1QnlhS1VmVnZsUVo1elZpYVNqWHhtTHEz?=
 =?utf-8?B?NFJDVG9WOHlnWGRaTHJZL3AxTmFwcE9EOGdJeXY1WC93dXcvRTlVWUtqYmFN?=
 =?utf-8?B?NkZuT2tLcGE1OUczY0NsNkl0R1B3SXlSUHNWZ1F0UGhTZWlkWk5IVHZVcVBy?=
 =?utf-8?B?TlJPSm5lbVhGOGVwYUhZTi8xSVFLQ1BxMUVWR3Y4aHMzRkxhMnVqNGxQM29P?=
 =?utf-8?B?eWd0ajdFdjZTRWE0UzJUdjc2YzNWUFJFWmYzREY4MzRMTm4zNUlVN2Nic2Fy?=
 =?utf-8?B?ekVjYzgwekxLbnhxZWFaSUdZZXlUc3prN1lxem1iZit1cjJackJUY1RLMlpp?=
 =?utf-8?B?R3UrRnREQ285emgxK0xHY1IyRGNxMmFhdktlOFZDb1ExdFhYbjB4TEVqTWpV?=
 =?utf-8?B?RmNsMkNmaWRxSEJORlNUQ3hmWE9QWGVxWVIyUldHa21wZlR4VGRCLzg2dzNh?=
 =?utf-8?B?eHFFTVJkalkyMmk2S0tEdkFxUG5sRGhaMnJGV0lQVWpmUEVkbGFMcEFXNS9M?=
 =?utf-8?B?VzJ6b2NCQXdGaE1IeGVJSWFxQVlKL0pEaGl5KzgwcS9NbDhkRlB1bTlHbmVq?=
 =?utf-8?B?M0lBSnZNUExMV3IxV2ozTE80RFdESjFhaVBMRnNHQ205eFF1NlhSVVlKaSsy?=
 =?utf-8?B?S1VWeXF6ZE9KSURVTFhQRFViR3U0ZTFjMmxxeGsrcXZDZTN0bWZqMkkvak5X?=
 =?utf-8?B?dWNEa0tzWVhXdXFCUHNQcTZMUHU4RytzSVIwTm1mTFNRWXNrdHBqVUlDNFRu?=
 =?utf-8?B?ZXhZTXlpRVIzenpTVXkvbjV2bFdnalJWQ0RlNEJLbUtIM0xkbDJjVlRHUnBD?=
 =?utf-8?B?Zll5bEx3clhyY0tNbE41N0NobCtBN2pmSGdhbjJ1MlFiVjRZR3ZKU1dqK2pQ?=
 =?utf-8?B?Qk5aT1A0aEdOOEhYQWlTdmRpSlRjQWlrNEhmNlpHUWlDSU1sT2QyeVVBbk5E?=
 =?utf-8?B?dnFqdkV2Wko0VmYreEFLMXNpbzc4SWVZeWsxRjZKNDZSK1lYVXUrbFk1eTlN?=
 =?utf-8?B?Q053aHNOdGZvOVBpK3k2cW9OcS9Rckd6QUdtR2R5eUVDZFIwYlV3cnZDZkNZ?=
 =?utf-8?B?RXBrdEJBRWhadzh2cW5UVVM4MXJXK2NQN3BRbkV3Rk01WnJ0OGhOSDQxTXNP?=
 =?utf-8?B?dnJOQXB4SXNZYUNPc2o4ZlAyV0VLS3NJd2lQSGF1UUlmUklWYk5KQmkzY3Bu?=
 =?utf-8?B?M0ZwbTE5c0llRmx4OHN2aVVvNHo0Mk5QclhpemJ0bGtoeFZES1VYY3hhN1lN?=
 =?utf-8?B?SkhoSWI2S0tRaGtiaytiZkRXa0ZWcWVYMG8zS0IyWS9DbDhMS01WUEtWdW03?=
 =?utf-8?B?S1BrVDIyeU1TeEJlR3NFcVoyK3BQb0RZMURkL0kyRDN0NmRaNVpQcmRIdFVq?=
 =?utf-8?B?Z2p6WGxNTlZLdUg1akJRNi9IUWNwOUQ4VkN4Z010ODNFbEVaR0JuV1RXdGVn?=
 =?utf-8?B?NjdTamRXQjRqajhOcGtFT1Q3bWhDb2I1eVdoZ3lSVVpRcFZpT1BnMHl0bHJ3?=
 =?utf-8?B?S1VmRjJlVlQ3bjhXSHZsUThkaUhncytBK0Ezek0wU1BDWlZFckEwNXJmbkQv?=
 =?utf-8?B?VDlUSWV5bFdjU3RESHg3SEtnZllCSUZsckNWTHdKQitwVjdzU1EvSXBaWjQr?=
 =?utf-8?B?RDRydGtGQUo5TktlRS9UL25RZ3pLb2o4MGJGQitOWXpmalMrbi8wdHV1RUY3?=
 =?utf-8?B?MC9pWHZubXdreE8rRVpCTmE5TDVrbmwzeXZXMHJEZVZxQTNuMWoyU3QxVnp4?=
 =?utf-8?Q?7UGiWvpjG2ZylXIpMH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	Oo5GJRPRCv/8eQHk5d1fdtDHsDNLSvRkoOwdh5v9/EAdt2o/xVbZX7vK/cp0YA0ip6xXqrlw4LAuingOcsMNJUcOLKNd5J1nEyz3QOoCLJfc32bHhdDXaBQLcFnkBfdR8NA/BpqYyJSjxiko8hqCVVhr0++9MJ8ujVBRkhewgor3uIfZel9UqvEYuG9kSA/pjeAPIC4t2SmVbk567g4exqU3knlmuiwwCefjDq96W4YI/uWqpALsK/06Bp18QCRGHhO96/ofIUyxYtARd7JHdNKx7xK+zQILltw7YHjFaB4gGNvKVoT72tEWFstXsKshDzCjFBfJBlmwnxtNSf9eKg==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea9b987-c598-426e-a4b1-08def8fbef9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 05:30:06.6586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ddKl925b/oCBFPWS10v9xG2NWhxZBdRwZ7cASP1fMlKjW5RXQsOcE6syCSQigWMqc/8kAxDukZ//k3hHbqkzdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4511
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 1QF-pMCpqUnj3VEpUefA95mGWj4AKjg8
X-Authority-Analysis: v=2.4 cv=HuBG3UTS c=1 sm=1 tr=0 ts=6a7d5663 cx=c_pps
 a=ypcO1grc5O9jTiuCy4hLbQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=EAYMVhzMl8SCOHhVQcBL:22 a=RpNjiQI2AAAA:8
 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=yPCof4ZbAAAA:8 a=pK6VUNixD4gbdi4qofIA:9 a=lqcHg5cX4UMA:10 a=PRpDppDLrCsA:10
 a=QEXdDO2ut3YA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDAzNiBTYWx0ZWRfXxJc6k/wRjA7z
 HkZU89e4YVPSKoXZJ0TL31XA9KZcpr3ujVDwj0VlO6JLcd23LtkwjrnrHggWKCLv0FZUGY6YcKm
 pczX5yNFEYoa3yxsm4Vj96O5GTe2GVHL5zqWlDsZDqyZEJpaXOW2H0/X4mEuWTdR2Zf+zr/+uHN
 yYwUee9fVi/gKAGMMf/q+ikVblXF9YXIBt5yw+wSSqinfDfc5jZkQsfd3GeYLgvCuybAEH6P/Nv
 VGwH7FPMgm9w5Qaple/zCIdWtMjnX68KAuKuqm+6Xeqg+3MQpTbXEdYcGyUJBJDWa9MbCoxGs/Q
 5R0XzRyGWid/XHXnCS0uoDYPuO//ymUVAoUgQI0NwV1NiKEjoCaq24xa+8/29ttldQPd+HnjTes
 sdt4CQ68hdhaA+VEk9xs/J2rbnCHLJB4amcMyzxg0tJyTOy9YB6hGX8vMcIpUh+8M6I9Otr38VB
 oR2Ruvk2LmHZZ2XIpUA==
X-Proofpoint-ORIG-GUID: 04KEfw4GcDMNQElWZJKcIARxEIWYWGrm
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDAzNiBTYWx0ZWRfX0Co+Q0xzctH7
 mA3kFTGO4orYvvRamuoe0bz7Sfen6xxGt4TCjn6BH48j1mK8SRlWPWuGvzruNERwnEQsdwzpHOm
 4F6LOrv53+roGTMv+BUmSk9maohTQjE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_01,2026-08-12_01,2025-10-01_01

TkFDSy4NClJlbW92ZSBHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbSBhcyBp
dCdzIG5vIGxvbmdlciBpbiB1c2UuDQpDcmVhdGUgYSBuZXcgb25lIGFuZCB1c2UgaXQgYWNyb3Nz
IGFsbCB0aGUgZHJpdmVycyBpbnN0ZWFkIG9mIGluZGl2aWR1YWwgZW1haWwgSURzLg0KDQpUaGFu
a3MsDQpOaWxlc2gNCg0KDQpGcm9tOiBOaW1hbCBQcmFidWRvc3MgSSA8bnByYWJ1ZG9AcmVkaGF0
LmNvbT4gDQpTZW50OiBNb25kYXksIEp1bHkgMTMsIDIwMjYgMjozMSBQTQ0KVG86IEdSLVFMb2dp
Yy1TdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tOyBqZWpiQGxpbnV4LmlibS5jb207IG1hcnRp
bi5wZXRlcnNlbkBvcmFjbGUuY29tDQpDYzogam1lbmVnaGlAcmVkaGF0LmNvbTsgbXNjaG1pZHRA
cmVkaGF0LmNvbTsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IE5pbWFsIFByYWJ1ZG9zcyBJIDxucHJhYnVkb0ByZWRoYXQuY29tPg0KU3Vi
amVjdDogW0VYVEVSTkFMXSBbUEFUQ0hdIE1BSU5UQUlORVJTOiBVcGRhdGUgUUVEIGFuZCBCcm9h
ZGNvbSBtYWludGFpbmVyIGVudHJpZXMNCg0KLS0tIE1BSU5UQUlORVJTIHwgMjUgKysrKysrKysr
KysrKysrKysrLS0tLS0tLSAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgNyBkZWxl
dGlvbnMoLSkgZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMgaW5kZXggMTQ5
NjhiODRmMGY2LuKAii7igIo3MTk3YjlhYTQyNzggMTAwNjQ0IC0tLSBhL01BSU5UQUlORVJTICsr
KyBiL01BSU5UQUlORVJTIEBAIC00NTYwLDcgKzQ1NjAsOCBAQCBGOiBpbmNsdWRlL2xpbnV4L2Jj
bTk2M3h4X252cmFtLuKAimgNClpqUWNtUVJZRnBmcHRCYW5uZXJTdGFydA0KUHJpb3JpdGl6ZSBz
ZWN1cml0eSBmb3IgZXh0ZXJuYWwgZW1haWxzOiANCkNvbmZpcm0gc2VuZGVyIGFuZCBjb250ZW50
IHNhZmV0eSBiZWZvcmUgY2xpY2tpbmcgbGlua3Mgb3Igb3BlbmluZyBhdHRhY2htZW50cyANCsKg
wqBodHRwczovL3VzLXBoaXNoYWxhcm0tZXd0LnByb29mcG9pbnQuY29tL0VXVC92MS9DUlZtWGtx
VyF0WTNaMWY4VVluVTYxRy05bWQxNmJ1SUtQbDNRMXJTcURJTElXd2Z3UHdDdURFUkFYLVY3YTk1
XzlYdXVYVUtHVzlVVVY5SnZyZUVzUm1FR0VKVEJUMDRsejBGV0cxQTdVdyTCoMKg4oCMIA0KDQoN
ClpqUWNtUVJZRnBmcHRCYW5uZXJFbmQNCi0tLQ0KIE1BSU5UQUlORVJTIHwgMjUgKysrKysrKysr
KysrKysrKysrLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA3IGRl
bGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUw0KaW5k
ZXggMTQ5NjhiODRmMGY2Li43MTk3YjlhYTQyNzggMTAwNjQ0DQotLS0gYS9NQUlOVEFJTkVSUw0K
KysrIGIvTUFJTlRBSU5FUlMNCkBAIC00NTYwLDcgKzQ1NjAsOCBAQCBGOglpbmNsdWRlL2xpbnV4
L2JjbTk2M3h4X252cmFtLmgNCiBGOglpbmNsdWRlL2xpbnV4L2JjbTk2M3h4X3RhZy5oDQogDQog
QlJPQURDT00gQk5YMiBHSUdBQklUIEVUSEVSTkVUIERSSVZFUg0KLU06CVJhc2VzaCBNb2R5IDxt
YWlsdG86cm1vZHlAbWFydmVsbC5jb20+DQorTToJTmltYWwgUHJhYnVkb3NzIDxtYWlsdG86bnBy
YWJ1ZG9zc0BtYXJ2ZWxsLmNvbT4NCitNOglTaGFyYWQgUGFkb2wgPG1haWx0bzpzcGFkb2xAbWFy
dmVsbC5jb20+DQoNCiBNOgltYWlsdG86R1ItTGludXgtTklDLURldkBtYXJ2ZWxsLmNvbQ0KIEw6
CW1haWx0bzpuZXRkZXZAdmdlci5rZXJuZWwub3JnDQogUzoJU3VwcG9ydGVkDQpAQCAtNDU2OCwx
NCArNDU2OSwxNiBAQCBGOglkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyLioNCiBG
Oglkcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyXyoNCiANCiBCUk9BRENPTSBCTlgy
RkMgMTAgR0lHQUJJVCBGQ09FIERSSVZFUg0KLU06CVNhdXJhdiBLYXNoeWFwIDxtYWlsdG86c2th
c2h5YXBAbWFydmVsbC5jb20+DQotTToJSmF2ZWQgSGFzYW4gPG1haWx0bzpqaGFzYW5AbWFydmVs
bC5jb20+DQorTToJTmltYWwgUHJhYnVkb3NzIDxtYWlsdG86bnByYWJ1ZG9zc0BtYXJ2ZWxsLmNv
bT4NCitNOglTaGFyYWQgUGFkb2wgPG1haWx0bzpzcGFkb2xAbWFydmVsbC5jb20+DQogTToJbWFp
bHRvOkdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwuY29tDQoNCiBMOgltYWlsdG86
bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCiBTOglTdXBwb3J0ZWQNCiBGOglkcml2ZXJzL3Nj
c2kvYm54MmZjLw0KIA0KIEJST0FEQ09NIEJOWDJJIDEvMTAgR0lHQUJJVCBpU0NTSSBEUklWRVIN
CitNOglOaW1hbCBQcmFidWRvc3MgPG1haWx0bzpucHJhYnVkb3NzQG1hcnZlbGwuY29tPg0KK006
CVNoYXJhZCBQYWRvbCA8bWFpbHRvOnNwYWRvbEBtYXJ2ZWxsLmNvbT4NCg0KIE06CU5pbGVzaCBK
YXZhbGkgPG1haWx0bzpuamF2YWxpQG1hcnZlbGwuY29tPg0KIE06CU1hbmlzaCBSYW5nYW5rYXIg
PG1haWx0bzptcmFuZ2Fua2FyQG1hcnZlbGwuY29tPg0KIE06CW1haWx0bzpHUi1RTG9naWMtU3Rv
cmFnZS1VcHN0cmVhbUBtYXJ2ZWxsLmNvbQ0KDQpAQCAtMTg5MjcsNyArMTg5MzAsOCBAQCBGOglk
cml2ZXJzL2luZmluaWJhbmQvaHcvcWliLw0KIA0KIFFMT0dJQyBRTDQxeHh4IEZDT0UgRFJJVkVS
DQogTToJU2F1cmF2IEthc2h5YXAgPG1haWx0bzpza2FzaHlhcEBtYXJ2ZWxsLmNvbT4NCg0KLU06
CUphdmVkIEhhc2FuIDxtYWlsdG86amhhc2FuQG1hcnZlbGwuY29tPg0KK006CU5pbWFsIFByYWJ1
ZG9zcyA8bWFpbHRvOm5wcmFidWRvc3NAbWFydmVsbC5jb20+DQorTToJU2hhcmFkIFBhZG9sIDxt
YWlsdG86c3BhZG9sQG1hcnZlbGwuY29tPg0KIE06CW1haWx0bzpHUi1RTG9naWMtU3RvcmFnZS1V
cHN0cmVhbUBtYXJ2ZWxsLmNvbQ0KDQogTDoJbWFpbHRvOmxpbnV4LXNjc2lAdmdlci5rZXJuZWwu
b3JnDQogUzoJU3VwcG9ydGVkDQpAQCAtMTg5MzUsMTQgKzE4OTM5LDE2IEBAIEY6CWRyaXZlcnMv
c2NzaS9xZWRmLw0KIA0KIFFMT0dJQyBRTDQxeHh4IElTQ1NJIERSSVZFUg0KIE06CU5pbGVzaCBK
YXZhbGkgPG1haWx0bzpuamF2YWxpQG1hcnZlbGwuY29tPg0KLU06CU1hbmlzaCBSYW5nYW5rYXIg
PG1haWx0bzptcmFuZ2Fua2FyQG1hcnZlbGwuY29tPg0KK006CU5pbWFsIFByYWJ1ZG9zcyA8bWFp
bHRvOm5wcmFidWRvc3NAbWFydmVsbC5jb20+DQorTToJU2hhcmFkIFBhZG9sIDxtYWlsdG86c3Bh
ZG9sQG1hcnZlbGwuY29tPg0KIE06CW1haWx0bzpHUi1RTG9naWMtU3RvcmFnZS1VcHN0cmVhbUBt
YXJ2ZWxsLmNvbQ0KDQogTDoJbWFpbHRvOmxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQogUzoJ
U3VwcG9ydGVkDQogRjoJZHJpdmVycy9zY3NpL3FlZGkvDQogDQogUUxPR0lDIFFMNHh4eCBFVEhF
Uk5FVCBEUklWRVINCi1NOglNYW5pc2ggQ2hvcHJhIDxtYWlsdG86bWFuaXNoY0BtYXJ2ZWxsLmNv
bT4NCitNOglOaW1hbCBQcmFidWRvc3MgPG1haWx0bzpucHJhYnVkb3NzQG1hcnZlbGwuY29tPg0K
K006CVNoYXJhZCBQYWRvbCA8bWFpbHRvOnNwYWRvbEBtYXJ2ZWxsLmNvbT4NCiBMOgltYWlsdG86
bmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KIFM6CVN1cHBvcnRlZA0KIEY6CWRyaXZlcnMvbmV0L2V0
aGVybmV0L3Fsb2dpYy9xZWQvDQpAQCAtMTg5NTEsNiArMTg5NTcsOCBAQCBGOglpbmNsdWRlL2xp
bnV4L3FlZC8NCiANCiBRTE9HSUMgUUw0eHh4IFJETUEgRFJJVkVSDQogTToJTWljaGFsIEthbGRl
cm9uIDxtYWlsdG86bWthbGRlcm9uQG1hcnZlbGwuY29tPg0KK006CU5pbWFsIFByYWJ1ZG9zcyA8
bWFpbHRvOm5wcmFidWRvc3NAbWFydmVsbC5jb20+DQorTToJU2hhcmFkIFBhZG9sIDxtYWlsdG86
c3BhZG9sQG1hcnZlbGwuY29tPg0KIEw6CW1haWx0bzpsaW51eC1yZG1hQHZnZXIua2VybmVsLm9y
Zw0KIFM6CVN1cHBvcnRlZA0KIEY6CWRyaXZlcnMvaW5maW5pYmFuZC9ody9xZWRyLw0KQEAgLTE4
OTYzLDYgKzE4OTcxLDggQEAgUzoJTWFpbnRhaW5lZA0KIEY6CWRyaXZlcnMvc2NzaS9xbGExMjgw
LltjaF0NCiANCiBRTE9HSUMgUUxBMlhYWCBGQy1TQ1NJIERSSVZFUg0KK006CU5pbWFsIFByYWJ1
ZG9zcyA8bWFpbHRvOm5wcmFidWRvc3NAbWFydmVsbC5jb20+DQorTToJU2hhcmFkIFBhZG9sIDxt
YWlsdG86c3BhZG9sQG1hcnZlbGwuY29tPg0KDQogTToJTmlsZXNoIEphdmFsaSA8bWFpbHRvOm5q
YXZhbGlAbWFydmVsbC5jb20+DQogTToJbWFpbHRvOkdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFt
QG1hcnZlbGwuY29tDQogTDoJbWFpbHRvOmxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQpAQCAt
MTg5NzcsNyArMTg5ODcsOCBAQCBGOglkcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMvcWxhM3h4
eC4qDQogDQogUUxPR0lDIFFMQTRYWFggaVNDU0kgRFJJVkVSDQogTToJTmlsZXNoIEphdmFsaSA8
bWFpbHRvOm5qYXZhbGlAbWFydmVsbC5jb20+DQotTToJTWFuaXNoIFJhbmdhbmthciA8bWFpbHRv
Om1yYW5nYW5rYXJAbWFydmVsbC5jb20+DQorTToJTmltYWwgUHJhYnVkb3NzIDxtYWlsdG86bnBy
YWJ1ZG9zc0BtYXJ2ZWxsLmNvbT4NCitNOglTaGFyYWQgUGFkb2wgPG1haWx0bzpzcGFkb2xAbWFy
dmVsbC5jb20+DQogTToJbWFpbHRvOkdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtQG1hcnZlbGwu
Y29tDQoNCiBMOgltYWlsdG86bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCiBTOglTdXBwb3J0
ZWQNCi0tIA0KMi41NC4wDQoNCg0K
