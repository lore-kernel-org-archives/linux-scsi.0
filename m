Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iJuCom1B";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qcJNdWcJ"
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D21F4;
	Wed, 29 Nov 2023 02:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1701254567; x=1732790567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g22G/7Ae0bmr8aGQRTi8pJyXN35Iu34bsuC/tzG4QvQ=;
  b=iJuCom1BuczipqK55wzztCri3la76aYbEKCs+33a7AmtXU0+/rwKzbTE
   qS5Pj2ul8IKv+IMKEpNJTNpOHJJkfuDk2NH4T40dkJ9cQqgzd2Gi8clIa
   HN1+jr9R3YBSeZ0G4o83IYm/wEQufuHeVMl8jJ2euyJavPCiUFRlgkECg
   8b6PPpPVyyV5ZFO+KHFMCA+f86VHlp0QrcszNtY41P2w4LIXUaS6C7aa7
   srLos1S9rI62vIYvQaqaT3Km5lELLWiTGkmT0ptph0qLB8/0wMssdP0ge
   2QaryvsHkvYI3t8keneOlX3Dnjgan21wQn6g4sOPbKjDn4hpGyf2sE9B5
   Q==;
X-CSE-ConnectionGUID: NtI8F/WqQSuLr+gS6NAwCw==
X-CSE-MsgGUID: KY7syxyCS4OeFx8qmB/7dw==
X-IronPort-AV: E=Sophos;i="6.04,235,1695657600"; 
   d="scan'208";a="3560011"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 29 Nov 2023 18:42:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTJF2sFkLKWPwyue6CerxZzbaURG+0jizIhDjFDHVnrEgdaSWeTTWfkHHERFrpuqepLmuTdny4Xq2FCyrjw3/MhqWJRL2i7+mp4NIrs97eEk+Nc48Gm3jkNrUI9Nfo2FLwB/wgQN8In+EU9xb5w1/XrB7lhLZbf3TJz0zcEOCV9bQcUFrguvxUTcXKKPFIYVvm1rD/CqWfOBgMv8WYUCP2A5EHg7hJL0r2uxQIzogrAfnV5GjV2xhfghVZEy/UXAsfnGy0m4QncdZw6wtGA6m99O+lWG2ictNUK9W2/pLmuU06Kas89ZCbhRVfP70/aeDW2O2KCdGPTi003luU1+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsSabjoQtnX866aUB+P1nrayQPh/vvKR/HODn2Jtddk=;
 b=dUHVX1e3pWufqaB3G68kgIvnoRH/cBHZDthF2HM5dhDSPoxJo9QtcOz9nyUqT9uuj6kHypLQBozajnrctjZcMlaw2teBISt523oyJ+C7lSsWwGB8e7aFEDiud92a3MWgaq/rUobvB80TFxC1xgcAErPgNaiHF0t89x8UU5qjyANBM6bxuGykZU43fOMLlWXx6oJ7puftgIaQFGFERIUfaIMGKBP0ifX0kK1qsgloyHT8AoykOqI0Pznv+ROb0Sb0KJywsQOvey8G6Gm6KYjpKaemuERgUr1TdpjfUlsPOu0H1o74kMzjfW+QTv4u1lfoOt5mJ65QjI7wOlhsl68nMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsSabjoQtnX866aUB+P1nrayQPh/vvKR/HODn2Jtddk=;
 b=qcJNdWcJhhMVHKN8ZPkrd2RGDDWSyvPshTFD69VLyufSjzrNvHwY4RrKdbbaimhQCzDh4+VeREEnGxSygPm7UMbbnwgMheLUYkX2mEK924AC/D76jaLVdl27/dPV0PLIn6uSa1XBo2UbTPe4tNuFJ9ORWGhfSEuN7r1aBtm8cBo=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CH3PR04MB8794.namprd04.prod.outlook.com (2603:10b6:610:167::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Wed, 29 Nov
 2023 10:42:41 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0%4]) with mapi id 15.20.7046.023; Wed, 29 Nov 2023
 10:42:41 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: "bugzilla-daemon@kernel.org" <bugzilla-daemon@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>
