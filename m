Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B90E13665A;
	Sun, 30 Mar 2025 12:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743336847; cv=fail; b=DoUC+jRP+okWm7A6tTl1WY/5txwKqOBPd3UC0W5+HQrWgzrdt1z4ufVrEW2nGGXqq11oM6ovb8Ht5rFcn5uZWjkiNYMUgq8GRBMx4e71CGDPw4O9QlUvojEPqASi/4TXUpqxak0jRq1OAiJsrSA/Qt9may34VbzeahQctlcsEJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743336847; c=relaxed/simple;
	bh=L1XEK2Y1V1BKSUkdHvxJBP1shH9Cc1IR25mMzyLG+wo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ADKgU4HLOzdSTsCT6XyBvAfvrx+XjGFg6gPPubR/RziyV/fxJLAoZkeIl1JF9pF3Lf3n65vtmK9/vY2FKajeLngq/8omU84myBKqF6ahzpUeqymTDbU+hjh2cpFQ2yLg2SK6FKNm7wvWXgNT4MWwCr9pTqTHhIeK+3ldM162pXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=BIRruh9V; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="BIRruh9V"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkim.sandisk.com; t=1743336845; x=1774872845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L1XEK2Y1V1BKSUkdHvxJBP1shH9Cc1IR25mMzyLG+wo=;
  b=BIRruh9VUHY5FZZXfJuQvPDMlTnsq/7Gdaw+8IeBFNGlt+XdYu6V5pLv
   uiZpF9H7FMBzXuT4hqBqLJHGyiPvzo89ZMYivvn1wWoIbvS6+SsDCsKMM
   g9pemepNNSaIkolJNg+Xhh8kBXIt+474hZPKLj3BHNITCwQ/PUT4HLoao
   4ZEDPOhg40YUnIpZUxOeN+zVigzloxVrFztcA6J/9NB9WxH8CHw74DZ9b
   Od39QAswnvu52AMmQYEmIHhVqAbwJLse/LRYnJkxPs6SBm3EH0Gl5VXi+
   6bSbTJsvWzl1eyQhsWa/WIEdu5TjYmbjM7uuAoXjWCEEv8iBd4tv77C7g
   Q==;
X-CSE-ConnectionGUID: h5FchnedQ76jTg79Pu5lOQ==
X-CSE-MsgGUID: OyxfD9b9QoqI1/pVBVgWsQ==
X-IronPort-AV: E=Sophos;i="6.14,288,1736784000"; 
   d="scan'208";a="65646970"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2025 20:13:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pZrECm6jncoQLkLKWb9jiiHLL3FcH2DIcf+WMWv5foeZ0rK0EJsz5lqZnYhooRK0ixPyIdNwh4w4rXYYe3Gn3qRLd+0WZ6qNEg3SiiL05ZJUMrDHWrmS2MClwTdoBAjKD1zhvMzseKdzgGPt7LIM4twdR1T2WD8cgvxSk6GzGjp5tU6qN0bbTIYmcAY9eykmoyI2C2kIL8rGIejz9NJ/q921NO+jOW/6eZQmm4oL1r4IUuk0xGGxy6Gnwc19Ulwg8eWW1LxnqX7W8wtIjH/oBZg1HqO3tjXYQvJ1CyQGbV2MjnmrqqYclgPCSbKRAttCiejm+M08LWViBjUJFSrSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1XEK2Y1V1BKSUkdHvxJBP1shH9Cc1IR25mMzyLG+wo=;
 b=yRa0v1bWWszRMasaiKTTRXHwggJio13cNSQEj93CzfIzpKmbdXZLGq5fby5tX48nUsjtxWbOk+ajDJpAops6oHIGYJdLJapKU5BEmR06+T1Ng17VrFNiMFuAFd0CRVIO8yNNwRfCG+tLNNDI8cNh4QuQMyHMPbZ0DJkB/9h7mdlfaMo/lLxfU3uIjOdEsFp/ilLvVYCu6mkLCo+cc51NIDx81+89eVWOsflaM9lnGNLn9pxlFevSOPXoBYDqJv5KZSfOvNM90evur75J/z/UGA+wJ6IQfpuFxDmmGvEBUgHmnHduZ/zgc6iV2r9fBErHPwEuosQkSeGnWRLO00SOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from SA2PR16MB4251.namprd16.prod.outlook.com (2603:10b6:806:136::8)
 by SA0PR16MB3648.namprd16.prod.outlook.com (2603:10b6:806:81::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Sun, 30 Mar
 2025 12:13:54 +0000
Received: from SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2]) by SA2PR16MB4251.namprd16.prod.outlook.com
 ([fe80::3415:d4b3:ef92:16a2%5]) with mapi id 15.20.8534.043; Sun, 30 Mar 2025
 12:13:54 +0000
