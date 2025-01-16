Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1F122A7E6;
	Thu, 16 Jan 2025 13:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737034061; cv=fail; b=r8ACpmKJB14ZSNTobFYpBTMZz8NJ6unKLJW2y2L2fKcVkZAJHn8xR4+FJyRM/gH9/FScD8xvJK6Bxog6Q6u0YTqppLRZ8/aRigiQQKRttcvXnGCAH7pl196ALIKwj3AqwesmtExhfkiR6bLMJZVloX17iw6L70wrXeiLUO5HZwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737034061; c=relaxed/simple;
	bh=rY103QtbMEkwJtcclaXVKyMR9CJivsD6N5FspRrhJGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bt5d8Gt2lcMdBeaN+y9dQa3/ky+3LqjTK1tsevBYEpK+A4kseKhALXYGPGBSVaELxEQPxdlZyTM5T7mSicjT7mDWqUY5+x3H5hhsrYYcI9uLtcMoTuhmmcAAPRHPNzRf8vxfSwMF6bqyo1VHM2q38gb6sHgn3DVfrFpevVOVjRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VSUuhy3s; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=q9ZLdrgY; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VSUuhy3s";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="q9ZLdrgY"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737034059; x=1768570059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rY103QtbMEkwJtcclaXVKyMR9CJivsD6N5FspRrhJGI=;
  b=VSUuhy3sk0Z4m9mTCL2C7Z2JNVqrUIZe42RlYPqRWr/bEBdG+4HxV8da
   LxaVbJaT2vdYKwMj1Zg/AVwt0xpoIln9dvf40mDkk9hLjRIP9/xHJEvDU
   Z4j6880L0WOY/hl80TdVeZDcImrT0Cor0d1aA9Fhh4OLGyX4XnuVCXJ1M
   n1rrRvcw00tZ9J7V02rYuADfaXebrNT2Mph7Lh9nQZHebZmfcx+NWphPi
   0kU3HTxtS0/QjfwqleqOzHSCl2AZrm0h2z+8s/7+QRXz0SX+h8bFbrJif
   J8KGq47DFnCd8X6NgzSptTwgSfPRFZ/9GwI+8Dom7sVoGC6VBWe552OKR
   w==;
X-CSE-ConnectionGUID: FC3GFbvvRjiFosX2qGIbBQ==
X-CSE-MsgGUID: HF9QAV+/TGqgDXzcmo2L6A==
X-IronPort-AV: E=Sophos;i="6.13,209,1732550400"; 
   d="scan'208";a="35862556"
Received: from mail-bl0pr05cu006.outbound1701.protection.outlook.com (HELO BL0PR05CU006.outbound.protection.outlook.com) ([40.93.2.10])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jan 2025 21:27:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xkBcyDwhreDTITC8VdOh4tssuajz9ELoKDcdZdfNtNrfqfl9LCbHtlICxed/tig0UnJjKP3yl01PXCz4QLZqbceGsku00zAnYbfgawHMi0AiQTD/aBiwNo5reDVzjbAOTMb6fLSUqjD1vN6jS4a565CZ5lWyLauVuFJo7JYvPimbLHSadZ6EmBVYa+4vaIf6ftwyYWVEtjaHqel+d3+abj6y4aqQ2mkkTJNaVod15lV3M74qjuU83PInc8WTjEz2mVoWJapNdLjLAYpKpNTY4POsJrbxAZjnnA0jKw+cjvpidBKbAdTmbDyz4pA30rnx6Wa9BvKd/N+t9ToXkztwLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtKNNa2gXZiMYRQ4Yzk/M+o5dq8ipOvb3jWLIZ7V5LI=;
 b=fwnqLckhdJqxRb/CcMAcMPKvQW0O53X3QnWtFD9RnTNJC+v3XOPvQ3xIjF8aCmA5yEUpLqlIH2ZxG6lJmo/d8Qcas60bT5Je5A1zD4nxorVQlYjSsBYbls7IXGlnenXKH0EkJDvXPYlGdveKRInUe7JimAOGNct27ULeSj1BDCmTc6+n3/7zHAtzuXr0MUSMAobeMQt5fMeCYLLoWZPwXab07C+XVVOIFsPGNiCg5QXTL9BRFf40CYa8eKJVKzkxJBajNoxGlZDGBnIsMYfhUlTus8SbHNK/w9dm4ny5fIq3MkCIez+C65nw4bzdsR7DXlcewrhLma1oDo9pw6uW/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtKNNa2gXZiMYRQ4Yzk/M+o5dq8ipOvb3jWLIZ7V5LI=;
 b=q9ZLdrgYrivofrFlqQVM9977UHBM+uIsoXrBNR6KwhS9CzXW56Pc2mi9fZwNmT/R9VCLXGn/85DBM6PzMYzEW3pMYiYQ8FZnfgS197FQGThmJCRjx4CxOK3DGpl5iTZgylL6P+ZUVaSeZZN7EIuVgwUb1P7FUbN1ggac/v3M1Zw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN0PR04MB7935.namprd04.prod.outlook.com (2603:10b6:408:152::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.16; Thu, 16 Jan 2025 13:27:35 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::bf16:5bed:e63:588f%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 13:27:35 +0000
From: Avri Altman <Avri.Altman@wdc.com>
To: Ziqi Chen <quic_ziqichen@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"mani@kernel.org" <mani@kernel.org>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Manivannan Sadhasivam
	<manivannan.sadhasivam@linaro.org>, Andrew Halaney <ahalaney@redhat.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>, Eric Biggers
	<ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>, open list
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 7/8] scsi: ufs: core: Toggle Write Booster during clock
 scaling base on gear speed