Subject: Re: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Thread-Topic: [Bug 218198] Suspend/Resume Regression with attached ATA devices
Thread-Index: AQHaIrDHZkHxUhWAhUCHwuvRR1mIAw==
Date: Wed, 29 Nov 2023 10:42:41 +0000
Message-ID: <ZWcVhXMbJOEHIq0D@x1-carbon>
References: <bug-218198-11613@https.bugzilla.kernel.org/>
 <bug-218198-11613-NAsEdarpyZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218198-11613-NAsEdarpyZ@https.bugzilla.kernel.org/>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CH3PR04MB8794:EE_
x-ms-office365-filtering-correlation-id: 102cb143-e2f0-476b-862d-08dbf0c7e9d0
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 H1QjsoImwp84XqORyYy8JnFrDduUcWNVzFKDQJGkSDZwfbf2lfp/yiRlLgYSGoQfVUNj1PlGjlS2yVHpqIX5vBcaJB8K8fGn17lXlarLiehNA4HMC9Wi8vqjs7woL0vQ5xU5KyX0h+sNVuDLubPGEtIPzdzaP8QJPdqXQpaZi7zTwuEdU2301gzr+p9H7XRI39VKLZvXb1uDoJXkYSL9nkLXKU/Hcmj188pWIn1avZ5UhmJv3u+UiTuzTngsV4X2HqTfwl2Hut1eN5MeOjB3XP+MXEbzaL/oXECjaHxgNmEY29XSlH8QOqbYordKZ8NXo0k8a2iW59wqcaDUSbju1ocFC8GLYW58PLP6FOekFVe7GXicp7r7h8bK3CaFbAZcPBKLmijTDeyTJmQ7x2vYR50/XeScYM7cmNZaHbxP/k0YgZBAvA0naW61Jw/uY/ukxBMxmikhWAJScnUV+mt4vKB1kaDFjpd9d1ZvjPRLkpI+fFAH6hyuhICsx3KMQ9LbM/bw0Q4MnX50B1pGFJS+HZsjNHzGTW3bOzm5JYFWp7fJCvEPTrWMXyAXiqY8qXfw7vlXEd8HrsQLmBLeQdvGsuSvK5P1yjZWR3gUGxZ5EREMK5MzklKUy+fPFwF4Mapt4sXug4sUUclOhXJ9oQlzoQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(366004)(346002)(396003)(136003)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(83380400001)(38070700009)(26005)(33716001)(54906003)(66446008)(66476007)(15650500001)(66946007)(66556008)(6916009)(316002)(76116006)(64756008)(91956017)(2906002)(4326008)(8676002)(8936002)(5660300002)(86362001)(41300700001)(6506007)(71200400001)(9686003)(6512007)(478600001)(966005)(6486002)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?cUftehUtpNsqO4b7XV6fzqKoDk9Xh4zsFN2o72QjpdCTKCXKZTDgOgQA5vwB?=
 =?us-ascii?Q?Cx74vzcti96MxOqanMbIFk4O9EMmdn80MLnwT/DInqv1bdM9s5DaEzDlmkrt?=
 =?us-ascii?Q?LmvcLQkJHgaCorRK3HIekNyP8XMtqYpkUV/XyjYFaMA7mMoGpuVKBfaXy8Tg?=
 =?us-ascii?Q?XjgdRidBheUtAeIV2NcmNFzYaQajUu66okJEOQFvv/mTEaupRmmNhCANitl2?=
 =?us-ascii?Q?vqih4s3Sdo9r/IY+JEVR9w2lGF95OvSc4N93f7kgthyzWKN5CnydW100mTA0?=
 =?us-ascii?Q?ANatwIQt0KFlwcBmNpXX7OvOhLaaV07pfudIrnWK3+byisAJfvA5mNvXWsDf?=
 =?us-ascii?Q?1dP4pv/PYDXH+TdZa6/Lf/jJQMvOOrP96atwTQz7pTidfE8RtxTSuA5rd5/Z?=
 =?us-ascii?Q?KUk6MR3F55CVwXtb2LBp1NUWNQyD4r0iQIf1+vK9UvmOFurUaS/ykm6taOp1?=
 =?us-ascii?Q?Dq6LQ1p0CP8SH8HEw1P/vdNaXUdF3JTzGNeIzLMnGvjTk80UUdEE21JFWidk?=
 =?us-ascii?Q?vZ0p/rRoT4jZcyueKzONJD1Rcb7okjBf+W8P7PotOqCMAZXwxDzzv5eEBHxV?=
 =?us-ascii?Q?ddiMz2rEWfSZHMvqzKIEVQhvJdXyBZece/RwmsqXEs4ullxA8ymnl4X4Gv8/?=
 =?us-ascii?Q?3m+8dLwMo9XDSqTySA9CXXHFA0lpgDhONckAUfnyAUF4OVqi03PkvDB1kEhB?=
 =?us-ascii?Q?VY26JKfmYo+c6TX71cU6Zp4MF5unEBeDv3KYVmHTx/FriOxegBF3MnPFrkjI?=
 =?us-ascii?Q?cpiaRpK9FT69yt1Rf9XKMbhKvzNbLrnl4AOUGjnNr69DceRJCXwJ/vd8wQlF?=
 =?us-ascii?Q?J2rYSBYYrvGmFa2XL38mfFedIMs2My2MKtG45CO2LXgbwj63URunfxqQvjMf?=
 =?us-ascii?Q?5c3+GrnS1aDKQzLVi0LbKHOTRs4BzCZWwFU92HrRY41jmdsNqjqyOboWCmQF?=
 =?us-ascii?Q?DnEFNqf9pPqVoZ8vSbBquQpaGecjELTxVBFV4HGb5+JPyQ/vqTSFL9xe3Ozg?=
 =?us-ascii?Q?AbP/45TuFAPy7vhKWi4V3CaAcjGNxVVYnoc43dInDuj1DU0cEvEs3n6SrElx?=
 =?us-ascii?Q?zxxgc5bj6jXPDKSadJtbXzFNsmRazMSxnnQYTFgX7hrKzgESkIMNUJxCiLW8?=
 =?us-ascii?Q?SNGHvU8+gVOFRGyrX6Xf6kJULkOgqW651nvjCiZg9AJTknO/lU0DHKfh3ER/?=
 =?us-ascii?Q?5onNI3cYkYAcII4g4HG/ZQ6/Wp7aidsdvuqfDcHA+V1ePs49A+oIaOcQpYDd?=
 =?us-ascii?Q?N02EVoGkyjzUWex9EvYE0/2iKztk7Eqv9MjN/I030UxTeJNxk/a6iQ6IjNMD?=
 =?us-ascii?Q?2HE0klrm+IVVkLLlSxIQjzzXdZ7yvh0Vg3HaRLSUs6V4Jo+pKbNuddI4bn9a?=
 =?us-ascii?Q?d3H7d1p4lqT2zPOW4NWv1rPdfi7ewCnX1AIVU/lX3NRGCIlZrc7IuUiiUWgY?=
 =?us-ascii?Q?7TU7orMRnF0O9RMVlPFKjh8pzc9QqWS7I0nQYfSPlO801p3Y0fdRdHduu2WD?=
 =?us-ascii?Q?Djg9n6THdn/S7quBLloqlDQ9u/ujlXuYXsExiEhWvYxGJkMLFY7aOtuGRiHX?=
 =?us-ascii?Q?9Gvjo78ntQ5pt2kNP2Bw0A+rROJsWVbMR0syibb/wOlN8jwM4254S9H7ISLa?=
 =?us-ascii?Q?yA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F52C952EF57D240B69E429CD39440CA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cb0BTq9c5b7ddms8EZju1h+klaliDKCsPRqMsddxndG9F7jBH3VUXjKay4i9MmT/YZ7Euq27wC76vjIH3Wc1G87SU+Qhz/0bUoTcrks1uk690RIOmcxW5OrEbF94w6Ocg781gxzZCi90ST9LO2PV6QY5X7VxH9qASCIK6HxM8BX1b1CgT5RohFeRkUiCCvMxWmYPCk1O/tPRJWMEeLVCO3mRgoZXtxZyygWvQlpzwFWa9i4XDBMdEjpV33eDqACj3H9YG1B8Us+Kv+xRyZi5XqXsdmNSiOPyibRyGrt1AjiJ73hh3dr7lJ/X6zz5l/ih63RCtpCeiaU3Y8m7NO/GWsziYRaYCjd5EHdziGlYsHHbzlQJg+rX0BnOnhctcjXQ53cN5NbHlI90sGmrAEtJa6vvWe3dxs+fxl3XLpOgG/nyy2NF+azt0er+SKXnGM6xJthqv9OYcnaLm3T42VlMwEEJNVC1Yuk+8iYoxg9aP5rwx+LkNSVYYgBaJ59HpYyB/roQxkvsyijgNx3STVDRAZLwC1Ub7cR1T6b0qDHtt+/1ccsU9Gg9+CPgFCz0yeHD3PI9JrhMG9KQidWosK5hq5yFQ8a+v9ENRBQL/R7JBuODknoXT0B9rr7ENSr3iWCTu9jpGuX49N1R4adcQOYh/ZoWpz23yXostYLp3Hq49t4+VYa4CTEETG/xDJwG/Pr1VhFY8yPgqW9NXlxaJIpAvF3CK3ZUlz4Z+zmCfNtEPjcoSeSEpJzJeakHrm7U9ZZuenhglbBtC158bw4RJheoJhVuu94C8b0JL/HeHpFSRqO/1BB4YY0iDXkpHRv+6Xvs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102cb143-e2f0-476b-862d-08dbf0c7e9d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2023 10:42:41.4939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvipU79Gse3udoS46yDf6XmF8tArLrVpVEYBq1xAeSBKuUAS37BoD5qqEYvuDSWaq9c/D9sbNsTum0L3n4PuQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR04MB8794

