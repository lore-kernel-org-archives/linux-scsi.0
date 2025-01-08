Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1330812DD8A;
	Wed,  8 Jan 2025 05:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736313579; cv=fail; b=bxYPXTrEzNb8DGws0X+zTwkh+2u9tnKfy+pvVMlZ2j05ZW1y7xkZSwCNr26sHZNt0ljCwnNeMMtJdEJvwCdm/fDAm3HEszD20+qo3wJoJnntC9005TErVL58XtDArdvEwz1kYPmRSyL3dN14XilO25tA7yE3MlzhrGnD4XiJfSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736313579; c=relaxed/simple;
	bh=MpABE9y91tYZA7Z+qNrXQXyzyaIQiXsUTvk3C5Rvqrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Tq701J8vG62R2H55upQz+MrADvxcCbURSznvOQ95Xn2r2gB9ioIRENFaClcXNLn4F1H2ctt6YoVUiiGkUq3OjaQMi737Rr9vN6F2TvSZQrKRtstGbqaB0MpoKIIWR7afYYRGlopZriQhvdseX2iv9E6DEHO5JTpIJ0KjPboZlFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=aULWUy1r; arc=fail smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="aULWUy1r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1895; q=dns/txt; s=iport;
  t=1736313578; x=1737523178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7TFsftzUYCXqUUMDFg8uNu1iRQXeTTOPZP/AL74Ujd0=;
  b=aULWUy1rwvcfNDJj13SJw6zVpNQaUc1YOxJXHtdwV/6dVQpxd1XsLCms
   hud6Hk+ttnSWJ9vswSgta12KKZtwqqscOnBxOJt+DGN9vY6LmLphCTjyE
   Af6eZcjNLqpUGcf7207hxotAQLNuStFGQ5EH6j3jJwsYi2DB7unLszRAg
   8=;
X-CSE-ConnectionGUID: Gr3SVoSDSDq5O6wpzrWydw==
X-CSE-MsgGUID: rJyRIAQoSxmopeZnnnPtTw==
X-IPAS-Result: =?us-ascii?q?A0AEAACXCn5n/44QJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBQCWBGgUBAQEBCwGBcVIHdoEcSIghA4ROX4hyA4tjkjWBJQNWD?=
 =?us-ascii?q?wEBAQ0COwkEAQGFBwKKdAImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOFew2GWgEBAQEDEhUTPxACAQgYHhAgESUCBAENBQgagmCCM?=
 =?us-ascii?q?AMxAwEQpUcBgUACiit4gQEzgQHdOg2CUwaBSAGILx4BimInG4INgRVCgjcxP?=
 =?us-ascii?q?oIfQgQYgUiEE4IvBIIzS4ErgllnnhNSexwDWSwBVRMXCwcFgSkQDysDIgs2M?=
 =?us-ascii?q?QIVDw8TBhEEbgU1QTqCDGlLNwINAjWCHiRYgiuCIYI7hEeEWIJLVYJIghd8b?=
 =?us-ascii?q?wMDFhOCfR1AAwttPTcGDhsFBIE1BZptATyDTx8BgQ4cEIIUKSvFLnEKhBuMG?=
 =?us-ascii?q?I83hi0XqlOYfCKNYoQFlnoCBAIEBQIPAQEGgWc8gVlwFYMiUhkPji0WFoNCt?=
 =?us-ascii?q?W54AjoCBwsBAQMJkRwBAQ?=
IronPort-PHdr: A9a23:TuC4GBIB2L2JzSQR5tmcuVQyDhhOgF28FgcR7pxijKpBbeH6uZ/jJ
 0fYo/5qiQyBUYba7qdcgvHN++D7WGMG6Iqcqn1KbpFWVhEEhMlX1wwtCcKIEwv6edbhbjcxG
 4JJU1oNwg==
IronPort-Data: A9a23:ICLJ26ml3RJGK4RtvhI8bVPo5gzqJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xIYXDiPOq6LYGb1c4p3YN/j/EIFscfVyNVrSlA//H83F1tH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/rav658CEUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+pe31GONgWYubzpNs/Lb8XuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FaICod1JBlpiz
 tABdRdTcQiRnd2nzK3uH4GAhux7RCXqFIobvnclyXTSCuwrBMieBa7L/tRfmjw3g6iiH96HO
 JFfMmQpNUqGOkEVUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIaPJoPWG5kOwS50o
 Erc3XXDIzgjM+ePzD2d/0CqgOn3gR/kDdd6+LqQs6QCbEeo7mgSDgAGEFi2u/+0jmagVN9Fb
 U8Z4Cwjqe417kPDZt38WQCo5WWPpR80RdVdCas55RuLx66S5ByWblXoVRZIbNgg8ctzTjsw2
 xrRwpXiBCdkt/ueTnf1GqqokA5e8BM9dAcqTSQFVgACpdLkpekOYtjnHo8L/HKd5jEtJQzN/
 g==
