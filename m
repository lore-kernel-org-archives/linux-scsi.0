Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AE22046AC;
	Wed,  8 Jan 2025 21:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=173.37.142.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736372846; cv=fail; b=EjezgHiWHjnRBGp7fjG6k+r0x76v9FV0tfrCobN630J/EHeQS/jz6dCSzlPwKQtRlQPU6nvgMsgA3jS+/r3efJKXHfzAYnSw4+3EWnREQcuAbfAUNv8Z0IwD0d8KT4qRgWX8p9j62mWUv+7R+YBBp2o8jRbgbu3HZoGl1uLusbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736372846; c=relaxed/simple;
	bh=hTCYaXUjs8LwTH9UVdGpV6LY2Y6Mdqs7C7zvUis2DAQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gebYVk6yzweBKutlppc2ScudGHZdsIy/fHq+zZKKT7GmvUj+VRBF5K1MSPwlf1m7ofBfBhuRHa/WWHmwRJ/0A/jhYT3/l8wwXodhCqFhcMBRtSbW1IW7PGtEle0taer5xM//yjF6uuqelHU9kA1l4YGyKjqIm8pQ/5OJ+Nv1KdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=QXFag9a0; arc=fail smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="QXFag9a0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2566; q=dns/txt; s=iport;
  t=1736372844; x=1737582444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WRxvskGLD+z3KJa5SUVNiF0WtqYE3HwJ0K/LKhgVMx8=;
  b=QXFag9a08WofDm+/hZAiGjsRZqI1yLlvEMxZRle+XIk0wcsPavszYdAV
   f32R5hEdC5gGRpRN/EipOBr767ENyBBzwS423Lj/ljpT8Rqaq4P42WnY3
   XG3NWanINJi1zy6Elqn0C5R18UJWXNVnfSjoX8v4CrCs0fXGj6GxyUc/2
   k=;
X-CSE-ConnectionGUID: +qnKnFAvRpeLVnsNZYfY/A==
X-CSE-MsgGUID: WX/wqCHMSv6B2ls3BVouFg==
X-IPAS-Result: =?us-ascii?q?A0AZAADy8X5nj4r/Ja1aHAEBAQEBAQcBARIBAQQEAQFAJ?=
 =?us-ascii?q?YEaBwEBCwGBcVKCGUiIIQOETl+GUYIknhgUgWoPAQEBDQJEBAEBhQcCinQCJ?=
 =?us-ascii?q?jQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFFAEBAQEBATkFD?=
 =?us-ascii?q?juGCIZaAQEBAQIBEhUTPwULAgEIGB4QMSUCBA4FCBqCX4JCIwMBpwIBgUACi?=
 =?us-ascii?q?it4gQEzgQHgIIFIAYhNAYVrhHcnG4INgRVCgjcxPoQpHIQTgi8EgjNLgSuCW?=
 =?us-ascii?q?WeGZocfkB5SexwDWSwBVRMXCwcFgSkfKwOBFCaBKgU1Cjc6ggxpSTcCDQI1g?=
 =?us-ascii?q?h58giuCIYI9hEdhLwMDAwODPIVngheBZgMDFhODFx1AAwttPTcUGwUEgTUFm?=
 =?us-ascii?q?nk8gn5re4MDlkqMXaMjCoQboXwXhASmT5h8glihByaBLINSAgQCBAUCDwEBB?=
 =?us-ascii?q?oFnOoFbcBWDIlIZD44qAw0Jujt4PAIHCwEBAwmQQ2ABAQ?=