From: Arthur Simchaev <Arthur.Simchaev@sandisk.com>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Bean Huo <beanhuo@micron.com>,
	Keoseong Park <keosung.park@samsung.com>, Ziqi Chen
	<quic_ziqichen@quicinc.com>, Gwendal Grignou <gwendal@chromium.org>, Al Viro
	<viro@zeniv.linux.org.uk>, Eric Biggers <ebiggers@google.com>, open list
	<linux-kernel@vger.kernel.org>, "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>, "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
	<linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v5 1/1] scsi: ufs: core: add device level exception
 support
Thread-Topic: [PATCH v5 1/1] scsi: ufs: core: add device level exception
 support
Thread-Index: AQHboCsGhQ8E9owlH0eTaHqJ3FZnsLOLmW9w
Date: Sun, 30 Mar 2025 12:13:54 +0000
Message-ID:
 <SA2PR16MB42517745A5A80EF3B09961D0F4A22@SA2PR16MB4251.namprd16.prod.outlook.com>
References:
 <6278d7c125b2f0cf5056f4a647a4b9c1fdd24fc7.1743198325.git.quic_nguyenb@quicinc.com>
In-Reply-To:
 <6278d7c125b2f0cf5056f4a647a4b9c1fdd24fc7.1743198325.git.quic_nguyenb@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR16MB4251:EE_|SA0PR16MB3648:EE_
