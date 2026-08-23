Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DBA39D3FD;
	Sun, 23 Aug 2026 05:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787461860; cv=fail; b=XJtzUXvEkbiZEnZ5eN9RdshYZMfEmeUPbRMZ6ZXx3GeGql6v3UWwlW/Zno44m0zFqW0cf+3eIDeHCQhlmTradtt6W/aENh1tjsYyOFgSwvQdkkWHyadIhkfGfM2B4rl52k41w6f/S7qLDOysrpoEC3by2/HNu3KRMjpKSGNIOCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787461860; c=relaxed/simple;
	bh=ZZG6h9Wj7iuse3Jd5CNuRylg8DL9ghYLqMFaNPZ/+70=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mOUcaLr09v1hoBNGWcwSUtBzEiSYkaj7skjRc64tXfs8OqZMPONJm7fqayw+jsdwQ7U1kLwlh6VkIhYnu7OKajV4a/qa1bRvKe2Q5anrg/3kyH6imgtnXGZLROtWIzkFBFalBoglrFQFxul7eaYEPmdF3ORwFG1zfSWZ/MM5sTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=k5qrSkqF; arc=fail smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="k5qrSkqF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2181; q=dns/txt;
  s=iport01; t=1787461858; x=1788671458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AbwTJftiuRi31J/k2Z+DNHpUsNSGYoKMm3ahL56RZ0s=;
  b=k5qrSkqFCnHDg6k3wEyFpqzYQup5zYtWi1AtDGNUV/n7KMnT94cLWzLu
   Btk+mQiwMdo0pS4cjrwhSCkdGwSuzdyilpadgBaVRpASsKlggUcVvwFvN
   vsKLt8EB5WR+nTq07oyUHdk1y1HYMRFj37nGcaHgYyxDZkgSm099tqCmh
   tvQsgnE4Uqmsjgby9hM0BnqdN15y9yr0nJR/SS4JOtGaitLe7WHtTJ3Yj
   WoSKAL2jki362cVw1LpW8PAZB09ZS22wyNpDl+nS7PHlzm/QgAQVcMP9H
   Dr0GDf9Yq3MpExoef3VRaVWtEu+f2B6FUtZqv0dxapCyUGyjfq9g4pZit
   w==;
X-CSE-ConnectionGUID: VoF18Uy6RTmZf+Mxq/y/ig==
X-CSE-MsgGUID: QVw7jpZ7S1C4cxBUU+eZdQ==
X-IPAS-Result: =?us-ascii?q?A0B4BABPf4pq/5EQJK1aHgEBCxIMZYEgC4FuU4IrSYgjA?=
 =?us-ascii?q?4UrhliCIQOeG4F+DwEBAQ0CUQQBAYUFAo1sAiY2Bw4BAgQDAgMBAQEBAQEBA?=
 =?us-ascii?q?QEBAQsBAQUBAQECAQcFgQ4ThlyGWgEBAQEDJxM/EAIBCBgdARAxJQIEAQ0FC?=
 =?us-ascii?q?IVvAwECtAICihx4gQEzgQHgORQBgTiIXgGFeIR8JxuCDYFXgmk+hAo7hBOCM?=
 =?us-ascii?q?ASCIoEMgX2RWlJ4HANZLAFVExcLBwWBI0MDKi8tFg0PEykFLR2BIxIPHRcXH?=
 =?us-ascii?q?lgbBgUSICpBRCMDPoEZQQKBdT8jGTZ6gQlegSspYAECEBdGLhWCBwKCWoEnX?=
 =?us-ascii?q?gIBSUMOB0giC209NxQZAwSBNQWOVB+CTAEBYyqWUYJpAbAiCoQeohIXhASUF?=
 =?us-ascii?q?5JRmQgjo2iFDQIEAgQFAhABAQaBbwgtgVlwFYMiUxkPjl/PXXk9AgcCBw4DC?=
 =?us-ascii?q?5FogX4BAQ?=
IronPort-PHdr: A9a23:5YYwCBa5ayRjfnlkMSsKWMj/LTAchN3EVzX9orIuj7ZIN6O78IunY
 ArU5O5mixnCWoCIo/5Hiu+Dq6n7QiRA+peOtnkebYZBHwEIk8QYngEsQYaFBET3IeSsbnkSF
 8VZX1gj9Ha+WXU=