IronPort-HdrOrdr: A9a23:QOUAHali/2GcHWe8A4FzmBStQ+/pDfNjiWdD5ihNYBxZY6Wkfp
 +V7ZcmPE7P6Ar5BktApTnZAtj/fZq9z/JICYl4B8bFYOCUghrYEGgE1/qs/9SAIVyzygcz79
 YbT0ETMqyVMbE+t7eE3ODaKadv/DDkytHUuQ629R4EJm8aCdAE0+46MHfmLqQcfng+OXNNLu
 vm2iMxnUvZRZ14VLXdOlA1G8L4i5ngkpXgbRQaBxghxjWvoFqTgoLSIlyz5DtbdylA74sD3A
 H+/jAR4J/Nj9iLjjvnk0PD5ZVfn9XsjvFZAtaXt8QTIjLwzi61eYVIQdS5zXAIidDqzGxvvM
 jHoh8mMcg2wWjWZHuJrRzk3BSl+Coy6kXl1USTjRLY0I/ErXMBeoh8bLBiA1/kAnkbzZZBOW
 VwriSkXq9sfFb9deLGloH1vl9R5xKJSDEZ4J4uZjRkIPgjgflq3M0iFIc/KuZbIMo8g7pXS9
 VGHYXS4u1bfkidaG2ctm5zwMa0VnB2BRueRFMe0/blmAS+sUoJhnfw/vZv1kso5dY4Ud1J9u
 7EOqNnmPVHSdIXd7t0AKMETdGsAmLATBrQOCbKSG6XWZ0vKjbIsdr68b817OaldNgBy4Yzgo
 3IVBdduXQpc0zjBMWS1NlA8wzLQm+6QTPxo/suraRRq/n5Xv7mICeDQFchn4+ppOgeGNTSX7
 KpNJdfE5bYXB3T8EZyrnrDsrVpWA0juZcuy6QGsnq107f2FrE=
X-Talos-CUID: =?us-ascii?q?9a23=3AGy+GYWqVfVmzAj27Yi6ycJ7mUe8/KUbjy0z8GGO?=
 =?us-ascii?q?hVEE3V6WHU2CB9Lwxxg=3D=3D?=
