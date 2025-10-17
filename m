Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E22F12BB;
	Fri, 17 Oct 2025 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720398; cv=fail; b=OlUr3wCEOy6WbdW5M+zVs7mroGJ2XqFNCBcEPj8Gd3Famvv/VC8P3qSZdjxszjhhRMigEllcWjBX1+TFAYhW4sB1VuHtczSLdM5dnlml0KYSfSjYpnjfgWjWGD3EySYtW/akonW/3LmRkVnixSqYLrt+LURmXq89hX9citgi3io=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720398; c=relaxed/simple;
	bh=yCs+gT0sBN2OzCqSNdywWG73s8hTCfHASSFLyzN+uvQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lOz0BNMUF6ZD9tRfYCBcOXwNd00vL1K1vZXKiex8yjDAb+5PHIkK9N2GRhd5vVfAr2axoMwJfhlcS7E44owDu9U8s5NoM+COFoyY4NqecW4TxY79WuDhqHF11oBF5vi+kAQXPPf5fmYBxShg/H8pALCd/AQlZTNCM6f+uh5OHJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Rrg26WC0; arc=fail smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Rrg26WC0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=948; q=dns/txt;
  s=iport01; t=1760720396; x=1761929996;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=riVso5O3kcBsaU0t7SH0/Jwq/DYEgVNbC4g3hHSx7Vw=;
  b=Rrg26WC0wO3tpK3/liFHnioJJquL1WVB6knr7UvyGUJgEwssOCTmUL20
   PTwlG4gIy34ae8Ru09l2V/rZFf5bb+dKPWNVjXOIUmLGw0hrlPVS4IX0m
   b9kDKxuF1Dk5OM9q3p0Vteeuwk8ImyrUxYpLfKghWGpcAAVouQeFJ7nqU
   fD3TVQLCXYf3LRiL7XA+UGigqLAC5o6efSmpSM3gx0XSuO/OqsOacpqid
   8sIkMQay2u6SGyGMuHfXtxZGh9gP2uQp1tIgxf5HAafm+cpnwYXwi6P9M
   OTJL7tgPEZKLU9ExF6htF5YmaZJNNZ0z8y9hykayaG6DPj4GtlOmhjM2K
   g==;
X-CSE-ConnectionGUID: P9k90i5TTYOatWFLzTLAdg==
X-CSE-MsgGUID: DnAiPiYIRqKdIZTd9RWLvA==
X-IPAS-Result: =?us-ascii?q?A0AOAABOdfJo/44QJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAUAlgRcGAQEBCwGBbVIHggkSSYggA4RNX4h7nhqBfw8BAQENAlEEAQGFB?=
 =?us-ascii?q?wKMSwImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGX?=
 =?us-ascii?q?IZaAQEBAQMSFRM/EAIBCBgeEDElAgQBDQUIGoUbAzYDAQKjVQGBQAKKK3iBA?=
 =?us-ascii?q?TOBAd0+BIJkgUoBhQKDTgGKZCcbgg2BV3mBbz6ECjuEE4IvBIIigQ6GMIJxj?=
 =?us-ascii?q?jlSeBwDWSwBVRMXCwcFgSAQMwMgCjQtAhQNIg8EFgUtHXMMKBIQHxwTYFRAg?=
 =?us-ascii?q?0kQCwZoDwaBExlJAgICBQIrFzqBaQUBHAYfEgIDAQICOlcNgXcCAgSCLoEQg?=
 =?us-ascii?q?gofD4Y9AwttPTcGDhsFBIE1BZI1gnoBgQ4cgg0XxxoKhByiDReqay6HZZBzI?=
 =?us-ascii?q?qh0AgQCBAUCEAEBBoFoPIFZcBWDIlIZD6FeAbMEeDwCBwsBAQMJkWqBfQEB?=
IronPort-PHdr: A9a23:iqV9NBUxp/jhOK0KQQN55ksGbWjV8K3PAWYlg6HPw5pHdqClupP6M
 1OaubNmjUTCWsPQ7PcXw+bVsqW1QWUb+t7Bq3ENdpVQSgUIwdsbhQ0uAcOJSAX7IffmYjZ8H
 ZFqX15+9Hb9Ok9QcPs=