IronPort-Data: A9a23:IaYrjqnVTO2XkcA+gNhug9Ho5gzpJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xIZW2iObKzYYzT2KN5/bd618U9TsJLXyNJnT1ds+3g3QltH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+ZC31GONgWYubDpEsfnb8XuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FbMf1L8nPHAQz
 8AdGj5OSwCawPPxwb3uH4GAhux7RCXqFIobvnclyXTSCuwrBMiTBa7L/tRfmjw3g6iiH96HO
 JFfMmQpNUqGOkESUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIqMJYPRHpQMwS50o
 Er/wXumAAkoa+fG4maO4liRu6zCry/CDdd6+LqQs6QCbEeo7mgSDgAGEFi2u/+0jmagVN9Fb
 U8Z4Cwjqe417kPDZt38WQCo5WWPpR80RdVdCas55RuLx66S5ByWblXoVRZIbNgg8ctzTjsw2
 xrRz5XiBCdkt/ueTnf1GqqokA5e8BM9dAcqTSQFVgACpdLkpekOYtjnFb6PzIbdYgXJJAzN
IronPort-HdrOrdr: A9a23:0EPv3qkjtl6qzBKEXEwhr45EmDTpDfMjiWdD5ihNYBxZY6Wkfp
 +V7ZcmPE7P6Ar5BktApTnZAtj/fZq9z/JICYl4B8bFYOCUghrYEGgE1/qs/9SAIVyzygcz79
 YbT0ETMqyVMbE+t7eE3ODaKadv/DDkytHUuQ629R4EJm8aCdAE0+46MHfmLqQcfng+OXNNLu
 vm2iMxnUvZRZ14VLXdOlA1G8L4i5ngkpXgbRQaBxghxjWvoFqTgoLSIlyz5DtbdylA74sD3A
 H+/jDR1+GOovu7whjT2yvp6YhKmNzu891HBMadoMkYIDfhh2+TFcVcsru50wwdkaWK0hIHgd
 PMqxAvM4BY8HXKZFy4phPrxk3JzCsuw2WK8y7avVLT5ejCAB4qActIgoxUNjHD7VA7gd162K
 VXm0qEqptsCw/aliiV3amLa/gqrDvwnZMRq59Vs5Vta/pZVFaXl/1HwKphKuZFIMs90vF+LA
 AhNrCG2B8cSyLrU5mQhBgd/DXrZAVyIj62Bm4fp8eSzz9a2Fp9z0ce2Ygju01ozuNmd3GBjN
 60bpiBU9p1P5IrRLM4C+EbTcStDGvRBRrKLWKJOFziULoKInTXtvfMkf4IDcyRCdU1JaEJ6d
 z8eUIdsXR3d1PlCMWI0pEO+hfRQH+lVTCozs1F/ZB2trD1WbKuaES4OR0Tutrlp+9aDtzQWv
 61Np4TC/j/LXH2EYIM2wHlQZFdJXQXTcVQsNcmXFCFpN7NN+TRx6bmWeeWIKCoHScvW2v5DH
 dGVD/vJN9Y5kTuQXP8iAi5YQKaRqU+x+MGLEH3xZlm9GFWDPw/juE8syXN2v22
X-Talos-CUID: 9a23:/BhGdGOHG6T1X+5DZi5JrR4pC54fTnjvwjT1M1b/GCFoR+jA
X-Talos-MUID: 9a23:83kgtgnh8/uuUhSvmDfednpbCtg34bycV3tUuskNq+O5CG99CTuk2WE=
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-08.cisco.com ([173.36.16.145])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Aug 2026 05:10:55 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-08.cisco.com (Postfix) with ESMTPS id BFA8A1800046E;
	Sun, 23 Aug 2026 05:10:55 +0000 (GMT)
X-CSE-ConnectionGUID: rr/OQn1iSEaj7EL1sHDsIA==
X-CSE-MsgGUID: iTmpL3EUSuCbwxrv+oZhMQ==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.25,238,1779148800"; 
   d="scan'208";a="84360525"