Thread-Topic: [PATCH 7/8] scsi: ufs: core: Toggle Write Booster during clock
 scaling base on gear speed
Thread-Index: AQHbZ/b1GDAJ+0dkkkWf2eRXNzBJqrMZYMtQ
Date: Thu, 16 Jan 2025 13:27:35 +0000
Message-ID:
 <DM6PR04MB657571E3A0EFA0E0400FD0A4FC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
 <20250116091150.1167739-8-quic_ziqichen@quicinc.com>
In-Reply-To: <20250116091150.1167739-8-quic_ziqichen@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BN0PR04MB7935:EE_
x-ms-office365-filtering-correlation-id: 1a7176ef-55c2-4169-2592-08dd363189f7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?mbiC6eAFumLNvNuOMatECoYvApwFqm/SGEp0eChMbeKip9gzkdh4UwpIIGZK?=
 =?us-ascii?Q?ix73kewx92dYjpIzEMxaqOVKJA1A8P9BfATii3/Z5EM1u9297hHUK5DmHOqf?=
 =?us-ascii?Q?oCpKHqXyJK9eRGhG5vBSOnTXyxnKTO/CUPCH1JS3tcgXBqFwSip2mY+WbpzB?=
 =?us-ascii?Q?pb8s41VPvxTnwtMGH+AltsmMP6NdDxcEUD7rb1znJMGQdfo6ouRpMHMJG4cj?=
 =?us-ascii?Q?ONwIBceEO1XHK9yWRr5bZGyEjb/1g+hxwd1KId5Jh7g+M6eh49/nFepXwZ9P?=
 =?us-ascii?Q?QDNvEZ/ZVLKXac0LSjXmJIueRkhvD+ve4eE6FEhDkGcT0osNRHgaldNUYVoL?=
 =?us-ascii?Q?cnbBmuu3a4nE4PkRokuLU4BLKwIJF2o/jsubYWng4jlqY3k29ibYTwJKftX5?=
 =?us-ascii?Q?w6oKihq/zEdn9xJUF7mZ8CDR0ST4KIwLClnlzfvxACRb5tncjORKA2nCAebJ?=
 =?us-ascii?Q?77UxuF7KUjA78LdsYRL7hY4D7eNAFMiA0dHfo4O7WxYKHll4xEaW+LfwuUbs?=
 =?us-ascii?Q?y8/0gD8e5Wp8xM+NpQNhV+VFNd2wkQtEXoRVgsVfhsxDW13AvnP13kalGHXs?=
 =?us-ascii?Q?DPy+yKpxdXNYMEyuDVX1wuIyZP4QBwYejcYZdfAHLiz2J2JVUKP/m0uyhGkr?=
 =?us-ascii?Q?c9u3CRhi7EC95QJH5GuAWjsvxp4ZsAZLI4MIvlDPyGJyWmti8XXiulOMD4Rj?=
 =?us-ascii?Q?nnugewyX6bvlPS7NcM0FEVaASO2G+Zo8qhuk1GusvA31jflPIkrxptgInvnE?=
 =?us-ascii?Q?O3DoMmYxQlvVenbDO+N8l8DrnrfM2i3sb1GlY9eOkRaHp5vB1iNxuAJVAyys?=
 =?us-ascii?Q?EhkO2NbngNdlZvEgnGB0HHzhOTWsDOCMF8cyUI/YW7MirE/g/x84A+vUh+nV?=
 =?us-ascii?Q?j9ETolfMkPovasivqGSFO842g8ZL7TuLygIKOEK6QQ7ru/XLAsZ7ssEbL/Py?=
 =?us-ascii?Q?yd0jVfGkCqIfYv4dS4WXsZOeQV9okMNWtvuHSRwgX+4iqSNj0KINFykFgd+d?=
 =?us-ascii?Q?aIzeCMwajdY14Wkoz/Dp9TIcWIjCjAMec89TXaruv8HD7oujxnypT8QHn4lk?=
 =?us-ascii?Q?9G7jrbtY/slau8Hd79/nR0hEpyX/oLuyMQLBmScCxQuB4MVIy/i3AmsL1ajq?=
 =?us-ascii?Q?IKnMtNSK7xYKeURj+sx07Iqo62hTPiuSNtQFrXgEuXdTrnr/96Fa6nJsfHEX?=
 =?us-ascii?Q?srynp0XzIFqw07DVLI8YKI1q1sGmeWMI7MJF+dJpNmZNR+hogInKx0f/3IY7?=
 =?us-ascii?Q?jCDTXcBVb609a0k4C00/9O1onO0PUr8hQ6cD+0VtQAfW3lDF3zM7LfDXGJpC?=
 =?us-ascii?Q?/U29bYcabmiSRu/BUfftd8mOS6RtNIWZmvOXLrTchCXsIyjg30raDl8W9Kbv?=
 =?us-ascii?Q?e5+aYV9CRRcMyklVYq+XrMLLEEd+GgZGHmuzHZrIIC4iWGhHGNKzE9SWBHeE?=
 =?us-ascii?Q?wgIyyCNm47a4MJTIDfi6Q2LMB0MMBW9NBk8+VkRxQEi6DJfXaLNrVw=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?zwf8CZscKUTaUF2dWtLnfT5jaeonROizeZcylh8yt16OexrA042gEX5K5SXX?=
 =?us-ascii?Q?ZzsrSZnqev5a0vqo58hnYqdcfCq4nbBYyBtehPECAP1IDJWdznwQ/MiplJR4?=
 =?us-ascii?Q?0WvERTWzapd8z75nufvOIj9i85F7IEC5fFNSKnyhvAGj7i28jWxX/SybcIYb?=
 =?us-ascii?Q?W60FxaiJW5C+NMj1V2GfCQ8oNwZB0ZqL1D6VnbRwez2BPBCzOIuCga1JQ0Xc?=
 =?us-ascii?Q?/zCA9Djp0dNjF7xY7xRDRzrUXdpczlNpLLpuDumzdzj3MpBuszJDnoIAZt36?=
 =?us-ascii?Q?sSwaOJrlBTPWYJDIprD631YpEp09/EI8I6RL7eM4LZHcWNPaXhDBTHw/LP27?=
 =?us-ascii?Q?1VWS48RQ/K1gpnpKkqIGxN0N1OhqmAYrNAyQTXN5pak2K9zfsn2nCbwxoqoE?=
 =?us-ascii?Q?3Bpu0Ja1NphE+3JzkI0GYyGsv/+tsVun2STm7km4PBmpFC56DzI+BRIiyqZY?=
 =?us-ascii?Q?Kry1Tk4B/tqE65RjKJheFIAdKoaO+qd3qGVdoO1kjg4WZMoFLZOFpXkNB+0g?=
 =?us-ascii?Q?c6vdUlhoXDy9jxUjg7vZzdLa6BxhO8lhVfHTQK+eXOYDxSsTG10+tsIJ/rfH?=
 =?us-ascii?Q?17C+xxo/dSF2uW8jBmNQvkMndbFu9OIHPWqN4qu3ADd87nLQQG+5XHRvl+hp?=
 =?us-ascii?Q?fKpFpC7h8lEYaquZoBXZ17C09UqUwt5QIXXqlZOf1bZnmyFl0evY9xYWQpno?=
 =?us-ascii?Q?CH+86EFYU7HADe8Wf+yxWJJwMINszOx4jSF+Wai9nTiRw+rHFQYqUqW0vf3k?=
 =?us-ascii?Q?D7yhJZTVlsevdcqENC2Z9W5RMbv1V+mVEpL3nM2KsxLi1+qdswlUsEgPKnLb?=
 =?us-ascii?Q?rY9ZeP8scrVRWRJTbcgFkNQWPzbiFOI7gwv05bxI0QNCZqCt4uo9YJq0WqQ5?=
 =?us-ascii?Q?hHSwDfCNWd4yGRzK7is7ubIUXEiIsnG/UHXvPGwhAQ5bfX7f5WiopGQSeJDW?=
 =?us-ascii?Q?bDp+nU6losx7ObPQVPlvKJYJBymIl+N3BULGI/Dm5GXnEruNBWZbSmK9Ojo5?=
 =?us-ascii?Q?wx2LhhVekp+ucMrtXwUWhaqGId9fSxJl+SBJM1zv+MQ/6q5pU+Bv838cubTE?=
 =?us-ascii?Q?BzQ6x1mvV+BdkTgcjdv8QtYShx3T6iYMODpSbp+hDTbbbS+DQ0F0Wf+q21GH?=
 =?us-ascii?Q?LbwD7DsluJ+ryBa7s2GkT+1eCamtGG/r03UT/eguaKJC5ZXGtKrNQdsNaHwd?=
 =?us-ascii?Q?AYcF29mGoHT7G1D3YVQQoxVveyitJt5T9zk5VjpCF1pnZH1dW6AEyLdvyldB?=
 =?us-ascii?Q?v2Upf/OCgt2Bm4t/nF9GSROl8IxlCXEHHKnKw5rFZgxwlAvoI6mv9gTG595l?=
 =?us-ascii?Q?gqoXwz52FtI2WGdZLVhC9r4/rG5IEqB1F56dKBHPU/hYilFD+SFC3DxeH6dB?=
 =?us-ascii?Q?Cs40uzWrwlL4aJpALEbB/MNlWLzLc7BIUuAAR6VnLorDEU31OSo0rtH2102A?=
 =?us-ascii?Q?QnZnTZYJdPNC7H2VD060IE79yKWS7d+PZGKm87kDsFN1+agBerI1eDE5NMKe?=
 =?us-ascii?Q?4XpYdhd0DJW1ZZgNXzpIfkcdo7Dse/6RWWcNHKz+PC6YvpPGmenTAcqUVxjh?=
 =?us-ascii?Q?X5vL9JjfOdRa0IWoF8voDNugWrmS8dbjmfvYhVgy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0O3fk8GYiX2zi9KC5Hrr2VyY5VNS3xnoxr4mXVp4tX9ku4wdDboZf29+F6cUBAWnmAHZBbWf/1g7Jh1Ru0DOwQyeSd0N6VTFKyOIVASl7+1yfGLBLslybN99Kp/ICppE3TEoOSSOVVJ8Mv3Kr2US4YzX2/lKrof+KT9vJEapCJ9J7+sCO/Yksa0dX1Ej4V/dLnWgSG96asqtJ7E9FnBtApJyDM/UgBQGLvbq0mKQm9uDim+yjLzsrsH4xMDC1Dt/rI2HxI9Isw+94wFFgeI5a8YkqzYA953XJLnPXXTllwIkFrvbhwAT6CrOuqNL2GdZgbdQQs/Ht0LfQyDxteXIXRlDT1vYzggPV5W6y//T+G5LO+GOcu+Gcm/N60KbvAG26qxwmirV81uZ7PRYuCSOhtZk45OFsPxw3hZq8ML+ld8Jr5Of+CoOKeX/jZYSL/xbjZlgflz7TMIY1o+hV1sb5S4H8DX77pDHG7gKhSPz+wxK7IDxYd95SKd2BkO6NNd3NE+nTKcSzxAdUxHY3+CI8laa5MS+1SWWpnthdjoupxk6p982ES0WArAVE+07Rrp7AjOJZxgcaEXLlM4un9GpUPkf7aQwvPyRR1a0RD+/EmXRX+ac8dGHs36IJXoVzpg4
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7176ef-55c2-4169-2592-08dd363189f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 13:27:35.2121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2C+LvTYuCCzxkLYE0nXCl6ICzgbwdoQjGZawHJ1S1fJE6i0PZslXRD5J5sWvh6U5LMb542EopZqzEy3+9FtulQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7935

