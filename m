Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Qt9esFLW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TtU4xW/9"
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56AE12C;
	Thu, 30 Nov 2023 00:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1701334142; x=1732870142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2u/owV6eBl6RbN62c6OKe6iG/M87rK8CYpLIWiFu/UA=;
  b=Qt9esFLWzk6JQW5irQ58RZM3BrfefAdmnoz+PIsZS6EUIKlssK/jbygp
   KpW8h8pCT/AKYPszBa1tZw/LbAet7DmoKqPYLkbNpQ65Y7LsE0Q2XQtPs
   zYiWg/0Kur3hiTcA8LDcTUJREIbSuf0WhyhfUbfrS2csUeDQzzQdOzzdE
   0c6Yb4s6eBFOCpeEqEj5BPqcI/lVu5yTQtCoA8JD57Rahsh7+2EEXq8+A
   w0XeNKIQgQJvEfo6R0l9A4V97LhsYH6WOWAYYY0WGArsvFcf7HD5+Mr5V
   +uZPKOmkmvCb5Adfu7j8nKKzsnkOj3WR2umb9iQPtRxhzZE0iF5U7BDcL
   A==;
X-CSE-ConnectionGUID: Vs4yh8xaSDmcfLSjYR+B/A==
X-CSE-MsgGUID: VV+0wrAwT4CRu9HQB1Ot4Q==
X-IronPort-AV: E=Sophos;i="6.04,237,1695657600"; 
   d="scan'208";a="3701688"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2023 16:49:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEujyQwPltd1mUzYy7QwxjafGXC/9qKq5jrB6tnzElFKrmmAWUxFxrl9XidzZXtEM+Oa9XlyAyBlmQDIX3/7/r2eEwauYqdLApTYTTOcWo5IND9ha+5WHH/eS3QDgoISnLqwqC//vJIydSjnwvvsyksX8h5HW/QbBFyLVJhyd7+QjthKoWKspuALZoJQGyQ/U93z0zyYc8TjyWoLEYVKQ/NZTK8CEu3xW7v1PQrpDzwsApBD2/D1DmFy/11e+O7DBbcyW43FBA4XemguaB9Up7oVqUOud73rT8yLAmw3fnMi/3rbbQuBuTbVhuTC59xFkIARiiIRnxhpfYRbtblthw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rLiU5/IbvjiDPNJKxdEhor9OxZDZ/8cKSih0rGNCdw=;
 b=TK51YJGweNfYRcQfTRn/37OIXxSILiYiEop91QhfV8A90E5IxKPVbrZrIH2XPNI4/G561wu24poAHuYNG3AzKW3TZTV2MQo3nW19ltbXZ0dkvL+obP5a8kJS+6yLrK5OiTk4K/qjp/DMOxQj4BZCp/wBLYCKhSp4oZe7PxFXCYBFLzLvKMpFgpYH/DUKNUGPrBHWimzeR7GKbl7h4hU9PwBKGV+ief1xFG6bw1c/ldKi3Twmrm6SBvDhKYeZMZgTIXyLzcKtnyAPp4Nv/JRooFrZVE6b9ZAe+Fa8hGB1ZvMfRBexjs/TjDQkKc6j5uX9QNTTPCjmWWMiA1i/v/RuQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rLiU5/IbvjiDPNJKxdEhor9OxZDZ/8cKSih0rGNCdw=;
 b=TtU4xW/9nZGrOnfuTCCowPHETEF9JSoGK2H0LCH8zI28eIFYNsYd46iXnQD0a/YDmlcK+TyIL8NGGXKep22LGNu0zQMTMt0FL8b8BL8hK10GAvgIhOH0aOHVCwr+XEP/gM/EwiItPzZfjMCjyDAs2ZodqhB+2x9KfhBdJE/yI5k=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB6697.namprd04.prod.outlook.com (2603:10b6:5:240::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Thu, 30 Nov
 2023 08:48:59 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0%4]) with mapi id 15.20.7046.023; Thu, 30 Nov 2023
 08:48:58 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Phillip Susi <phill@thesusis.net>
CC: "bugzilla-daemon@kernel.org" <bugzilla-daemon@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>
Subject: Re: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Thread-Topic: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Thread-Index: AQHaIrDHZkHxUhWAhUCHwuvRR1mIA7CRo5AAgADrKoA=
Date: Thu, 30 Nov 2023 08:48:58 +0000
Message-ID: <ZWhMeabsUAupQ8Ob@x1-carbon>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
 <bug-218198-11613-NAsEdarpyZ@https.bugzilla.kernel.org/>
 <ZWcVhXMbJOEHIq0D@x1-carbon> <87zfywv1l7.fsf@vps.thesusis.net>
