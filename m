Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA0639B4AA
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675403; cv=fail; b=AxLCGouRA+ub3lpQ3wIw8g4OioRxGfgMEBAPdY0uyaW/nKgPFCSafjjtv7J12u9EWT0Kos8hGte33uvML9OAgZ0M+gFCYpXgYmwWN+PGKRUP9Gc7C5aEuJ6IBTB86Fd9zyCE4oQ9iSSTwoWzpu6U4h7qoSwjB581AybbmhsYGyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675403; c=relaxed/simple;
	bh=iV3rL9Nh6H+oYpB0iuh0EpFuCT52sLS6d7ijwXwsWZI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u0Z8923fDux2hb4Yiq+0YYWrI1y0L3fTU76G2iALmgf7FuFZHPEpCsL6QgEgDihXQZRC6Y9OoFZmZeIr9vzY0evZUadg91mn1Pukj18+CmpipBar77sKKQolrFT27lJZmpulLprNAXrbhumHIAK7wJLE28/qeS0t5IL/BrIeldQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=DVprRqxX; arc=fail smtp.client-ip=52.101.193.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="DVprRqxX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f1pfZV49B27OdcDMoCZa4CxSAMZfGc1D169jDTKz6jqVIYnhq7PDIsxRKyLqgEESfsTfBDHUYEZHd+Xp5Ed+1458OAlu2/jYpiwWfwN98wUtamy3zQwG0QOfht29wvrQ2ykMHppGyN7wIqmYcApfuusnzsUr87sLoRjUgR9YhuNTYRUwqnoFzNTCKbGnNxtDitfYr1plNsBNqXgvm7hugBF0fH3ibG5X9rUkb1tlP3bvocNGEg4VtJwSC7CU9ZmpVRk1Q/w9hqNE+ZvajVWILghBk9jD0RF/TNNfudX1XzJZtcqtQW9rIX/vPaZ0tQbW0CgoPy+R6yhptTuawpGm3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iV3rL9Nh6H+oYpB0iuh0EpFuCT52sLS6d7ijwXwsWZI=;
 b=jlt0rCc5n1NNhsoyPoIVXAfjunu4vnyOt3Yj6XaQrS7CmgmhG84p6iwzupOa07t2sEx0h3F43WfZWKqVqizvzpI9tAOjhkJv8fo2rPp1TWs0oLl3cyAu8etW9x4IqFoStHtgkLOD4KolhUbniOZ6VFGA0+ECCCURRnUj6xowBGVfsxoF2qcEi09SPxKqS3jGkAqYG8YYS65LQ10jklEUXlNjVkzJQP7+/d70G2Bi/VdCZ+rPpFJaznpTjQTXhUaNYonT3zs4w73MuGDx898Qu/wVps69Q8pwZD8qyqdSaSgU+NiMPzxkMHL4MoSEe/NCHcB7kSLZSkx++/e/WLVCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iV3rL9Nh6H+oYpB0iuh0EpFuCT52sLS6d7ijwXwsWZI=;
 b=DVprRqxXi56WA0dTBqNP2SCafm5qyBJ+OAWUbInjt/iIyFQonnzbMywZE507LEx0Kn5GCYdU46xOY3CbxOuKyz5KwQU+Q50kF4b3aCYdXthp69DG1R/KvmonVXq0oiOsTY2maBTnOZmMog6m+DKDWXslZL/H2KEKXmDIJIP9QwZZiMhqMSHydcrseQ8tKxHcVpUF7eZ413PK1qemmdVDzcSjjnUEx+kP1xci3G6yyvuFVAZpBwiCB5b9YLkJYhgN1Kd7WCbTUKX4iynh9QVGLlytUyR3Yaui5Q1Q399dU5YKDPryoaHXPt1N7jl73gMw7P6Q7KGpnyLWr+ZYlugQmg==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by SJ0PR11MB4990.namprd11.prod.outlook.com (2603:10b6:a03:2d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Mon, 16 Mar
 2026 15:36:37 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::6777:e753:dd60:983b%5]) with mapi id 15.20.9723.013; Mon, 16 Mar 2026
 15:36:37 +0000
From: <Don.Brace@microchip.com>
To: <bvanassche@acm.org>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 34/36] scsi: smartpqi: Prepare for enabling lock context
 analysis
Thread-Topic: [PATCH 34/36] scsi: smartpqi: Prepare for enabling lock context
 analysis
