Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A5348C400;
	Mon,  7 Sep 2026 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783993; cv=fail; b=i9USFdg2QV8MUAyqe58ccyGWUnY+rH0YVtXfnWL0LYHSAZ0/DO5UFB/6O+kHpepfGniQdSNSgtVWQL4T3ElpHLJOeYeiL2//BS5LVSSiutUZ3bV2jH2xzTdTsGc60XifQ+Iw2ZGa4GLjmf3unZrvu+iozLblxlRMs096DHSys5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783993; c=relaxed/simple;
	bh=jwKhcBUl+q2QsllqO+78Ir1wuZ6saSalxKiGhSx78t8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IgrLU7NMidU1x5rT91kVMqQyI2SYwUxgwCDuwhqfCMUPj08ETWvSu0MueplXLixHAMizzOCEaqFutqpmXa/HxzdS0ktzwiO0qP0viiFwNS7hgpScu3bQ3Qh1Wuf85tjMDR3Ox5eermFruUZCAjlE+TgNuR4H8nQRokcGlQggdEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=OlfTK0J0; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="OlfTK0J0"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687ApAVq1515846;
	Mon, 7 Sep 2026 05:26:29 -0700
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021114.outbound.protection.outlook.com [52.101.52.114])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4gh7b92d6h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 05:26:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upQpkznF12WWnkucZ5cBXoz4sYLeFpOzFFEs6LmscEwZHgrbBS0ISB8qIDHHfRYMv81kaguVm4y67fHRPLDd5ao5WQzTF6Mff5tk5gucsiDJPxKN7+olaJviWdNEDyALf/lgC6dapFOwfdcy5Rz5LowEZIM8T0oUoyX4CXc/cGrzH648N0h/gTwG5TQ6mQD4tzhZIc2v6cOBd8jCVc9phMYeT+vHFvwOIqxVhhchbqeZP7GHoVPVbyrAdnHXp/R7+PZni5nALkhFwF2JLy8XtFgrMFTb02tbnxG8wLuOpNthY7zg3AeZt0bV7lhQo9PRAbkwxWVQAb2ECmb2jTW+1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwKhcBUl+q2QsllqO+78Ir1wuZ6saSalxKiGhSx78t8=;
 b=Low1Q6OfiOZAYqykpZgvf6J3lUyeTLExK6jKW1IwB4kPtlCyBCP0+wOGe2VRy/09rJMBNEpkOk9SiUrDG+tYQzHogLhYpZsbiL1PiNlgcI+Dk2TB/BDAfDsoc0qkLYnkPc7Gm0my9vul0Muw74lVO6FKdmMrSkn6XfW/QUp2CTdO5k65IqMuvffcKksARfnTltg/tjHJLQp0K5pKO53bpiB39PCZIeRgAxTXPqWAGDyviKx8xYtggcvKLVHrQEvRp3rxJzuip3fUIsBqCRNqZrEyicgEd6wbG1ddGh89nDUS+jvSUGuJtk5/VSi7wBPpBc65V0nmR4Q+1JNeObr/EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwKhcBUl+q2QsllqO+78Ir1wuZ6saSalxKiGhSx78t8=;
 b=OlfTK0J0Rz1wHs99SJ4Cfj4FngcJ2voB4TTUqQP37FkPUAYkQ53UwshuYH7rFwJM2Y/iE7ifl4ueLVJOf25D2M1w2ZDNmvtdutgcsCItLOz9JZSqfpLNvUwfV9nG8P+QY8QoLER8h22jgBiMrnxbr2PMxji5yK2oLoreefTveCE=