In-Reply-To: <87zfywv1l7.fsf@vps.thesusis.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB6697:EE_
x-ms-office365-filtering-correlation-id: 0a3cd63d-825e-4aa2-03fd-08dbf1813142
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 POGSgYGqN/dyQDFgWEMthKDxNpcaB1xrkS0lUP5L7fF+UWIlB6/OiYxeDWI1Ag5ncqrvEMkbVuNZu1djbgrITgPBWl35b2fPWN4PQMErq1mL3pyaNnkAjh0oxgBdO1igywY4JpBO6X3JGkiRiYzyHMs50/5Z0gP7HOjqoM6gXLDnTVs6wn+fxkmsOzN6E1c2neWdJPWGXInK7TH7Ua/zyxqOpHJOBJGa0ZC/kfVeJt7fAOluO88ucPQYVCl5l1pRWidMkY4H1Fa4DJL53a/r1XJVU49luyqTs9GJsyBqIjbbfZjSV79Y5uf1zJ0l/Gl/BKNV9zo4eUjKdutlOFMN5/g78TmlOhnm3t2Ao32NocVH3wn89ARbNu7Ko8EniUaUy1IQhHyOEHuClFr3yt9et1zhXKv2R2t9bwHqT7jsaqebznbps/qq4RlrjdCDxSwITPpQWO2Q631ZduhS2ZBxwMjmjLcXOTAH2cLVAkeW+zJPL3iGwvPdHiiCZ350Us1k8Kxre2xI0QRkodcety6q+w9145Yaw5FMBHxoweqTD2siCQNXldS0IxUl6T8ii5wamyJsJ6fQVT2CfYet/ihx1fBNK3/8b/lwENuxPjaV0BwjCoPSjUoqVmiCwto2RkjJLk5LE6mDw2G2Wr1gUJUCwA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(71200400001)(26005)(6506007)(6512007)(9686003)(83380400001)(5660300002)(15650500001)(41300700001)(33716001)(2906002)(478600001)(6486002)(64756008)(966005)(8676002)(8936002)(66556008)(66476007)(4326008)(66946007)(76116006)(91956017)(66446008)(54906003)(316002)(6916009)(38070700009)(122000001)(86362001)(38100700002)(82960400001)(202311291699003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?u3b6W2bTXQClemlbcfckI/gJPZ+JyWH/qXRsmwSQPgCltuaGPaDWHHugOsck?=
 =?us-ascii?Q?lA/YwsbN4HgcBwrDjEm3oDesHqphd+xAPjacg8f1W87j4oIaZD3Wum8ECnlV?=
 =?us-ascii?Q?ZSKAE5xC2LioC1WFnJ+58K0Cksm/cSgQB80H7BUrjP1XUV8XpPBUy1c8nyzQ?=
 =?us-ascii?Q?yVK9zgWBbAhFG+qm6FBM2WSkoDGNOLasyPpjOI/W6Rg0P3ymMHMvdSzcQClL?=
 =?us-ascii?Q?HFl2MWiOFEdSQgNqejR5l4SSyutugzwabLxnuCwfztFMrhKdQQ3zlbyaBUey?=
 =?us-ascii?Q?hqpmkWzPs1SQCd8goCAkIKdiR1VVXUdVPfHOdBRcDzB7rhA9r0N4qYeqCcGM?=
 =?us-ascii?Q?GkwXXcC7cejO6Ep6dNW84phymOEXHnD6yG89CeTRg7/OXTk4KMXZrQRHZUgA?=
 =?us-ascii?Q?njcHPAZqeW9+vEP297l4p7QrbiU2wFGX3V6WSVBi6HPZ+KsDtXZeQHjH+z6g?=
 =?us-ascii?Q?4L6P+8xLhlEECMy8965POjbyHT/YMOSnhtqdcXATUgimL/uzABvZa721u2hn?=
 =?us-ascii?Q?3U1OC8Gku3wWZrXK7Ox++C0/5qKhEODxkepn6M59vSi253oVY64KsW2glQK4?=
 =?us-ascii?Q?8p6x3u03Ctul1JtpQOj5G6kCuFhsCzj4SaXryhfuxH4xSCb5+ynSJxL4s4IT?=
 =?us-ascii?Q?VLcackfliOjBKWg86Pe2c1txlcPhdosZQCZzmezgq5Stoqbjgp4RtGfkYDwM?=
 =?us-ascii?Q?zQDDNeWa8Vmy4RZNwIldWtpoGJ0J1sP7047Xcy4tES3WvVMHsjDhLRN4rZ6c?=
 =?us-ascii?Q?OR0OLODLXCiSXF11AtfHi3ao8EPGit+Agsb6FyPYktXkJKoAoacxYFu6VAvp?=
 =?us-ascii?Q?7jFtGxjJiNkEbZKZDE4/HYdIk3ZQsTMlKvtOTCfWFPOwaGfwVNbaporcJxq+?=
 =?us-ascii?Q?xtA2reetSNdyN06UXx28XlAl8MMahds10/AXMFFJm9+Vd7/WfGwVp5l77ACb?=
 =?us-ascii?Q?NCjzwgFFybWDxv2848XIkIZKOV2H2fMgFj/lP31SHng+WWy4bQ6hRt/+knDc?=
 =?us-ascii?Q?TfRFOQm5LCbawiEpG573kujAM/11U3t8YFVVHzRjDVINMC4fa5ywOSY6GmqK?=
 =?us-ascii?Q?RZ2Z/9FUzVVEO8EBa/ALvf5AMZX+BWr4PAKOkelUlsOOItxH6kmVjVBhio2l?=
 =?us-ascii?Q?jOJkOnOGAp9Dm2SF23I6aDCj96pJQwNY2x+XvsMmuAToOfXuq4xur5cuxHZH?=
 =?us-ascii?Q?4130jyunGF0MjCM68iSGRQFqijYqH+xB9Nt2dZB+bZC8vQIgw85zaHw7x2xd?=
 =?us-ascii?Q?V+cnKSeMe8vL2nbOwSr/SznNVig1zAqX60g2rHhp5Wlq8xXarU/sKaBymu88?=
 =?us-ascii?Q?ccGLprQmQg6z2DLBCHP3AfDk3lT1eZAv4TN0dGdO3V3Q/N2Hm0S890czJvKe?=
 =?us-ascii?Q?8+C0WTb92TwVI5RoGBe38BraMGiBaN/WOLIrbyGFFtcBArcBSMTMUfviRejS?=
 =?us-ascii?Q?+WGX2K0bqXvTfrCOI9UkIYfj43RsMihckm7eKq0EjE0vD6em20vdNpnizSQD?=
 =?us-ascii?Q?xuNOkXcka81rqdEVe4/DQvj27UhaKJEzGqgl8Vv40zNHf8b6fTuykm3fCiR5?=
 =?us-ascii?Q?MS7GHxY4PrTq5zg0hY09C0QOq0U4LvdhiHudEAI3dB5hP2Qju6sl9Yr56H5S?=
 =?us-ascii?Q?BQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <340D56A530C6714B8605BF3E2B81D712@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hVhRMdwnnq4WbtPgLpJyNYsufTGdRDSKtusH1LPrIpMzPMP193IBkLRY/ogBpfnJYlFspv0Aiqc06Lbh0yRgIbDbUEq4S/4r9rHECA9aUkgz6OX9sqVOCBfx/asirXYKJvxLfDmRYD16Rpw2/D7YwqL10xr4qExfs5ViBVXANh9unYY4eE/bsaLuLOWu426w2oWuWu4q1iduQzp2Gp14t8FhPMTVcEsvPaCK1W4mUnXg68RkzU/o3NC1LM4RVjOBGtF2GAuJx3F9SCfaW8BaNXIaZOQmVLYwKvyxx8Vmhpy8DH0FlMWyCXMyO0xjlZ9H/sdzmBwXl0XMaGCmRbTAOV2swaXZKAkZ6nKuMfnEKNbcoHXnalBMMqSYVF4bzDnzfqu4I44TpEthEMlJJynWysZAFj5y6Y13UQypt4zVcKSetVDFYR/Re7H7pIuzD/4AX3azaMN/ilXBCTCP9IysVxLCcl/jzgaJVY6M2DwF34E8mCUpPZS1eWvJgTxreYpA2KiO+aqQ80rZQKcXTcV4rTfuy69APUpRtCN+YL+TIPxoN3+GDQNYEgQ9tuP+jh307+rsF0uLsQj4Vv+30FN2e0tYQDQqUvj1MKmutw6dURKVmkgeKEQEH/Oa/qGNxXDy+T2k1ThycLaUnPnVS90Yn3IT/iaH+O/zQ4PFrxUGX8ZKXDaGw9z6Eg1tut/qKOk93i7dn1+3JbxR1PFn4vEoFNbChAYro1KHe1Dl7iOhSv6VYSP0YcC9KaH5oDWud8j+s5HmHfGYsHum4tV5FYHTlkOSRA9/AwshXiWzx/j9Cs7wD3fNcAPwCPk+Fgv2XDY6uHezYSltxIOOXvK4S2eR7CuHwqU58U6z4wlsyNBzT5Y=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3cd63d-825e-4aa2-03fd-08dbf1813142
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2023 08:48:58.2345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1vOrcHQL0SaOFJqEP58zazudvCrrN2ESCVuHTw565NKcaDYS+YukY0wBa+oDr0R/zYdEIjQkDs9vdr5CfmShZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6697

On Wed, Nov 29, 2023 at 01:47:16PM -0500, Phillip Susi wrote:
> Niklas Cassel <Niklas.Cassel@wdc.com> writes:
>=20
> > The reason why many platforms do this override, is because:
> > "One of the requirement for modern x86 system to enter lowest power mod=
e
> > (SLP_S0) is SATA IP block to be off. This is true even during when
> > platform is suspended to idle and not only in opportunistic (runtime)
> > suspend."
> >
> > "SATA IP block doesn't get turned off till SATA is in DEVSLP mode. Here
> > user has to either use scsi-host sysfs or tools like powertop to set
> > the sata-host link_power_management_policy to min_power."

Note that I copied this text from the original patch authored by someone
at Intel.

I've seen similar claims from people at AMD.


>=20
> What?  I'm confused.  Here are several things that come to mind that
> when taken together with this statement confuse me.  Perhaps I am wrong
> about one or more of them?
>=20
> 1)  DEVSLP is an odd thing they invented to have ACPI twiggle a GPIO bit
> to cut the power rails to CDROM drives that aren't in active use.
>=20
> 2)  SATA ALPM has the SATA controller automatically transition the sata
> link to lower power states when it isn't being used, and back again on
> use.