Received: from mail-westusazon11010056.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.56])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 23 Aug 2026 05:10:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A5bnfM8Z548DIOvMENP6OqX09sboyBjko4EKD0tCdj+CVUy6JarYZQOH7uwpeyOzZO9BqzcrUkK5G1O5kHFLixx1D//n6qgmxVWnQsKGXSegFYmXLlQsidHgD0leO8BlcjPX4WK+UphsYUzBSxba6L07jpG45B3aRjZKOmH84iC0HE0SmJHr6LwxiJLNRCaT555bW0mVqoL6SkDqJtL/kJvRVuWc35vjf5TZHMBjdp+hE7+kUmQQNc5CWPbCAGhv4/wtnA+MEGJzmm3i4XAOtwStKmRTyNsSXqK6h7waskHpWYfVQD3jdH2u37kBrDJ/D3HRvH456nbL5Nk7jA1aeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbwTJftiuRi31J/k2Z+DNHpUsNSGYoKMm3ahL56RZ0s=;
 b=LK5LP+eWMTt6FSXvVQBeMpqjdON8h+S4APgwtFiEgjGuZeSXu7lQdbUSDjLIQdYiOCQMyVz68CmvTzFX0UFqa4JfNCMzAfi/XLAbtReZkJygYd73lQ4Q9a1hsKDRzPhaC0FFezVhFh3ZT0QmoBC1LqsYPTIVWBI5VlkmYljnoVMoqVlD8hhYoCJgDkIMHZ1CptoR2/JR0oaD073gYpxBdQzBboZO5IaxqOl0K6Ejy7RFSw89hgFCDbXmIiBrqzlMQEdXme5cCyBr2SEfeISZGhbxj3M2MzYgnttIS7Rmx8yd2XTQEmVz157x+s/Mn3rg3or84y7cSgzE54CgPew4Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DSVPR11MB9743.namprd11.prod.outlook.com (2603:10b6:8:34d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 05:10:52 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::41fa:d12d:31c1:d5db%6]) with mapi id 15.21.0339.010; Sun, 23 Aug 2026
 05:10:52 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Linmao Li <lilinmao@kylinos.cn>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
CC: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Hannes
 Reinecke <hare@kernel.org>, Justin Tee <justin.tee@broadcom.com>, Naresh
 Gottumukkala <nareshgottumukkala83@gmail.com>, Paul Ely
	<paul.ely@broadcom.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: fnic: initialize the NVMe local port info
 before registering
Thread-Topic: [PATCH 1/2] scsi: fnic: initialize the NVMe local port info
 before registering
Thread-Index: AQHdL8/tiO9knU7kREqpjtsF7UOa8LarGafggAABhbA=
Date: Sun, 23 Aug 2026 05:10:52 +0000
Message-ID:
 <SJ0PR11MB58963CA2B53ABA6D1E89A0B1C3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
 <20260819114242.3598034-2-lilinmao@kylinos.cn>
 <SJ0PR11MB5896AC03937115745995EFDFC3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
In-Reply-To:
 <SJ0PR11MB5896AC03937115745995EFDFC3A12@SJ0PR11MB5896.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DSVPR11MB9743:EE_
