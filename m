Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB43D2F37
	for <linux-scsi@vger.kernel.org>; Fri, 28 Mar 2025 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743167103; cv=fail; b=kKbtchQm93za1qt1rJAZ1VfiINYTzJfVPX1BknAFOfjx2vleJ2TKfIMrIS3BdnGe6yhjO72AXm0pp9uDRVrsZYEXG6UnLFd5Yu5tEx3CxWPrNr2CSDfHeh967F1tDjub/n9xtfq5J9B+IrZKjKM+j3iKLv/3oBw+PLpBrCIJBs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743167103; c=relaxed/simple;
	bh=NT8kDAQdDiiwZby/3A+AexQ5KstS6KpAertgwXoBcCM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XlCKTZ/+Ofrm+AvDdAHbIpb7Wqy9ifzz2Vd50FRLZ/stBpbWESWFUXVWsTj/D7shV2rWkkSPJR5EHiXAF6Yg8QgfM0nIHqdcFLTkzNfPrwvqCZnXczPRWDdGdseVUaDBAePKLSQvRb+/vWVCsBQexoDwtiwJTO1acaCvMsSbKfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=yj3je7BU; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="yj3je7BU"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1743167102; x=1774703102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NT8kDAQdDiiwZby/3A+AexQ5KstS6KpAertgwXoBcCM=;
  b=yj3je7BUL8cKGHTujRrQHue2RPxJp2vuaLRFQW12toIRfmLXnlIKESYr
   YU9RdU99+u8nMF2x/pJoOjO9/rvtRHLWTzxIrlYjdq2p6Y3/DgMC6zMSZ
   R3sZs8wHrti5Bv4+W5k632hOihqLoAfadEiq+lwYRJvtU18m3w/k/6ODf
   aA+K6o5zAndRx7LeEGkYKDJ99yNWOROnysJZn65bCa2aZIvKGSV/97IoF
   Ca7M2x1FhuCIV+YnPCRDt0kBXMlsh7BkTKiBNBeGEqit//ghtXA7NJLfz
   6WFRU6sMNGHO2BXfFgdZnRrm9eRRsjLx9VLU3WEqWBApiBgCm15+UuPrS
   Q==;
X-CSE-ConnectionGUID: jhZiTJXpQX2qeSgeC61WLA==
X-CSE-MsgGUID: 6e93qO3BQjWD9NeIYDk7zA==
X-IronPort-AV: E=Sophos;i="6.14,283,1736784000"; 
   d="scan'208";a="62993673"
Received: from mail-bn1nam02lp2043.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.43])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2025 21:05:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PVl7r/IaL9FTvtoZ094egKnm5qzdlkyRVR8hOLisKQ/+IhR3z6+aDEAhP5Q+AHUGC7GC5RbNDIx8EWKwfaovHw+Eg65wSWeH3P1kYQYhLOZPVjtR8SLHphp25PjyWIubYoXnyXdlYFuH802MQeNhfB6pFgktjGl+++2dkux21Zd2epD2VcOCUsjCt/KcIim+bpTqrns1mVFSZfbsBq/oXmUWBrTDhFmqGsSoZk7QifsR/AkNaZgGwIL6yKiFR8QUL+yt3cdVCP40x8G1yNGfg2IQVBfuh8063SviDBsMHcHaLYQUedr7aq+wxEEsh7a/tdgVfU+Ooxu+bFLQm4cBaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gxzs8y2PEhOU9WTf6exFOc372u9nJ1nguo04v+N1HFM=;
 b=ldviJ2cVFT5ixj4RMVHbVAr9h4lpYi+hFwskIVfUVkk+IFKqbKDpd+fI9s223jpZwx/XqaqgMsVQPfaJZuQplndup1ub0vtj6x1gP38FUGsrq2mU4AwojUmErw7oOxv3Vzl/Azm5Qy9Mn774WauJbCVxD24rr3MS0h4Fj//zSvUUH5i59zCgLwbqpdR1dX4cj/8ZDJc9jBWgOoWm+YioPTglHoT6DiM1r6AFefKcDTru1Wb2ZqrAz7luWcaNo3d4SDk0w7HfuM6YYUJAC5pJwTQ7ByskvilSo7S9qmjXpAzw1CGeLrvzh+DDbHMcluPIgKV0/YJLpdQMOXeRIlgUhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by LV8PR16MB5886.namprd16.prod.outlook.com (2603:10b6:408:1f7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 13:04:57 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::58f:b34c:373c:5c8d%4]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 13:04:57 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: "Selvakumar Kalimuthu (MS/ECC-CF3-XC)"
	<selvakumar.kalimuthu@in.bosch.com>, Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>,
	Manjunatha Madana <quic_c_mamanj@quicinc.com>
