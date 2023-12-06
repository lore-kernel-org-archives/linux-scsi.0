Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ICl0gwSm"
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Dec 2023 06:51:56 PST
Received: from esa5.fujitsucc.c3s2.iphmx.com (esa5.fujitsucc.c3s2.iphmx.com [68.232.159.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CAD9A
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 06:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1701874316; x=1733410316;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=MOEwbG1c2bfvlBiXwytxWEluhIhPk96sW6QK4DwpU1Q=;
  b=ICl0gwSm0uE/h7zCsj3sUgZ6t/aCDGG3yaiZG7n5Jl//wIXTybqFoJEF
   eXNsn88B/y9ziJRCk01clID1qbJXFQWD8dIiP7f6WV6G9OMWGFRhq6ZLg
   OYbI5wKbjtH46N3AG5o3FokGDNVDhvi4LZ6Fx8gngt+55KN0yJSOnQfnI
   VGE4RepXz4lCoxhs5Ld8910peLbEY3gAoj8QaD+Bdj3EqTG7hLw9ZITQQ
   aEafdRiOBdRs2903cnEcGV1sYLdw/w9c3xLHoug8Pd+82p36IM34tRgTD
   luZ3ujSheQAuoeIbfk50ey72D+HXk0B1gOrCLndEsn8dTJYqj4inGoY+c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="105199395"
X-IronPort-AV: E=Sophos;i="6.04,255,1695654000"; 
   d="scan'208";a="105199395"
Received: from mail-fr2deu01lp2168.outbound.protection.outlook.com (HELO DEU01-FR2-obe.outbound.protection.outlook.com) ([104.47.11.168])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:50:51 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmlBPMYEBfE01lYjxb9zcAGFdzUb4Ixi3kaEqihJ1LMDo9Ex1qaBlU2E6Am9fCNTjOaba6QQzAv/uPmqYnB11KD7eIiY4NPXzFyju2dMDAcVZ0kf7qP73nuW8pSBxPGjO0QIaRObrQLhoJsWe+zzd5ZEYsxC+13mrMtnfK135P6a+A0qAE56fteRw47SYhVl26qc/rQMeQmEEx58rZIykTdj2niKr7Ig5pN1PgWfFdhLEUJk3LR8iOwDwycBsJ0JqJvi+rTnSAuKtihJFiEMfQ2uS+eqjE31yLDRRZCoh29WoTIOmoWXCEdhgn8zKI6wAEu7wgh04cBRALdKUwvc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zh1L7Ln1QQM5GQVEsY1+KFqHTNe5sFEuHkAQdNNIp5Y=;
 b=cL3dBzW0ZBB0+a7EtfoTvOH2RhgjhHivevi6sSthewFGoi4vea+1vL8hqiYVA+tCHfmoLkp3FAPZKahmdqN1MuzFyEd3vyIeGeu/cSIbypzAF96iWRphdNWf8mx2IM840gdw7ue4CDGeFUxID6cbrBa0TsYSibuaN5uBvocxCFklrJH9sLAl2XC/AqCxaZWE/HEj28f+OWN2gx/t8w0YfdgUIO6m2QpDLTeom8p1WGepzXA/HPSGc6HP7bhv3ztqpIw+havdhfH4ZpCyXPY4H1zqdB8er9OfwDnHOHpVSsuQ/X+hDOyJ3Ik8+IoinltS5tMuC7i9ddRPuD5CiAUiDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:29::6) by
 FR0P281MB1949.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:23::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.25; Wed, 6 Dec 2023 14:50:50 +0000
Received: from FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM
 ([fe80::dde8:7a0b:d9a1:1d60]) by FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM
 ([fe80::dde8:7a0b:d9a1:1d60%4]) with mapi id 15.20.7068.025; Wed, 6 Dec 2023
 14:50:50 +0000
From: "Dietmar Hahn (Fujitsu)" <dietmar.hahn@fujitsu.com>
To: James Smart <james.smart@broadcom.com>, Dick Kennedy
	<dick.kennedy@broadcom.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [BUG] lpfc: Kernel NULL pointer dereference in
 lpfc_dev_loss_tmo_callbk
Thread-Topic: [BUG] lpfc: Kernel NULL pointer dereference in
 lpfc_dev_loss_tmo_callbk
Thread-Index: AdooUmFxy0U56XdSSMaEGMVLLKSB8A==
Date: Wed, 6 Dec 2023 14:50:49 +0000
Message-ID:
 <FR0P281MB212385AC7DBA18F47AD793179484A@FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=de3cf24a-241c-48c3-8f54-1be0692967fa;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED???;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2023-12-06T14:40:31Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR0P281MB2123:EE_|FR0P281MB1949:EE_
x-ms-office365-filtering-correlation-id: 23a173cc-4f7c-4c6e-5bc8-08dbf66abcf4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 +HJJR26nbMepB9w3jSzCvtBsR82p5QucroGtQl0rDrEYX2E3fiPkIbQWCpH+KnFLul+JrfYgj/rGFe5Hkf1A4tLwfg6M5/PBlOwYA/shqK32D6GayVb3PA0Wg/S65P4eKQlJBhl3Lybxa2nM1F8CGgHXEPBtEF4P/Zg1tyjSvtfH1czlKOdCLsRbE3EbX08KU8VU3loAS1zLoaw7pjnGeXpSBhuUG035L2+JgtxHHPeWJ73GoZ0C8SUPeR1in10adID40brsPM3lco+GEqu5Abjxj33BF9HUJBdWlunIkJEicvbBQZBWr2+Ts98Lo2ClEJoIa89rx3cRvPhVQLmdWC9R+z+VvIV4ZZGZCSgRoMsJ5vORSfFAFCPKp9pHNx+bV8rmNsQnt5cZmCf4i1YLMdRBZ3tyqDf3wtD7WuJHpTL25GM9z1Nz2wE1Ci8hzw0z5x5hWBRKVviLRfzdypRDAxI/ig3GAXh4pmmYWIDKO/rPvmuJR9n1z5HvDtmIzF42Qa1GTuUJDp0GCWPcgIJSDqs2iRONLI33dFAj9WJBl9oPy9kMZ8FCt1OLRnUEVu+jyChU9NQk9P7ybMoXOijz87mGR43tCy4+CdICImsJvNAgKgClTXOlPdpORfmU9bMMmpjqLYqrlUQOzSRrlf1keuj31QjPD3UH/hxe4xgU0H0ZFf+MlXWBaFE3LOOBTKVZ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(376002)(366004)(396003)(230273577357003)(230173577357003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(5660300002)(7696005)(38070700009)(6506007)(45080400002)(71200400001)(52536014)(86362001)(8676002)(8936002)(4326008)(41300700001)(33656002)(55016003)(38100700002)(82960400001)(122000001)(2906002)(9686003)(26005)(83380400001)(76116006)(478600001)(316002)(110136005)(66556008)(66946007)(66446008)(66476007)(64756008)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?CyE3cn33bB3hiAAgo4IN19QJmStLTK6pPcMj6rXoVtoaQETh0Lho2xSlgw?=
 =?iso-8859-1?Q?TtTzYJz/xqQPgW761vz9KLtcSY4I32s/bjLX0menD9MGzO8a1b7+KGSQM4?=
 =?iso-8859-1?Q?E2QtPu9N7h3nk71s7OEoyP/Ao7O20NVK9HtOGeYSpTaea1FRh7YhernrE7?=
 =?iso-8859-1?Q?r/itF3P2HcByuoEhq14V/x2eRk+/arBrG9xyT3UAgb8v7fzF6dCCYzMhsI?=
 =?iso-8859-1?Q?HyUJ+TBHafnakZrej+CfpFORXVrnzMZwFWm6giePr3B6Az5xeT8IhpTClw?=
 =?iso-8859-1?Q?fFEDls3Zj9sGz0zG3Zn2V6oFFZJM2uz1uePWthCTUIEEuh+fV3E3spAvYl?=
 =?iso-8859-1?Q?FnhXf/D8ZOJ2uUKaV1v0Epp20k6/gVEo5Z4vCNuTW+YU34UvAJGfXEgAWj?=
 =?iso-8859-1?Q?BrUCl5pN6YcFC1BIEiV/pOVbvInfQFHClBiZ1gI/U0TfAaIOqiqZW91cpH?=
 =?iso-8859-1?Q?K6ePbJDGewYHxqhy1HzQPBshUr7op5dDTmVxLksGaZYl2fBHV3Tnr/Ffb1?=
 =?iso-8859-1?Q?VHoGjTUF4IHl2xvAkndREwk8Oqv5XP6uodq19Zn1RMVPSE53a/+4wAltdK?=
 =?iso-8859-1?Q?g2TDw4VU6DACYkPUsJZPeXAlm2CPDbQx4tvpvbEgM2zdI6rrPJQ5RWuZcw?=
 =?iso-8859-1?Q?8zo/jwZq2t7BxVk+33LcdNhctlIllxPG5AVnzYYj3p/jkz8zQTMAkoU9C3?=
 =?iso-8859-1?Q?X+ax4tmlEAmcPDn56i/hIcGSTiWOc5r+o941BYiN8lsheXhixjj5oOBBMr?=
 =?iso-8859-1?Q?XnvNFWTuzVA1mPBAungzqhmAmtUwmWAIqaCj0Yf86ZLQm/r9WUVo5+MGcI?=
 =?iso-8859-1?Q?yX7ANqZ99k6mcu8fTsUFNnQaPdslD67gQ7t8te25m1WtOyDp/njX0v2cqF?=
 =?iso-8859-1?Q?2K36o6A6HmwZ66MIO7gvwRMyL3aS4UMwDIN4nPEPuQ1p38yboFA2YbArfl?=
 =?iso-8859-1?Q?exF0yIQQ63uuaiFJ0bwgWcKpepjwlyKhM7GLpg/Vn7Z9FKFQKk/15rYHef?=
 =?iso-8859-1?Q?4LZp3x+RjvZS30YLILwKHBtn7Zio7AjWY6RXMwUx9DdYg4SswJyzNBy0ti?=
 =?iso-8859-1?Q?gJfT5ZjdeQMYoYaO1zDr1TLK2Ypg4Foaydvz6U6x/yPLSXWsXRKNEfMxLd?=
 =?iso-8859-1?Q?NUPIHE8SL0QoeSkLa58/NZUqCbTz+HFlFF+KnJ+R8eIPr/bRjrS1KSEYoM?=
 =?iso-8859-1?Q?KtzDDbkSPhp4kKnSdjvwxnAPohUactatpWFHapQu5cn21qmaTQyQ87K/FK?=
 =?iso-8859-1?Q?dpRjZeABcvXvFybSkqH/xJ8c8NWG55kjI+dEGmoOP8HernfGhpQnk/jt44?=
 =?iso-8859-1?Q?ALl7aFFNrdJfeL797Ge6ge1aFfZxcxvF1ZVpI9/9VKBeoeJkPqC0zHUyhm?=
 =?iso-8859-1?Q?W5PZ6Ktw+5pR5UYP9WiG3QdOutqw+iy49QrEIjdC0I0B8JH+wxbbvSC384?=
 =?iso-8859-1?Q?h77Hc0DCygd0jempnZ0ZPAKm362mSbyisfdJIomOnzBzw8JWwFEYvh+BOZ?=
 =?iso-8859-1?Q?BAVsciRA5XHhxNDQUN05QMa5WylBeFbpu/Qd95Ekx4SPNi4SF3k9SGBJQG?=
 =?iso-8859-1?Q?gOID99JGKKLzyd+EyOhSUujjzwEMaXFdz8cLCP/JS2ftK6HvdfXpcIMpfL?=
 =?iso-8859-1?Q?69RlaXv1rxeZNtE3AZfd5aj4rZ8QOnJRvq?=
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
	2m782UhvxWUR+IskOnG8rIUudJ8n5ObfMBNdxFB7t3joTexvUAZ9vqC2J56b6DK/msVtqa4sCUG4P+IBHKPjhOZ9TfgkhZS0U5WwjH0TcfIkYKtm91q7dFaEbtz7+pK/R7G8WeqkqLj7WcQyeQdvkAtzROPSBcDJcQ+cBW0lxtsd1Qu/6W9dD7zkgopoMiHnsPXfOmkOXsEcaLL6fQeBYLWxTv4L5XufHi0nsWeKqw8GdHDe5rEwZ4TW3DHI9EUywBAveG/C0KZ5oIh8sHOeZmdTyyi/IbEXV38fE3W+z1LpYimzGJUa3vKngo6ZaV57c7OuRYjIy5napzb0AIjfo0VVUOVoeIZytksKCEoi5T9SCYTgO3n8JaPertUxCFu/7CC78yA024Cfez6/7H/hFeWfRXlXh8bxkJV2FOAzi9LuRj2EYph0a9v4KMXX+52nQM/gL+0bE5FMDxiyIHnJcjJ955i2tnJ6e9KejKfZ1XiT94k7X0aXySLucKUG0z4gf2MpqUFDsFQ6zwwYJskNIIBaXFpT7RfLgfJ66/5dVOSVyBuNVB8SReBbcLWLeO2ts0wzZv7kvL5Ki8xMYvkhf0JWOlzwCuxtF04hU+gD8OeMzDA2yy7EMgqYfgAwhD1cwPk61knFXlFi+f5TRoPOjZFrHz6Aqdq8Tqklih8QovyhtRPU5SLhmjUg9iEfqPWdhWk8b9CWJBBOgtSM/XwpNSunCoydPAIrvSm/aByFwBoFYFjLD0V+apPgfnnkc+AiDJ1bhgtdSXcNaJEXWTOS3Q7uYfsvzEUzUVua0cPEXQPF9kNm3yVtaEsPi1fAmEPe
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a173cc-4f7c-4c6e-5bc8-08dbf66abcf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2023 14:50:49.9907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lby8uKmJcAxi5TVYPuu4vPzfiE0soZGmJTyBBdSDeSo2hHvbDn+pfoI35bywJgavIkfY2UNHypFbif85/lPT7735MrPQS7Oe9yS3uChNRHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR0P281MB1949

Hi,

we have several system crashes in the lpfc kernel module again.
The trigger is a still unknown problem in our io-periphery.

We use linux kernel version: 5.14.21-150400.24.92-default from SuSE SLES15S=
P4 containing
LPFC_DRIVER_VERSION: "14.2.0.14".

We had a similar panic at https://lore.kernel.org/linux-scsi/FR0P281MB21234=
EA6C74C286904E682CB94319@FR0P281MB2123.DEUP281.PROD.OUTLOOK.COM/.

[ 1286.401093] lpfc 0000:0b:00.0: 0:(0):2753 PLOGI failure DID:6E0900 Statu=
s:x3/x103
[ 1286.428251] lpfc 0000:0b:00.0: start 20 end 28 cnt 8
[ 1286.428252] lpfc 0000:0b:00.0: 20: [ 1286.428243] 0:(0):0408 Report link=
 error true: <x3:x103>
[ 1286.428253] lpfc 0000:0b:00.0: 21: [ 1286.428244] 0:(0):0211 DSM in even=
t xb on NPort x6e0900 in state 8 rpi xe Data: x0 x10000
[ 1286.428254] lpfc 0000:0b:00.0: 22: [ 1286.428244] 0:(0):0904 NPort state=
 transition x6e0900, NPR -> UNUSED
[ 1286.428257] lpfc 0000:0b:00.0: 23: [ 1286.428245] 0:(0):0212 DSM out sta=
te 255 on NPort x6e0900 rpi xe Data: x10000 x10000
[ 1286.428258] lpfc 0000:0b:00.0: 24: [ 1286.428248] 0:0321 Rsp Ring 2 erro=
r: IOCB Data: x12070300 x0 x1420016 x90010000
[ 1286.428259] lpfc 0000:0b:00.0: 25: [ 1286.428249] 0:(0):0929 FIND node D=
ID Data: xffff8882f80bd400 x6a2600 x0 x8000000 x5 xffff8881de4a6c00
[ 1286.428260] lpfc 0000:0b:00.0: 26: [ 1286.428250] 0:(0):0102 PLOGI compl=
etes to NPort x6a2600 Data: x1 x3 x103 x0 x11
[ 1286.428262] lpfc 0000:0b:00.0: 27: [ 1286.428250] 0:(0):0108 No retry EL=
S command x3 to remote NPORT x6a2600 Retried:1 Error:x3/103
[ 1286.428265] lpfc 0000:0b:00.0: 0:(0):2753 PLOGI failure DID:6A2600 Statu=
s:x3/x103
[ 1316.509631]  rport-13:0-30: blocked FC remote port time out: removing rp=
ort
[ 1316.534676]  rport-13:0-31: blocked FC remote port time out: removing rp=
ort
[ 1316.560127]  rport-13:0-29: blocked FC remote port time out: removing rp=
ort
[ 1316.560129]  rport-13:0-28: blocked FC remote port time out: removing rp=
ort
[ 1316.560386] **** lpfc_rport_invalid: Null vport on ndlp xffff8881bf14fe0=
0, DID xfffffe rport xffff8883dcbd9800 SID xffffffff
[ 1316.650508] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[ 1316.675952] #PF: supervisor read access in kernel mode
[ 1316.675953] #PF: error_code(0x0000) - not-present page
[ 1316.675955] PGD 2d752a067 P4D 2d752a067 PUD 21d983067 PMD 0
[ 1316.675959] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 1316.675961] CPU: 0 PID: 777 Comm: kworker/0:2 Tainted: G           OE  X=
    5.14.21-150400.24.92-default #1 SLE15-SP4 d377298f215df506cb43d1afde43c=
807abec1444
[ 1316.802083] Hardware name: FUJITSU SE SERVER SU320 M1/D3892-A1, BIOS V1.=
0.0.0 R1.17.0 for D3892-A1x            08/03/2023
[ 1316.802084] Workqueue: fc_wq_13 fc_rport_final_delete [scsi_transport_fc=
]
[ 1316.865580] RIP: e030:lpfc_dev_loss_tmo_callbk+0x50/0x530 [lpfc]
[ 1316.887889] Code: 00 00 00 0f b7 8b ac 00 00 00 48 c7 c2 20 17 fe c0 44 =
8b 83 98 00 00 00 44 8b 8b 94 00 00 00 49 89 fc be 80 00 00 00 48 89 ef <4c=
> 8b 6d 00 e8 37 a8 04 00 4c 8b 83 f8 00 00 00 41 8b 90 e0 02 00
[ 1316.887891] RSP: e02b:ffffc90040effe38 EFLAGS: 00010286
[ 1316.887893] RAX: ffff8883dcbd9d10 RBX: ffff8881bf14fe00 RCX: 00000000000=
0ffff
[ 1316.887894] RDX: ffffffffc0fe1720 RSI: 0000000000000080 RDI: 00000000000=
00000
[ 1316.887895] RBP: 0000000000000000 R08: 0000000000fffffe R09: 00000000000=
00000
[ 1316.887896] R10: ffffc90040effe08 R11: ffffc90040effc80 R12: ffff8883dcb=
d9800
[ 1316.887897] R13: ffff8883dcbd9800 R14: ffff888163a1e000 R15: ffff888103f=
43440
[ 1316.887902] FS:  0000000000000000(0000) GS:ffff88888fe00000(0000) knlGS:=
0000000000000000
[ 1317.131282] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1317.131284] CR2: 0000000000000000 CR3: 0000000383962000 CR4: 00000000000=
50660
[ 1317.131286] Call Trace:
[ 1317.131289]  <TASK>
[ 1317.131291]  fc_rport_final_delete+0xef/0x1c0 [scsi_transport_fc d1233ef=
07ad0ebe46ae80c1c0661eb0484450196]
[ 1317.233099]  process_one_work+0x267/0x440
[ 1317.233104]  worker_thread+0x2d/0x3c0
[ 1317.233107]  ? process_one_work+0x440/0x440
[ 1317.233109]  kthread+0x156/0x180
[ 1317.292874]  ? set_kthread_struct+0x50/0x50
[ 1317.292879]  ret_from_fork+0x22/0x30
[ 1317.323483]  </TASK>
[ 1317.323483] Modules linked in: tcp_diag udp_diag inet_diag nft_fib_inet =
nft_fib_ipv4 nft_fib_ipv6 nft_fib ebtable_nat ebtable_broute ip6table_nat i=
p6table_mangle ip6table_raw ip6table_security iptable_nat iptable_mangle ip=
table_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tabl=
es iptable_filter ip_tables dm_mod binfmt_misc btrfs blake2b_generic xor ra=
id6_pq SMAWLemp(OEX) smbus(OEX) unix_diag SMAWLzlio(OEX) lpfc nvmet_fc nvme=
t nvme_fc nvme_fabrics nvme_core SMAWLslan(OEX) nvme_common scsi_transport_=
fc nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct af_packe=
t nft_chain_nat 8021q garp mrp stp nf_tables llc nf_nat nf_conntrack nf_def=
rag_ipv6 nf_defrag_ipv4 libcrc32c bonding tls ip_set nfnetlink rfkill bpfil=
ter SMAWLiod(OEX) SMAWLhal(OEX) SMAWLemd(OEX) SMAWLv390d(OEX) SMAWLstem(OEX=
) SMAWLpcib(OEX) SMAWLlic(OEX) xen_gntdev xen_gntalloc xen_evtchn xen_blkba=
ck SMAWLacf(OEX) SMAWLboot(OEX) SMAWLk2k(OEX) SMAWLtram(OEX) SMAWLstl(OEX) =
xsd_mod(OEX)
[ 1317.333262]  SMAWLbase(OEX) sunrpc ipmi_ssif intel_rapl_msr intel_rapl_c=
ommon nfit libnvdimm pcspkr mgag200 nls_iso8859_1 nls_cp437 drm_kms_helper =
i40e cec igb acpi_ipmi rc_core mei_me ipmi_si i2c_algo_bit syscopyarea vfat=
 i2c_i801 sysfillrect sysimgblt ioatdma intel_pch_thermal mei fat fb_sys_fo=