x-ms-office365-filtering-correlation-id: 8c607b40-7a1f-4f20-a9bb-08df00d4e76e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10067099003|56012099006|22082099003|18002099003|5023799004|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info:
 2i++PAJsmMtBYEKP3ZXzAhoFsqSycnOsgh5oAMKVLPzoBHuZ+snay+yT/WZfuTTrKfva++qEY35zpfjC+LFPos3lAkchs21TPWJ4CRZqCjffwWKZfrRXBJAk0U+6oSMgboiQ745LIMMRipzCIzpjQypI6H0qAyII2tEUm3Ovwe/jDzW+OLur8iSb7srJQjPWijepUy/+DZx8bxC7Hh91GDWaWO0IsaWSucDBAV34QXpc26Iaybc/6TSuwJF1+7QMox27tWX97jM47dEcH0eQwkR6rrcnZr5bc0qmxQWZ/e4cyaO6yPLbYOkR/jHg7PFJ2bjdOtmKkVSc/8H9ClINObLc7y7Dytpp2oCLILkdNndSBsxVjIEgpyH5jLJoeSHuufuNp73WI2KSpJAL99nZ6Hdji/R5kSRYNaxfCWyGhnrDNTtryFd2Z3fNMfZpE6X5GhrngZFiE1ozoU6wfpIgDK5pHA33gg270Iu24YnR58T0ya6bqju0jDzlNDX2v0XhwUWSdCQbs35rPOCTQZgEoyT1Yh169XgsXpC1tEN924G/3njMqNLWDgb6KjgopGSx382Jf1gRqFSfJu1Tsk4mUID4rAB+WOxKAdG0OSz3g/w8Hb4rL5AfwYrWCR5SBq9A+CGzwMpIePb+5c1mXEWnLV/AI8g9qfTWC4pdweEc/zilS1Xh7jaGAcJRlS5zS6ZjKJqZeOlOLWIVVpHYBcJH0o9LZ75Qobm5aY7Ob7MejHU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(5023799004)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YNdgxi5E/Dego7FxkTFeMD99xBJLbHsQGRImKTZwwIkimkE7Byq+tgIwY86b?=
 =?us-ascii?Q?OPRO5Qu2vg/LU9Nms/yTIGbn2IFllDPbsHHWIP7ZjxwXzmIJHs5Rhl9CrgiV?=
 =?us-ascii?Q?MB7ApUozokP8CSKnlthv8aoGpcvwT89ncFiN4j210DzV4DG2IggN4f8vCbkN?=
 =?us-ascii?Q?SYaJYrgoE6VpT3UXBotXJ14pvD3aWOnT9GLj1fZ+JaVr0TbxHLZSwe9H8GeY?=
 =?us-ascii?Q?YyDVattoz1fM/58xVr914/j9y5sepdm/SwUOh8CZTfSmIpM656dmVF+beFRY?=
 =?us-ascii?Q?TY2tiLM6HNC1ox1aTEfXcnurtWLl7qFk8hs2RvFwTPMwV6/Wot4lO6Gb/d/M?=
 =?us-ascii?Q?YPto986zeBd/eLyDC8spoFxeh9RcIJbymmiUEPADpDxIcYaLv3BJipSsUgX7?=
 =?us-ascii?Q?qGIatc7Fxx4zwfltbAgSCkxXR+IkCmPsv6c0BayE8TCDD3SvyAusWltI0olC?=
 =?us-ascii?Q?Ik6J0BrDIQIWsl8rwzeM22i8pk19ElyTC1EcTB+MH1mpOVswKb9f45CmZRWU?=
 =?us-ascii?Q?PP5ldnonpmDazz3JS8qD0mVBV9uJOOlB4PxlMetPWk2YRAUvknI5MAryFWcw?=
 =?us-ascii?Q?jg7UiVwIF4WPId8LehaVdCobDMrwQlxqvTYhGNMjMH6J6RRHNLlSrcr06OuA?=
 =?us-ascii?Q?lhcA5UqkQaHtTkgrNODAhi0VQxOBsY2A+mWUhyE8znRAjSLLVBhTAwzui8RG?=
 =?us-ascii?Q?oUL42ksdsoOJdfYAdVouvcqMb2NNoenCseuTZHG1pt0MyRXWwheIJZ+TqEsa?=
 =?us-ascii?Q?u2rLpin6WjsAqFJ+fjoTPOcpeZJDjSZssGoV2TAaj2DoZNQ82a+kovtwYaXc?=
 =?us-ascii?Q?wCH8YjSbBd1Urp1kSES+7fOj3N0Szv7OJQBA5qopaujq85tAr2pKOCSArRym?=
 =?us-ascii?Q?3pC1JlT8SaECCjVqeBqulKvmok8/MamJM4EBal6hjjx1zK5BOsM7GUx57Uje?=
 =?us-ascii?Q?oT7Za6VdMyaiOqSJlIUh1mgzYKrK6eQeFen84lFQVJ8lLkTU0iHC7t5nZibo?=
 =?us-ascii?Q?AfLrOrYHQBs07OsOl+k75eOz059FqNSSNImOxiMwhOGk4M714fq8Ymxekzov?=
 =?us-ascii?Q?UwJA/tTkchPz2pIdvsunFIL7XiKgE1d1CoFXajqcNC+mNE7yhWbadmtRZ6CC?=
 =?us-ascii?Q?uu9IpeZy76K3x48PoeQWRZHYrF/Jy0uCyy+gjmb0j16MJyLWKBjGrJpjhIcb?=
 =?us-ascii?Q?fHNZqHqx3a7UVZJEmy2Cw6ehHB3M4T/7ieQtwipW1XnC3C6+zmjCA8Zd3gSc?=
 =?us-ascii?Q?yCmPS5x2zpWv+hN8ju/n3EsPaWyL04XfZaEN7K1hdcB1HjiWA3WMfBbkOuYU?=
 =?us-ascii?Q?JxPiUtPADWxqJeMinY15BqVJYkv7608WuXsfIhjJ0fgqfbrj5BIT4aYyEox3?=
 =?us-ascii?Q?0Gzv+DytmiGss0Hram+DxxLE4oKkRgs6jisWpETT3vw64I+ha+AdFwK/yhCy?=
 =?us-ascii?Q?z9bPDvGnlsULNTwP9ftyNdiyhGaAptDLYIkNLe/oug5xaxwafQZNk0is1OWn?=
 =?us-ascii?Q?OAI2aK/j9DeL4jzxk1X0gIGajYUN4XKHY5llh3Gofpf4vfiNGUzfulmb5ZTO?=
 =?us-ascii?Q?h78Eb1KTYKS5YKqltUkkZQjQJcIIDqx/vbnIQjWSVrMS7BEsqN0eapMbY756?=
 =?us-ascii?Q?HhbqAlbQ2xDyASD69ZbOnZZ+5LZPJ2MVfTezws4vZucmhrzNBAgAue4bUkmg?=
 =?us-ascii?Q?SIe6ylzZSFWyPIoupNqSErHD8H52dsg4W8N0xxJxdB0nwXnV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	lUXWKb+RvyDkKu/DtFC+pA3iEgS8vbZYAnru2/lqLZBoMm6v7ciNuXCuiUpKmnnZ1RF/luSD8vi5dX+j6ujeDRvco2LbFNeaAJSej6sI+/Z85H6MrySJAmjG/g5rV9PGKc5/xrzsKAkP4w+5z+krs2yYnYIBxPRWVcEt5cBc4u/dWAhD2kvtVHgPD480mIRlHpPTrvr9y1hZ+XNRno86t8vIGqwOvgSw+QO/ISKRKmGN/v4ETCPrBfNzhLyrvsnhAUOuPGpdoSzgxrsLeCLjYu/K8B+03Z5h0/AFbsIvMomvpesVpoHGqYv6SnvZKAeY0yWq1w4cykgQWn0ZcTSjoA==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5896.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c607b40-7a1f-4f20-a9bb-08df00d4e76e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2026 05:10:52.5451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: glfarMI2t4+TYtFpybQl7kLXspr1P8THTMElUL3Tbzmy0GgzDax67aAa8CLw5rApReGgrjFSjP5tTxB/3Ah38w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR11MB9743
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-4.cisco.com [173.37.147.252];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-08.cisco.com