IronPort-PHdr: A9a23:R8Sz5RPyaUnkSZZEsFcl6nc2WUAX0o4cdiYc7p4hzrVWfbvmo9LpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:/nZCzKlAyhVWD5AQVBVPMjbo5gyiJkRdPkR7XQ2eYbSJt1+Wr1Gzt
 xIfXm3QPvuPM2vxKI1xbY7loEsB75PXmNdhTwQ6/3hkQ1tH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/rav658CEUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+pe31GONgWYubzpNs/Lb83uDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05Fc4B/MVxL0hQz
 +QVDA4LdTaxtuyHh5vuH4GAhux7RCXqFJkUtnclyXTSCuwrBMiaBa7L/tRfmjw3g6iiH96HO
 JFfMmUpNkmdJUQUaj/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKJIo3UGZwEwxbwS
 mTuwFS+HQgxFPmk12SvqHa33cXxmj7VV9dHfFG/3qU32ALInDN75ActfV+6p+Spz02zQdRSL
 2QK9Sc066s/7kqmSp/6RRLQiHqFuAMMHsFbCOwS9g6A0OzX7hyfC2xCSSROAOHKr+csTjAsk
 1vMlNTzCHk36fueSGmW8fGfqjba1TUpwXEqJjYCbg0rysfZuIwXsBTUaORSHp/yp4igcd3v+
 AyioC87jrQVqMcE0aSn4FzK6w5AQLCXFGbZAS2JAgqYAhNFWWKzW2C/BbHmARd8wGSxEwLpU
 JsswpT2AAUy4Xelz3zlrAIlR+7B2hp9GGeA6WOD5rF4n9hXx1atfJpL/BZ1L1pzP8APdFfBO
 RCI51kOuMAPYir1Msebhr5d7ex3ncAM8vy4B5jpgiZmOMMZmPKvpXs3PBDMjwgBbmBzwfljZ
 P93jvpA/V5BVPw4l2DpLwvs+bQq3Ss5jXjCXoz2yg/v0LyVIhaopUQtbjOzghQCxPrc+m39q
 o8HX+PTkkk3eLOlOEH/r9VMRW3m2FBnXvgaXeQLLbbbemKL2QgJV5fs/F/WU9w0xPQIyLuWl
 px/M2cBoGfCabT8AVziQlhoaajkWtB0qndTAMDmFQzAN6QLCWp30JoiSg==
IronPort-HdrOrdr: A9a23:y3UfkaOhX+vQ0sBcT47255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NCZLUbbUQqTXc1fBOTZskfd8kHFh4pgPO
 JbAtdD4b7LfBZHZKTBkXSF+r8bqbHtntHL9ILjJjVWPH1Xgspbnn5E43OgYzZLrX59dOIE/f
 Snl616jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1yb9pI+9gf2F
 mAtza8yrSosvm9xBOZ/XTU9Y5qlNzozcYGLNCQi+AOQw+cyjqAVcBEYfmvrTo1qOag5BIBi9
 /XuSotOMx19jf4Yny1mx3wwAPtuQxeqEMKiGXow0cLk/aJAA7SOPAxwr6xtSGprXbIiesMlZ
 6jGVjp7qa/QymwxBgVrOK4Jy2C3nDE0kbK19RjzkC2leAlGeVsRUt1xjIPLL4QWC3984wpC+
 9oEYXV4+tXa0qTazTDsnBo28HEZAV5Iv6qeDlKhiWu6UkfoFlpi08DgMAPlHYJ85wwD5FC+u
 TfK6xt0LVDVNUfY65xDPoIBZLfMB2BfTvcdGaJZVj3HqAOPHzA75bx/bUu/emvPJgF1oE7lp
 jNWE5R8WQyZ0XtA8uT24AjyGGGfEytGTD2js1O7ZlwvbPxALLtLC2YUVgr19Ctpv0Oa/erLc
 pb+KgmdMMLAVGebbqhhTeOKaW6AUNuJfEohg==
X-Talos-CUID: =?us-ascii?q?9a23=3AtcCUBWljUnf1UQyLD0XFxzsA2P7XOT7EylTWDWa?=
 =?us-ascii?q?mM35kbIOTUnmiya1V1OM7zg=3D=3D?=
X-Talos-MUID: 9a23:/723igvrdcG3goFLmc2nuwElK95Dw4GVFh4ny5Ed4OO6MjFeNGLI
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-01.cisco.com ([173.37.255.138])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 08 Jan 2025 21:47:04 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-01.cisco.com (Postfix) with ESMTPS id 12010180002A7;
	Wed,  8 Jan 2025 21:47:04 +0000 (GMT)