IronPort-Data: A9a23:MH11BanHqydqtEqEmPYNxT7o5gzpJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xJOCD+PPK7YZ2L9Ld93PNvj9x4A75TUnNIyTVRp/itgH1tH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raP649CMUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+py31GONgWYubztMsv3b8nuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FbVJ+bcvADxyy
 c0/ISwyQDSRu8afzL3uH4GAhux7RCXqFIobvnclyXTSCuwrBMieBa7L/tRfmjw3g6iiH96HO
 JFfMmQpNUqGOkEVUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIeFJIbQHpUEwy50o
 Erq+U34OhArFeaG6jakwE6g19XwuT3SDdd6+LqQs6QCbEeo7mgSDgAGEFi2u/+0jmagVN9Fb
 U8Z4Cwjqe417kPDZt38WQCo5WWPpR80RdVdCas55RuLx66S5ByWblXoVRZIbNgg8ctzTjsw2
 xrRwpXiBCdkt/ueTnf1GqqokA5e8BM9dAcqTSQFVgACpdLkpekOYtjnF76PzIbdYgXJJAzN
IronPort-HdrOrdr: A9a23:lXefzqxTgLhSHP5ybJKeKrPxY+gkLtp133Aq2lEZdPULSL36qy
 n+ppQmPEHP6Qr5AEtQ5+xoWJPtfZvdnaQFh7X5To3SLTUO31HYY72KjLGSjwEIdBeOjNK1uZ
 0QF5SWTeeAcmSS7vyKrjVQcexQveVvmZrA7YyxvhUdKD2CKZsQkzuRYTzra3GeMTM2fqbRY6
 DsnvavyQDQHkg/X4CQPFVAde7FoNHAiZLhZjA7JzNP0mOzpALtwoTXVzyD0Dkjcx4n+9ofGG
 7+/DDR1+GGibWW2xXc32jc49B9g9360OZOA8SKl4w8NijsohzAXvUgZ5Sy+BQO5M2/4lcjl9
 fB5z06Od5o1n/Xdmap5TPwxgjb1io04XOK8y7avZKjm726eNsJMbsEuWtrSGqf16PmhqA77E
 t/5RPdi3OQN2KYoM2y3amRa/ggrDvFnZNrq59hs5UYa/peVFeUxrZvpn+81/w7bXnHwZFiH+
 90AM7G4vFKNVuccnDCp2FqhMehR3IpA369MwM/U+GuonFrdUpCvgMl7d1amm1F+IM2SpFC6e
 iBOqN0lKtWRstTaa5mHu8OTca+F2SIGHv3QS+vCEWiELtCN2PGqpbx7rlw7Oa2eIYQxJ93nJ
 jaSltXuWM7ZkqrA8yT259A9AzLXQyGLH7Q49Ab44I8tqz3RbLtPyHGQFcyk9G4q/FaGcHfU+
 bbAuMhPxYiFxqYJW9k5XyLZ3AJEwhtbCQ8gKdPZ26z
X-Talos-CUID: 9a23:EFgFR287kHq9q59TrmaVv3ZFGZF9cyDh8Eb3KlOHJ0J7dJm8RVDFrQ==
X-Talos-MUID: 9a23:iWoGPwtu48B575gWtM2nqDdLNf9p0oWUEWMBsKc6t5i+CghuEmLI
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-05.cisco.com ([173.36.16.142])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Oct 2025 16:59:55 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-05.cisco.com (Postfix) with ESMTPS id 21E8918000178;
	Fri, 17 Oct 2025 16:59:55 +0000 (GMT)
X-CSE-ConnectionGUID: 7SA8972BQuK8k7ik/8NaXw==
X-CSE-MsgGUID: jlgxYPsXQ9OAWQYZnUe0Yg==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.19,237,1754956800"; 
   d="scan'208";a="56365941"