ps ipmi_devintf i2c_smbus ipmi_msghandler dca button drm fuse configfs xenf=
s xen_privcmd x_tables ext4 crc16 mbcache jbd2 raid1 md_mod hid_generic uas=
 usb_storage usbhid sr_mod crc32_pclmul crc32c_intel cdrom sd_mod(OEX) t10_=
pi ghash_clmulni_intel aesni_intel crypto_simd cryptd xhci_pci xhci_pci_ren=
esas xhci_hcd ahci libahci usbcore libata megaraid_sas sv_hti(OEX) wmi vmw_=
vsock_vmci_transport vmw_vmci vsock sg scsi_mod e1000 efivarfs [last unload=
ed: ip_tables]
[ 1317.841546] Supported: Yes, External
[ 1317.855845] CR2: 0000000000000000
[ 1317.869290] ---[ end trace 438fe814fee92d17 ]---
[ 1317.887022] RIP: e030:lpfc_dev_loss_tmo_callbk+0x50/0x530 [lpfc]
[ 1317.909328] Code: 00 00 00 0f b7 8b ac 00 00 00 48 c7 c2 20 17 fe c0 44 =
8b 83 98 00 00 00 44 8b 8b 94 00 00 00 49 89 fc be 80 00 00 00 48 89 ef <4c=
> 8b 6d 00 e8 37 a8 04 00 4c 8b 83 f8 00 00 00 41 8b 90 e0 02 00
[ 1317.973683] RSP: e02b:ffffc90040effe38 EFLAGS: 00010286
[ 1317.993417] RAX: ffff8883dcbd9d10 RBX: ffff8881bf14fe00 RCX: 00000000000=
0ffff
[ 1318.019443] RDX: ffffffffc0fe1720 RSI: 0000000000000080 RDI: 00000000000=
00000
[ 1318.045472] RBP: 0000000000000000 R08: 0000000000fffffe R09: 00000000000=
00000
[ 1318.071498] R10: ffffc90040effe08 R11: ffffc90040effc80 R12: ffff8883dcb=
d9800
[ 1318.097524] R13: ffff8883dcbd9800 R14: ffff888163a1e000 R15: ffff888103f=
43440
[ 1318.123556] FS:  0000000000000000(0000) GS:ffff88888fe00000(0000) knlGS:=
0000000000000000
[ 1318.152724] CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1318.174178] CR2: 0000000000000000 CR3: 0000000383962000 CR4: 00000000000=
50660
[ 1318.200205] Kernel panic - not syncing: Fatal exception
[ 1318.243048] Kernel Offset: disabled