On Tue, Nov 28, 2023 at 08:24:01AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218198
>=20
> --- Comment #2 from Dieter Mummenschanz (dmummenschanz@web.de) ---
> Thanks for the swift reply.
>=20
> I've applied your patch. Booted up my machine and waited until it transit=
ions
> into lower package states (pc8 at the lowest). After that I closed the la=
ptop
> LID and let the machine suspend to RAM (S3). After that I reopened the LI=
D and
> gave the machine 1-3 minutes time to transition to lower package states w=
hich
> it now does.
> I've attached the dmesg part including your patch when the machine enters
> suspend. One thing is odd though:
>=20
> [  109.424369] ata5.00: qc timeout after 5000 msecs (cmd 0xe0)
> [  109.424397] ata5.00: STANDBY IMMEDIATE failed (err_mask=3D0x4)
>=20
> this shouldn't be there, right?
>

Hello Dieter,


I took a look at your logs, but they are very stripped.

It would be nice if you could test with latest v6.7-rcX.

And then provide these messages at boot:

[   50.101909] ahci 0000:00:17.0: flags: 64bit ncq sntf pm led clo only pio=
 slum part ems deso sadm sds apst=20
[   50.375109] ata10: SATA max UDMA/133 abar m524288@0xa5700000 port 0xa570=
0480 irq 270 lpm-pol 4
[   50.783496] ata10.00: Features: Dev-Sleep NCQ-sndrcv NCQ-prio