CC: "Antony A (MS/ECC-CF-EP2-XC)" <Antony.Ambrose@in.bosch.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Topic: [PATCH v1 1/1] ufs: core: Export interface for sending raw UPIU
 commands
Thread-Index: AQHbnw30oEUDAgUu8ECtfHNx8Wh+hbOG4MIAgAACLgCAAT0DIIAAOLKAgAArd/A=
Date: Fri, 28 Mar 2025 13:04:57 +0000
Message-ID:
 <PH7PR16MB6196CA37E7CC476FC781CA2DE5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250327114604.118030-1-selvakumar.kalimuthu@in.bosch.com>
 <20250327114604.118030-2-selvakumar.kalimuthu@in.bosch.com>
 <9c791cf0-1853-415f-a037-0578d6573e45@acm.org>
 <VE1PR10MB39363AD29DCDDD5CAFD3B6FAB4A12@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
 <PH7PR16MB61962ECD8A529648422CFC82E5A02@PH7PR16MB6196.namprd16.prod.outlook.com>
 <VE1PR10MB3936F035CE799C994E16188DB4A02@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To:
 <VE1PR10MB3936F035CE799C994E16188DB4A02@VE1PR10MB3936.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|LV8PR16MB5886:EE_
x-ms-office365-filtering-correlation-id: 0c01e62b-93c4-4085-72cd-08dd6df923c5
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|13003099007|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?ohpmAasR4sYKB/7wPK4xDbBJ39lQidjTErcOY1diUca1+u+cCZ1STe/50n?=
 =?iso-8859-1?Q?VpHzqM9Q+Kj1f3d7uiUmffyuy9JixLdwpD6c+wDkHKsjQ7V0frTdXHXg/+?=
 =?iso-8859-1?Q?9oJaqWQaDjVqnNuUNZm/XZbkXk0faZ2/k0dyV+Y7P9t9Jj9wno/K/nQgfy?=
 =?iso-8859-1?Q?IeLpszhJvu30D8rSE5g9MLhEt552ZyPHaXbUA8AYyOIuJ+WcSMrAmwRVPn?=
 =?iso-8859-1?Q?lMLAPEzApHpm8TWuLaAbm/xmfYWk0UjSssIpCugs82umxxnxSwz66XjSLY?=
 =?iso-8859-1?Q?xOu59wj0Gi/ntCET9EVGaDUh+XcRiVq6VCPyj3xLK1fbs1McBt0hZi9hd5?=
 =?iso-8859-1?Q?QDK9BUCE8IXtQ8T8KcYJ4BKfWIHA5BXfPnCXrcqs8jbYygxpcpJsqsn7zR?=
 =?iso-8859-1?Q?NR08BLIy2P2u1ilttVEfNBfumTxGzAFxFPJzgFY4UPrQyoJhxzrf60H949?=
 =?iso-8859-1?Q?jgCL16HBhJbp5FXFrvjaANvagP8EinNRdWfdNEj/DwfT4G0+30fusKBvkA?=
 =?iso-8859-1?Q?oJp7QSrBeHHTwVjDfKauqq3ccNqJVoUI8KSpSU1GktUX+4Gdig7TzkXcH+?=
 =?iso-8859-1?Q?y+VKvJ9hZzwDDaIG2mrBog6athyFi7ByZZLXsaW64+eSZb6NgTzwMXkQR4?=
 =?iso-8859-1?Q?+mB2b0HRE/3kreok/gG28BiO96uQuYDj8L9dFX0sTobRFEOziD/h2gvoc9?=
 =?iso-8859-1?Q?iX18hsthaA/VUl/msOJ2KodtjcBrArbglHuJoPodvhWVjpDEDSfrSqnJBv?=
 =?iso-8859-1?Q?cC/mRda/pF7CkJ0AVHWoBQkqyKg1ts7n6fdYvs/HhFxutZzDIoB/qqKm3o?=
 =?iso-8859-1?Q?AEfjQt81PKd+3qg9z1sNM5RUcWMmmnbGl5n/dDG0Qo2K3/YZkxT6Tf3B9X?=
 =?iso-8859-1?Q?fi7h86fF3vfz+MiByk/S7g7D7vOVkz4LM8z/SzSEnm6WC8y2ktZ7fOJxOU?=
 =?iso-8859-1?Q?XPG+x8fRRT0Nif/fWydSuiKIi7/MyumRjrOmAHKHiYzKR8jbC70Z+7niSm?=
 =?iso-8859-1?Q?qocwnMxpE8Y/VC8On9O+D7ItZZrq0f5alWIj8gKGuvlr+XfvprKHisyEn9?=
 =?iso-8859-1?Q?OgD7jNir/Gwh1vwijy6F1oX0uYs8BdUcw5DThzxrlwL90ZAO4K1KDVkJOz?=
 =?iso-8859-1?Q?Ovdgo4Fmbr8HJFPbtkOXToROJxi+C3Sf43FG6WOLeCyZ4yv49jZFsES2hb?=
 =?iso-8859-1?Q?3R3QyaJ/V8QMnXkTb2Tgg3VkIZOJ3QV93asilv/+QFiQ/j0Q9su1KuTu0q?=
 =?iso-8859-1?Q?G/fseKdjX5pGEap1K8qOAW4w0HmLQYduhdRIJ+IiNCBuc7O2/Ql3DOkOXS?=
 =?iso-8859-1?Q?6tn6caOrQlODdbYUhVtlfIOjGj0bWZSRh5fNlRz4feyVAFuxCKwrD7yaTH?=
 =?iso-8859-1?Q?CM1gjQRyiEhmtYeAFqKhEef4ldEqFhn99JJZvf0sj1DWykMCs+10G1Af/6?=
 =?iso-8859-1?Q?WGr9oNJJsYJMaY1b?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(13003099007)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/XvA7HIhSpOTyo3nkbsYb7SocHtA31B21qJdcEOwiV6HLNlqQCekt4DA13?=
 =?iso-8859-1?Q?Ksfmp9ohq16iiAPs/5NZwY6D3y7l6z4e9XcXSRdzWL9gBVycbWMulaH3Fs?=
 =?iso-8859-1?Q?OCkM6OUYVdFGZuSIuQSk90aHYhN+mM4qsiXpoEoYpiSVvaWM7cESoiC8D9?=
 =?iso-8859-1?Q?8jDfdk9EFBCcyEXz0gM+j5VXcDcQq1GN0WH5qY26qLtlRBC6d6BObJ+JWp?=
 =?iso-8859-1?Q?woGXMiFKzPeqjFq4AUE5pIbnUorkxneFq2y8c9rbr42WSq04ZRosoGhol9?=
 =?iso-8859-1?Q?ZfSTXPmfd2Hdw17JMncMTrsKtZayx3VDNgnpbJNGtTuCCfBeL77nRpnW23?=
 =?iso-8859-1?Q?Vu2deQvn2KHKjGpRZxMl1f++pvprVQOKmWN8Pzo/eVkWQ3RW+G1GMDYcgb?=
 =?iso-8859-1?Q?uJFAWvnEOzLlz9alTrrGLEXIApOv4OmnYeYXH4EylMwlwigg15N7g1zw0w?=
 =?iso-8859-1?Q?YFMi2/vO20Rg93byapSnhi8X/SpczSpqo5EzX0pME60oL6mR3t/vDA+8YX?=
 =?iso-8859-1?Q?APDjC+v+RYl7xiM+A0IG5zuaZ2dWPolYgixEgAkZexGlO4bCB3igYSy2Rx?=
 =?iso-8859-1?Q?J6KWHc0zLrjxbnZf6lnuax5HwMW1Y8qN2JBPT7y6iXHqXLgvyZ+3e56zT9?=
 =?iso-8859-1?Q?fsxrUP6MJEnQhN/RPZrgd5Wuw2FtfdVXHL3/k2gGWmWGvmRP9bXsLJ57CE?=
 =?iso-8859-1?Q?Djy3D484H9jIiIdPQ1aYW2KUhTdIsuKBFdx29sbNL2DSNOzvjM1Ul+SH4g?=
 =?iso-8859-1?Q?E21vIuEnHreZFF+zvMvBHmGZZnMBoe8/JGSflDUM3bKfII9lHg/nEWNOkn?=
 =?iso-8859-1?Q?8RQtEL+b+xctzWmfqUnPDnK62+X9NbO2UHJqDlMYk5MKEydk/wfUd08/xz?=
 =?iso-8859-1?Q?+u9OAUUde8MZ464j+0+ggBi++6t/wwMJSzLYL6BE3mxxphn8tIuZKcBWXP?=
 =?iso-8859-1?Q?HHc3ah5o9tmmLiKHE5++Jro/96pzksYA5SK6GitNpGRn0wawjXOzXOZoiH?=
 =?iso-8859-1?Q?h/tClxcb2qN1eI3bRCeS3YOfu0JGlpk/YFtds8/uMuOAn2i1FFEGIiXqLk?=
 =?iso-8859-1?Q?uJb7rdyzfj2dAfFLGv5YvYgAuksxZPnEqHGSxQI4yacw5tq+6XYZpNbYka?=
 =?iso-8859-1?Q?Hm0/fseilKBk2Y49JrlHj/iTLdLPdk/MUMSjq/VnLt9hraCWaMqlhx4Xrf?=
 =?iso-8859-1?Q?VXwerqhaoJ2QXHzIqDtqQqc6wOda+ShIS6Bmfa0TDZ8ppIOGuBwHCUBZo2?=
 =?iso-8859-1?Q?BHDKrlFRksRKZiUOTNOyMGJU/X39t3WNc2EWT5EihZ/GDCkSrTHUNsZsjA?=
 =?iso-8859-1?Q?TL5lkAMTsx4rJy7K4+lkUC/ZxmHDobMyToT8tp65tIh28msWj3mgnOWAVW?=
 =?iso-8859-1?Q?UPcaZ7FtunL6c7ckuOFnBDL+kJJi/X9R4vcjBmH2/yknnAEGA0EnpwGjxD?=
 =?iso-8859-1?Q?8XVYRNV+ePf+6HpFQ73ekXqmkohF66hR3QYQ18i0Vikxor9BrJXINLFq1+?=
 =?iso-8859-1?Q?U02weyKhKrcKHxQbdN3d0PEokC8cxOA+B1u2hm9d1R0ZX4WbEcmCaymyvb?=
 =?iso-8859-1?Q?KkEioefP5W6TC+//XAop0S5q7XX/y5n2ZagJRP3actZ7i2BtBguHszeMcK?=
 =?iso-8859-1?Q?PX+39UTxpvH6hkfRMIRwzTUL2fsd0PTFe/?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sAatS4h3A3JCq849WI0Kp896Llkmg4kra0e36q17OY+zXrH3w2RpjeJb2t5t3ozBwKgXCLDS7m2XqtJcToe5UMEDl04VIFrYvT7yshLO0jpaJhzulwvJHLF2WQJi0g7R9NkSIhACjmY5UAyoHP80sMftRJB7WqbrPxLkoREOuhyHP6FO4vs1gLt6sOd+17f9SlQecwofJrdE1gLzj9VDyAcSapxk7TY476YEo+nc755j1t7aAX9eHCqV3kpgjvMi2fh9+AsX9LWJGTyCX/KVS7PNOK+Wt5RMuVFCIo8CB1BuvPdOes4JA+7EXJTZxDZT0goTAmhMv0L4soByjwjZc0U0SHwhN7gyO0EUy78pCVNKbyH5RbBXOBtWEGjbpH4aHz9v/7qrzW5/smva2iz8+XD3vYoWs/83pHzWHIjOr4FT6L69rSSK0xiZyEQ/wG3OUhgjlEheMHCYo+RJG/wL/UnSggn2ZPKKjCiNWb2/iaCJXsnOSEjbOSY053WvUPa6OgBjT7FAUUpt+2XmJXKbNKopzFCRxVnB22jGQY4SAG0zWYzyV17OzBHx+Y6b6bFSo7ZhJF75LGNCfnI+COne/3ILamwwxizJE2V5socyCIfwpmAntD6dPl2AIWrTIUcN7cGq6kljNR6rexsM4xdSdg==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c01e62b-93c4-4085-72cd-08dd6df923c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2025 13:04:57.0819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E9nx0KqDoK7LbPxsBReeHkshVSeb/XxKl+Dh3WxXtd2Q9yUVO/U1pEYl0rztKP0qbT5I1pvlx+c6vUvWKNW6Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR16MB5886