Received: from PH0PR18MB4799.namprd18.prod.outlook.com (2603:10b6:510:c3::11)
 by PH3PPF712D081B7.namprd18.prod.outlook.com (2603:10b6:518:1::ca4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 12:26:26 +0000
Received: from PH0PR18MB4799.namprd18.prod.outlook.com
 ([fe80::4d3:4752:3090:c8c9]) by PH0PR18MB4799.namprd18.prod.outlook.com
 ([fe80::4d3:4752:3090:c8c9%6]) with mapi id 15.21.0360.008; Mon, 7 Sep 2026
 12:26:25 +0000
From: "Nimal Prabudoss [C]" <nprabudoss@marvell.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        "mschmidt@redhat.com"
	<mschmidt@redhat.com>,
        "Sharad Padol [C]" <spadol@marvell.com>,
        "Yogesh
 Sawant [C]" <ysawant@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-ETH-Storage-Upstream
	<GR-ETH-Storage-Upstream@marvell.com>
Subject: [PATCH v3] MAINTAINERS: Update maintainers and group list for QLogic
 and Broadcom drivers
Thread-Topic: [PATCH v3] MAINTAINERS: Update maintainers and group list for
 QLogic and Broadcom drivers
Thread-Index: Ad0+uA2wkT51/sKoRJiWeVfdIfWHQAADArXw
Date: Mon, 7 Sep 2026 12:26:25 +0000
Message-ID:
 <PH0PR18MB4799B6A39977C80374EA4FA6C9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
References:
 <PH0PR18MB4799279C272F238CDF36698DC9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
In-Reply-To:
 <PH0PR18MB4799279C272F238CDF36698DC9B22@PH0PR18MB4799.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4799:EE_|PH3PPF712D081B7:EE_
x-ms-office365-filtering-correlation-id: 47e155ef-a7fe-4829-2cb0-08df0cdb3c20
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|10067099003|56012099006|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info:
 8OhW1n6+RMEIO9P43NWk7sbBi2Kr54BafWq5KqhSJfyZqz9WwfmoN/kQWqsgjwDioPMNe6NJmQ1BgvSKo8l80KiL6pUecsD6E09bgaDJdbHVX5V83CR/gClBVpvuMWlYRS9h58MNuMvdCHm4lkPDQx8+hn1nGkIAKE0NdIJ3xt9MwDUdXxjZoYH+7fRMc7sQ6psKVPgrizhJ8iy0A0LeC3bC5mu0klHYebzY/TL9g14KP++Wg+53DOWj2TQhwuRrULXpLgGRvf/fwZeMNLvqUbt3CkmFvhZHrq7GYlrHjZTjXXKvJidXa96ErLC20fFB4p9GAHnWZ3TDJI5UmPCkVURjwd14z6pathFPFc+wNPKuYxL4uLiSchbrppv2xqdIs+WdXGFUlublm+BdGHgIIEcpMNOxaIuVpoODsS2nBPIW6qXWstYJLcdkZ8mQqIlBqKEgn03aCW/EI3MAzT3TgiicLaUEJmwBXn53/BfKRyRwTGRjDeB6xmySMMOGeAxO5KIY92ZGhbfPiZhgtWIRKHqS6ct/jcl26GDNF9bXVwC5ZdAxcaXaBvxgMVXU0cbJh3n9CcGNDf73IUempxukiTc4TsQ2uiJdT0db9IxLpbGbaZkeji+HqHNaX08rrx8vKOF/7TEbn3QmDkJqMtzvqdRZa2JMGUSCFfOu0XY8FUiAXUnLygQJcmzr5V2aQctO5D2WXUmxQr9/ijTDwmuUniotItS39msTDWy1TqTXdVQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4799.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?rg1Phn9q15AQZUyD1zHLR0to88yiaj32tTfl2/1Hh3J9rUDbrq3RZPChZQ?=
 =?iso-8859-1?Q?04uXDBfPqQtxbS1Ufj12fytPbCLy0EoTHiFhywPVW/Thx4f7xGu+ZqEcu9?=
 =?iso-8859-1?Q?EKs5xdShd1tbpq6aGO2GEz8GdWi+DUkaYlboTDKCFjMmxCtEceNdgvuAaB?=
 =?iso-8859-1?Q?cm+v6iZd4Gstwv/qjdEs7bguR5+m1T8Dv7pWq26UVoJh7vn2ihfvPeLsRr?=
 =?iso-8859-1?Q?p7aGp8GWLCwdV+ZX03clcSkqe+dSBwdZGz+VUD6xHhLd76W0EylKEaO/a+?=
 =?iso-8859-1?Q?a5nQvqdArQ1EJOn77zvJ/4SgAlmncbqUMw5xCCvd3xlqmD0I813/TvGbS5?=
 =?iso-8859-1?Q?1Fc85O8T9UJlavu8N+vbLLlvxnbuIm+9n4jFrpJ958+vY6KES1XQ0wcQs7?=
 =?iso-8859-1?Q?tNchcjQ5MxcxnMbLV33aCm0IOcNmNIwjLI9f+X1IpYg/dT/tv9cr7z7aAc?=
 =?iso-8859-1?Q?/sLjVAZErerZn71hQ2ZSR83Fddfsj5/3DOWFH5UhAyK6Vo7U3AnS8kBljQ?=
 =?iso-8859-1?Q?NiyVom2Y2Ksw36SOuBIygPv9YRhzjcLxBxzZ6oNdE296Tqq9d7IJ+dfSS+?=
 =?iso-8859-1?Q?znHuXpu46dyNojhzMzyxM5L/cUduUVH06W2UTA1MdOkjuP5MGPDv5G+CiG?=
 =?iso-8859-1?Q?7hQkjWO1y5Gkq2sPwh8TgOZ5sIS+W82dEDUajkhsHeqaEqBMsbbHpZMIxp?=
 =?iso-8859-1?Q?oyLcbmtu6rzmbY91gmncGZWXW/ITyX7XJeUqgoQJdTFY7zKtY5c2QKtqUr?=
 =?iso-8859-1?Q?pfxGA/54DwdyMWEsmgEyhu/SKyEz7FOVh8R0M7zgVzUyHtwMNNRRl3Ma7o?=
 =?iso-8859-1?Q?xp3YA5dNDbkv0J3SOJfxVAgOYFeS1j0xcbyYWbjJIc3g21eTPIaDUDR8e3?=
 =?iso-8859-1?Q?CdTrc+dnMjG7keqX8y2MT+OHVlLBqLfXsE9ZY9WvgQIo1goqCUQuPP5Gv7?=
 =?iso-8859-1?Q?5NdovJMLXb64EYUmj5AX7xemLZ9v9ELdtJHtJhlWRd6/Fi31TawvoXfa8q?=
 =?iso-8859-1?Q?D3Im9/sSqxinkUxXoUvUGQfpI4Efj1Sr9snZpy2Hz6K8LHZymIpkImhYgW?=
 =?iso-8859-1?Q?mMX/NcA2WWj1TV+d63rHGBI/h1is71oZxbDt5pjGr1xfh3h1jE6n3hHfrv?=
 =?iso-8859-1?Q?04ypeOpZW8dZwQm7ohKznMrw4hTClCpPsR6OrXhha971xGxq/i+pOXrg6Z?=
 =?iso-8859-1?Q?DRrZ9Vt6WvyS2BawAgVlyZ+JLm/DJ+/3MPdZy4TjtXdd9uzJyZoFsVRVUj?=
 =?iso-8859-1?Q?hOywRI07fjdzjMqVtzEd6iSN8JpIPJML6955HzwFenvQpcl7mcSc8dH7px?=
 =?iso-8859-1?Q?qn/4d/3PPA3Wi1YY+K/fjPypIyXulArJHuvAsCzsqtud86rFB7e35M3qIk?=
 =?iso-8859-1?Q?aPWAkF043XZji7x1unPNHN1OA7aN5nZFDdAK2cH43lyVjckMPs0MsvIzIU?=
 =?iso-8859-1?Q?hZrleMbsmf/BxAxijkXZknDYDiXPeVXDkJug1kofom5NT3u9l4/g81534c?=
 =?iso-8859-1?Q?eE+ytC4oeRdgYGMv8Ves9NgBypS1S+JKnnWhO3G3Ojo0B+H3O49cHZzACP?=
 =?iso-8859-1?Q?ef1JNJhD968pNj7O8eVkaxZQyH0S6D2pfM+4mFC3lRAVODNG+dQ90Pkg82?=
 =?iso-8859-1?Q?DvB2l9ULPh2yYA7Na3/sf7lj5Qmy8YIcDGqWe6HCXKyHPhVDnyTQ5L1YVs?=
 =?iso-8859-1?Q?9hW6gHHjwn7FvjvHCpw2+/G/PI6zbbcde2w8ZmueqR4rCer3owJkkTxjeY?=
 =?iso-8859-1?Q?iKms3P6rTSRJCUMkVvIohYWVfuUmec8uJ5VNzCxU7hnYJbN3J6A0VGkxuq?=
 =?iso-8859-1?Q?sTh34jQb9Q=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	OKsuf1ChMl91QVB1lty0hPXFIjwf4LwqOCc24OZzyhEAVJ2yHmKIbye1Mjv/J0Qkyj/A3ZNZX85+NHmBcmdHSkiK1TSudCg+a3+ubpumOAeAXMtLqvlA1osfq2fDY2YB45LR/RFD77w8AaTwbgK9nVy+2C0Cq6m/uknQIX0fc5TlJUb2Lc0jR1vZPS+XA2/mnCd7LIYAjkUZvM6mRh3n4WYalfumPHfcMmBLEM+gg6CLg8HTLRC3bdnKe1pJ88a3MyG5MQ2ZJTrIkwmBlsoNvoZKoUrqSlpR/rgDiquxtJ9W0HkbuG+mqBC1KzAISXiv/OyqKxLCsL9CgavxhQoCvw==
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4799.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e155ef-a7fe-4829-2cb0-08df0cdb3c20
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2026 12:26:25.5908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OACWrxhDvzNzIYkodG/9Wh9n5GLXGpQQBvqG4yBi/0s6sI8dZLYH1WGlgCi1G+CoVuS9w0Z3z1rpMivObx7OOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF712D081B7
X-Authority-Analysis: v=2.4 cv=J/SaKgnS c=1 sm=1 tr=0 ts=6a9ead75 cx=c_pps
 a=iJ0/73tnBOJCmN8OdmQeBQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=VdqzKS8jKosA:10 a=-AAbraWEqlQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8
 a=VwQbUJbxAAAA:8 a=eJZtPekdMb5ZeeVTcGgA:9 a=lqcHg5cX4UMA:10 a=wPNLvfGTeEIA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: gKS3r8AxJDensYSAyCNGvIkAGnk7BF3x
X-Proofpoint-ORIG-GUID: gKS3r8AxJDensYSAyCNGvIkAGnk7BF3x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDEzNyBTYWx0ZWRfX7YSjCQydDPyn
 TCyQNvBWEe0QXXo7ceI7ZEw2w9iBldhFP4rgLuzcfbXvFIX5YmIKIHOe8K3Mngqg7SU0mUfrkjJ
 2/sehRtcQbTXLylpL2yOM10dM8iVz+C6y44tzTBNn+23wvyWWUYQXcgDmjt22+5e1Vb73hu/GAb
 Iy1kb/zN/ygV5vX92Io1RQYm9e8zi+wjwNNtGQ0KRMNlFADb54mauGKo8ebCti8A7a0EySDAs0I
 +jXXtqB2DEFu+SHfO65sdpeO3wGidAhBCR44O2hQmx1Wl6lQizhd+EaRBq9YIPAC8KJy8HRKsJR
 crRGkdXVnVGN+ilApP91tshuNfU7z2DsupBvucVBNV04nHDKdV9mfNlPDxRriWF9ANRNLSwUEPj
 0RlJp3tIw3/pdJjnmvKmlLMRbixDyb8pXqnScD9/8b4WQFnEI+qLCYtWoAXkEpKCmJpl4TSfmGz
 fdOXYffTUXPBd6IGs3g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDEzNyBTYWx0ZWRfX8m6J+lSn0fyu
 P61nUCAKXiniB2H9yqhIcCpZ9n2UH587IZOPSiQZBJHTcuwB/QqL0aqPxd66MY0dBlg2/x/u9U6
 Ouz2bDEIdJOsHf5zNEa8vgaeWuIjdd0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01

From 650f8afd4f71e7d4a11322a026a978c7b85c5794 Mon Sep 17 00:00:00 2001
From: Nimal Prabudoss mailto:nprabudoss@marvell.com
Date: Fri, 4 Sep 2026 07:06:17 -0400
Subject: [PATCH v3] MAINTAINERS: Update maintainers and group list for QLog=
ic
and Broadcom drivers

Signed-off-by: Nimal Prabudoss mailto:nprabudoss@marvell.com
---
MAINTAINERS | 32 +++++++++++++++++++++-----------
1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3cb12243b636..9e59e93a0860 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4595,7 +4595,9 @@ F: include/linux/bcm963xx_nvram.h
F:=A0=A0=A0=A0=A0=A0=A0=A0 include/linux/bcm963xx_tag.h

=A0BROADCOM BNX2 GIGABIT ETHERNET DRIVER
-M:=A0=A0=A0=A0=A0=A0=A0 Rasesh Mody mailto:rmody@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 mailto:GR-ETH-Storage-Upstream@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-Linux-NIC-Dev@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:netdev@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
@@ -4603,9 +4605,9 @@ F:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 drivers/net=
/ethernet/broadcom/bnx2.*
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/net/ethernet/broadcom/bnx2_*

=A0BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
-M:=A0=A0=A0=A0=A0=A0=A0 Saurav Kashyap mailto:skashyap@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 Javed Hasan mailto:jhasan@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-QLogic-Storage-Upstream@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 mailto:GR-ETH-Storage-Upstream@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:linux-scsi@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/scsi/bnx2fc/
@@ -4613,7 +4615,9 @@ F: drivers/scsi/bnx2fc/
BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
M:=A0=A0=A0=A0=A0=A0=A0 Nilesh Javali mailto:njavali@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Manish Rangankar mailto:mrangankar@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-QLogic-Storage-Upstream@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 mailto:GR-ETH-Storage-Upstream@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:linux-scsi@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/scsi/bnx2i/
@@ -19050,9 +19054,9 @@ S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/infiniband/hw/qib/

=A0QLOGIC QL41xxx FCOE DRIVER
-M:=A0=A0=A0=A0=A0=A0=A0 Saurav Kashyap mailto:skashyap@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 Javed Hasan mailto:jhasan@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-QLogic-Storage-Upstream@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 mailto:GR-ETH-Storage-Upstream@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:linux-scsi@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/scsi/qedf/
@@ -19060,13 +19064,17 @@ F:=A0=A0=A0 drivers/scsi/qedf/
QLOGIC QL41xxx ISCSI DRIVER
M:=A0=A0=A0=A0=A0=A0=A0 Nilesh Javali mailto:njavali@marvell.com
M:=A0=A0=A0=A0=A0=A0=A0 Manish Rangankar mailto:mrangankar@marvell.com
-M:=A0=A0=A0=A0=A0=A0=A0 mailto:GR-QLogic-Storage-Upstream@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 mailto:GR-ETH-Storage-Upstream@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:linux-scsi@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/scsi/qedi/

=A0QLOGIC QL4xxx ETHERNET DRIVER
-M:=A0=A0=A0=A0=A0=A0=A0 Manish Chopra mailto:manishc@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 mailto:GR-ETH-Storage-Upstream@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:netdev@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/net/ethernet/qlogic/qed/
@@ -19074,7 +19082,9 @@ F:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 drivers/n=
et/ethernet/qlogic/qede/
F:=A0=A0=A0=A0=A0=A0=A0=A0 include/linux/qed/

=A0QLOGIC QL4xxx RDMA DRIVER
-M:=A0=A0=A0=A0=A0=A0=A0 Michal Kalderon mailto:mkalderon@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Nimal Prabudoss mailto:nprabudoss@marvell.com
+M:=A0=A0=A0=A0=A0=A0 Sharad Padol mailto:spadol@marvell.com
+M:=A0=A0=A0=A0=A0=A0 mailto:GR-ETH-Storage-Upstream@marvell.com
L:=A0=A0=A0=A0=A0=A0=A0=A0=A0 mailto:linux-rdma@vger.kernel.org
S:=A0=A0=A0=A0=A0=A0=A0=A0 Supported
F:=A0=A0=A0=A0=A0=A0=A0=A0 drivers/infiniband/hw/qedr/
--=20
2.55.0