Because, for devsleep to be enabled, you need support in:
1) The SATA device
2) The SATA controller
3) The SATA port (even if the controller supports devsleep,
                  not all SATA ports have to support it)



For devsleep to get enabled, you need "sadm sds" in the SATA controller pri=
nt,
and "Dev-Sleep" in the SATA device print.
Unfortunately, there does not seem to be a print for the port.

Additionally, your lpm-policy (lpm-pol) has to be either ATA_LPM_MIN_POWER =
or
ATA_LPM_MIN_POWER_WITH_PARTIAL (i.e. lpm-pol has to print either 4 or 5).


> Regarding automatic transitioning I'm not sure how this works. However ev=
en
> though I've set CONFIG_SATA_MOBILE_LPM_POLICY=3D3 in the kernel config, I=
 have to
> call an init script explicitly forcing the scsi host to use low power whe=
n
> idle:

Note that even if you have LPM_POLICY=3D3 (ATA_LPM_MED_POWER_WITH_DIPM) in =
your
Kconfig, ahci_update_initial_lpm_policy() will possibly override this by de=
fault
to either ATA_LPM_MIN_POWER_WITH_PARTIAL or ATA_LPM_MIN_POWER, see:
https://github.com/torvalds/linux/blob/master/drivers/ata/ahci.c#L1639

