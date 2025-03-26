Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B8614831F;
	Wed, 26 Mar 2025 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743001735; cv=fail; b=o9iYXhm8p97HLtF6UI9rrp7XfcA9AXrvxX1tTXTz71AOPZx4CLT37e9bNCRvaNokO3YhWNlH5eeyqj4FKzoNkGcPmHhVTvG6VnFRNZmnpHMy/E/f92Fv7zNJb0OBkoMafXpui/OAUQuiYxrXnquaCb6zHsGogzg87u0sdi6ULU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743001735; c=relaxed/simple;
	bh=IlFMsN/AzpeR/sumNViB87hKULxEqmXLW6IRDdd8M7A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MDfeM2MJZpMKbbmgEnjxxLcvZZlkavBrvT9OLP/0UrfB1Jxs0yxAq7OG052YWpOj+iUNSfP1KLAu8r8ifEbMhLpxZquMW4UZ6j9IHSajY4237FDe/Xip9rWRLkvfYZ6OLVfXrORKKIncKBXbGhCwCRAIbBD0lThLaMbTwZI+64M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=EahFnssM; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="EahFnssM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1743001734; x=1774537734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IlFMsN/AzpeR/sumNViB87hKULxEqmXLW6IRDdd8M7A=;
  b=EahFnssMeDTve0kaHq9qLtHbv7sggRxTRCKj6UVQuue1pc+WHKFqwY8j
   Ek4tXtnr1R+VZ62FW5TJB2GEi9jEKWp9JZjK2kAHmP3fvcjKuTJFa+ZQW
   yQzrqPaa/4V8tbkVONGVM7fxJj04EuKhk0Nqg9Pm8Nm0ZpNJA2x8wTOQ/
   P3VSQK4LaVn1MKdowqZMeB0VAHNB0d5WtZ2iA93zzFB4dC3XpZv7KohFu
   7HZInTqZu5yVxIg2dFg9LeLuBWPOu3nlpLlvSIrIPY9Kx7DF9i96Trktl
   xvShQLo+PT+1EBKpHLU/tP282wsl9jiXOc0O2gk4yY4EDiM8L7beAsBvi
   Q==;
X-CSE-ConnectionGUID: rf3lR0drRIGRXK7NoTOU7w==
X-CSE-MsgGUID: tgwO/9yIR3Wp1Y5Jpplipg==
X-IronPort-AV: E=Sophos;i="6.14,278,1736784000"; 
   d="scan'208";a="63692705"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 26 Mar 2025 23:08:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bqCHgzgzy+gZeKwrv8t9Sic6kdvtWxmMS6rBSiLW6QvQKG6tvbqhR0KTn7XySM+/ZDlojLKtmpneEpgae6EZ7GXDsbVb2E5MKiuv9E/CgYuRTeRo7Wg83O07hgJRHZvTpPnN4kc4JVOM678QsYpjGPN0VREf3JjB4imPiMz3gn03HNCq/VCklH9LPPZOYY/RIaXj5w4bMwb1orL81cAt6Mf6RzhJHNKbeK5GJRUL+cjZ0iXuZCupJf2E+fyQkfdQWx38CDWBmThAOMTR3vFAbbRbO9UEydwMSIYB6IZlZJI/Bv/x1wEpCgPh6LwuGVzqErumZ+18MrbhvrjDsrYrMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IlFMsN/AzpeR/sumNViB87hKULxEqmXLW6IRDdd8M7A=;
 b=p5S0Vt61oAhYNy0SlOWlYh4nOuIWahGLU7bWlkOOj8jgI8c3diTT1NnI+8QsTlaP+8D5W8eXyBfF5xEyKmSExht+dRhDtx299Fyl2XzlOUayJXx9NsosRseD/QHn6+NTYt4zIk9om4D3ORQY6OuNJISKm1Cd6ikR+n3Grp59wEPCsdruG0GMJVuHnfA8ksc35c+43aB6JYrYwh+/07ZJe+z0KNAZu8Wff9Bd/vqfRtU6oIZKl4RfdemMWXPVkLjI/1w6bL+xXmsrV8uy+aTwYdQoOr6hPLUnU1FnPnZCs6E9InGtACBm99x9uuLB1IX2ajqU7s0+zaAOjQlmXX+WZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from SA2PR16MB4251.namprd16.prod.outlook.com (2603:10b6:806:136::8)
 by CH1PPFB28BF70E7.namprd16.prod.outlook.com (2603:10b6:61f:fc00::a22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 15:08:50 +0000
Received: from SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2]) by SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2%5]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 15:08:50 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: Can Guo <quic_cang@quicinc.com>, Bean Huo <huobean@gmail.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"quic_mapa@quicinc.com" <quic_mapa@quicinc.com>
CC: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
	<Avi.Shchislowski@sandisk.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: RE: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Topic: [PATCH] ufs: core: bsg: Add hibern8 enter/exit to
 ufshcd_send_bsg_uic_cmd