void
lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
{
	struct lpfc_nodelist *ndlp;
	struct lpfc_vport *vport;
	struct lpfc_hba   *phba;
	struct lpfc_work_evt *evtp;
	unsigned long iflags;

	ndlp =3D ((struct lpfc_rport_data *)rport->dd_data)->pnode;
	if (!ndlp)
		return;

	vport =3D ndlp->vport;
	phba  =3D vport->phba;
                  -> vport dereference -> Panic because %rbp =3D=3D 0x0

struct lpfc_nodelist *ndlp;
crash> lpfc_nodelist  ffff8881bf14fe00=20
struct lpfc_nodelist {
  nlp_listp =3D {
    next =3D 0xffff8881bf14fe00,=20
    prev =3D 0xffff8881bf14fe00
  },
  ...
  nlp_DID =3D 0xfffffe,
  ...
  phba =3D 0xffff888119220000,=20
  rport =3D 0xffff8883dcbd9800,=20
  nrport =3D 0x0,=20
  vport =3D 0x0
  ...

rport:
  node_name =3D 0x1000c4f57ca4be00,=20
  port_name =3D 0x2017c4f57ca4be00,=20
  port_id =3D 0xfffffe,=20
  roles =3D 0x0,=20
  port_state =3D FC_PORTSTATE_DELETED,
  name =3D 0xffff888574d5fbc0 "rport-13:0-28"

I have a vmcore at hand.
Many thanks,
Dietmar.