> Hi Avri,
>=20
> Thank you for your insights.
>=20
> We understand that vendor-specific query commands can be sent using the
> ufs-bsg module. However, there are a couple of challenges:
>=20
> * Some vendor-specific commands use unique msgcode values that may not
> be handled efficiently through the existing ufs-bsg framework.
ufshcd_exec_raw_upiu_cmd only supports a subset of the message codes suppor=
ted by ufs-bsg.

> * In the Android system, access to ufs-bsg is restricted, and not all pro=
cesses
> can communicate with it, making it difficult to use for vendor-specific
> extensions.
by 'restricted' you mean privileged?
I don't think that allowing non-privileged access is a good idea.

Thanks,
Avri
>=20
> Given these constraints, exporting ufshcd_exec_raw_upiu_cmd provides a
> more flexible solution for vendor modules to execute necessary commands
> without modifying the mainline kernel.
>=20
> Looking forward to your thoughts.
>=20
> Mit freundlichen Gr=FC=DFen / Best regards
>=20
>  Selvakumar Kalimuthu
>=20
> responsible for Platform 1 projects (MS/ECF1-XC) Robert Bosch GmbH |
> Postfach 10 60 50 | 70049 Stuttgart | GERMANY | www.bosch.com Fax +91
> 422 667-1208 | Selvakumar.Kalimuthu@in.bosch.com
>=20
> Registered Office: Stuttgart, Registration Court: Amtsgericht Stuttgart, =
HRB
> 14000; Chairman of the Supervisory Board: Prof. Dr. Stefan
> Asenkerschbaumer; Managing Directors: Dr. Stefan Hartung, Dr. Christian
> Fischer, Dr. Markus Forschner, Stefan Grosch, Dr. Markus Heyn, Dr. Frank
> Meyer, Katja von Raven, Dr. Tanja R=FCckert
>=20
> -----Original Message-----
> From: Avri Altman <Avri.Altman@sandisk.com>
> Sent: Friday, March 28, 2025 12:36 PM
> To: Selvakumar Kalimuthu (MS/ECC-CF3-XC)
> <selvakumar.kalimuthu@in.bosch.com>; Bart Van Assche
> <bvanassche@acm.org>; Alim Akhtar <alim.akhtar@samsung.com>; Avri
> Altman <avri.altman@wdc.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Peter Wang <peter.wang@mediatek.com>; Manjunatha Madana
> <quic_c_mamanj@quicinc.com>
> Cc: Antony A (MS/ECC-CF-EP2-XC) <Antony.Ambrose@in.bosch.com>; linux-
> scsi@vger.kernel.org
> Subject: RE: [PATCH v1 1/1] ufs: core: Export interface for sending raw U=
PIU
> commands
>=20
> > Hi Bart,
> >
> > Thanks for your feedback.
> >
> > The caller for this exported function resides in an
> > OEM/vendor-specific module, which is not part of the standard Linux
> > kernel. The intent of this patch is to provide an interface that
> > allows vendors to send raw UPIU commands from their external modules
> > to retrieve device-specific information or execute proprietary commands=
.
> The ufs spec defines a wide range of vendor specific query commands: 0x40=
-
> 0x7F, and 0xC0-0xFF.
> For those you can use the current caller, e.g. ufs-bsg module?
>=20
> Thanks,
> Avri
>=20
> > Since vendor modules cannot modify the UFS core driver directly,
> > exporting ufshcd_exec_raw_upiu_cmd is necessary to enable controlled
> > access without modifying the mainline kernel further.
> >
> > Would you prefer that we also provide an example of a vendor module
> > using this export, even though it won't be part of the upstream
> > kernel? Or is there a preferred approach to enable vendor-specific
> > extensions without modifying the standard kernel UFS driver?
> >
> > Looking forward to your guidance.
> >
> > Mit freundlichen Gr=FC=DFen / Best regards
> >
> > Selvakumar  Kalimuthu
> >
> > responsible for Platform 1 projects (MS/ECF1-XC) Robert Bosch GmbH |
> > Postfach 10 60 50 | 70049 Stuttgart | GERMANY | www.bosch.com Fax +91
> > 422 667-1208 | Selvakumar.Kalimuthu@in.bosch.com
> >
> > Registered Office: Stuttgart, Registration Court: Amtsgericht
> > Stuttgart, HRB 14000; Chairman of the Supervisory Board: Prof. Dr.
> > Stefan Asenkerschbaumer; Managing Directors: Dr. Stefan Hartung, Dr.
> > Christian Fischer, Dr. Markus Forschner, Stefan Grosch, Dr. Markus
> > Heyn, Dr. Frank Meyer, Katja von Raven, Dr. Tanja R=FCckert
> >
> > -----Original Message-----
> > From: Bart Van Assche <bvanassche@acm.org>
> > Sent: Thursday, March 27, 2025 5:28 PM
> > To: Selvakumar Kalimuthu (MS/ECC-CF3-XC)
> > <selvakumar.kalimuthu@in.bosch.com>; Alim Akhtar
> > <alim.akhtar@samsung.com>; Avri Altman <avri.altman@wdc.com>; James
> > E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> > <martin.petersen@oracle.com>; Peter Wang <peter.wang@mediatek.com>;
> > Manjunatha Madana <quic_c_mamanj@quicinc.com>
> > Cc: Antony A (MS/ECC-CF-EP2-XC) <Antony.Ambrose@in.bosch.com>;
> linux-
> > scsi@vger.kernel.org
> > Subject: Re: [PATCH v1 1/1] ufs: core: Export interface for sending
> > raw UPIU commands
> >
> > On 3/27/25 7:46 AM, Selvakumar Kalimuthu wrote:
> > > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > > index 78b57e946cdf..226cc90c74b0 100644
> > > --- a/drivers/ufs/core/ufshcd.c
> > > +++ b/drivers/ufs/core/ufshcd.c
> > > @@ -7360,6 +7360,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
> > > *hba,
> > >
> > >   	return err;
> > >   }
> > > +EXPORT_SYMBOL_GPL(ufshcd_exec_raw_upiu_cmd);
> >
> > As I already mentioned off-list, please do not export functions
> > without adding a caller that needs the export.
> >
> > Thanks,
> >
> > Bart.