Thread-Index: AQHbjPsw3ucJcBmYkUmzp81f56cI4rNmEpWAgAAEGYCAH45YwA==
Date: Wed, 26 Mar 2025 15:08:50 +0000
Message-ID:
 <SA2PR16MB4251E65FB23943146F8FB560F4A62@SA2PR16MB4251.namprd16.prod.outlook.com>
References: <20250304114652.210395-1-arthur.simchaev@sandisk.com>
 <bd2e01d8b33413655a4215221c910eaf2cdf6461.camel@gmail.com>
 <c3f0d284-07d8-42a2-85d0-f4023b9b6bbc@quicinc.com>
In-Reply-To: <c3f0d284-07d8-42a2-85d0-f4023b9b6bbc@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR16MB4251:EE_|CH1PPFB28BF70E7:EE_
x-ms-office365-filtering-correlation-id: efed1987-6342-4862-3b91-08dd6c781dc6
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WTdOMVBUcXh4V3YxVGVIcTQ1V1NwUmRJUThKVlVPMGY5YU5uMitFWFFIRDIw?=
 =?utf-8?B?eGs2SURINWl0a3VDaDVkVGtrd1lhZGY4MS9KZGdNbzBpeHlZNmp4ODRINmtl?=
 =?utf-8?B?MW8vSldRZWhJbE1FalBCa3RVbW1taGdIdC9kdHJ1czNaQ2VwYXRUa2R0ZXZ0?=
 =?utf-8?B?UjhENWdVU21mSjI2dUpBTkFsVGIrQUxyc2NiMmkwRzRVZk02bUFXR25PSlJS?=
 =?utf-8?B?NFUzVUxxUkswVDREUlVxRTdjeExNMGtVWDRsNmsxV0lEdEpBVDFWUVJKQ2Jk?=
 =?utf-8?B?cTVBaGs3c1NjOUNSR2hJcWNxWitEZmNjampXQVVHZVRGWWxNZEJjVmJnSk85?=
 =?utf-8?B?MFcrYzBJLzZ3cS9uRE95ZUtHU0hkVkpMUi9sTmxxNUYxc2hwMDA1RWZaZXpW?=
 =?utf-8?B?K1lPdmx2NHlYSTl1cG93WW1URTZtRjVGV3kwcFlKRHhTa3J4czFHclhyU3Nr?=
 =?utf-8?B?a09janpRSXpFN2lpUithMGx5ZWp3d09nNE9nOUd5ZTExSTAzcWV6T3U1OXZu?=
 =?utf-8?B?dThSWE5GbjRhZ2w0VHp4TCs5Y2d4aHdaeWZmcnR4ejZ1amZRTVdubVk0eERC?=
 =?utf-8?B?K1VGa25nc1J1N3lsMzd2V0ZwdzFlNDNVKy9jenFZVUVUZk9vQWlqbjllTWcw?=
 =?utf-8?B?cXVZWFd1cUQ0MFpuUmFtOEJ6empjTXdlNStUUWJNYXFLdHlFR0dUV3ZNaG01?=
 =?utf-8?B?bHBXWnpmdTdsMVVld1hPeGxTb040R3VCWmxkb29TaEVqY0FjMjFxTm5najM2?=
 =?utf-8?B?dnR0WG85WjY5aVZhZFFQaE5uWVZYY05jYzJUVXVzWE5vR1pYYVhIVTNnNXpj?=
 =?utf-8?B?aVpEcGFMczRqVk9IekErd3Q4eHNOTmdHZG5pb2lXTGhiOXhFZHk2VDRPYnJ0?=
 =?utf-8?B?eUJkSVdZQlVpMHhUR2xmejRsQSt4U3VPWEVnWnUvT3U2d1Q3Nzg5ZmRBMDNz?=
 =?utf-8?B?UWVOMWFZaEMxUnNETE1WNlh2eVRWUklGZEtRZzhrNTQ1cDVra0JaYVA0OVp2?=
 =?utf-8?B?WCtScW16eXU0b2xUWjZrNTU3eU01Sko1bUlxakFqL01jVm1VQUlpSG1jR2l3?=
 =?utf-8?B?OGF5ZG5sSjd2N0UxcWdvVmNndWpQaTZ5elBhSkNPUzE0RWg0UlpUZHJKWjJx?=
 =?utf-8?B?Z1ZGd3FPd0Vib1NqYy9LdWxGRnVxa2MzRVFIQkFtVU5EMzNjWVphaTdxQ1Ny?=
 =?utf-8?B?MFBaaUZQcGFwSHIyaS9oSnN4WUVacjFCVUxXMDNWT2tvdlp3ZTZJUTVibGVG?=
 =?utf-8?B?eW40SFM2S21KK2xISW5Rd0s5RTlxUDZCVXhaYkNoWlltL1pPSC9CRCsyRHU5?=
 =?utf-8?B?NEZOaHBiaHRDUjQ2aFZNUlBmMHZvNGk1WUVwWC9LbU9BVjRGb2docktCeE9Y?=
 =?utf-8?B?V3NlaGdEWmx3RGNkdmxabHBVRzhUczc5NG1mbG5YTjQxQWdHeFJCamJ2bC9X?=
 =?utf-8?B?MkdudnVVVGtoNVdybUQ1Ynh1UU9yUnFBVnJuTlY3c3JqZVNXaFMxK1Nld0tw?=
 =?utf-8?B?NVV6ZXY1U00ycjh0Q1pnT0txalBkYjQrZXBlNjFQLzVxbVR0WHZoNDlZcmZq?=
 =?utf-8?B?U252dUEvSnlYY2VBR3BKUkdrSFVDK3ZtNTFJc3crMElkSDN6UWdXeEFUeU9J?=
 =?utf-8?B?aWFGVVZzWmJ2a2dUVVN1QnR6YVM1YTRZeVUydzAzVkE2elZNekZVUFVRYkJ3?=
 =?utf-8?B?MTV6RjljSVR3d0t0akk2U1pYMmFnSWRuRDEyb1RyT2RFQmhSdjVER2VtVWx1?=
 =?utf-8?B?U1Z5SVV4VkFBQ0p2dmQ0UGlTRnYvYmpXdU1BTWVrUTErZDVxL2VETmFIeWo2?=
 =?utf-8?B?RGJ0Ky83VEo3Q3kzZHM3UnZxWWpENjk1U1JRRFdvNVozYTRqa28zMUZXaUxa?=
 =?utf-8?B?TThzV0lEOTc1VWpzUjU3diszUG1xUFc1Z0NSeTVBYmdCZ0E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR16MB4251.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Mldsa1JCSkl1QXEzV25QTVltUGJYYTVTOXpGaDVwOE1Zdk1hYW1aaktiVUU5?=
 =?utf-8?B?YnBrOHBwU3Z1VndaRFdqWEVvQndZSlc4SWJ4dDJQNEdjemN2QlVYMzFCNXZX?=
 =?utf-8?B?b2d3VEY1SGpaaC9MK09WQVFobTI0bkxWVkxBM3JaeXFleHkvU0hxSk5xa0My?=
 =?utf-8?B?R0NkbFpSMUNLOWhPSlNGOElHS1JLUE9xOWRkdHZ0VmpRekZBRUZFRmE1R1pt?=
 =?utf-8?B?WThIYlhISW1xMUZmaG05dVM2ODVhOGEvR3c4SzVqSk1ReVhJYWc1NkI3V3l5?=
 =?utf-8?B?ams2dG83QndxSndFdkQreHgxbHQrSmVvaTB0dVlGUnlRaElTaER2UlBDb3Vh?=
 =?utf-8?B?eXZYbWFieVBmTVM3RVhiQ21XUTVpOWlrZ1o2QzhkTzNzNGk0anQyZUxQQ2cz?=
 =?utf-8?B?a1orMHdWamhoM0ZOK3FERHMwbjVxOVhkd2hRNXBzdS92S1M0alBmNERSNmZ3?=
 =?utf-8?B?bG9pZUtDSWpHZHdrWGdJN2UzbGNCNUwzWHJoNlc4STg5OFRSL1NxVUw3VGF5?=
 =?utf-8?B?bzduYlo3cS82NEhTcG9GZlRTK3UvZmQ5NDV3VHNHQ3dJMlhYeTBKYkFPYmNP?=
 =?utf-8?B?YlVuYjNRT3RKUjFxQlp0RXFZRFVYV0syaVZCTGRXeXhDSW15VjJuQzJPNjhv?=
 =?utf-8?B?UjJ0WGlsckpIUFRmNDdZeHNLdUZZb0JoNHlqV256RVZTYVdZcVB2TzVtNkR2?=
 =?utf-8?B?TUV5YUtBNXI2djRLM0xWYndwWkplWTgvSVhsRjdxSllWcW9FYlZiVlBYV3NP?=
 =?utf-8?B?V3VQWFhYSmg4aDlzeWtLUWRxRFgxZU9aaUJGZUFtaXhHckFWWTJ3WkpnRDJB?=
 =?utf-8?B?c0hRL1ZvblNoKzd1RHZMUWhUdUo1cnZ0TWxjeExwRHo4M2IxVGJJWWJYM2d2?=
 =?utf-8?B?RkdtcDJBaVQ3NDdJT2VQM2ltRmowL3JWamlYSVdvRlB6MWsyNUJqSFRxbU5w?=
 =?utf-8?B?dXVIbWJldmpCMElEOTVFK2Y5bGZacFhuVnBWZm4rUUJYR0tIbGUzL0p2TzZL?=
 =?utf-8?B?YmNVeDFXN1lVZFN6YmcwV2RVRkY1SWk3QklGRm9qcThqa1dxaExmL01qMWlw?=
 =?utf-8?B?dTQ4YTkrQjhBRzJXS05KdDJZSVQwS0IzeWhUNis3YjB3bWNDcjJjc21LNHBu?=
 =?utf-8?B?Y1NseGljMmRzcE1mWU04MCt1UVZEYnVFYm5XcVFjVm9hNFIzdlR6MXJWMGRl?=
 =?utf-8?B?aFhsSy96NGdobS8yRmkvNi9zMXMvNFRHTEpoeDFrbkc0M3Ixek50VFBtdS8z?=
 =?utf-8?B?VFQyNzVCWjZjUjFBRVVGNi9YYlAwaUNONFFKaEZVeXpqMjA3R21EVnlPbXVt?=
 =?utf-8?B?N1V0b3hFMTk5SlRkL0ptVGJFQTJQcXgxbGRveForblE0U2NKbWRZOW1vYURK?=
 =?utf-8?B?SUtjUCtWdTdiS2hGb1JXUkdhY0xuZGs1Z0lldXRucHpxbElNZmk5QnVRWlc1?=
 =?utf-8?B?em5KSTR0SnBpNm1UZU5OKzBHZHN4amJoL0xtcHh1czVNYU9ZdC9QRlMyZUlu?=
 =?utf-8?B?YkZCY2x1eVN1WG90MlBFZkZzQUwvcnZzbEs4ZmN4eUJLbThrbHdxYXVsQVBK?=
 =?utf-8?B?c1ViMjY3Z0pidTBseHVDakhNZEZnU050T3RtUnBEWmh3MG9pVEMyM1NWc05O?=
 =?utf-8?B?ZmJrT1ZyMDZtTlZNbU40a2pwMDY5dGJDVzZ4ZlZDKzBEQS9xNW54cnVSOEdp?=
 =?utf-8?B?alNpYldKd2E0RFNIbk1SVGhnRVJjanNTRmFidXdweElPUEZObjZKWDhmdkRp?=
 =?utf-8?B?THA0Vnp6bGtxZW01NDMrYXV1MnVFZ0xoNjZIUTlFdEh5TWhzNi9Xc1ExdEF0?=
 =?utf-8?B?a2lBdlVWbHpOb0gvdG1lSUkwK2JtYVFPa01wVk5qL0Z5ZVprSVFBSUtGb1lm?=
 =?utf-8?B?L0QyeVJVMjBqUFpnbjZ0bmxFb0lDNldvTWlKNDFwVzZlVm4wOWN0eXc1ZlRq?=
 =?utf-8?B?Nlo2Um4zMitjY3BYLzJFNFR5V01kUlRGM1FaVS9NUU12MUFWSDlwdFpJd3Zs?=
 =?utf-8?B?VnNPQi8rb3FXYWRRc2djSnZ6cTdtU1NvUUJGZHhYYncxNnRCMWh3QWprWUgv?=
 =?utf-8?B?NXNjTlYySUVsRVY4YzU3YWFVeHJyZ00wcXZNelRUSWpCSVhsNGpTdzY5YjRZ?=
 =?utf-8?B?aUNjb2Eva29hZG1scU54Q3V1T0lNbzVYTUhTU25QY3BwSldjMmdVRis1Qm0y?=
 =?utf-8?B?N2lhcitzeXppeGxYOEZEbXhpQWY3NitDUmpKVjlkOUVwUVZqbmQ4MnAyWDUy?=
 =?utf-8?B?K2xRblZQT0N4OWI2T0JwYnVzdHBRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9IaLlDxXZSZDLRafJ/iUGeQcelqdxDT819EVYBG1lVvDApsYzZvb+4rTxcCJkts2z+jMp7+TDsqAynXf5DuMqWjrFKH+EE7iFIjxdRNPP53lM3f1Xw3fbSyhwLHOVvlMwNp6mSn8LsSCTFNCQ1v1IzoAI8iMwESfq2XSskhnE42APkSCT60yxrnrtEYTX/s75/OgR4rDAoi9mFIx3HY8FHQzFfD3TC0W8Rm8xjI2EMGfHZJ6hndbRtnraSD0JVvt37KsZlQT5lbX5K620MYZsPIuz2drkpQPswmVPeSJhEvd1PaWIj0pKEFOsTK7K8c1EY4K7XGznLJwrRGFQyDsKjlPdDp8aQxRsuFSxkJidepMBaHGi5S+/K4BNaqx7eix3mlEtt+QJZqlRZy6cyLPTGBUh2fgR9QAR3PRIcM1ctMMs6pR5+yfR2eo3W6Klfam2f71kxiXr9k11rM1nZuPtpDmLpv/gu0UJUUgkrlrOFtuwfP2UIdxLaKKJ2nZOKmahmW3UFcC3ZCOG0s5+Crm8wtU173+X81meOcT2/fxFljC1buMWx/34rgr28b9OnpLnBB8K5ZSMZ93ptliQ2vGArLkCeGDVPl1vSBJuNbaT5zEZXC7mKHuqa49z1EnKw/1RFG34nfGxC/I0ZqE2+hiAw==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR16MB4251.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efed1987-6342-4862-3b91-08dd6c781dc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2025 15:08:50.7506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M1oMUrDlC4wcsI8vR+iCyNOLkP7R4ljmUXFKsXEV0OIkueiCwtyWVP4QyC8EgKcOm5AxmC4frLUM1gfn9tWm09POij91uITriJgKsz9ZVZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFB28BF70E7