Received: from mail-co1pr08cu00107.outbound.protection.outlook.com (HELO CO1PR08CU001.outbound.protection.outlook.com) ([40.93.10.103])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Oct 2025 16:59:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fiEksbqvj4n7i9foo1i6/e6siAWehIjavgVS0r17IIG7AQheYs0YKVFyElosj+WQvTHxXeWU7rtzIhOvSBUdZxrWnwg84BkBWcMA+Lgaf6nVfl4sbYBa6TAwb9EJ9+/41bRom+YgwUHj30ldBu+myHhfgYTsXgDrxKSqTZCNjYAJPdg/dXXxZW6hEHy5Jc8U4Pu9zBmK5gr8uWaJzHzlTXwVF/IUoPWvnoe7lFi8Pv6BoSErh8rDthAVGqHxviZuAf4pm0I3rOdwV+W0HEZtqXjjlGUXV41Hu5mUFUQlu+4I2sHtaF0olozKlBk0/ghXBFbnOlMB6BcjtcrZMIZSyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=riVso5O3kcBsaU0t7SH0/Jwq/DYEgVNbC4g3hHSx7Vw=;
 b=AB9VdgsA8rTU6HUvgfqD9IR8fgfHRb5dQQHky2nC/gXNW4JW0AlrnDVBk0e1uBWeM5TlXiBWO9kt1fc5ngOSdU2T8wL6HKje1cY/23cnQFu8A01e2EWGGG1jvzemDzbAg4oXVVZELiwUOYJnmj8gCNy+ha+o+U2Y1F5x7zxU17faZMu527sFYq06hNwVlTOGf+vFs64Lv95IQM422bNpj/cLnQB5ZBtLjNA8zto8HlUNxr0b4bOgGMU74a9y+D7EuBZPg2C9VGSmNC70n1INCzEvMuc8n/67gsUFnFDRr9L0ZzFjYn8RnIeL+1h+fkl534WcRSi03UaE0pAHMlCfkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by DM3PR11MB8682.namprd11.prod.outlook.com (2603:10b6:8:1ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 16:59:51 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 16:59:51 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: "liuqiangneo@163.com" <liuqiangneo@163.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Qiang Liu
	<liuqiang@kylinos.cn>
Subject: RE: [PATCH] scsi:fnic: Self-assignment of intr_time_type has no
 effect
Thread-Topic: [PATCH] scsi:fnic: Self-assignment of intr_time_type has no
 effect
Thread-Index: AQHcPztiagGBbI+dwUS+lNxOH3UBdrTGj9KQ
Date: Fri, 17 Oct 2025 16:59:51 +0000
Message-ID:
 <SJ0PR11MB5896DA752A919EA96B8D24B4C3F6A@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20251017075504.143491-1-liuqiangneo@163.com>
In-Reply-To: <20251017075504.143491-1-liuqiangneo@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|DM3PR11MB8682:EE_
x-ms-office365-filtering-correlation-id: 3d5f83ba-f768-4189-edfb-08de0d9e965e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?lm+R+vDSEFklL07xiWBJ7Kh9L8Gs53fUsWi8+HLDdOt3vp5qxTKPRzGTLrJM?=
 =?us-ascii?Q?qeFkFBOCF8VagqqwJRsgZZ0F6TtO8oNLB7JSFNtCZlZ0LQ/eAyx5KBQtUtlM?=
 =?us-ascii?Q?hIniNTmJMQ2veoqIlV4G9KvVDsUu1s7g9Bm1OkupxE+BA1yXSjz4WtyQ5lTx?=
 =?us-ascii?Q?MHTuDrAEd7d/14MAaCWw3KNNxJZh3u/AKC8gMnkhB1E/wMJOtiz4232VVPqy?=
 =?us-ascii?Q?5ZIypxwUBJz7kqm6vXg6Eq2iXiKmz+9TvdTkEmtL2Do80O8lSrA4C0YmnDkX?=
 =?us-ascii?Q?+t10lsQ5C1RAUbmMhlL67Oz2h4Cplj6lg2q9p5Y0D70erYJGd0vknRl+0HW1?=
 =?us-ascii?Q?F/qOSE/Xk3IxCFLCTczt8iyhsUd4FJDGE9LIqjLLLMLZ+grGUOQVAIZKcPIt?=
 =?us-ascii?Q?0J5A31FxdD6bqYuCJgok2lrqJKeRCG7sWvvX+1akkBkwmG2Z4tqOF+B+eFxW?=
 =?us-ascii?Q?xRa8LLX5kHpVAccnxyjlpMWP9c3f7+lpcuBOtuOCFotnA0bYuWGWVghEn3AS?=
 =?us-ascii?Q?tri9nrlBJW+92V00eFPMgnftH0+XjuywExA27D+pgnQgf5qD6k+lw94PnNlA?=
 =?us-ascii?Q?WaMw3JkKUyeKzr2RsXbfF15spu54qbQLbJZvNi67SoeB9wiRyJdwyi/IGX8G?=
 =?us-ascii?Q?f4B01udAWrdOPHxMd9GpcLzMgFtRlqcrxNnfs8ny7+S93KiExfs4jILeaOhb?=
 =?us-ascii?Q?whopxtc7IdRsF1ED+c8p4LEdiom3NGQDZR560Kh6mTU6YHgyV5w2vOVSRdM4?=
 =?us-ascii?Q?5k5BPyjEUPGxtzHQ81aMIBOHi+xItlUVw6if7ygwQHrmRX6O0u0ZvE59Uy7c?=
 =?us-ascii?Q?Lkb5WIjfu5mvTnqRGERmCA9Z3rVBq6KV9DAT/0U/cGsTfckf4QOP+Bqahl2n?=
 =?us-ascii?Q?+kXKCstQhDqW+kbZPe0wH20KHdPItBJKvrcKv8EVAuhMMj6237sO2UyaDILt?=
 =?us-ascii?Q?DFaBpYd1RSWhQ9mdkDLC4EHB3bN/a/AbVsVqCIL0LabItImtKNXyNqYlfRTp?=
 =?us-ascii?Q?wiKbOaEu2hdRBIVLT0vZbNdd4lM7q9laKGP7dbsGqbfapp8t5x/g1Zl2WTe9?=
 =?us-ascii?Q?P4Eub5HzZTGg31Y+Q419CRUMBFgrZBBaKnN9bw/S778DmZ2MM2/EmZPn2CWW?=
 =?us-ascii?Q?ZyAUpSWMjiYFXbHTprIkUMwpkn8FVaLtObe8P23Ngowq1hTdE1cPBVVclL3t?=
 =?us-ascii?Q?gSaDplONLhzrM78MmUlgwsLwWmUMfBL1BujSL5b5sM3LIwb0zhS01uOUJ/CK?=
 =?us-ascii?Q?3n3fR18e+ZtSpojO6dKDqynQ8AKmPR+taZVyoRBIut+nOfUfUgUf8/nR6zY9?=
 =?us-ascii?Q?RFCk3y2we5ma1eJyuCoUZ+8uYgb6Vs6FgdyU88Qc+a3mfnHnf2D4tzgIwVvp?=
 =?us-ascii?Q?3cFxAq/ub+tTRamVePJONcrzeY/ksyEnF91QVOPH+/El7I0URcOSGnrfTsEu?=
 =?us-ascii?Q?btxwhLmgIwtKJc5DdJULths1y0TIsjpCJslFvuCTDJYxChE4mykvmXIF7012?=
 =?us-ascii?Q?40gw3pj6GC3fE77FkuBn3hgz66a+lvQGEQiw?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?kEIHhotRr1LkIrfKoQTFiM0mrF/FSf9mU60fo9EwRO6O6prFbSN9/m1Xv3A8?=
 =?us-ascii?Q?KGLZVmyjuC1BPE10EjLv5DIaSCMSP9OhNM6dxqVLp/DMyX2lQs0Mlu4/0CB9?=
 =?us-ascii?Q?jcUw6uU8yoc+8grTdZxRqbZokUC9Nb4FLRVb5+jM3jZJw4T3gpqbljkjHcnQ?=
 =?us-ascii?Q?o3ixSLv9DxRD4P92tTp3e/0AhJGCnE8xJGI6FfgB+GCZGYdwSIXyCtVZPQwF?=
 =?us-ascii?Q?KAiKZWXPtmmF+R8tRdPb1AfR9z2aGhoW2BUbHQUVOk7VvK+Avod34+SE0e29?=
 =?us-ascii?Q?XQEGIFnrQmkGn5rfMCOKYLRcjPQ4voinyJUp6+TbUNowb5LuiY9rLn/hsgsa?=
 =?us-ascii?Q?TltE4hzputWR6K9hQrF54WPAn22LCI3m6d7e2Z5TSnR5UajURP84sqcIXkS3?=
 =?us-ascii?Q?8PV2B9Jizn/Bc/wy7k1h/tz8kRPTMt6aYOcZTIL2MXFxHmRW+famQq2EpU0l?=
 =?us-ascii?Q?lzokEpq89utI/q3roVngsD8efg8iVy2oSY82bAR7EHyi9LaBd01R/hsg/LRA?=
 =?us-ascii?Q?BNDgjTGz7bX+Bjc21fOFjsapPN9tmA8WgRcOVmkCsRCLU23A4dhi2yb2bG1O?=
 =?us-ascii?Q?VlB3B5MaU/zpS9Sq9it2xpR6ZokvZrHj0p2rMg4skDyeki3axrf/BssuRhue?=
 =?us-ascii?Q?I68QAyPZpdlQVxGqicqFwgaZhJE29r3//Q0t493mjV9dH9OnxrQW5ztwqyPt?=
 =?us-ascii?Q?/++89H0pmQxjFR2YKPkEMY2I4amKKXjNPgosWYgVnSW2+qOp975vJ5nRkZqr?=
 =?us-ascii?Q?VYgsQXHuLJHkSpQnesuSS0mH8rAiQ43jp1W3GDRwFal2MtTowtDOb67QRAYr?=
 =?us-ascii?Q?b0m090KYKSSJZ9bRFq26XjIs9y3Hc8r7D0zz8iGkhx9cgdjr4tGzK2Xes3N4?=
 =?us-ascii?Q?BAY7GrSUmIX+DLT34JN9m7nAl1hN4addooEYDqTYAqoQO8/lxygdRFdraqww?=
 =?us-ascii?Q?+jkh/joBX8VbJZviRvEnDZD7aZPDB2NqJlOXK/Ota/zHh5rdySqGNP8ujMFv?=
 =?us-ascii?Q?OM2j/ETm8b/chtl/1nihTs6tfsFujStgRr46wubhdJZ1QIm7SRCR1FiP/x1m?=
 =?us-ascii?Q?iGZkprzTvAHFvLWLG15gVWMXRqKuwJp5Qp3Hgj3N7ASCj+ujXBe/slws+3L1?=
 =?us-ascii?Q?w6vXFuR7lhmrTVJYi1hETGSzk9Ft/JWlu0O/mIRrW3lANh7lJQXRmxlGDDVY?=
 =?us-ascii?Q?GqR6Sv8d4xu8oEGfT/xUa9yK75/wPZtUdqtc1EnYHOI+Mopz31dn4TbFvegi?=
 =?us-ascii?Q?GcNxWVEw8SCPD8VHEhx67aotULdghs+85rd6ZyXznUYzUxmlF25Gr1ScOYSM?=
 =?us-ascii?Q?ip8uKScU2abE5ClSN7S3hMl8uliUiv1oJh6qAJKXhbAgPpGUONjPb9+l8FcP?=
 =?us-ascii?Q?ZDFQn6H82eKkzj7ZDyWALbWyakRTIlnlRSV/H3MnD5LtiITq+j2z0YpmFUY3?=
 =?us-ascii?Q?Tj/hO/4OyBGKnvpmiuraW/hWmfzs40s3kYrt7wVYF8M8oGRmxvHrKhu2MqmP?=
 =?us-ascii?Q?J7+Q33v1PrGebxSAWZV5YxGaSLDORf+0YYBW84NrXCFKjsGidd1I/3n9MRBq?=
 =?us-ascii?Q?N9ZuE1c23Fv0/mwBHG6LYYhpg4D8AGrNO2LJm9Fs?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5f83ba-f768-4189-edfb-08de0d9e965e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 16:59:51.1786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bVyghNLzbOa+GcuTWbS0aW8gcGIcnDh3SLdr6hl2PbNJG0Me69L7iGkvsDtDsiX7f2Jx7DuzjxGT+sReDn9FWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8682
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: alln-l-core-05.cisco.com

On Friday, October 17, 2025 12:55 AM, liuqiangneo@163.com <liuqiangneo@163.=
com> wrote:
>
>
> Remove the self-assignment statement of the intr_time_type variable
>
> Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
> ---
> drivers/scsi/fnic/fnic_res.c | 1 -
> 1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
> index 763475587b7f..9801e5fbb0dd 100644
> --- a/drivers/scsi/fnic/fnic_res.c
> +++ b/drivers/scsi/fnic/fnic_res.c
> @@ -134,7 +134,6 @@ int fnic_get_vnic_config(struct fnic *fnic)
> c->luns_per_tgt));
>
> c->intr_timer =3D min_t(u16, VNIC_INTR_TIMER_MAX, c->intr_timer);
> -     c->intr_timer_type =3D c->intr_timer_type;
>
> /* for older firmware, GET_CONFIG will not return anything */
> if (c->wq_copy_count =3D=3D 0)
> --
> 2.43.0
>
>

Looks good to me. Thanks for the change.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