Thread-Index: AQHcsmXLxGS/yDPzLEWCeIXzHBL7dLWxT9y7
Date: Mon, 16 Mar 2026 15:36:36 +0000
Message-ID:
 <SJ2PR11MB836948EF98E0F45B7D384682E140A@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20260312211636.3245119-1-bvanassche@acm.org>
 <20260312211636.3245119-35-bvanassche@acm.org>
In-Reply-To: <20260312211636.3245119-35-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|SJ0PR11MB4990:EE_
x-ms-office365-filtering-correlation-id: f3eab3d5-ca7c-4c97-99c2-08de8371cf81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 TtKQvJhAzBwsx9zaqVAHHP39oVENsXjFVzHIiJwIILUyTCn3frqUQS2fujJs1cAirhxuK4U6BLS5dDPxkp70w/7r7pzhAO9vRJaoUA/J3YDEWOTBrxZbDn0SO2J8/WZd578TpjpzgOd2uEBmYD5pcbbMeIFM2HsEtBDY25USr9WeO/lqR7re/zbY4VM9DxbTSahLxF2Jr9hqLk68DeDTMNMSSTMFor4IA8IQaupVLGxGTTXyUA8rtTHF13qLbupcnO29fNXbVTk2EnzOIQYMHI3EBgoIhqYMMSeGWFhRXulb3zQsG+ke1/evjETOYcyXpuPpV6dW7hynxAxZcDlamz7LoY1EZ53HVFzdeDyJOd3PA0Bw79zMRULr0rJSz2OZnn9XYMfPxguwgyL2g0eWHrVfw4jAtFixW5y04BX7o0grEqwYtCgImaUSKUwkUPmkdFv154HRd0cn3fMx1wRvIKOTkoek0dE/IrzkQwSA/hLczZfPJN0bqbzpzQ/Ww9a6VnbhTKBuLv9uPbteq5K8dg5li71SfrcvRAI0bL/LOiBQTZE4jGVNrAzK7jqXWgb0CE478+o9GfwvS6CuoTL9/MZCaVuFFo/GI2Xu2bUVAWSNH3MzNDxden3bSbxhUVcXOEMKCpp2Nrtl5/tJpwfSnnWh2BEBZcwd0I0tQioJmh/5d6ADZLOCCfJ9WiQA/NIoQFUR0C3nEY67zuTon3eiwKGlOra9V+B5mm8DNmfYDgkqrtgBEk1l2jPkouoo6LeY8trC3MCKwZVNusUU3iaQsxUShC03dBoLod0VOT8uZ94=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?A4Xc5WkfvinhxlDcEjCktMP0j6svRwC55vqHkz/hZnc+n7cG9pMkpyaAkD?=
 =?iso-8859-1?Q?bBIqeW5M9LsTLprml2YSUKvB32kGPB5cBoTyIUemFUEsVBoyAxUt1D82St?=
 =?iso-8859-1?Q?wKhqXjy2QdmvESceFd7MaomDzZYDlJ7wZz2iGQry2pvRpknfwCsqAE3ymz?=
 =?iso-8859-1?Q?GsnA3YMxZ1Q+1yE6fhIqORBC+hLV/792awv/OPWYFHt/NvuRn7jkYYcz/4?=
 =?iso-8859-1?Q?pN+9Ywadxo7lNDAF879mF2rJlODXY66x6qaRQoRcjcc4iqfMfjoE/gGLFH?=
 =?iso-8859-1?Q?ZH9oxf7XeyZj45HiduSefmKyDYjqEAmQG9EfNSnWUW86bSmnI8i09Xyxgx?=
 =?iso-8859-1?Q?8Ey4LH6SL5v7cvSjKb4AsEKMTH30OVYKW7tLhRy5XCbSpJ3ZfwHvMaLyic?=
 =?iso-8859-1?Q?R6RghLGf3El6wnJz0R1n6Wnvz/3B7WrXzh8fFyCJGlU2KeC54FomAwO75d?=
 =?iso-8859-1?Q?XpqNXQBlUjtSNy1ANWu1+UGmpHRXbh9+MnDWkGrl0OtoByqVKILiBxrb5f?=
 =?iso-8859-1?Q?l/mE51yw7SEHPFux4/hF2KjyeAR147knMQl/AKstx6GK802XWcTL/92yt4?=
 =?iso-8859-1?Q?sqytONlAtLUXTTr7zagZAXH1N27TOY3XLONlRojBDvn6Tz3Ji2YWx6CRmy?=
 =?iso-8859-1?Q?/FQ04iOJR4QjXRa+vORnZ9z3oRRmJCYjRQVKoK4Dc+La5EPmaEgAp9EiZv?=
 =?iso-8859-1?Q?MB1cHF1LzIWe0sB9+0/GrgeSJ1LcES46Ki9S9zNC9eo3xFAT/UsDfF202L?=
 =?iso-8859-1?Q?VgLQeKcwevX9SRnzfmjf2pfiagB3zmqMrLC5HFyert1Ddh7LZNHHhG3EBX?=
 =?iso-8859-1?Q?0YjxMx5SpIW461OyEtlKiLYQchhjhaU9i/lI/mywTsXKhOSiCfcdoteaeQ?=
 =?iso-8859-1?Q?vmFRt4Jbi0X4xb8mlqFGNWlM+uzjb/BljsREEAbsj1YAxYX1BqMTRdRPqT?=
 =?iso-8859-1?Q?7F73IGjdupCJGxFoKkbuWlEUJEGI78OjkcmpTym5FL7jMkqUlN8Rk9b9Us?=
 =?iso-8859-1?Q?xPmM0uL8LQwqWl+3WyN5qdnjR3IiUDH5t3wSYg8LtHuknoGwOoCEv9NkKz?=
 =?iso-8859-1?Q?Hallpic70kalOLNhoGEIX4uzLct6zP2XYzAdO6XqAuRdmkhIC3mnzr87vq?=
 =?iso-8859-1?Q?HNYkIyonqeVe2Nm/+8Rlcn3rv4uc/GFOpNnOPA3oLULeslGqNGNmoQW55O?=
 =?iso-8859-1?Q?wYjrweYAggb+s+iTpLVecToJuzyMsVwKZOU11M9lKPsnFz6EQY2v4ABUFp?=
 =?iso-8859-1?Q?9+KuYwETJhwQNTia/jVJBuGnNDxNzkE3K0gF3NIDaucpjUiSkLxk3K9fMd?=
 =?iso-8859-1?Q?WKnsYg/J6bcURF4bjFJ3+r/KwtrWFP+LHphbYzmUf2krz3RNfKwxYWdoWk?=
 =?iso-8859-1?Q?Mm+zEO0CvXKHXbW9RrvPuybROnqyy8ZC1yJQJB3g2p0GX7oayzrSzXRex9?=
 =?iso-8859-1?Q?MD+PoY9at5Sl3OMOR0qfBKzGLP4qej+BWZjzASCpgMEe4NPWnMwJ2oTDCd?=
 =?iso-8859-1?Q?x9V7Mwor33C3EyzI8Mtzlcc4GnBrlBgGoLbZPHwlMBL5MOiFKRvwhAmrtK?=
 =?iso-8859-1?Q?85PjRttSTIBCdnvVwitq2D5Rm7rTzaTE0d2f6F8iUZH9OA+UMcX1g8qTcg?=
 =?iso-8859-1?Q?mnAjvPpnkl5rinjA0ulAVSdXjXx70oT2h6BkrJibvmoGT/YWIxp83/uuxK?=
 =?iso-8859-1?Q?/AfHkaBFDfWMgTf621OqWJnSi8t86RRRSDVfUjucT/qX7Nv9KfqFsPzqpp?=
 =?iso-8859-1?Q?toZ2pCJj1H0vH9gYemNb1leS/HiHTIQqObphraGDjrn8KNnaNJCP2/2/6n?=
 =?iso-8859-1?Q?oCfgzsariQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microchip.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8369.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3eab3d5-ca7c-4c97-99c2-08de8371cf81
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2026 15:36:36.8924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jq/dMh5LS4fplArCO0bTmhPPOQ+F8EYyMWdgPMjCzCGMy7+9avOmhlHnK9rgngHU/ftoXu7upcf7MPttf/4ffA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4990

From:=A0Bart Van Assche <bvanassche@acm.org>=0A=
Sent:=A0Thursday, March 12, 2026 4:15 PM=0A=
To:=A0Martin K . Petersen <martin.petersen@oracle.com>=0A=
Cc:=A0linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; Bart Van Ass=
che <bvanassche@acm.org>; Don Brace - C33706 <Don.Brace@microchip.com>; Jam=
es E.J. Bottomley <James.Bottomley@HansenPartnership.com>=0A=
Subject:=A0[PATCH 34/36] scsi: smartpqi: Prepare for enabling lock context =
analysis=0A=
=0A=
Document locking requirements with __acquires(), __releases() and=0A=
__must_hold(). Annotate functions that perform conditional locking with=0A=
__no_context_analysis.=0A=
=0A=
Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
Thanks for your patch.=0A=
=0A=