PiBJIGNhbiB1bmRlcnN0YW5kIHRoYXQgeW91IHdhbnQgdG8gdXNlIGhpYmVybjggZW50ZXImZXhp
dCB0byB0cmlnZ2VyIGEgUkNUIHRvDQo+IGtpY2sgc3RhcnQgdGhlIEVPTSwgaG93ZXZlciB0aGVy
ZSBpcyBhIGJldHRlci9zaW1wbGVyIHdheSB0byBkbyBzbzogeW91IGNhbg0KPiB0cmlnZ2VyIGEg
cG93ZXIgbW9kZSBjaGFuZ2UgdG8gdGhlIHNhbWUgcG93ZXIgbW9kZSAoZS5nLiwgZnJvbSBIUy1H
NSB0bw0KPiBIUy1HNSkgdG8gdHJpZ2dlciBhIFJDVCAod2l0aG91dCBpbnZva2luZyBoaWJlcm44
IGVudGVyJmV4aXQpIGZyb20gdXNlciBsYXllcg0KPiBieSBkbWVfc2V0KFBBX1BXUk1PREUpLg0K
PiANCj4gRllJLCB3ZSBoYXZlIG9wZW4tc291cmNlZCBRY29tJ3MgRU9NIHRvb2wgaW4gR2l0SHVi
IGFuZCB2YWxpZGF0ZWQgdGhlIEVPTQ0KPiBmdW5jdGlvbiBvbiBtb3N0IFVGUzQueCBkZXZpY2Vz
IGZyb20gVUZTIHZlbmRvcnMsIHlvdSBjYW4gZmluZCB0aGUgY29kZSBmb3INCj4geW91ciByZWZl
cmVuY2U6DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9xdWljL3Vmcy10b29scy9ibG9iL21haW4vdWZz
LWNsaS91ZnNfZW9tLmMjTDI2Ng0KPiANCj4gVGhlIHJlY2VudCBjaGFuZ2UgZnJvbSBaaXFpIENo
ZW4gaXMgdG8gc2VydmUgdGhlIHBvd2VyIG1vZGUgY2hhbmdlIHB1cnBvc2UNCj4gSSBtZW50aW9u
ZWQgYWJvdmU6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI0MTIxMjE0NDI0OC45
OTAxMDMxMDdAbGludXhmb3VkYXRpb24ub3INCj4gZy8NCj4gDQo+IEhvcGUgYWJvdmUgaW5mbyBj
YW4gaGVscCB5b3UuDQo+IA0KPiBUaGFua3MsDQo+IENhbiBHdW8uDQoNCkhpIENhbg0KDQpNYXli
ZSBJIG5lZWQgcmV3b3JkIHRoZSBjb21taXQgbWVzc2FnZS4gSGF2aW5nIGg4IGZyb20gdGhlIHVz
ZXIgc3BhY2UgaXMgdXNlZnVsIGZvciBjcmVhdGluZyBkaWZmZXJlbnQgdGVzdCBjYXNlcy4NCkZv
ciBleGFtcGxlLCBzdHJlc3NpbmcgaDggLCBNUEhZIGVudGVyL2V4aXQgZnJvbSBoaWJlcm44LiAN
Cg0KUmVnYXJkcw0KQXJ0aHVyDQoNCg0K