The best way is to show the:
[   50.375109] ata10: SATA max UDMA/133 abar m524288@0xa5700000 port 0xa570=
0480 irq 270 lpm-pol 4
print as this is printed after ahci_update_initial_lpm_policy().

The reason why many platforms do this override, is because:
"One of the requirement for modern x86 system to enter lowest power mode
(SLP_S0) is SATA IP block to be off. This is true even during when
platform is suspended to idle and not only in opportunistic (runtime)
suspend."

"SATA IP block doesn't get turned off till SATA is in DEVSLP mode. Here
user has to either use scsi-host sysfs or tools like powertop to set
the sata-host link_power_management_policy to min_power."

See:
https://github.com/torvalds/linux/commit/b1a9585cc396cac5a9e5a09b2721f3b856=
8e62d0


>=20
> for foo in /sys/class/scsi_host/host*/link_power_management_policy;
>   do echo med_power_with_dipm > $foo;
> done

I would really not recommend you doing this, because when you force set
lpm policy via sysfs, ahci_update_initial_lpm_policy() is not called,
so if your platform requires ATA_LPM_MIN_* to enter lower power states,
you forcing lpm-policy to ATA_LPM_MED_POWER_WITH_DIPM will ensure that
you never enter lower power states.


Looking at your logs, we see:
[ 2022.700556] ahci 0000:00:17.0: port does not support device sleep

Which comes from:
https://github.com/torvalds/linux/blob/master/drivers/ata/libahci.c#L2260

So it appears that your port does not support devsleep...

PxDEVSLP.DSP (in AHCI specification) is the bit that determines if devsleep
is supported for a specific port. This bit is initialized by BIOS.

So this could be a BIOS bug...
But you said that it works if you revert Damien's patch...



So the question is, is PxDEVSLP.DSP always 0?
(Even on the first boot, before you have done any suspend/resume).
If so, it could be a BIOS bug...

Perhaps you could test this patch:

And show us all the prints, and tell us which prints are before/after
the suspend/resume.

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2255,6 +2255,9 @@ static void ahci_set_aggressive_devslp(struct ata_por=
t *ap, bool sleep)
        int rc;
        unsigned int err_mask;
=20
+       dev_info(ap->host->dev, "setting devsleep to: %d port support %d\n"=
,
+                sleep, readl(port_mmio + PORT_DEVSLP));
+
        devslp =3D readl(port_mmio + PORT_DEVSLP);
        if (!(devslp & PORT_DEVSLP_DSP)) {
                dev_info(ap->host->dev, "port does not support device sleep=
\n");



You mentioned that it works when you revert Damien's patch.
It could be interesting to see these prints, before/after the
suspend/resume both with and without the revert.

I would expect us to be able to read PxDEVSLP even when the SATA device
is in suspend state... I could imagine that we could get a bogus value
back from the read if the from the SATA controller itself is in a suspend
state, but I don't see how Damien's patch that you bisected to:
https://github.com/torvalds/linux/commit/fd3a6837d8e18cb7be80dcca1283276290=
336a7a

changed any of that. It does touch ata_pci_shutdown_one(), which should
only get called on shutdown... not suspend/resume AFAICT.

So the fact that this patch changes things for you is weird in the first
place. Damien, is it possible that ata_pci_shutdown_one() is incorrectly
called during suspend/resume? Got any ideas?


Kind regards,
Niklas=