>=20
> From: Can Guo <quic_cang@quicinc.com>
>=20
> During clock scaling, Write Booster is toggled on or off based on whether=
 the
> clock is scaled up or down. However, with OPP V2 powered multi-level gear
> scaling, the gear can be scaled amongst multiple gear speeds, e.g., it ma=
y
> scale down from G5 to G4, or from G4 to G2. To provide flexibilities, add=
 a
> new field for clock scaling such that during clock scaling Write Booster =
can be
> enabled or disabled based on gear speeds but not based on scaling up or
> down.
>=20
> Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> ---
>  drivers/ufs/core/ufshcd.c | 17 ++++++++++++-----
>  include/ufs/ufshcd.h      |  3 +++
>  2 files changed, 15 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 721bf9d1a356..31ebf267135b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1395,13 +1395,17 @@ static int ufshcd_clock_scaling_prepare(struct
> ufs_hba *hba, u64 timeout_us)
>         return ret;
>  }
>=20
> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err,=
 bool
> scale_up)
> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int
> +err)
>  {
>         up_write(&hba->clk_scaling_lock);
>=20
> -       /* Enable Write Booster if we have scaled up else disable it */
> -       if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
> -               ufshcd_wb_toggle(hba, scale_up);
> +       /* Enable Write Booster if current gear requires it else disable =
it */
> +       if (ufshcd_enable_wb_if_scaling_up(hba) && !err) {
> +               bool wb_en;
Can be initialized?

> +
> +               wb_en =3D hba->pwr_info.gear_rx >=3D hba->clk_scaling.wb_=
gear ? true
> : false;

If (wb !=3D hba->dev_info.wb_enabled)
> +               ufshcd_wb_toggle(hba, wb_en);
> +       }
Wouldn't it make sense to move the wb toggling to ufshcd_scale_gear ?
This way you'll be able to leave the legacy on/off toggling?

>=20
>         mutex_unlock(&hba->wb_mutex);
>=20
> @@ -1456,7 +1460,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba
> *hba, unsigned long freq,
>         }
>=20
>  out_unprepare:
> -       ufshcd_clock_scaling_unprepare(hba, ret, scale_up);
> +       ufshcd_clock_scaling_unprepare(hba, ret);
>         return ret;
>  }
>=20
> @@ -1816,6 +1820,9 @@ static void ufshcd_init_clk_scaling(struct ufs_hba
> *hba)
>         if (!hba->clk_scaling.min_gear)
>                 hba->clk_scaling.min_gear =3D UFS_HS_G1;
>=20
> +       if (!hba->clk_scaling.wb_gear)
> +               hba->clk_scaling.wb_gear =3D UFS_HS_G3;
So you will toggle wb off on init (pwm) and on sporadic writes.
I guess there is no harm done.

Thanks,
Avri

> +
>         INIT_WORK(&hba->clk_scaling.suspend_work,
>                   ufshcd_clk_scaling_suspend_work);
>         INIT_WORK(&hba->clk_scaling.resume_work,
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> 8c7c497d63d3..8e6c2eb68011 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -448,6 +448,8 @@ struct ufs_clk_gating {
>   * @resume_work: worker to resume devfreq
>   * @target_freq: frequency requested by devfreq framework
>   * @min_gear: lowest HS gear to scale down to
> + * @wb_gear: enable Write Booster when HS gear scales above or equal to
> it, else
> + *             disable Write Booster
>   * @is_enabled: tracks if scaling is currently enabled or not, controlle=
d by
>   *             clkscale_enable sysfs node
>   * @is_allowed: tracks if scaling is currently allowed or not, used to b=
lock
> @@ -468,6 +470,7 @@ struct ufs_clk_scaling {
>         struct work_struct resume_work;
>         unsigned long target_freq;
>         u32 min_gear;
> +       u32 wb_gear;
>         bool is_enabled;
>         bool is_allowed;
>         bool is_initialized;
> --
> 2.34.1

