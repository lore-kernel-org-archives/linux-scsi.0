Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712786;
	b=jX0lIS0uGgdj2Hs4rFUEMJ7dSxgWNk/oW6dSSiy5DO6eH9zGq+V7j6HZPzWmK4t7B28g
	 LIF7mCIs9h+8VmDzWsOUnI5C2kX6H05SpzsPpG4DcOZOqeTeKr3JAzKIrFqjp7m2q+DyB
	 BAkjKdiu5yXA4Jq5EKt//zt+KO1Mv3LJCXqVenZ/2BDuP9PG1XPDzqbyFdtWsdD4bjgSi
	 6jKQ9AtwzyQtnwaxPpCsujj+J7Qcxrh6FcSKPLuqQyxkiQ/R+rHqgeJqfo5U/vzFya0kV
	 LIfHjVVkVLp37EELMgPZsyrN4q81nT8TstbG/WV7Mes4MEmJTvExSE4QTGYURaidxDA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712786;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ol9OUfQnsFvC07fZHwebuGUg+JXMuA4kYqTrAjm0DcQ=;
	b=vWHxk2ChT7Uhfpjb3CvYqqFVZhrcNOKba4IDtlnWw0g5+f0TQ0spBnZfkTjs0pss+a19
	 uFHUiLXuEd+FJ4/T9EGmTrwhQ/EW3oD/DP1W7+WAGlc4jSgxjHL4s6oLz3Bz2q1AWW/j4
	 mb4PfA1L9GCNQl0y+ndPfYSbjhXediuQAT0OO5pvnIc2xurFFcRKFuaP06rXF+eeAI5UB
	 iEWcNDwWlDRQQs+h+yk4a5FbKUpgS5ZfoRDXpxF4t1D7i7FcweN9uCYqu/DJW/jD/iUII
	 Qg5Va9pZx4vOhdvMVJAJcfP1gDDXEshQv3WPZ9vD3TkSxoSPwTZrQ2MRTmIs9RrFxmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YwfDXJ0p;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.159.46
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013046.outbound.protection.outlook.com [40.107.159.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF86082BF8;
	Tue,  3 Nov 2026 13:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08DF86082BF8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=YwfDXJ0p
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PLa0Dt2pZ5Ps173PKag81cS33qxi4wf0GOBqjRUdP3mBEwVR/qUjMCQHtqeD2P5X0XwN7JheTxLRlP43TBOOcJkPm1MwbF+uYI7/FE/E+dU2tF+NkV++BAsomQegPfP4O4UXwlXJYspuBO6yMwbYobZ3HAe7TObG/HSl9hNWrW+yl6GIbnjZeeHUieIU1W8pS8t2sShU9goo6/boKCOhNwCFY8jOkt2oX55jEruhajky5rxHbRVG4E8MiQcDs/MuUPC01G4LVXD/M7OIVCZAiiR58Ma+Hp+8iCawkXIq4XKpVb58hLHbYnsPs1s0O4HKjMcfnj1C2qIhdG5i2mN8MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ol9OUfQnsFvC07fZHwebuGUg+JXMuA4kYqTrAjm0DcQ=;
 b=IrMr6qmBqZYtWNe2Hi1r+41nha8m+4BrL6DWrPXq6gC5gGTFN/OaoTa9bFySzDd7YyLWPP1Etreamwl4tw4Na19ALMqZ3T2LVxsJqToIWXfd5o1B/UmgE2B7Z9uLWyr3lL/3c0W0uGxh9Ozt4dEQMDoenRt0l10NrvQyn7JAj9xa+JEej1+ViKcc+JP8ZRmzwCbbszQ60Bjnvc7Zsdt0r0alUtSZtneiB+Gj1zniXm9rzhr9Uw8Ap5MB4hfE6AYWSintKjSYU35ot6RVz6rfEtu18eadpifXOKgCOre0rK1RxmlORuKIKFGUr5LljKsTbRVCJWw1oziuj4DMUB+RMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ol9OUfQnsFvC07fZHwebuGUg+JXMuA4kYqTrAjm0DcQ=;
 b=YwfDXJ0pPWKhKn2KSxo/tvFe/+5vixhR/Jb+j4LfOKZ8j65fYJBXfXc5jS6VLa/+679tvxPxmaRo1LNxywHxp6G7Ny2i/Jzm7TtfwrYkKrU3KVUFT+YlCw0nojeefM2nNPY5H3i9Rh3ka0dgNPMh+TkuKr75f8sh/FWT+ucpNcwus4a5H4YKbCeYijVfu4R0lEYdNBS+l/AoDVXoZWJHv4c6LLQRqusmBhBs19Tm3D/Vb03iAwT9IKs7IOElzoSZHIN+mKY755i82yKdeooZ15J+ZPXRUwHv+71HMyly0K97SaLniON50IBFg9n3X8q3tgyNSeKgySOgTVKWCIMiHA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by DB8PR04MB7002.eurprd04.prod.outlook.com
 (2603:10a6:10:119::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:33:02 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:33:01 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Cc: imx@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v10 11/11] MAINTAINERS: Add NXP S32N7 UFS host controller entry
Date: Tue,  3 Nov 2026 14:32:15 +0100
Message-ID: <20261103133215.1385823-12-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0538.eurprd06.prod.outlook.com
 (2603:10a6:20b:49d::25) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|DB8PR04MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: a89e8b50-6548-4c24-5dc7-08df39aefb33
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|19092799006|7416014|23010399003|1800799024|376014|10067099003|18002099003|22082099003|261102123227099003|56012099006|261028144727099003|11063799006|261026140227099003|921020|261022105027099003|261009223027099003|261026121527099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
 ifA+UGgydH8T68v7G2I5q/kQkEE++oUTsgEz6wpz8JhBdwQeACiJTV6zgRDYoqYqDsRbJ4UrgNPjGKlJ+36TQLnmwgnCF2PwDeB0W8mWo2fXKu8G0iMql/xdcSkejvnXozC4Yg0lhnPeu10kHXu7PsTGmmSdZOq8SXXtFYLmZkAvTeCivVl3LalvxFkBvErgCIWnA1mrYJsVaosarJOucJLa7ZwtY4iOumUEyTTW639B8JxMhyUNJErreTeyajWHfHRn4F+MerwgOJoBMNbSCUuCGN0al2QHMCQnnqfZ8gQzMRvdE9sXuxq+wPa0ad66KXS3sVaTFNLGdYyuROjGC7vXTBCaXaQFVMGsN4TxS0nNv3vdkqzLhj5+i90xqOGjmwuy2fHKs2aPZbTF7/YmKJ/4S0HcVBLoA+rapsj2/kQOgYvSAGR3QA3s5RmGAABe1NorFCo/aTsSn99QEkdncQxS3Lbxoc2LFhMhA9K62wvIDthlN/v2lm7oECs9vtJMCKU6UTN2uDTAdK986pRuY2Vz0KmiLzPejEZQFzSY5k7OjkdaxXtbIifwcU0QE8L4Ggvjwzbmk4FmrIbFCrv4yETjTX9H88RiwEaGET0E9mob4Hkb6sgKATlu0rcwsSYf5otBef78FMymtiVFe3e8ODe8sKRKjq6UT4KivCCMTFpPJUM0pFEzQ/sW5JLQm1eW+82WWZDAiTo8glTV7IgFtw==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(19092799006)(7416014)(23010399003)(1800799024)(376014)(10067099003)(18002099003)(22082099003)(261102123227099003)(56012099006)(261028144727099003)(11063799006)(261026140227099003)(921020)(261022105027099003)(261009223027099003)(261026121527099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?VUw5WTdHeEpNZzlpWG0rOUNNbGZ2a05jQ3dVNnhDNkI3VjFpeFpSUDlpTDFj?=
 =?utf-8?B?enFscEtFQ2NPcWZva2ZoUnkwK1BSMmZNd3BDN2VoOERVZytLU1UrdFc5RVNE?=
 =?utf-8?B?eUZma0UrS3krM1pMakdHVUE2MmoyZFFlaFZyQVFwd2FrTFlUVUZIM3hTWExi?=
 =?utf-8?B?cmQybVVTMFNPQk1RTHhvaGN1cThrSnJiNWZONVlUK3d1VnpiTWd6cW5OWlFS?=
 =?utf-8?B?NVdwZ0NBdmpIblVNMys4RVp2WkwyNjNNZExDZ2NFeVY0NXNMKzhJZFpVRmFB?=
 =?utf-8?B?eGx5VHFSQkQ2OVBBeGNWQkFITnJZbUloa3FGMzRBa2hjNEhyTmV6eVg3VVJh?=
 =?utf-8?B?NEpTQW1TMGw1dnhvWnQ0Y3lXbHVtcGx1NUVhRDFNNFJqNG5QTGpSWm1SUVda?=
 =?utf-8?B?OE9Za1h4NWtiTHhYMDFNQ3Z1aWs4bnlVUFRoYWYzaFZJcVVGYVA2STdWR1JF?=
 =?utf-8?B?ZVpQNzRiWmVBRGZkQTZlM2pmWXJ4SERvOWtsR0grMjU3ZUQ3ZmI2cnBXQnYw?=
 =?utf-8?B?ZmhhNFJsQk1rSlNqREtsRmRDQlo3b05XZGdBK1BrZUlLeXkvMlRvbXJMRHN2?=
 =?utf-8?B?S0FXaGJmeXZrMDNuQmVKWEVseFh1ZVhxdW1tK3lLYllka3NCNnFPL0JQLy95?=
 =?utf-8?B?VHF2bTNPTE9mUWNwbDVnMDl2RkR5V2NWUEU4TDB4Q0s0RzNYYmFSUUN2UHk3?=
 =?utf-8?B?MDlIMWJ4ZGlrK0tFR25rb3dXNnNUWWFITWNpdWJMUDZ3TVJ2U2g1d2dET29T?=
 =?utf-8?B?aVZPb0Vnckd0WkVuMnVaQzhkMk00TTIyemdkNll2bE05dFBPR0llWVBtOTFG?=
 =?utf-8?B?M2I2VVZOYTNVTUtQVHpxSFIvb1VFKyswaWlUVXFXcG53di91bmdLWGhUSitw?=
 =?utf-8?B?RUdyYURUc2pPWHc3MmMyWDlnOW9PaVJNQmRHT3llODkrTlh5d054dUpPMFRC?=
 =?utf-8?B?UEFkczJSMlZCMmQ0THVMTmYzb1N1Sng0QnZUdEFHV2phTHpzdWltcFB2VmVX?=
 =?utf-8?B?dFR2VS81Qld4N09jUDdrRjFlMUhjQ2NYdjdoblM2elltK29jTHNRcHVsOXhF?=
 =?utf-8?B?WWc1S2hYbG45cldqbTBnT0tkWTlJZkJpUHFHQlVRQXdpZ0pzelRBckk3YTBP?=
 =?utf-8?B?Y2xTYnJqUnN0K1JRRVlNZWZxWlpwNWlrenhOVUdDZCtHZXArakxQVEowUy9k?=
 =?utf-8?B?S2JibkQzaEQ1cGVDVElnTWcycUFqeTllNmVrbFdhTFZsUlkyc1I0OTh4d2hY?=
 =?utf-8?B?dWhONHBzZlFJVGpFdnI5QlBTWWFZQkR0RS92aXhMK3R2SDN4K3ROUC9RTkQz?=
 =?utf-8?B?WFM4LzJ4UHRmNXMwWkZob1R5REtRdlhoQzNCNytNY0NrOTFIWUQ1RUVDckE0?=
 =?utf-8?B?MlE0OEpGSWlvZ2VXT3NRazNzY1g3OUtubEdoZGFzM1l1VW02SWtKaXp6Z1h4?=
 =?utf-8?B?QUs5c203RjQxK2U4ZzFHZmt6ZHZ2YU9janUvT0gvaWp4MXhTMzF0aVJUYjZ6?=
 =?utf-8?B?bTh0ejA1RTczenUxeDBuWi9kaS9zUENTdHRZNTA0OEJ6YXRrdkhxbEMyOXcz?=
 =?utf-8?B?Lyt1azA2RFZYNTVSa2hmNno1UDVDQVpsNS9OMmNva2lYYnIreTE5dU5US3pE?=
 =?utf-8?B?ZllEd3JQUWVrU3dNVy9QaFRHaXd6d3hwbnBEUU5zaCt0SEFLYWFCVzB0WjhH?=
 =?utf-8?B?WlMvUFgwRmhJV1pMdmFHbEtmakI2ek4xYmV1Mmt3aFBlakxZMTZYK3FKUlRP?=
 =?utf-8?B?NmVhTEFwRzdXNEI3WG45dngxK1dxZ2IzUTNrejRVK051Yjl1VHBjRlRXSExM?=
 =?utf-8?B?bm1oK1U5bkR0M0dQcWZhR1VORnlaM3QxTGJoSzczUERuZHZEM1pEa3FDQklZ?=
 =?utf-8?B?MUtTZWhtTWE2eDNDMksxTDZXSXJkekErRU5SZmU5M09ORGZYNnRva0lHM1VD?=
 =?utf-8?B?ZDF3WmplcWZSUXRnSTNNcGxucUlBS2ZvWVZBSGRteGxCaC9QbEhsUm1KK3lj?=
 =?utf-8?B?RDArZnFKKytCRmxhaDRrVFZ5UWJNOWdVVXVXbm9JajRDOEVUeG9CS2szeWkr?=
 =?utf-8?B?NHpQQ0tyaUI5MlE5L3kvYmsxbUxiQ2lIUmNXSWsyY29MdUE3ZTRpZW9vSThi?=
 =?utf-8?B?Q0lkY1NjZ1BCd2VJZ2dNM29mRml5Q2puZmpCam0rYlAxRlVLTCtjRHE4c01a?=
 =?utf-8?B?WnRQbzVTNDA4QzNpWEJGZllSeW1WWGMvTXQvMjJ2eTFJSVU4bjJXTmFIM2lK?=
 =?utf-8?B?a2dtay9WUlBkdytpd2pqUFZHeDZwVUZEOWRhbU5lUzRYWkZHTXVBZjM4VGdX?=
 =?utf-8?B?Q1hMdHdnR3JldUxIY0ViUTRlOW54dWt1bnU4NG12YnJTb1V2UU9PZz09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a89e8b50-6548-4c24-5dc7-08df39aefb33
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:33:01.2175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5Vgf90TgnTdLmOK1dIJTilLOhm6CEeKfXn0RspK/2zH6IHkff7TL+ARrOSSNctkcmA6EHWdeF90SDejQh4Jmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7002

Add maintainer for S32N7 UFS host controller driver.

Signed-off-by: Larisa Grigore <larisa.grigore@oss.nxp.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..9ad14245acbd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28801,6 +28801,15 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	drivers/ufs/host/ufs-renesas.c
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER S32N7 HOOKS
+M:	Larisa Grigore <larisa.grigore@oss.nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
+L:	imx@lists.linux.dev
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
+F:	drivers/ufs/host/ufs-nxp-s32n7.c
+
 UNIWILL LAPTOP DRIVER
 M:	Armin Wolf <W_Armin@gmx.de>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.43.0