Yes, the HBA can initiate a transition to DevSleep automatically using ALPM=
,
however, the specs says that:
-DevSleep is disabled by the device on power up (and has to be enabled by a
SET FEATURES command).
-PxDEVSLP.ADSE (Aggressive Device Sleep Enable) for the port is 0 on reset
(the kernel resets the HBA on boot, so ADSE will be disabled for the port).

(DevSleep is never initiated by the device.)

The kernel will only do:
-SET FEATURES to enable the DevSleep feature on the device, and
-Set PxDEVSLP.ADSE to 1

If _all_ of the following are true:
1) SADM and SDS bits are set in the HBA
2) the device reports that it supports DevSleep
3) PxDEVSLP.DSP is set for the port
4) the kernel LPM policy is either ATA_LPM_MIN_POWER or
   ATA_LPM_MIN_POWER_WITH_PARTIAL

See:
https://github.com/torvalds/linux/blob/v6.7-rc3/drivers/ata/libahci.c#L2322=
-L2324


This means that if any of 1-5 it not true, the HBA ALPM will never transiti=
on
the device into DevSleep state.

AFAICT, the HBA asserts the DEVSLP signal as long as being in DevSleep stat=
e.

To exit from DevSleep state you can just issue an I/O like normal using PxC=
I,
or write to PxCMD.ICC to force a state change.


> 3)  The SATA controller can not be suspended until all of its ports are
> suspended.
>=20
> 4)  Suspending a SATA port does not happen during ALPM, but rather only
> either during system suspend, or when you enable runtime pm on the disk
> and the ata port in sysfs ( both are disabled by default ).
>=20
> A quick google led me to this: https://smarthdd.com/device_sleep.htm
>=20
> Which indicates that this DEVSLP thing is now being used to send an OOB
> signal to a SATA SSD so that it can power down its PHY completely, but
> isn't that what ATA SLEEP is for?  aka. hdparm -Y.  That command tells
> the drive that it can power down its PHY and then the host can power
> down its PHY and it takes a sata link reset to wake the drive back up.
> The link reset is easy to detect with minimum circuitry that is far
> simpler than the full sata PHY.
>=20
> It sounds like somebody decided to hack an OOB signal into ALPM rather
> than use ATA SLEEP, but why?

I guess you need to ask Intel.

I assume that their firmware simply requires the DEVSLP signal to be
asserted in order to enter lower CPU power states.

If you have a signal, it is easy for the HW logic to detect if the signal
is set or not.

If you just send a command to the device, if it not easy for HW logic
to determine which state is in. It would need to read some registers
or similar. Sounds way more complex than just having a logic gate.


Kind regards,
Niklas=