On Sunday, August 23, 2026 10:35 AM, Karan Tilak Kumar (kartilak) wrote:
>
> On Wednesday, August 19, 2026 5:13 PM, Linmao Li <lilinmao@kylinos.cn> wr=
ote:
> >
> > nvfnic_add_lport() declares struct nvme_fc_port_info on the stack and
> > fills in four of its five members, leaving dev_loss_tmo holding whateve=
r
> > the stack happened to contain before the call.  The structure is then
> > handed to nvme_fc_register_localport().
> >
> > nvfnic_add_tport(), which registers the remote port a few lines further
> > down, memsets its own struct nvme_fc_port_info first, so only the local
> > port path passes uninitialized data across the transport interface.
> >
> > The NVMe/FC transport documents dev_loss_tmo as "Used only on a
> > remoteport" and does not read it in nvme_fc_register_localport(), so
> > there is no behavioural change today.  Initialize the structure anyway:
> > the driver must not depend on which members the transport happens to
> > consume, and any member added to struct nvme_fc_port_info later would
> > silently start out as stack garbage.
> >
> > Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> > ---
> > drivers/scsi/fnic/fnic_nvme.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvm=
e.c
> > index b237948dcafdc..00d9d5d439a38 100644
> > --- a/drivers/scsi/fnic/fnic_nvme.c
> > +++ b/drivers/scsi/fnic/fnic_nvme.c
> > @@ -2216,7 +2216,7 @@ int nvfnic_add_tport(struct fnic *fnic, struct fn=
ic_tport_s *tport,
> >
> > int nvfnic_add_lport(struct fnic *fnic)
> > {
> > -     struct nvme_fc_port_info pinfo;
> > +     struct nvme_fc_port_info pinfo =3D {};
> > struct fnic_iport_s *iport =3D &fnic->iport;
> > int ret =3D 0;
> >
> > --
> > 2.25.1
> >
> >
>
> Thanks for the change, Linmao.
> It seems simple and straightforward.
> I'll bundle it up with the other change in our internal testing and get b=
ack to you.
>
> Regards,
> Karan
>

Just realized that you've requested to drop patch 2/2.=20
I'll do a build and load of this change and check that nothing's broken.
I'll get back to you.

Regards,
Karan