X-Talos-MUID: 9a23:a8ScmgU+gus9Lgzq/CXOlQtDHf5v2LSrD1gAo5MAvfGYCTMlbg==
X-IronPort-Anti-Spam-Filtered: true
Received: from alln-l-core-05.cisco.com ([173.36.16.142])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 05:19:21 +0000
Received: from alln-opgw-1.cisco.com (alln-opgw-1.cisco.com [173.37.147.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-05.cisco.com (Postfix) with ESMTPS id 8A5CE18000153;
	Wed,  8 Jan 2025 05:19:21 +0000 (GMT)
X-CSE-ConnectionGUID: UNauzg3EQPaCMcbgb6kPaw==
X-CSE-MsgGUID: 6xCl6MkRQ1OesHLJo52DJg==
Authentication-Results: alln-opgw-1.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,297,1728950400"; 
   d="scan'208";a="41879123"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by alln-opgw-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 05:19:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=befK8k+8zp2eU2kfA51w8tLiM4g/RxkBNA3ztZtd6PHinmHQX/JeqR4+6//2XoHyLRvUBFMlEqrjuSDmsIw1fkoGZnu/wAHXBxMvMToxpYA44V+vvHbJFUq7BCUoEW8DFSjFNJy0w7uW4xdrMBT3F2dSf6uxHEcs9ENQrXViOfih+7K1Xh7hefTbf6jF802T0Ybu5/woGVTWQWWxrCW0f7VlTHR9itY8OFbJzEVj8i+erlFp/aanUj5IrjcPUtS29tK23E4HBQOXbrZkvXPB0tdtNWy7uLd0wdW6QUvVhvvR82jLIi9wGXJA+fUa1UCPZY0PJEyW5WHgN4ZUumHpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TFsftzUYCXqUUMDFg8uNu1iRQXeTTOPZP/AL74Ujd0=;
 b=Mj/hinRgGIefwr55x5x0OufuW0LVwMkVorIBjbhRbYbRqo8B2sxZ7f/u5WmtfUEBy7sX9q1sz2zExpeoAzdGqtir0NL0RWMZN8Eb/4Slxzn5RwIRBad5aIPByjxP9JNZDA4yyDMmllz0NQBg4mMagD/0d0bH/H/WiBYAlA4MTd4dRWt5GrZWBh0+CdRm+qOFMUdc7rxFX4ua0b6mDFm49No6QrCmlgkPIyyocd0vr/tlPvsesCzI3gIMYIJnCsnXeOco8/bneBI3KZstaR7/6vjsGJMEEzl8g4uzR4GQblZF9TOyeJeVyToKjO5ycjoH620506shzhKR1hJYRTD4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by CY5PR11MB6209.namprd11.prod.outlook.com (2603:10b6:930:27::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Wed, 8 Jan
 2025 05:19:20 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 05:19:19 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "Satish Kharat (satishkh)" <satishkh@cisco.com>, "Sesidhar Baddela
 (sebaddel)" <sebaddel@cisco.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH scsi-next] scsi: fnic: Fix use of uninitialized value in
 debug message
Thread-Topic: [PATCH scsi-next] scsi: fnic: Fix use of uninitialized value in
 debug message
Thread-Index: AQHbYYt+fS7k0jVE9kKFY5Qw5bZt9LMMVX7Q
Date: Wed, 8 Jan 2025 05:19:19 +0000
Message-ID:
 <SJ0PR11MB5896FC2D687CBEF0B547FCA9C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20250108050916.52721-1-dheeraj.linuxdev@gmail.com>
In-Reply-To: <20250108050916.52721-1-dheeraj.linuxdev@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|CY5PR11MB6209:EE_
x-ms-office365-filtering-correlation-id: 8e8bc95c-0595-48bf-1465-08dd2fa4012b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?m2Tbz1ggNfels9u8pEjlY3sBT3x/Mu//5CYQ+zVE5DCywZ1LxMKARVnkYx/x?=
 =?us-ascii?Q?/ZPuwrhkqouPF62UDaA68KlyzVHXZqOFZttfJZOMP7tjVYYL4zuMPGdjIyOQ?=
 =?us-ascii?Q?0mltzodYNREM0py4LSYFh5inzqICGYMJGfEzrP5DNKkw/VwtllqrQfpeKpKe?=
 =?us-ascii?Q?fonGUmA07+t5xF8T+5antMKoP+9iZCB61cMWVOSP9usGOs+sdLyI5ZJHHxFF?=
 =?us-ascii?Q?E/ccL0PBH/R2JbLlHDu8XEer5farW/5HAQO75zM0YTk6mkGyIjQZF2GRhOxJ?=
 =?us-ascii?Q?f6EdIrOlro4T1qghY5iVrGjx/M4FLem3hSai7AUhaptNSPHdTf5egd5vzox5?=
 =?us-ascii?Q?yx2Yzib0DVRnKoSReBs2j5A1UcwWyh3iEckKPBiZKpE9n4nf83l39fCfqHAf?=
 =?us-ascii?Q?C87SeAqS/vQ9N8+LEzhqL+pw/H0MG30uOpT6WhHLYKNOoM/rbl08HZVEOTXR?=
 =?us-ascii?Q?Q8Opiaf0IK2Ia5g7AEP9Wip9L7PCMRKTSbUygS3s8p4x/1v0SEamgym2ZHp3?=
 =?us-ascii?Q?ca3vIYcBzr+hMDa6mvd+ODmYx3q+eJoioCB417FhreS6ApcF25jA+Jcd40al?=
 =?us-ascii?Q?YAzb5kdaRbKiu/20xMKHPqnS5eKSTr7GXybDVdrtVOlcLEuBj+W8lx7wHf5S?=
 =?us-ascii?Q?ewTIzS2fnWQD1S5eX+TsadiJ8x46yVr9cTs34NYl6O8+y1edfaty3tGqf5MT?=
 =?us-ascii?Q?GxXLqzXIr+qLR94X9VpyNWP6nUwjy0vFd/2TpFcgayxk/x33xm0xZ+M8FrlX?=
 =?us-ascii?Q?3Y7MOSnU9jAVuN51jmMD2lgrBz7VdEvO7k5HcuBi0iu2AGWJLRidBj88yFqM?=
 =?us-ascii?Q?zwL4xbZW0YWpnNOtOGhdll1FdMTIgCPU60Ol0tyaFv91fHX+jq3U4ZePH4yo?=
 =?us-ascii?Q?ODEMnCgH6ehYMA7EA6kbcOgLPHO8zBW1kywbcuJy/yuvQLlfHpk1k4d8eYNP?=
 =?us-ascii?Q?s0IY8YD0MXJ4YvvIgpu+cpeX+cajzBEHpnsHcJ+Fj995XY0NVwo039qS5KoL?=
 =?us-ascii?Q?o/AryGZR+fFT+WOaQkPh4neqyVm3DEy5Y8bFwipBda93j39C/CCJOumXXYU6?=
 =?us-ascii?Q?ik1TaO1ZgVceBTFWuy3+xynExkxeS81Gdqp0tirWgjOJUECy3LHzdy0weoG+?=
 =?us-ascii?Q?00ToiMRe2uV+BYBLEkYGywOwvIybGE6gFle50kK5Wbov8jksJFpC7je3xsCg?=
 =?us-ascii?Q?+fLmxScPM1RvrPlTiuauRPziOeLXROMbO3M81FH665Lz/vYZQUWpgXD/RDQz?=
 =?us-ascii?Q?nNAMGx3LkpusqTETzAPXXE10Yo17wCWVc6NGOZlvSIvJgkuWSvPvw7lErYsJ?=
 =?us-ascii?Q?W+RDgvXWskeDXCpc/9/xyWMdOZfkA9o1DUaArkk4H2maLoUffp+FI81nPQDV?=
 =?us-ascii?Q?cy1qrfOFGL6/cu76/jPHuq05jizh?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?AFuwYOE2uFAP8deshgJd1utp5Sqr3E6QdJmUjR6n/a2W2fcrC+sQqprc8uKv?=
 =?us-ascii?Q?78/25cF3ktshheRpRNBKINuzAee8V1CUO5H6Bhak+NAeEzlTmyqFJ68/Nxbi?=
 =?us-ascii?Q?/ZW20yu8FuRK1jM5OQShcbM5/Ou65AdudZMm3wKFe2R9eyvIk17VFk4y4WpX?=
 =?us-ascii?Q?Xp0FhbjsdpV6y16hSP74DHV6rPnvglX+2ppAvWpWK1mN4o0fDWECOZ5cOwmb?=
 =?us-ascii?Q?LmR95O3SOrHFo4ThoARkQ7/SEG3e/GQ88OjR5O/SXZqikOWv3Ss0Wd7mJiP2?=
 =?us-ascii?Q?mxahWlD42jo4XQy9QS6RcLpY+0+tZYlgz1UDEONw75eVjAeOYaDt0imVCkVs?=
 =?us-ascii?Q?VEzbc8SJSsop7/tQivgf9XQadtg/lRtebgfpzM6ty360A43qSPTY7AjYqIBP?=
 =?us-ascii?Q?NiGUlQnwrTal9qikdTqgSEtxyuF2mc392Qgrra3xCNuwAQJVh5zaATC03/6O?=
 =?us-ascii?Q?lnhuzYodP/PiAXl9VFGd4ksU/6Kb3HiL1eyH1Oz4P4BjEJnc3xO5REu6CK8V?=
 =?us-ascii?Q?mm7MAwemoOCg11s3kHoo3x2ig66GbFjX63CkrqB4QbdcDAO2ytpTMsvaZ7LP?=
 =?us-ascii?Q?0mZIiWzdqMY9fMdYnkTOgNEgG33YZZhUN+8KeZv10V97iY9CEY3KBN2mUppT?=
 =?us-ascii?Q?paiCYRxB1MJYZer1c1u/vBFFBPrMLCm6f9wIrmObHhA81Qu13sfWlnnihwme?=
 =?us-ascii?Q?H7cP116nxfEM5TVDEXvpGwRzaIdBD7yzEhIP7QQ1Mul600J3zNxWRqA4Somj?=
 =?us-ascii?Q?dJ3d4SZVXFUCZIQh86WYD5ItSj6KbDSjNKqlhFfjjwzYYQFqJ+THgtsKJLd4?=
 =?us-ascii?Q?elSENWd6zngfYLETM+rrljimOm8TqqlDmTUBp2jOjbNhe2slZpgxLBr1qwV9?=
 =?us-ascii?Q?nuZ2cb44HeWvPVGv/i6KlCpfV+NKHfb9ouURs4TThnX7il0Y82VCSt9bCvzM?=
 =?us-ascii?Q?pbluVChg+xsv9mPFX2YSq2+mngkWiod/UwFUb18CXx2e0VVqHMrcgBHkL2jT?=
 =?us-ascii?Q?XO7kfsXpNoSIsoA0AR5cH8rc1vbJ9sBOM4X1Rv8RTuKLhMq2KGYyjztRaguC?=
 =?us-ascii?Q?6B7bI0RmB/6h1LQe1d7v+e1FNhhP3sSmmjRM1k1lpbJ9QhCCeAqFb6BrJ5Im?=
 =?us-ascii?Q?40ZAzQ7xijNeQFooSsNCYyNcFklMf0TIwxPPgH4ao8qDZqv1SOR+QWq/Q3U6?=
 =?us-ascii?Q?/DCvZHqlhiKAS6RYkQ7/nRy52pX4NolRojEIciy6Y5cDjLVsYpVKc3kURTch?=
 =?us-ascii?Q?oDpBp2rVnimvDZFmki4uPCJSGq6NmTZ8Z9EIf8ntbEwyvHTtz019j4Ud/WJV?=
 =?us-ascii?Q?urvsfYvUwdvb3fMg8n3PWmPuI6u/VUabi7HTaLYbEpGgvU4FKZTudbW7mTW5?=
 =?us-ascii?Q?M8OIaJmGAmeMqGuFBQNG75nNI2TavtKKtTYQfvbwixrytD4w3rxt83NODfMA?=
 =?us-ascii?Q?/MbAle4/VCWJ1Q4WN2e7j9ThUt/IwIq7mJ+KkAzW2zchwtB198FjA2aZI+Hq?=
 =?us-ascii?Q?IkWpuMRrTxZKrYHTQGcpK6OezVQLFVI+1xZ1c2lHB8SRVlDs/54xs84/QwgX?=
 =?us-ascii?Q?Qai49Ur8PE2aPVMSCfYffuG3Go91rD7JW8Ma5WF8n47Dck4Ph2K4EpKZvpJs?=
 =?us-ascii?Q?zJQ+9OhJG6WHF6duQFZbnAg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8bc95c-0595-48bf-1465-08dd2fa4012b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 05:19:19.6976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o5bkjZPQY3UhnQcXIhttnYFvMKscUNqHNt75KpVPsh+wZWl37+mRT5kdAzPbi4BnqPnpVA4y55944OP3CK6rdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6209
X-Outbound-SMTP-Client: 173.37.147.229, alln-opgw-1.cisco.com
X-Outbound-Node: alln-l-core-05.cisco.com

On Tuesday, January 7, 2025 9:09 PM, Dheeraj Reddy Jonnalagadda <dheeraj.li=
nuxdev@gmail.com> wrote:
>
> The oxid variable in fdls_process_abts_req() was only being initialized
> inside the if (tport) block, but was being used in a debug print statemen=
t
> after that block. If tport was NULL, oxid would remain uninitialized.
> Move the oxid initialization to happen at declaration using
> FNIC_STD_GET_OX_ID(fchdr).
>
> Fixes: f828af44b8dd ("scsi: fnic: Add support for unsolicited requests an=
d responses")
> Closes: https://scan7.scan.coverity.com/#/project-view/52337/11354?select=
edIssue=3D1602772
> Signed-off-by: Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
> ---
>  drivers/scsi/fnic/fdls_disc.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
>   diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_dis=
c.c
>   index 2534af2fff53..266d9f090772 100644
>   --- a/drivers/scsi/fnic/fdls_disc.c
>   +++ b/drivers/scsi/fnic/fdls_disc.c
>   @@ -3904,7 +3904,7 @@ fdls_process_abts_req(struct fnic_iport_s *iport,=
 struct fc_frame_header *fchdr)
>       uint8_t *frame;
>       struct fc_std_abts_ba_acc *pba_acc;
>       uint32_t nport_id;
> -     uint16_t oxid;
> +     uint16_t oxid =3D FNIC_STD_GET_OX_ID(fchdr);
>       struct fnic_tport_s *tport;
>       struct fnic *fnic =3D iport->fnic;
>       uint16_t frame_size =3D FNIC_ETH_FCOE_HDRS_OFFSET +
> @@ -3916,7 +3916,6 @@ fdls_process_abts_req(struct fnic_iport_s *iport, s=
truct fc_frame_header *fchdr)
>
>       tport =3D fnic_find_tport_by_fcid(iport, nport_id);
>       if (tport) {
> -             oxid =3D FNIC_STD_GET_OX_ID(fchdr);
>               if (tport->active_oxid =3D=3D oxid) {
>                       tport->flags |=3D FNIC_FDLS_TGT_ABORT_ISSUED;
>                       fdls_free_oxid(iport, oxid, &tport->active_oxid);
> --
> 2.34.1
>
>

Thanks for your change. The change looks good.

Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan
