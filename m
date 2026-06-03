Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5323719F12D
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 04:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780460101; cv=fail; b=O9vIP49zX3te5xs069d0f21SMdXRmv8UavcIuKsCzz2G2nqQm7Ms5ek050yp3ciEySILqGtIN3iulXSh7qTFJ/a4OhK/TGPdD1+V/NmYIqMIGW6y2gyT7j2xfW7rUgmK4LNImtlKV12BNlymaAOEdoyPMOQIWL4lAvtuyFV2NNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780460101; c=relaxed/simple;
	bh=zaqDRmJSJK+5uxFYHmsOQxOU1BsTiDt9480Foz6RJNo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BkQCGJ42is2CGN8ntkdgtvCgPK9WHINbuq+t2J6pWuf7Q5omk7DECA4sVKRDufP+Uk8gGYVAzRzrFCOQ8h/jJH23b0TVqyS6Zh7Sy5IIRrMUBHS9IEEbtSi6oweSemwJhjautY/anLvNVoj25MWqGbkzmKC5vRdnWiR40HO0Rwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=aeddMHr8; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="aeddMHr8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1780460100; x=1811996100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zaqDRmJSJK+5uxFYHmsOQxOU1BsTiDt9480Foz6RJNo=;
  b=aeddMHr89csf/RQVRQXJLRIhjTsYAQQnaOzQm7HhGMQi9d2Ug4UcFnk2
   TY9yN0UCqmc7wDImaMsU5r1F2krmlIBJNe8FK93NaUKGNYpEe4tlnpqFF
   ZEaRI3T2+eejQNu7HHYJPeDU3GDnKvrRdDyAbNFX71Gc+LeIXdZ9oDQF6
   kxumeFa3OoZgIxhEr4lNlTpQR7XR+hW2Y+rXCvjzbIcXtrIZqDMjMeng0
   hYNkmciZLhSSATAMV1au1QzQR8RU6DTEmOKbY1/ULXDp26WuM5HbzJEB/
   1dWsDjhD+5ypPSUI5QNZSgocPqUfLMfUzGWY1sB1HvWvw355M4wItE7qj
   A==;
X-CSE-ConnectionGUID: AzBM0IUbSbK7sVLNFwdJ3g==
X-CSE-MsgGUID: xwLB8QuOSWWLEAsFg3ihgg==
X-IronPort-RemoteIP: 40.107.201.58
X-IronPort-MID: 24014258
X-IronPort-Reputation: None
X-IronPort-Listener: OutgoingMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
Received: from mail-northcentralusazon11013058.outbound.protection.outlook.com (HELO CH4PR04CU002.outbound.protection.outlook.com) ([40.107.201.58])
  by ob1.hc6817-7.iphmx.com with ESMTP; 02 Jun 2026 21:14:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OPKCyYqs7kUnCYJnFJC57g+FcWhy5XInXmhW0eWNN9JP/he7mdcx+xP48/oT9ZRInqv9kbk8/wuHmrRs+KmyFo4TwW/1zpSAy7RyAhzhAmc+RJtJ8j7pJrqlnRQjHs0tXIHvB7xMiaEF5/sVxu4Tr4bt8+V5J/SC1dtRrM/8I+g7IHy867ai816LCHbHZQU7a1I0yiNx2MWgyullkaD0KZz3IMCLRui/kWWRdPXKfizoxRSuBZZyxjLP3IkTNU0mcUq4qEp0XqtKklcoKwY7GLVEyUlwVZc0vnNxFCA6SDIEAPWYWr/cYOSY6QUAjgxYvmnPlQvDLl58wCkyrEqMLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaqDRmJSJK+5uxFYHmsOQxOU1BsTiDt9480Foz6RJNo=;
 b=f4zBkr11LIlwm2BtfQ1pfd9RKqzNVXNyOecogaVCYDz1sJO8EGh4jDP9H6Uupu+lSdrHrrJafSWk/NkWPQ9w+A+OOa3lUbZdWpyqYovhKpkSNSD4UqmGniCKUPJMt+6LAAd5bEAlCeePQJn7Yd+0b7byE4sGsPUgZHEXMN60h57TtpQxrr1N3dispXby3V5rQFcy+qWPB9NPGMNwKuSzZW33IejGREcTYWAfkiZgObzkCt4f06PFR7Z7TW1xHgwMstGKjl+jg8ww+An+OTKAuvJ9HMPDAawDS2ApTZ97s80xyJEqnDAGnCxlxS85bEKuS6Sx13GJenswBlFPUJcBbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from DS1PR16MB6753.namprd16.prod.outlook.com (2603:10b6:8:1ec::5) by
 SA5PPF9B8AA7311.namprd16.prod.outlook.com (2603:10b6:80f:fc04::918) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 04:14:57 +0000
