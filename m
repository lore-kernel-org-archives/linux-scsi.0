Received: from aer-iport-2.cisco.com (aer-iport-2.cisco.com [173.38.203.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D3D279DB6;
	Tue, 24 Feb 2026 19:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.38.203.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771961510; cv=fail; b=mkSxX3gm/F4qoadbz1TQerGZx3McDeSyQVf+WkfRbzcCvjQSaOagXXMe/fak+zpzLh606NJKnEQ0+NVeE+Z+TBIYF2gQaD1+Vd8GSCrVhdC0VxWG6NluAU1LESxXhAX0xDZD+gDoOioXy1fO0bKkqh0m7m5g8vmnMildx4T1flQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771961510; c=relaxed/simple;
	bh=iCVRLCkIDPpbXQuDNlPBVbKLPn8ztSEU8f86QBhhvFg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iNVmSPg4U93IDoxC774TRkVOHQyb28RH84uivCJBT1qvrwKB2UQpcCUNVbBtWoULcJBarbqauvpwjtLl4yuBp/Mcrhtp4+/0mmidjkNwXXoX2fdXlPO6bdxtdqjmEeB9HIzYwHOAzgGhldJwSdxkmj2VMd7C0j67UBLGm1s68C8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jnrrlbAJ; arc=fail smtp.client-ip=173.38.203.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jnrrlbAJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2452; q=dns/txt;
  s=iport01; t=1771961508; x=1773171108;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qk7frZ/ok6+3y8qZrBWRCaV8Q11LuzTJVdj1NpKuwuA=;
  b=jnrrlbAJtRpVAdcYhroUYFSQth07qJIM6XjQfTJ7CSrWK1tH7wrnobCz
   Bk9QV/8Zsi8j4u5HDAebKty5ygAShhdU4A+743oMwyJ4Hg/jF7CbKf6h+
   ndzm1GPkCYPiv+oePxYpPSYkuTWnL69zkEKGhezUxcv6CHFZZVYNKYFM9
   VJghCKQlrxXdJ9HzYHzB4lzhzZaJaYe7YY0YErqBpkPrSpRzQTGBRwzl0
   VUPsHSwlngrXp4+ugn/HQuVXT8mZHaSgp7tUxXNxgzizdcZ5d9Hc1LG2Q
   3ayvh6z68DshTbvujpYdq9QA0M+fqtJ2iL+w/7Y5Xu9SMWkCVQ/MQjKIv
   w==;
X-CSE-ConnectionGUID: I0aMVoedRlW/RUfh4SKrSw==
X-CSE-MsgGUID: fyEwE5d2TaKCQhxt5NBnYw==
X-IPAS-Result: =?us-ascii?q?A0CPAACo+51p/8pK/pBaHQEBAQEJARIBBQUBQCWBFwgBC?=
 =?us-ascii?q?wGBbVMHgiFJiCMDhE1fhliCIQOYPIVegX8PAQEBDQJRBAEBhQcCjR8CJjQJD?=
 =?us-ascii?q?gECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThlyGWgEBAQEDE?=
 =?us-ascii?q?hUTPxACAQgYHhAxJQIEAQ0FCBqFVAMBAp1zAYFAAooreIEBM4EB4C4UAYE4A?=
 =?us-ascii?q?YhTAYV0O4Q/JxuCDYEVQoJoPoRFhBOCLwSCIoEOiXWJRVJ4HANZLAFVExcLB?=
 =?us-ascii?q?wWBI0MDKi8tI0sFLR2BIyEdFxQfWBsHBRIhKgdhAgIEghN7ggEPhmx5Ay5hG?=
 =?us-ascii?q?g4iAiwSXFAFPgtfBYEOAwttPTcUGwMEgTUFjgU/gjMBgQ5NM4FADJZvsB8Kh?=
 =?us-ascii?q?ByiDheqay6YWCKodAIEAgQFAhABAQaBaDyBWXAVgyJSGQ/UbXg8AgcLAQEDC?=
 =?us-ascii?q?ZNnAQE?=
IronPort-PHdr: A9a23:iPyJghIdwyMFQ35tbNmcuVQyDhhOgF28FhQe5pxijKpBbeH/uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:ZEB/z6qESCRAmRT4dsHLHMU8OWJeBmJ2ZBIvgKrLsJaIsI4StFCzt
 garIBmHa66INzenLo8kbIm3/U0C7ZSByYNgSlY5rys3RSMTp+PIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgbNNwJcaDpOtfrZ8k835pwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0scvCERw8
 vEUEjQyKSq+ieLq+5GhcfY506zPLOGzVG8eknht13TdSP0hW52GG/yM7t5D1zB2jcdLdRrcT
 5NFNXw1MUiGPEEJYA9NYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDbHJ0OxhnFz
 o7A12roLw43adDF9TOm2UuslvOSuwn9aZ1HQdVU8dYv2jV/3Fc7DBwQSEv+ovSjjEO6c8xQJ
 lZS+Sc0q6U2skuxQbHVWxy+vW7BpRUHWvJOHOAgrgKA0KzZ50CeHGdsc9JaQNUrrooyADctz
 FLMx4qvDj10u7rTQnWYnluJkQ6P1eEuBTZqTQcPTBAO5J/op4Rbs/4FZowL/HKd5jEtJQzN/
 g==
IronPort-HdrOrdr: A9a23:dwvyj6Bxrz3HIzrlHejjsseALOsnbusQ8zAXPh9KOH9om52j9/
 xGws576fatskduZJhBo7y90KnpewK7yXcH2/hhAV7EZniohILIFvAv0WKM+UybJ8STzJ846U
 4kSdkANDSSNyk1sS+Z2njELz9I+rDum87Y55a6854ud3AXV0gK1XYBNu/vKDwMeOAwP+tAKH
 Pz3LshmxOQPV4sQoCQAH4DU+Lfp9vNuq7HTHc9bSIP2U2ltx/tzKT1PSS5834lPg+nx41MzU
 H11yjCoomzufCyzRHRk0XJ6Y5NpdfnwtxfQOSRl8k8MFzX+0aVTbUkf4fHkCE+oemp5lpvus
 LLuQ0cM8N67G6UVn2poCHqxxLr3F8VmjzfIB6j8DneSP7CNXYH4vl69MVkm9zimgwdVeRHoe
 d2NqSixsNq5F377XzADpPzJmFXfwKP0AkfeKgo/j1iuU90Us4KkWTZl3klS6soDWb07psqH/
 JpC9yZ7PFKcUmCZ3ScpWV3xsewN05DVStub3Jy8/B96QIm1ExR3g8d3ogSj30A/JUyR91N4P
 nFKL1hkPVLQtUNZaxwCe8dSY/vY1a9DC7kISaXOxDqBasHM3XCp9r+56g0/vijfNgNwIEpkJ
 rMXVtEvSo5el7oC8eJwJpXmyq9ClmVTHDo0IVT9pJ5srrzSP7iNjCCUkknl4+6r/AWEqTgKo
 CO0VJtcojexEfVaPJ0NlfFKutvwFElIbgohuo=
X-Talos-CUID: =?us-ascii?q?9a23=3A1TV1X2pcL9AyP6+Oe5nDv5DmUeF9e1jjy3rcGUu?=
 =?us-ascii?q?HTlxURr3JcnyKw7wxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AXxe44w3uAPA6dYD+ZOlo25Be7zUj7bWDF21Qnc8?=
 =?us-ascii?q?6suqvDCxgJ2q7pjKGXdpy?=
X-IronPort-Anti-Spam-Filtered: true
Received: from aer-l-core-01.cisco.com ([144.254.74.202])
  by aer-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Feb 2026 19:31:40 +0000
Received: from rcdn-opgw-4.cisco.com (rcdn-opgw-4.cisco.com [72.163.7.165])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-01.cisco.com (Postfix) with ESMTPS id 8A36BF20DC;
	Tue, 24 Feb 2026 19:31:39 +0000 (GMT)
X-CSE-ConnectionGUID: Fo5PiSSiS+ezr+uGZn1Mlg==
X-CSE-MsgGUID: JV+lwYu4Qvmvzqk+LecUPQ==
Authentication-Results: rcdn-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.21,309,1763424000"; 
   d="scan'208";a="71093047"
Received: from mail-bn1pr07cu00304.outbound.protection.outlook.com (HELO BN1PR07CU003.outbound.protection.outlook.com) ([40.93.12.4])
  by rcdn-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Feb 2026 19:31:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9wLD35kI2ns7ETpcJpqGQJSDoCOqynyBKnNdb4uHUC4qubF2B/eYNsqVAfUpD4uwB4u4D61q7490hgbV5KcUTm9Oqs3QFTYtyNn8ZkzUcHvDWpIW83serNxbAX7K2nRZVtee4HsbCE6L9YvGFkhMxpy+fKt74BBgW91L9FuT8Gq55J2/k8VJgTqEoaaIwrAe/RjTAcY0iy4XYgCkJ4pg2hC3uGjWjUBBjZV6bQGZZMiznVaamrfLH4dwKPVL1dd1j8pHdoUbn+9WY9vp1yZjaJBo5ivWBgokbpVKm6Mh5BsX6YKM4Ltj7s/6W4RXj1THTMd6eUK0jK9R4IJaJLe5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qk7frZ/ok6+3y8qZrBWRCaV8Q11LuzTJVdj1NpKuwuA=;
 b=wIAk0MSH24Ibe/hOTBPfDKo6u8uTVcS+8w01zoO1DCAheg9TvGKMCdkEXjzi0E4ImfI0/KO1Iuc9uKf1ua1qLGNXg11tigs/KUmpS0vcMUjAfXyFbMysat1v7TYJ0RcaxyTulhHvsihHj17/rQ+maxuGT4IoC60rddDxJZNrg/gfjSyKzuiYhSR1zUHvh6hHV17zL4gzJIqZhAw8nuAIvrk00VNST5eNx8MvOerRAF0mhMtPyq5MkrfYFKcgjSKVa9GVWppDDMeQXW9OlTDfA7c2hCBDhmwQWoYBCVix0dIGOK+jzMlfGSBBJKI9zKyazjoVCTmnE2wgsNB9n7K0bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by SJ0PR11MB4783.namprd11.prod.outlook.com (2603:10b6:a03:2af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 19:31:34 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%2]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 19:31:34 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Bart Van Assche <bart.vanassche@linux.dev>, Peter Zijlstra
	<peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Marco Elver
	<elver@google.com>, Christoph Hellwig <hch@lst.de>, Steven Rostedt
	<rostedt@goodmis.org>, Nick Desaulniers <ndesaulniers@google.com>, Nathan
 Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>, Jann Horn
	<jannh@google.com>, Bart Van Assche <bvanassche@acm.org>, "Satish Kharat
 (satishkh)" <satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)"
	<sebaddel@cisco.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 29/62] fnic: Make fnic_queuecommand() easier to analyze
Thread-Topic: [PATCH 29/62] fnic: Make fnic_queuecommand() easier to analyze
Thread-Index: AQHcpRA85NG/XHZdk0CFr1GRUx3yV7WSOyXQ
Date: Tue, 24 Feb 2026 19:31:33 +0000
Message-ID:
 <SJ0PR11MB5896E1F414082E723050BD7EC374A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
 <20260223220102.2158611-30-bart.vanassche@linux.dev>
In-Reply-To: <20260223220102.2158611-30-bart.vanassche@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|SJ0PR11MB4783:EE_
x-ms-office365-filtering-correlation-id: 54221de7-1600-40cc-bb99-08de73db51c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?gS2CRYcoSzSau9DOSzhJvaMajaxQ5F/8V61e54yJ8m0q9QZA3NOIHT9VUQBf?=
 =?us-ascii?Q?aRFatklPzJJ9N/YYJng+y/ZoplsxP2vlaVS3DZfWaZjNIheQRb06Ar1Ys/W+?=
 =?us-ascii?Q?oT4QTR6ow5Rl3K7RxYyvqyq9U8EGwhNKLwTzumSxvFllUEwdTpGcJtDfSWn4?=
 =?us-ascii?Q?dwabpJuD1qmA7wG4OzX5SxkhcMi9x3SJkduOWFD4bU/i+QtNy7H2henDLY1r?=
 =?us-ascii?Q?O8SLxdUS2RfMUKUt9IjLlg3doeI0Hrynm5cedWDTipQwFCZ9Hs559JdHVQgd?=
 =?us-ascii?Q?xTgw0ggR2rZu4LSDEWJeUtzHnNsn9RYPOkFFkuVmPhnFFZokE4ZLCtX/SlmJ?=
 =?us-ascii?Q?R2UCx3zBlkftnu2028Azg1qy4F6YaokWBPhBqTJhaEFVOP+OZNPe2xlBeAp7?=
 =?us-ascii?Q?AILCUcxcMLmLxxkv5/pBpAExB8XVGtDY9fQ4NgH8LmlUN6rsW2yhFDOy+4jI?=
 =?us-ascii?Q?r4+OunfbG1OuokAK6jT/9cuwr9pM6evuMESNTrt68bywQYMmx6jmhCsh26Ii?=
 =?us-ascii?Q?l+YUECsBzoV+tZCUZl5DqpUcZtwCZ7E1Jth5kkFCxDfWWiK0aPkC0iv7nY3W?=
 =?us-ascii?Q?qgk8uAY7s6mgQl4/J38+D1et1u3UIEtjTE+m8E467QUurWjpg3ex3GAJgAdv?=
 =?us-ascii?Q?9cwUBMqNmhW+TudGofCdioqv59V7aoXTDncsDFvXeeG5oU1tUj34ETUa1uCB?=
 =?us-ascii?Q?lsT5QSLoYQssMoxPXzY31raHPwA35AWZPRSlpXMJpzWHWSB+JNYlreK45/jH?=
 =?us-ascii?Q?tBXXzecm4e3u3z3bmtzVw9EmW8N77xEonmLBbB6VmN8z7QaaK2bnOgsvMBnw?=
 =?us-ascii?Q?H10rsaYb4gjR1lT2p64AcrWnUVFyBJOkON4gTnhcqWbehSq0yOrW5EXe4SYp?=
 =?us-ascii?Q?ubGgjlhyLf3RVFHObVO/UmXIg5jE0izLNKqrcysTNFWoosywJ1PiNOw7Gefc?=
 =?us-ascii?Q?ef6qA4iQD6J0QJjXhV7apHQKRpMrAIcLW9JtWtcqwGCYHU6Umxvybw1ljaPu?=
 =?us-ascii?Q?aStcuWbeeQUhbgIJOQr5spkd9mD6MzKTP3vuKkTl5JGHzVY7Z6P5OKlsLovo?=
 =?us-ascii?Q?Lorm2I4hWMSOkRJm/SPAI9PRAv3ZYwmAoSVJ3LiISiu2mP4ZnCvJOp51q5ZX?=
 =?us-ascii?Q?ugY/McT156cvTcAcL4UtVtFF02feY/F9s1HesIu43XqrvzJYpWp1SsDHMlI5?=
 =?us-ascii?Q?xyoGJXP7v9rRPUeN+P7AfRf5l9LRq4rydocGWowEUSh7rX9fTG5opdFbp3sx?=
 =?us-ascii?Q?BThJmXFgYTxaYd0HuEAsGJ93H8sUEeELqIxE4bkB/ztm93q6OquqxIq+CXUw?=
 =?us-ascii?Q?1y10ZGeVmS2xMfBJWvPCJgCCEZNRQ4oCCWWPcEvDG14mnBiTym21idGMWHmT?=
 =?us-ascii?Q?wHKZYr6FPLV7b+ZZDJcRz74KybQUjBq9XRIudqyvZAckKwgtmP08xX7KuWbl?=
 =?us-ascii?Q?Qk89HLJ3faiSS50ijz7arW14WavLTy7vB++aQut99wMYvkrLvz1PPfe2ZNrw?=
 =?us-ascii?Q?GojVBtJyFvfsb1zeeypJD2fEE25nvLmpzCXC9kieQAdLyGsFSynQKZI54hN6?=
 =?us-ascii?Q?BjqiFHXGtC31D5N+KSot2rt8gT6CABH490ycC40vRGBbmbixvlu6f+cm42o/?=
 =?us-ascii?Q?Paf0rPR5qi2D1qvs+zNjybA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?oEhFVS8i8S3m8bKArbYcYotT9UYrkK5gVr+UQN5E/+FVK2sZp0hSwtJHRsJs?=
 =?us-ascii?Q?jmsB3vsPe/ivMfiPAd816YS4ul0M22jownHFvOuJHhoo/shKXNgjYtGIHv74?=
 =?us-ascii?Q?CoDhw4obmOsD68dx4zbh2hYeWiUsiFaT7UhdCiY3XG+3MSTDYT4brxNBK6RD?=
 =?us-ascii?Q?Psb7GSkkXtaAJsM20OunD49KO/wLl0nMUu62LELBYMqQVKkOhJuhACJyr7IR?=
 =?us-ascii?Q?4B57q63cIEN1YK99A6FLkdAJAdgZe3BUBlt6rs3djD0+8aSs0Jewhk2BM5rW?=
 =?us-ascii?Q?5L9xaixiuPPWW4Lqz+v5Prk90V98vWWCkcsd1N3C4KZMw/V105hTVjMuShfU?=
 =?us-ascii?Q?m058odhhfqGIWha3HI06QxQs16hzacuuvFyU11PEN6WYihDdx296w2V/4B2T?=
 =?us-ascii?Q?7ZoTVxW1iK1jG7Xlcxc3PYbG/ClX9N0caibdoNEMOcymALlEqYzF+M3/Y3IL?=
 =?us-ascii?Q?WHGoufSf4QyCRuvBR7SU7q/HuqI07mJ/7Qo2Tk7HQsr2h/vOc+Ute5l1w2lL?=
 =?us-ascii?Q?UnWtaK17M/sUhrrL3fJkZaWAoe4CW/K/qVidG7e4yvp7hpzBwgOmZDPnkAjx?=
 =?us-ascii?Q?RIE/XkaxYV1m108xqhpf75lS6sn//xKKs4qWyp1lAJZU/fDl5tG/dD/yjQzi?=
 =?us-ascii?Q?ZjckihIoVSVeUQKcXt5tNILJ+JnnDg6Ntd38VgAEKgY7cuavx3e04gRoZJZy?=
 =?us-ascii?Q?LJlH1f2B9Apr+az2BZikecCidEvSpncDa5Fv+1AcSfDpJZvo37k4fP1Hmm7B?=
 =?us-ascii?Q?MChXJYaEV749UjmvTqdW4jFDvqwvPslbGLJqJ4yjr6p6e5cPBHFHI4jRzPZU?=
 =?us-ascii?Q?R/tnnhus4lAEnyGOnV7aDSgRxqya9DeKZQpiWrtc1JVyryc7/DQBPTwjJV31?=
 =?us-ascii?Q?ACOlClcvW9GG/deRoRGTdSYu4Kt6jD4vlMa5/P6N64uuD2aAPUZw1VBmDYiT?=
 =?us-ascii?Q?fjBxjIDBsdux1IF4yyedmBJGRAxXQxgSzeOBKpqsYmOGCv7jAyErDV0B/mW+?=
 =?us-ascii?Q?ubQq2FFNDfrd4HX+yKoNf6T+bTBWBBn/6sYAz3TiwRMAbuMplkYnG2EMCkA3?=
 =?us-ascii?Q?0RTZmP633vX+r5Gfzkcq5r8YBOvkLON9x1FmjkQN3pXD4LSapsviPT5/V8rD?=
 =?us-ascii?Q?vym5NIzWOAoLgqqShHF1wHP8z3ZWQF1XcQ1pJEuRpYT4zYiEYFx3yw9qjeX3?=
 =?us-ascii?Q?t1V6jrS0Jn4AG2OSWiEDvxsBDMk56M00pkVff8/0JgeJHh9ReNvC90uLPGgI?=
 =?us-ascii?Q?RYdHIrPKNXmfJVz8JgVvBInEFc9jbmAAwFxajXmDAChGSVpeoDtFaeay6TlB?=
 =?us-ascii?Q?ixDv2kkN2QwdURL76DI9ZQuZxufL7jBpZq5oxd4KglLuMu7sZFYQk69nxBRd?=
 =?us-ascii?Q?th4aU6QElbxFM54dx4naUPfR14wwNpEueiyfM6GpUZtvBmJevp9+6pVOHJQZ?=
 =?us-ascii?Q?Bf553i37Ul+GbDSIOnTQ51QDcCWwBTyOLHTcgt1R7DjldewK3I+vNRYg1Pon?=
 =?us-ascii?Q?WYlUhCLsZdqCK3sNGagEZ8DABsgsT39VjBVb8w9uM60LKcwSRP30+8KXxWSm?=
 =?us-ascii?Q?fXLgyuBW8PNh0dXRpAAbMn1AuOgl/7aUrs54C+XRJMfP+Tbhjh3VOZwDLypk?=
 =?us-ascii?Q?d8gvyCuE+HdnfqopG1vu1AlMGbRnQI9BH/P3vWkrbmmtUNu4LzP3Yr+x7aIl?=
 =?us-ascii?Q?SdS57TDw7miumGoCuLc7e/vHWU5fL1sU+awxk1W9XwPHhCE5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54221de7-1600-40cc-bb99-08de73db51c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 19:31:33.9636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SW84eVMjkrqFQCwHQX9gzuKx3vUyc1iBXVoHTCbJ0GvtWqItiGOuuwecQnkg3nOG8095PJ4cMnQ+gjDHRuS8pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4783
X-Outbound-SMTP-Client: 72.163.7.165, rcdn-opgw-4.cisco.com
X-Outbound-Node: aer-l-core-01.cisco.com

On Monday, February 23, 2026 2:00 PM, Bart Van Assche <bart.vanassche@linux=
.dev> wrote:
>
>
> Move a spin_unlock_irqrestore() call such that the io_lock_acquired
> variable can be eliminated. This patch prepares for enabling the Clang
> thread-safety analyzer.
>
> Cc: Satish Kharat <satishkh@cisco.com>
> Cc: Sesidhar Baddela <sebaddel@cisco.com>
> Cc: Karan Tilak Kumar <kartilak@cisco.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/fnic/fnic_scsi.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.=
c
> index 29d7aca06958..f47c92dfbfd0 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -471,7 +471,6 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Hos=
t *shost,
>       int sg_count =3D 0;
>       unsigned long flags =3D 0;
>       unsigned long ptr;
> -     int io_lock_acquired =3D 0;
>       uint16_t hwq =3D 0;
>       struct fnic_tport_s *tport =3D NULL;
>       struct rport_dd_data_s *rdd_data;
> @@ -636,7 +635,6 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Hos=
t *shost,
>       spin_lock_irqsave(&fnic->wq_copy_lock[hwq], flags);
>
>       /* initialize rest of io_req */
> -     io_lock_acquired =3D 1;
>       io_req->port_id =3D rport->port_id;
>       io_req->start_time =3D jiffies;
>       fnic_priv(sc)->state =3D FNIC_IOREQ_CMD_PENDING;
> @@ -689,6 +687,9 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Hos=
t *shost,
>               /* REVISIT: Use per IO lock in the final code */
>               fnic_priv(sc)->flags |=3D FNIC_IO_ISSUED;
>       }
> +
> +     spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
> +
>  out:
>       cmd_trace =3D ((u64)sc->cmnd[0] << 56 | (u64)sc->cmnd[7] << 40 |
>                       (u64)sc->cmnd[8] << 32 | (u64)sc->cmnd[2] << 24 |
> @@ -699,10 +700,6 @@ enum scsi_qc_status fnic_queuecommand(struct Scsi_Ho=
st *shost,
>                  mqtag, sc, io_req, sg_count, cmd_trace,
>                  fnic_flags_and_state(sc));
>
> -     /* if only we issued IO, will we have the io lock */
> -     if (io_lock_acquired)
> -             spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
> -
>       atomic_dec(&fnic->in_flight);
>       atomic_dec(&tport->in_flight);
>
>

Thanks for this change, Bart.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