x-ms-office365-filtering-correlation-id: b1171d22-4c87-4d46-d7fc-08dd6f845745
wdcipoutbound: EOP-TRUE
wdcip_bypass_spam_filter_specific_domain_inbound: TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?sLIZmt0UGgpC8yRAKWP+tNs+vx/jRstwjpCQN3kt/IePsw6VAknmLSqTIXjl?=
 =?us-ascii?Q?2CtAYq6qLWBoNIbyyZMvnJ5215/2fX1YFasQ+zg+z5U0r1UqPZCBqY1d7IXy?=
 =?us-ascii?Q?Qk8XB9FYOwzqafFajX0kxvoK/h7gNzLVn8cWgTVwJwH66OipBpzdmq24HOUo?=
 =?us-ascii?Q?3Lw5dZ5QX/WW6cIMuAlbju8/980irD5Dkh+fvIWCKNhsRrtIu4vYpx5JpQeY?=
 =?us-ascii?Q?RaJfzKhs16sERXe5w0l7W/Pxwa5GkJG6aOrjQ7MLwX/4Ms04+o2zbp8h81zi?=
 =?us-ascii?Q?LMp8jmem1igjcXhgwGt3R7eGEvyB1v6EF8QFDGkfClDB5klsWcWZJh+tAIxe?=
 =?us-ascii?Q?dj4yYnbcYbJKO4ZQXCNYiNZYCHAidN6fiacJ3CLMnX9uTR9mF71TJm/iF/CA?=
 =?us-ascii?Q?tSNttJ/iAggMqWdrti76IzNIChbecjiFoaeYe2GXtxYG1TfVuSS8s/G/BKGv?=
 =?us-ascii?Q?sFbugSmKh8JWpx1sXdjikb8vYDOUreq9cwEo6QB5GM4EZps8AIsjmVZQxOQB?=
 =?us-ascii?Q?WGbiIM2chTz85xtFJrK1CdTcRSDadMDBctm1T6/htOY3z6BPUS+ZgUq1CMqV?=
 =?us-ascii?Q?zu1nYoLVPjsxsxrVLXuMJSufGqVOKRrwhLvLh1BK/wJeK0bWJ8yk9JXsKPAE?=
 =?us-ascii?Q?Ubrdz1FEXLTyqjCGg0CnXXL/LTfJNFfT5CI0meVrh/8nYd5nJZQPxVVcmQFn?=
 =?us-ascii?Q?kAdNNfs4E7atNTEyaG6dooDjCuvYec0XLEmKiT4RE79F6R1idX4zQPdT7Hyb?=
 =?us-ascii?Q?Z58Vy0EheiuxEmhnTUnO9jszU3pUsGyPOnjTbMIpu0PIqeFGwiArqHadcRHg?=
 =?us-ascii?Q?Cb2UyU0pRkDPqq0DRlQLnc5uZKLb4BBw6fFUf84dGWKHpG3CDjHP3eBNFRPz?=
 =?us-ascii?Q?goW6jEHsNdsTdyEt/2712LQCCmtRNpoGcIOZfamOQDwi58QtZ86Z8cziNT59?=
 =?us-ascii?Q?pTHPr1RDZD7pBeS99cSbqwTJzkNq/0TLgwHZBwE9LCNJj2QS3sdBuP8nxTGM?=
 =?us-ascii?Q?5SpS8PquMC0uLBQ02+P32GicuNLMyu8IYEQGylRUnhn8hROPr5wHrRDZUt7v?=
 =?us-ascii?Q?WcNT5+2uF6W6ZFRHJY+H7yAP5ANxg71AIaPAj5aI5tOCYKXN/JRkLVFiDPU8?=
 =?us-ascii?Q?zX9f5YDNA6ITgMK0XIbvM+sxFxePR9EGmfg88xyc/JWwBTD3ForK3oN7Zrdd?=
 =?us-ascii?Q?+sRBSHjF03U3ZvvORVuoaApbgXfgUf6436ZGmvVj3YegDPY5rWvZ0JGhgeFO?=
 =?us-ascii?Q?72MBP9628p9e3fJd08bam66bB8pDqeWlY8xdRX/sYE9BO/KL2TlXBfwYJpV2?=
 =?us-ascii?Q?l+vYq9HKNMcjYQnbYYDpWfABidMDgarq1STl1qRXQIlHUsJkbqqtaccoHtbz?=
 =?us-ascii?Q?oVTa+tusQnCVjRnoNfaOE3flCG2hWxQJLw1FmWjMKNuYMaNQQ4qenNhzMGgy?=
 =?us-ascii?Q?d3cJSwrGprZwXbUXp7wFN066iqw1j1Qy?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR16MB4251.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Vs6Etf6ZueW7oJ5Iw0Q00BFAqOEqgMOB6z34yLpmLbC05a0da7W+MMaV+z7b?=
 =?us-ascii?Q?r27fBitBVdhS932pJiaZ8QFIe+6BH3WHzru/NNE6zq/QWWCZwUxvzX/1dUNq?=
 =?us-ascii?Q?E/zNPq5fwLZ0/SsTC+5tMi/3X7zXRx7fnKGY6UQtcSi7WjhIEP0Lu5Bqzx8Y?=
 =?us-ascii?Q?9gSFJyvI0QwEiNukOrRQgrv+fupopP4j+YreTTC6vzVUZz00XqR8kDTB1Ebg?=
 =?us-ascii?Q?B+TUDNM7BaKCB7nC8ZkGfB5XexGJpyPMwRP2m3930iePwYFhhO3KPUNGW6gK?=
 =?us-ascii?Q?w3mwzLIT0qc3L+oukCOLdqmQKEDC4z81rtlia2e6IW1sl9PaReiaqj18GQjQ?=
 =?us-ascii?Q?mcRtxSOP/NllMbn9Q54Qg7ntw1SPrMt5hvQAHvKEXFT0Sutjl8DdLuVCoviC?=
 =?us-ascii?Q?Vxn4N4Oqttcsxo/7pyuDDEPQv/jzfWNOQnnS/pR3UpazvS+IvZctHM8cgDnR?=
 =?us-ascii?Q?gr7HZiaExAgjfxWPC0VmD+QuMOoLhPqX/sm1P+CSXpbh3caIMiKoTjxy30B1?=
 =?us-ascii?Q?ZlNqKi2pIJ08yUjzSjmpTK649a9FwmUGLIfdJbuDBBib0gdnnFc24RBv5UFj?=
 =?us-ascii?Q?UTSSifSBEUuC98exmwU7s34VDNC3yTzR7K7wlz5bWI529nnJkwphtZ3QfjOw?=
 =?us-ascii?Q?Xalj/1pEI3JEAZfUSs9nj1ThXAhww0SkVJJQuJAZOr4SLWSN88NKwbeYV3aD?=
 =?us-ascii?Q?smKgYrH7Z1FJHypln9m9XlRpDz414E6k6/WU6kyTo4+lNFSYofll+rfGUdti?=
 =?us-ascii?Q?GftFjyLQHuEknyUkucH70DNB/dQnxqaVMmVRZbkDp0L5XHAEa9s+klSsd0Zh?=
 =?us-ascii?Q?FfF2N6m7TpibGInQS6zXqT3/vtqx7QYD2dNpnpYZGNWvlX6seRsQoQVXt8N7?=
 =?us-ascii?Q?xOxR5/kwgtN9488jeLtEoR9FdlmY6tnjBql2k5oimZe7tqhCbF2kOI9JFx3A?=
 =?us-ascii?Q?dHjbz5J9c+arK2xhiVPr54ssAtU3scb+NvEdhELkFM+oAegKbTlIBz7WDR3p?=
 =?us-ascii?Q?A+L3HrWPJRp9pSrekXm5CC56LAO9k3zXCglJEzK3qONk2bU9Lo+iunXEaQp2?=
 =?us-ascii?Q?bAhMGOMzr5qQeWq7XihCvap2tU2PPPTBUiLZPXAwknSo3n5UC3V4bAgZptoZ?=
 =?us-ascii?Q?Bhkx7Eqpyh4+9cUKaC8yHIStc1rHgdyIRVIK1vKzq1qvOzIQohtNMccubo6C?=
 =?us-ascii?Q?F+gOIoGj17Vl0mHgL1Q2h/wCC4s4RwlPkRzTIMUtVx3AVAzU4ZYsds1yOX6c?=
 =?us-ascii?Q?YI1Wm8WcH1mFGQz1aj8Jc1UyqOx+rf02FaAb6MxTPZvx8EcYFUDhw/nUKlWm?=
 =?us-ascii?Q?8Lezmau/94s5dcAhW4CGveflzIOCAey6pS6bL9QutZoy6x9txKRZJJdxvMSn?=
 =?us-ascii?Q?UDhAg9696tUqXEOTNI0OsmuVjuJW/ECtRqISt+gnWESvF2uBGZuwv1mb+6Fh?=
 =?us-ascii?Q?FJti54cUcdw1wp2oSFcpe5NF/NYOyRn+rXDq7tWgxQt4AcjAwxl2bn2+5BYo?=
 =?us-ascii?Q?1wu0f4HPMXIjf1DLtN0sqYhxEybOb66ATJRrtYPKyo2p0Nww3mcPLTaejXhX?=
 =?us-ascii?Q?nSgBOm9KE+i/Df9qj9ybP849q9PT1LFe+j3qBlSJQ/KIDhJaJWxYpkCm9olE?=
 =?us-ascii?Q?zg=3D=3D?=
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
	vp9PL/svOCTC9fWk8IOjq7ADBkeMV5NRYOsCr2EMbzBGzUOMXCjzt0ZTXLsOP96ifv8m712pAkyjCzPml2lDRd7zGTA+YRJfz7tFzIrSw4eGbEe4aJy1CvQrjWacuKDt3/Evj4Z9hAVRm8WSO8wsnHgNjedp6UjDoXsCCB4slm42QD8OEkyBSfsaYay3ceegkd8GJMnY5uS+ldk3kltD1kyZxuaatnXXsb81uXd9H+tUonjVr094t4kUIm92jOYHHN5Gs73HJ3ESOAPM0w3DIOqJVvamplf8scR9oqcO2GQjoeA19rpeizVDu6nz2E8CjO5HuLaaGnfEToK1ie21bNVv9ICI5BSl23tUG56N6TSTCGddWheWwtufUuAh9CAXi63qFPym8DJElr23qJDX4WPVERh0DntT8OiH6/Kg91PetJwyn/bnr8bccg+edEIjDmsES7V/CY5uMDsKojX7Diucxq2Xp/CZ9a0qfVqFLsPoNA5JKyABZMfVln4fTXEjHZNuEh0QgGPFebCfVPzI7tr4ScPmJQCt7y1+eRdd4subUHbJOTB0tkdIQA2nS0okB5SRj30VxfrC90urXE4lb74mhUce3saHfQx5gzfY5w45WoW1AOB3kBd37cJInV60dv8yn8EEaSUazRcYsqosVQ==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR16MB4251.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1171d22-4c87-4d46-d7fc-08dd6f845745
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2025 12:13:54.6848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QylhXz2kcofD1MV7UVJ1Gm/UPPpVV5y7HZVZQFGRSgZEAwLIKBeaoLCEpPiR01YW+hmgsM3LnUzndzyvivvw7UwmLImTP5IBzmInuAlOL6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR16MB3648

> Subject: [PATCH v5 1/1] scsi: ufs: core: add device level exception suppo=
rt
>=20
> The ufs device JEDEC specification version 4.1 adds support for the devic=
e level
> exception events. To support this new device level exception feature, exp=
ose
> two new sysfs nodes below to provide the user space access to the device =
level
> exception information.
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
> /sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
>=20
> The device_lvl_exception_count sysfs node reports the number of device le=
vel
> exceptions that have occurred since the last time this variable is reset.=
 Writing
> a value of 0 will reset it.
> The device_lvl_exception_id reports the exception ID which is the
> qDeviceLevelExceptionID attribute of the device JEDEC specifications vers=
ion
> 4.1 and later. The user space application can query these sysfs nodes to =
get
> more information about the device level exception.
>=20
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Arthur Simchaev <arthur.simchaev@sandisk.com>