Received: from DS1PR16MB6753.namprd16.prod.outlook.com
 ([fe80::72d7:97b5:4539:a90]) by DS1PR16MB6753.namprd16.prod.outlook.com
 ([fe80::72d7:97b5:4539:a90%6]) with mapi id 15.21.0092.006; Wed, 3 Jun 2026
 04:14:57 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Avri Altman
	<avri.altman@wdc.com>
Subject: RE: [PATCH] mailmap: Update Avri Altman's email address
Thread-Topic: [PATCH] mailmap: Update Avri Altman's email address
Thread-Index: AQHc8rh5dDxkQkSim0G1qA4nuRmhoLYsOSLA
Date: Wed, 3 Jun 2026 04:14:56 +0000
Message-ID:
 <DS1PR16MB67537FB8757D26105D735E7BE5132@DS1PR16MB6753.namprd16.prod.outlook.com>
References:
 <b71be634e78d3a51048ec28fac2eaedb52d6cb09.1780422652.git.bvanassche@acm.org>
In-Reply-To:
 <b71be634e78d3a51048ec28fac2eaedb52d6cb09.1780422652.git.bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS1PR16MB6753:EE_|SA5PPF9B8AA7311:EE_
x-ms-office365-filtering-correlation-id: 615923a9-5a5a-416b-d746-08dec126abec
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|11063799006|56012099006|22082099003|18002099003|55112099003|38070700021;
x-microsoft-antispam-message-info:
 vu8axpThboxhPgprLmmORG+rKfZ9jcmgo1JTwAAmqNgQJEJrr+SKFpQas3yeOlkzVom9oJ3/hrhUJzikniPkYsXFwN4yC137wTijhOyAO7bn4giI3LtHZOfdWuvFasia9pLLzEmR59d8wj8JjHx50fPIrngS+V0I7RATsxkDy7LrdiikWt55L7GSRKaTSuZQqyYrvRwg/voOA3U0iE0aJDDw77SDDVhlXAxq8OdIget3Pls7zk0u3gEVLVNGLOa195wLYEHOS2/xzi50FV1Le2mj8qiW0NyF7touVKPfIYh06ZvWALmM5KRMb3sKeaVtxSUed9p419uvbOOkfT2koRdVhyquJCmtGQnbzildqWMe4rdEN3vsnQNWUm2Bbcz4UfK3+y+/nfjUR7xfoUQbKI+DXTSQr7bB7/pL9JAO0ZK5iLJIw3LUi5+jeZu7f5LSP2/rrqzVnEL6zJ8f+PYx5QC5mdb9AbzDNB4LFe6KZNkAMJqcv9hS/77B/1NNq+6WjrIK3RmzI3mNVAQFhOKaHyg3ZQIuy+m9IdxU+jV7njWlS/j9pNxLbarBqLAss/IBr1R5AHCbB/31iDC9IEv5eEltBVXuQBOGwwYVl1G4Y1WsqWGbKR0Y5b9hBopyqXvVLKBTXWV/POzO8VxGxfj5FXD66w/AbL5tqPVjb2N5YJ4RkAndEOcD4tY5o7OkEfNILQqazoW78BjX2nXEK5JSWK9bBw2oHyuOVMlG8Lw5pxyFf4gPgTCyQ7ht4FCPEFv0
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1PR16MB6753.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003)(55112099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ftGma+FhyXS6vRkLTm6T/NnqPqY5OU+CWo5yfytilFbpyj9Eq9dZTK/Clasu?=
 =?us-ascii?Q?5RoCfNFrKDWeYAHdpg1mpWNfK+Fep2A9vywcfiQNuD2LmTmRp+5nH0y/YHx6?=
 =?us-ascii?Q?X8NMOp50J6UUcXHk+9Et8WpkanT+1bDpIxADQVg7gOLA2UmBH6S4n6jEn3iv?=
 =?us-ascii?Q?Ws8/8XFYrSHYt/vcO7BG7QhJSsEue2ssQLOUUR99f9vvDd6kYTya2e2vm/kp?=
 =?us-ascii?Q?r0+MtZF340fsSTWNkwHnvSFTL+xWU6BikITXI0/mikMw3WxiAYaP4whT760r?=
 =?us-ascii?Q?c2ojVgVkbvlnA8gXQjhE/Bs25194UyuYX1upnsdmLZ92jP7eU1OCiAoPeHnu?=
 =?us-ascii?Q?oX4DDmsbVwlRYkLCIFmGZJrpfti8zfohruknrXj+Zw/X0x5KDTLuYfn3Syrx?=
 =?us-ascii?Q?vd0rrROBKRVzmC1ZJda7+Bgv+OWivi6IHzdcnjMvh2Q/mZ2E6mJb5L3+gLBi?=
 =?us-ascii?Q?V+sbAo+8i3PisQIHL+Ks/vJ0iJtiUykrDvZt54TCb1td5NwSRtsAMH0nE0Ps?=
 =?us-ascii?Q?uMe48yRBdFXCcf2z81jDLwjZeSm1C1nI6e5kc50j12KFlss0Ggsubhbx+PSi?=
 =?us-ascii?Q?IBgNPvA+YRHPZyIg+tTxbbY3SlwMz/Ty6UNNmBz22buRmehiEdqDvDqJ1wcM?=
 =?us-ascii?Q?gqSl770qQRgZbmRTZ26NJIJIrJZ/jb735Fj07m+UForYA8v0cb3SacdDz5GR?=
 =?us-ascii?Q?07OWrPQkLYT5m+MQTmXwEwYkGiyoFHeOuO5Foboy8Wn0XHB99hkp2s4UVeb8?=
 =?us-ascii?Q?bft3+yMM6KH6GaO96WoXxNgbbpG6gGLd9icMUksqfMSelKhUbCdL/TPlchKH?=
 =?us-ascii?Q?ESb9rIqPnywYyujVBCB1KV7JQTEmYazJzOeOex1XU0sM3NhUQkzKz++Ny1kQ?=
 =?us-ascii?Q?6FEsZrzTSTIFid35LTYmLdoSw/lMGojymSSGC8LJWqJyvywkvUi1An0Q7Hkp?=
 =?us-ascii?Q?3TS7l40j8HWnK7lf84jr7z6oEo+HrFhf6YfWu14hJObaoQ71SCfNU7wE1a+p?=
 =?us-ascii?Q?KLD0BPs6AhTLD12Y51wjpquvtLyjxBC6yKsaIHh/UhyO3yRzgrrpOTygCGKq?=
 =?us-ascii?Q?BFKtpDA0TBXN79+VeueQSROSzgvM1M+571S1kRdNFAr70uK2BTtieUvO/W8d?=
 =?us-ascii?Q?SSDRsDTjjghm67mpbVEBVI5UZufkSSKFXHyUNzeHn7xXyS4ptK9KLjMUxV7q?=
 =?us-ascii?Q?+0dSqD18eX3cO2VO5uy+Aze5g0vGkpno0Gst2akg13AQZu6eO3Z/2jl/Mp8p?=
 =?us-ascii?Q?eLV2U78PU+7IovKJfI4gr1tqHvIvOIQLciOSpMA3L1e5SErRNDtexF9js6Xr?=
 =?us-ascii?Q?gxuCOdtB2DZamRKQ03pjZhMA9ZdUlz6RAiaAQltmJBEyLyTBTP/JCypBwbWx?=
 =?us-ascii?Q?KuVRyNUAkKyALIoWj2VdO2ih+kgGLGgxCR8qTyNtS8TXlukAvgx+diYSmYMV?=
 =?us-ascii?Q?AUZBYvaL+eltMirhEI3oEqFH19njrWnL8In9WHtlavq8f1VOtq6Wd9rsEWf+?=
 =?us-ascii?Q?NKSQOnCfvKB8N2caQYlqBe4+U9Nj9erOS+KPS3XdKItNJNU9k8dy9jGgPCob?=
 =?us-ascii?Q?MUPcb77PA0bGEaQcO2Kv01E31c8QHAvtJ2ThPdTInfuivfFFDwjYDW/rHD5z?=
 =?us-ascii?Q?krJ/mK4ALNrvEagYQv3xweAiKaXFVL73SHUAvE4kLEkael3+mS62f1N4IlZ/?=
 =?us-ascii?Q?jJ1JLgRmYRy8WS3utSPs45160b+C0WhsKbPrzrMfPf/au1n9i2iV4dM/c3Vd?=
 =?us-ascii?Q?X/nnmxQcsg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	B/w2G3zsOyUzpeggfUohjq8axkPJ/vMxQu7kPqJWbzWvoQpehKU6o5lUfJ2JFFe7ZMklzYxGU+jcOVWousiWVt8l3ZbBrnN7BomMoD4wo2Fk+Lz5tpGm+tZxGOhhd/u04i/1/dSdxFKi03gQKtvd9ODyOjs+NsSkQEyhMBV52aDXqp6Fo7r6346Yk60jk1FXjz8fId+YkUOnBfqV4shV6nBbKCwuvvb0YIaRHsOyb5Ee3DQSUAO7fCmOFkW3cbL/QOdHmQlFa7FIM9DvddJ9JM+QIAqV/JIXeyEVFJUstHGKwZ3sAzvXpW+2HXkPeE9j5a9eOP7QPxmbWgXrBiBgCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ze4JtUndfVpS58v5x99wVf+KsAXz0Y8lXKxd0bFjTO7SawK4pVxJrM6lcIyeDwte8UHSx4cBtAm99P8LlMiVijxmoNbteDIrqjuFNdyZve0f7Ongb0AEQx8oNbAv+wRV/kEHjE7frFfTeIjQPfHfOGZyMkrtulagsNRuU8NiXXdBq+/ln5xBAi2fNdUPJRSNEjl26KSNi1v39xfWqEbvlpyOyUi5dGIhbt85sQw9Qtxakmckc/d518/oeYHAqZWQx5Jw3JEAWbHWVp0KnR1t1ieqf8B2ipSJrBHamumjj62BGI1X5ktwMPcrqOF4+CAIAEqJBPnxoVo3KZ7eaqiyB1m0W+fholNB7ARzMVItOXv5w4LRg7wtYYZIG9kGx67wKC5WLBjRWno9U4W/E6/ycnk1HDjR74MAg/CHyY2UTRsl3bE69xBUYT01V5OhqwPEdnyxGmepmobUqgSKphbZuDaAcr9IxLnzFrjT4GYvl1E9WgLYYUn0R3uPaJfTSaUXflvbZR9vI0KdHdXfTUWCyfKmuUSDMMLhxeuICzChPxinmfDn8I8kAXZEEPVSqRtxjgrTT0sfl4Hy1FIEjlh9nkuTgVVZFKxaWDHuDt/h6ss5Sbop/O99o/NaLmK1EAB1+Q6BBaK9JkBxCS9EcIH5tg==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS1PR16MB6753.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615923a9-5a5a-416b-d746-08dec126abec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2026 04:14:57.0134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4s3NJriKL5ZpAKmuMCrmoNu7jZKSkJGSIsFHCJrBr0K0GNSYB16L+Gh4PoGV/ONA60+mVTyl8LsT9yirhEGyDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF9B8AA7311

> Avri Altman's email address changed from @wdc.com into @sandisk.com. Add
> this information in the .mailmap file such that scripts/get_maintainer.pl=
 produces
> the correct email address for UFS kernel patches.
>=20
> Cc: Avri Altman <avri.altman@sandisk.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <avri.altman@sandisk.com>