X-CSE-ConnectionGUID: Y1AIG4sZSw6LC5rm76ZyKA==
X-CSE-MsgGUID: p7W+VZF1T6SxVmk9lwbspA==
Authentication-Results: alln-opgw-4.cisco.com; dkim=pass (signature verified) header.i=@cisco.com
X-IronPort-AV: E=Sophos;i="6.12,299,1728950400"; 
   d="scan'208";a="42041138"
Received: from mail-bn1nam02lp2044.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.44])
  by alln-opgw-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 21:47:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTwgfVfpyfMFu+2X3H0n8lkolic1cNzv5nvcUpccYsHkUWBDNZnV18BzjKjRRaj6B3xKZhENLbyMUhMef/JePByT/G8llCB0hkkT8oEVrBENtuMXUKOdp98QjaYK5C6zVXfqxLF9eV7CK6NOww80O2u+o0891q+3E613FmhakUfuZW+uFimzsiXFa0k5q8IfGap+8aLzIgJMRItUqyxu4u3heoNnRY98T7AG7zgIvHUqMoHZx/Ibvs76gcMtjUDiqR7Fpm8oKPGjW+cHjJ+MsDZS0U6duRbZlNQFq9YkI3mwJvZFQBuB40dNIq1VaNUc8H6uhVeiFOSuFz1k5bFdaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRxvskGLD+z3KJa5SUVNiF0WtqYE3HwJ0K/LKhgVMx8=;
 b=whHAicP0P82fT7WwRIMPWL3vJkfWHroe7GM4VVkLyq4S5d1vyhxL8+JHToU8qOy9tjqgmyEcRoStYknDQ2ZoVVErkSdZ0eZtl04EnXHJH6oT5B0UY9IKmRqXt2D+XUQC80UaUtPSbpVPPTNAUCsUPMIoHDLAMuW+rJFrAwpH03eZ6dSrUFd/nlNjfemZzsLtYqn5hO/JjBLwq2PESlLy9YdE+vyS+NOAq2dX20vK6s9XQ9+qeY/saJ+64Bh1hH0AkTgp8BEtjOD6TiOvsMWxmuD3l7zJLSX21lx4SHgJGu/jxW2zqeLa3M4ROp8Z4InWA0qJrCQ6T54vEGNnG6QEMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com (2603:10b6:a03:42c::19)
 by MW4PR11MB5934.namprd11.prod.outlook.com (2603:10b6:303:189::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Wed, 8 Jan
 2025 21:47:01 +0000
Received: from SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd]) by SJ0PR11MB5896.namprd11.prod.outlook.com
 ([fe80::2081:bcd4:cb3e:e2dd%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 21:47:01 +0000
From: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "Arulprabhu Ponnusamy
 (arulponn)" <arulponn@cisco.com>, "Dhanraj Jhawar (djhawar)"
	<djhawar@cisco.com>, "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>, "Masa
 Kai (mkai2)" <mkai2@cisco.com>, "Satish Kharat (satishkh)"
	<satishkh@cisco.com>, "Arun Easi (aeasi)" <aeasi@cisco.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: RE: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Thread-Topic: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
Thread-Index: AQHbTDq6HSN+iJUXdEijLsA+yRSpm7MLZ02AgAIsPvA=
Date: Wed, 8 Jan 2025 21:47:01 +0000
Message-ID:
 <SJ0PR11MB5896ACC32269A48A0DE10EF3C3122@SJ0PR11MB5896.namprd11.prod.outlook.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
 <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
In-Reply-To: <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5896:EE_|MW4PR11MB5934:EE_
x-ms-office365-filtering-correlation-id: cd1fa61a-d8a1-45d3-64d2-08dd302dfbe0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?p4zHs0s9BJaXjkFQAW+BiOpsfq61w59vG3BGypFnYztGXMfJLKmlEsmhVFPA?=
 =?us-ascii?Q?17+BLMNOpzXfDHLHoMQhVVgOyi/5+y1mAOfn+9ZxzYCzRuzKE275e7se4rid?=
 =?us-ascii?Q?/7hctmVntwsIX+8lVThoqbtH6DKUKZjJzjE8Bb5Zuv2oQ155wJxEMHBp2+np?=
 =?us-ascii?Q?FBBcmWS7Laq9ge78TJHMJIFDEHnXWYSO5Bq/JPLSLtUCjqUJUMp1FBB0hs56?=
 =?us-ascii?Q?gn4YGp2/s/U2ge8BFV/9xcTSdhc/FdcDDMsLMmdiLsyS+bv1lug4hn/TRfLP?=
 =?us-ascii?Q?8mFNpECJCh1xGEtagpVcKl44QPH8dsfFzX81fjJjyimHkZzSOluKzTpXBmRl?=
 =?us-ascii?Q?FQcrhZrQKEWhlkTnuVfvRJbjJnZ5Tf2iJkf0E4m1f/2RsiQBE7cCoGptI5Ii?=
 =?us-ascii?Q?Jao7CC/7jypNNEa4H1tyQChmnxwNSFkZkqSsK6n7oaE6+Sdbk3NjQfxeza0W?=
 =?us-ascii?Q?J8APzbz0fJ+rzymn51kZg/U7XQdE2ZfnikvwegtV6LKrxlLDYEghVJ9hwBxd?=
 =?us-ascii?Q?v5wxv7IMsUCXgN+9yM4kH7Vh2KQ1Hl15ji0aSQ1kKuWhUxl794Ex/r2MeRrI?=
 =?us-ascii?Q?JCFTn0aSom5dpv27ELHZzcf4C8YAcAtjfcTQeECxQ+hGF1fB6JZNcMewX0I9?=
 =?us-ascii?Q?nlgGRKdrqy4fSSq7RgFUu64w/kQ0g92qPn9FDvw6fD5gvtSrk3jnxbXmbk1Z?=
 =?us-ascii?Q?alzAhZYJip8Fyv0ph+NOh4QUC1NZbsLBUSH2F1GQi5Q2X4iBLnufhTE6hQ1z?=
 =?us-ascii?Q?DpEG9AOUrXVKaTVJQD4nQ4I0FK/YGJPxMNVRTI0B5rBA3S0hliRsV0Ntb30T?=
 =?us-ascii?Q?h0qjpjYVptJjpErRR9QKCQm74QUql9b/JRY3NkuK//+sJX4Bd3tdRMNMywGg?=
 =?us-ascii?Q?qJx3YAN/oXF5DYlNo6WhFQ36LPKphKJJ7Rfem9ndUp/wefNAIvOajgNAemxP?=
 =?us-ascii?Q?tqRqJG+pacn0BoD2LxY9tdNNWgXItYHs1vst5V2wnYd7aOFYwXG++yPdi0FN?=
 =?us-ascii?Q?ewer5fehJiyQvUU6MsOc0O/vf9nFETcEQuqxV84GkxhPlbdt9Ktukxfyb7zj?=
 =?us-ascii?Q?xCTsIODDSWG74K//howeoQCkJNMnwawee0lxxc1Fj4USaVNtK7ZgQq1Ml0Wi?=
 =?us-ascii?Q?OWdcRg2UsWsgJeRhqAdNXh53G1M8PXKcC/VFYHO6pKygIbwGkilBqzE3C32c?=
 =?us-ascii?Q?C5nIo7FCXZCq/qKe6iF5YGIf0BNtoEiCw0ne92xWYADKzaJvzuLEFuxCaPlm?=
 =?us-ascii?Q?v2LuNrXTta1Gign31uLeHTXP7jxyWlf+cJv2lSmPiWOcrt64Po66Mz2d15tX?=
 =?us-ascii?Q?euiaVo4wKFjap/7JlZk3SGCaCAoRz296yWMI+ibfJcZly8KBqmPOjVb5gCZ7?=
 =?us-ascii?Q?31tT0oaewiIVgTXktV+LmRFm6OhL5Y56aqCdVI74xJ6Rx/RmaJnMtOLrdA/+?=
 =?us-ascii?Q?rpQYwjwynwCRirUEPOYsb8FslW1xSJKd?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5896.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gNzAbl1BbyIlyU1KaLkEM6zP8yLshewBbhZ5vUCXOE7vzD27XEhUoTWdFaGS?=
 =?us-ascii?Q?Wto8R4CBmR30wHqL4820bn9MjgEd/l8LpOqM5X/vLv46zBezDQU/3N2PjH8E?=
 =?us-ascii?Q?2PbjrQ9gDK8Jgw5l2SPVMjLzf4qXZW+K7gWVyOa8d+zos8CIgFfBPtxKs0dF?=
 =?us-ascii?Q?WHRGy5ZZVaypQRbDCxdg/6b8NrpOauwQgHhPd9iEXjyaMBGsYIIimAJRHqm0?=
 =?us-ascii?Q?AxCdFaOR+jRea/97MWTmtFut5PgtGxIEZanqEgqc8E6BJuA3ofCYHmAuHXqz?=
 =?us-ascii?Q?NWVMV7rb6t6K2zvvveYvk9b5dupbqszl4hc3DyVH1WRJK+/hB64a2/lnw97U?=
 =?us-ascii?Q?f33GP68e+Ebrnf1G6hQRZXp4I94RKsFLui4CmWH/hNzaQTQ3v0yjceSp0Ec+?=
 =?us-ascii?Q?uU2qIjpSMa1FODTxCVWH6xHp5z1/LqzxpwdYV6Ss59Z7IIgg7yQNC4JanDrz?=
 =?us-ascii?Q?E6cF4RYFYIokUsxMLx4d/JWoDOMmKqtl2vzjg0SfNonJtwraX7fxB1Jcj2C6?=
 =?us-ascii?Q?QZWjKMju1n+WfXW4WH3Y+E9phif7nt8UCwEVTqXg7uvwLEVb9EvZNdx4WzQW?=
 =?us-ascii?Q?L2R/r6Qho91DBKaOU1a0WvqpCn24VcOTto7s1HFiVQjwC/kihM8MAG6rhfej?=
 =?us-ascii?Q?y47gAVkKCIAKdHTjxSFhKl7fiZ8rmXqgtsVpeLs8nQ54n54pYGTNI+4rofpG?=
 =?us-ascii?Q?zjz9x+xmS4RyF4tSIeDf+dD7/A2ZklIrujjdpJ5L1glreFO/+Al12dNdrlUW?=
 =?us-ascii?Q?HbsdLIxgF8Ek0uX5aCqcr7xBJ1RZ73XHNgcg2OexAq7spqcFtLw5O2lhigxT?=
 =?us-ascii?Q?opjJiPr2GLgQQRARbdX0iZPk5Hxj6Fx2xE1LUYYaU/+AXRaEIeHkHOUJqGHQ?=
 =?us-ascii?Q?+gnt5kv5qT31RrhyeVcedEuzP7AgC1cW7oejWM0hTl2jzS4aRZkMPKcVnyGx?=
 =?us-ascii?Q?rLzgv+JVcJajaUcD2eD5ndGzDNAGM9GLpXvb+rPi/pRxY6AASrMKI2zGxpvU?=
 =?us-ascii?Q?LJgqh7YaP/bgHG3gJ1kti7ZppZXmXwx2lUKcE/IY1VolrQjuTRuBeZm4BZT2?=
 =?us-ascii?Q?O2X4mAjUyM1QP0h4uGdWCVX/CieI//aWiE6oivX/hqMlMXQ1mzzommRR/Mob?=
 =?us-ascii?Q?Qf+ZVEo0trZIZ5cpcjKX019xg6Arq/VgjpajxvXWeFEKfySBiK6VbwLt7req?=
 =?us-ascii?Q?KXX0PefXlmc0u4yguxkWf/YSBjNXiamNjb+/EIEgglApGH5mnUcRvavra6Jm?=
 =?us-ascii?Q?9PAP4OLwk44qXgmxj+ZNdCq8BRAPl4aIFmva1VYszHDAcmO0ISpIu/SP+Ov2?=
 =?us-ascii?Q?8CZ7Sa5qL68aM4WX4vCBpokayt5bU9tYUR0o66cKdtU6dMJ6iv4bBsmDQjgi?=
 =?us-ascii?Q?li3j3JCzsHMCV60zKa6Ed6ywHJkEnZgx/Sxl3giA9AkGoNB52ilFan/kocOm?=
 =?us-ascii?Q?3e/5n2efKrv/Fu34ajK+L5GdgMiALTbOFB8gIzCD3o9PEkQ3SYJU2z7MRfn7?=
 =?us-ascii?Q?cw5iolbF0x8j35wVXRJLpQhNU/0f3Z1NIVRi6R9c1KKm5H9XDi6TtRzekf18?=
 =?us-ascii?Q?iug4XtYjymrr6exA6sxfLbYBrwjKJggQ2W9dg77liaL93+6/j8w1fq5VDbGr?=
 =?us-ascii?Q?Lv2br07VjJqmmwLR6lplnjs=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1fa61a-d8a1-45d3-64d2-08dd302dfbe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2025 21:47:01.3464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vNxUQIOzSKMpzJaZwUk6UW84G2pyf/+qBomJ4Va+W6W/M9Zt1FKhEkc8gSvltUkOrAnuRta+gNcNAq3W5BLd/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5934
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-01.cisco.com

On Tuesday, January 7, 2025 4:30 AM, Dan Carpenter <dan.carpenter@linaro.or=
g> wrote:
>
> On Wed, Dec 11, 2024 at 06:03:04PM -0800, Karan Tilak Kumar wrote:
> > @@ -612,6 +615,7 @@ static int fnic_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
> >     unsigned long flags;
> >     int hwq;
> >     char *desc, *subsys_desc;
> > +   int len;
>
> Do not introduce unnecessary levels of indirection.  Get rid of this len
> variable.

Thanks Dan.=20
We will address this in a future patch.

> >
> >     /*
> >      * Allocate SCSI Host and set up association between host,
> > @@ -646,9 +650,17 @@ static int fnic_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
> >     fnic_stats_debugfs_init(fnic);
> >
> >     /* Find model name from PCIe subsys ID */
> > -   if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) =3D=3D 0)
> > +   if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) =3D=3D 0) {
> >             dev_info(&fnic->pdev->dev, "Model: %s\n", subsys_desc);
> > -   else {
> > +
> > +           /* Update FDMI model */
>
> This comment adds no information.  Delete it.

Thanks Dan. We will address this in a future patch.

> > +           fnic->subsys_desc_len =3D strlen(subsys_desc);
>
> Keep in mind that strlen() does not count the NUL-terminator.
>
> > +           len =3D ARRAY_SIZE(fnic->subsys_desc);
>
> Use sizeof() when you are talking about bytes or chars.  For snprintf() a=
nd
> other string functions, it's always sizeof() and never ARRAY_SIZE().
>
> > +           if (fnic->subsys_desc_len > len)
> > +                   fnic->subsys_desc_len =3D len;
> > +           memcpy(fnic->subsys_desc, subsys_desc, fnic->subsys_desc_le=
n);
>
> So this is an 0-14 character buffer.  If fnic->subsys_desc_len is set to =
14,
> then the string is not NUL terminated.  This is how the buffer is used in
> fdls_fdmi_register_hba()
>
> strscpy_pad(data, fnic->subsys_desc, FNIC_FDMI_MODEL_LEN);
> data[FNIC_FDMI_MODEL_LEN - 1] =3D 0;
>
> This suggests that fnic->subsys_desc is expected to be NUL-terminated.
> However FNIC_FDMI_MODEL_LEN is 12.  So in that case the last 3 characters
> are removed.  LOL.  It's harmless but so very annoying.
>
> Also strscpy_pad() will ensure that data[FNIC_FDMI_MODEL_LEN - 1] is set
> to zero so that line could be deleted.

Thanks Dan. Cisco VIC model names do not exceed 9 characters.
I understand your point about the theoretical case though.
The data init line can be removed in a future patch.

> regards,
> dan carpenter
>

Thanks for your time and effort in reviewing this patch Dan.
Appreciate your help.

Regards,
Karan
