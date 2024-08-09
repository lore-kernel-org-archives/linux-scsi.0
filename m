Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2090.outbound.protection.outlook.com [40.107.220.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429151FA4;
	Fri,  9 Aug 2024 00:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723163152; cv=fail; b=IdveR0bJVQkcD5tdsz5ARAqah6oxnmAcOgsaBGPwpCRJMy9415tdKQoYkMrQU1/Q8zousFYD6NTbeGz9KOMMVyY2opGWAa0UFOXEAW4SgdvcDFyC4NyEZ7eYWoQQpXO+NLtvrFQ1K3PyfxlVEHCpe715Y9WkZLYYfYSE9kfjpY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723163152; c=relaxed/simple;
	bh=xduFEPvYCUhpUpvB7LZ766t4XvkNJILpSmdDvb+86aY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B9WMfhQE7X9HQD685fr0cTlFsGJoaCp/e5G20u23wbCCOHv4fnavMFoplLahXp6Hovpksjn/MY1Unc+EQB5julx5qCUrj+cnNR9PFegTrsvpPTp0Lep5+eYOEEBMf7K2LHiBJJF7CttWV7956cE69YkwUoxEbyh1Z1q3WzPR2qI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com; spf=pass smtp.mailfrom=perforce.com; dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b=S5ubz+q0; arc=fail smtp.client-ip=40.107.220.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=perforce.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perforce.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=perforce.com header.i=@perforce.com header.b="S5ubz+q0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VlXmagbMh5UUUYwa20s82JP8Vz2ws/xt3BN8fthXqdUb2qinzE4feiE6cV/SsH82UhB2JezYJUWbVPYKNKno0wdE2SAKkaeMB/bqzEBJBO85evtKdl4eqi5Rla5u4XISh0/Xk+igQ8BRF9FfI8ga0eiWSjCV5PiS+V372pblfTQk5/hNIgg1h8mNOyp64HX7JPd5/5HPEv+4IXFX5Da8zMisAK0Mz0RJEw1V47+kWutffFQ0TEF8RMk1Srzz8dx2BILPhUpHOEnqzNWwvCDrdFqgWWyYQWN0CNaykjo6ib4m2tApgstMqmvj+zSWkrJXQsO0fi8t6hkcVsgIQsLk6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bcV7m4rrrfj/YfsHOtez1CErySsVfmZ1axw/kiBj8Q=;
 b=bGLNz9Dt1xU6IxTYgNEsve7+pkJXygAYRHe/zktjD770SY+RAP7aOUNjuF9PFOyxwLQX2IHxLyCY14t4P2WwO6OVJYZN03hXk/g4Pyetg+/6KJWzFKVeYSUyXhTj3MQJVbsutfAnA67vQIagNbGYMMyfvG5XblVjMnW2u6kvH0Qb4CGK7g5uw2m9v78uwLj3mizob2HW5JDZoo4QQ1F6Lx/7lgAvqLr7RcAEm138tlJ4tNeRvtWZ+sjjrTOS+330EPI1VBlZjGSFYKY28mssx7hhIB1u+fDCC0rqdD6wmv72hxSRzblP8eu5NDQrhsJFwBYR6qM9Epbl+KsIheH+EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=perforce.com; dmarc=pass action=none header.from=perforce.com;
 dkim=pass header.d=perforce.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perforce.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bcV7m4rrrfj/YfsHOtez1CErySsVfmZ1axw/kiBj8Q=;
 b=S5ubz+q0ogmU4rnLV60yHF82ZNjqiXs7jpXNReHaSZ86xlCW1WH1AqqtgtoYgCIMa9qpng90owdyIri6Ft3jwvsukMBaaCEBkQwD562cfGwT8rxbzFDNVAPRRWKicfkWqofD/gkvaqvOV0EmyvNE00SJQi8pgE/3jB/YZmuhBRbX0ZaBK995t+4kbx6tasU8QrL68rvUbJ1Zy+RI+tXzhum7yADK7O8/tr2EF4veZN6oep6iXx/+lgj6iEz4vNlps+I/dZX/JBOP7WwmmJKLWFLfayTIMx0b0bTzIR5SHMGSqSkUnrLVwvAk6ySvPuTKZLqIEDiGmIE5Irxu4gLK6w==
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com (2603:10b6:a03:44f::11)
 by PH0PR20MB5890.namprd20.prod.outlook.com (2603:10b6:510:283::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Fri, 9 Aug
 2024 00:25:45 +0000
Received: from SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410]) by SJ0PR20MB5136.namprd20.prod.outlook.com
 ([fe80::f788:9323:b138:c410%4]) with mapi id 15.20.7828.023; Fri, 9 Aug 2024
 00:25:45 +0000
From: Paul Dagnelie <paul.dagnelie@perforce.com>
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "mlombard@redhat.com" <mlombard@redhat.com>, David Mendez
	<david.mendez@perforce.com>
Subject: Re: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Thread-Topic: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Thread-Index: AQHa6KRbbFI4qD4X8EGlMr55N6qqtbIcZtmQgAGnnDI=
Date: Fri, 9 Aug 2024 00:25:45 +0000
Message-ID:
 <SJ0PR20MB5136A763BB1792A1FDECABD780BA2@SJ0PR20MB5136.namprd20.prod.outlook.com>
References:
 <SJ0PR20MB5136CD6B38D86FD141070F7E80B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
 <SJ0PR20MB5136C6C85B1B82FF78ADECE680B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
In-Reply-To:
 <SJ0PR20MB5136C6C85B1B82FF78ADECE680B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=perforce.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR20MB5136:EE_|PH0PR20MB5890:EE_
x-ms-office365-filtering-correlation-id: f0061cf5-97dd-4096-42b4-08dcb809cf64
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?BxrdkLt5N61dDzQLnvoXNpt/kg/ya/cSci97U0IAC1WGg7BvFwnilwxLoZ?=
 =?iso-8859-1?Q?u5WgBito463I7zdKGV56ogfjpLzwcnYxepLwTCw8LEzBDHdIlqITdqlo3K?=
 =?iso-8859-1?Q?cZG5HyCGaXMTRpkJtOPajCojcJHkdes9ZoDApAMfFLFCVR5k++FKl4TpKV?=
 =?iso-8859-1?Q?BZ2SIGbSiLA38zhlUod3iK9ZHEO7mC33iIEuJoxMONWaS8df2x/CCxFVgO?=
 =?iso-8859-1?Q?ejnxzltcehYok4VqLJMt36rJLtCmpEVabrPuv3CeYcF+vGBGiWpuaa5Jo3?=
 =?iso-8859-1?Q?5VKo7m8oELIre90ij6KHoH4EQt80YOrMDjX7HgKSpPiQ5lhbgAIt7IzR74?=
 =?iso-8859-1?Q?+1nhCL0uLaqBiRgxQ2bgELuqVwaWtZslkCKfS32fXag/Q7OeVPzl6tWPpM?=
 =?iso-8859-1?Q?cHckIzfQ8Xbww3OHOF/0fgEowAFz8bzErRo0SXef5u4UV0An2D6I/lbZWN?=
 =?iso-8859-1?Q?RxH2pU0X32syBrDhwuGY187TQAK0b4Hz0Fi/+rM3WDjIF6ejLzCObc7tJu?=
 =?iso-8859-1?Q?LnLZxbmmuR89AanqfDB79/aUwCyhwu482GvbX9dkTrOv1SKN8rLqeSTiK4?=
 =?iso-8859-1?Q?lhflP1PnuX7ZMOhunUyFqz/Fee7webhUhg8G62X4+tVVRvbyhq9wNeKIAJ?=
 =?iso-8859-1?Q?zfgWxXg68Yl/ijsN0gkYxS5mLN/hB8gHDzPqVBuimT1C8mYreu06FCNtJ+?=
 =?iso-8859-1?Q?W1f3cH0QaFP3LDfx3bQd24es2hhvwpikaeqWprJXtOjUFSuOpJQDSAiuWJ?=
 =?iso-8859-1?Q?+C6+glw/cL+0dZ36pgWY8nOAEVj5CmtUSeTHqt2UnqJbxM+YEgtRXh3Yoo?=
 =?iso-8859-1?Q?UDLKRFrNYUdT00my9k8FuCwmXgRfl+vEIS02mAKnjBLG2NxsXQhveekn23?=
 =?iso-8859-1?Q?BXqmL9YYeIcvD5yOtqpkLSCJX0E5P0g8N+qqFG858JT8ZwKIXLjklQAMjc?=
 =?iso-8859-1?Q?MVc1TrijYVVypsnZvGLrRWiHU6SxiTp+0OxyV+0owdznmyGtPZJWg+X5Tp?=
 =?iso-8859-1?Q?1HLnC7A3pyuvrNfqjeWhU/Y/R+PjNEKgMbzsLcOM9XRM+G0ezz12QqLxg5?=
 =?iso-8859-1?Q?oe0qBLEDzdIRvZsWrM3EaRkuTStvoFWGhsqS6HnvIU9pbIHAirqFE72lZJ?=
 =?iso-8859-1?Q?X6LVDMft1PlqpRFksHL8LExXJ5uFU5auEsGKV+I+o4f1+e92dcEO6yyPxe?=
 =?iso-8859-1?Q?X6J9SVXsmhV1ttZxQDZDLFUL7UXXVkQ8sZwlZkWUebkuGeAbk9NmdiQrwp?=
 =?iso-8859-1?Q?/u3BTsW8Ek7gMy00G6LMTvLtesF9dycdHAFKhszKFbT6zVzQhryVQYTSbp?=
 =?iso-8859-1?Q?qgtQqf0V80T/QnO5m7G+sXccS5j0AlZPpwhm00Fl/RcxT8f/SxfiBnWZtG?=
 =?iso-8859-1?Q?MPyeF3XIytYjo+cD4zVLOMlcb9YwOZZkjRngFE7DKGpjg3SKS+388hMfI5?=
 =?iso-8859-1?Q?P0HiwY8PsyXo8CxI+LI5wd+ShEG0vvVjpCfz2w=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR20MB5136.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?lxWTpJ3g0UvP3E4LsZTblFSIAmMYti2sqP0QE/iMmpOxP2zZwCUTDO65oh?=
 =?iso-8859-1?Q?MqGbbwqWuZBpGX3eJnsF6bGEOm9/0Fk/OH9K52z7+/b7IN90M9EZ+VWJ8z?=
 =?iso-8859-1?Q?sijTNm+kRPl0+rWkPmbDK8/lT2rWHS6uQ4LciG9og6YcrO0MQypjw7Nimh?=
 =?iso-8859-1?Q?ffhgBwodbT7W+sdHZQxKIZxL2eaBIqfjlj63fkfPKdOGSPCxzJX8FV+DX1?=
 =?iso-8859-1?Q?o5iysyO6nHISUHYB14g3FY8IEp/kc/k4CfLBvPGjouFYkg02cIFtuVEUij?=
 =?iso-8859-1?Q?y7ayiA6pd1ccJ5JFMR943KLyRmXi4nde7kkS0FDMb5in6SjW3dZ/DE5dGL?=
 =?iso-8859-1?Q?C8BnsI/ttvI7XDlwohWx7oqcYU8XnLbxbjMpc8EMRBwGgDJxlsomuSiiJM?=
 =?iso-8859-1?Q?Lf8Bwp2qWJLtGA1rJTiug4uxA/7OByy8ZrawEG2L4ht1ZacKAHSzZqGK/o?=
 =?iso-8859-1?Q?zlEsbpv++RVx8QHvNU7jK7OGlHsv6131li55m8/Na8pBMUUJs9jtFbljqg?=
 =?iso-8859-1?Q?RpIkyJTH+zE+woYSR+QtQApWcECjAAHfUggGAWOTRqftMDeFOb+WATXBsI?=
 =?iso-8859-1?Q?6XE4rEjx94Uiw8ZgKQxVd7p56LNKaOM+rnJcGmMAUpCU/IDs1eZLA912Y4?=
 =?iso-8859-1?Q?Mh0pTna6HZqfXw4Nnfm1zS3NAW+zZhWdw+NUnKnZKqPnDZrW+vbCj+62np?=
 =?iso-8859-1?Q?2CqqA0CMdPKqj4t3a/dXEUBaVCtrhiNEpD2SJyK0d/5KsoLlbgaNiV89O9?=
 =?iso-8859-1?Q?AJCKVgCYt4fIgE1Fo8xfRb76MHGAzJVIyfoD4+NYFxj0VSBy0xnd60wd20?=
 =?iso-8859-1?Q?oz8NSu9teix9pcKF0KAiGls4bOeQmsCLPrepEhU+QrYDzMketjUhX+7nmx?=
 =?iso-8859-1?Q?UgbFx+Cf91zYqtgRaabRrznkPZN6COrpfnFMkd2CbZfKEzMGaobnD2renJ?=
 =?iso-8859-1?Q?BDVGW/VPlMZaQ39h8gdMqYBwLUGi0QU23iUtm5lJc+ef+gM4kX8i7BLZyF?=
 =?iso-8859-1?Q?IiSVD2/HAJk2R5FHi+PdC9CcJ/YFABRF34F7RWe8QgeXk6vDjQZ8+QR90A?=
 =?iso-8859-1?Q?kzMfl8VJvm7lO9fr/D4PpzaHtzpG0fLPv5KrwS3nhju1LDGoqfmZIfNgdo?=
 =?iso-8859-1?Q?XTrWGnGluOxNTTaUNp9LVDfOTXPSnMVW6AOTKucx/dNF6DpboF/5Cx5Irm?=
 =?iso-8859-1?Q?XkBkaGwEuJsx6K62gQh+a9jJQFvAXk3YH0ETOew+7kB5a4X7bmzOJcTR8o?=
 =?iso-8859-1?Q?TSPWwhs4jMx6dLCBP60pjvmDhhzeX/Wo42i+MJup5jdssu/x/nuI8yeU4K?=
 =?iso-8859-1?Q?KJBCF0Xd97NMQIuxwr9Vm8xFneYzmn2Zl/EwkTdIoHsb5Ojnbbbz77viX9?=
 =?iso-8859-1?Q?Sbn47h3xylyWoVpMSOZBkqs5TnqfHs+0bpeudx8pkfVJVDZ+Ap2CV6cp0O?=
 =?iso-8859-1?Q?kRnITKsO4slDN4Feq7QbJ7as6Tk5sdB78OPznvzv4vANRBPV6sNpMvYo6d?=
 =?iso-8859-1?Q?oB8EWpKGJiC6z16k5KCLdNmOaVVA3PvcmrrjdC1OEVQsOSx6GhBBesfPBi?=
 =?iso-8859-1?Q?lj7Xm0EI7Iz+L5VivoL/4vBeK4wWwXYbRNuOWvAMT6IYjHwTXMj9+PWABm?=
 =?iso-8859-1?Q?Ogtc9b3OUJ8WF8W9DsButHdqpovxpGYrBD?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: perforce.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR20MB5136.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0061cf5-97dd-4096-42b4-08dcb809cf64
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 00:25:45.3193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 95b666d1-9a75-49ab-95a3-8969fbcdc08c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WYYtHbZFGg/ohmEPaSb+bpcjFQMqBkSozbFiHZkle4pMeqrU6MHNA6jksrKR9x5QACGeK2NwHkindFsUMwj8evqYYTY91k/4ZJ7fJqwLpvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR20MB5890

Hey all,

I've done some more digging into this. I still would really appreciate any =
advice that folks have on how to root cause and fix this bug.

I have access to a core file from a system that was taken while the system =
was suffering from this issue. In that core dump, we can see that the threa=
d in __transport_wait_for_tasks is waiting for the LUN_RESET command to com=
plete. This lead me to realize that in the syslog output, the LUN_RESET mes=
sage that occured when the issue first happened is different from the other=
 LUN_RESET commands I see: We never get the "LUN_RESET: TMR for [iblock] Co=
mplete" message. That lead me to look for the thread that is blocked in pro=
cessing the LUN_RESET command. That thread's stack trace looks like this:

0xffff9416b0fa2080 UNINTERRUPTIBLE       4
                  __schedule+0x2bd
                  ...
                  target_put_cmd_and_wait+0x5a
                  core_tmr_drain_state_list
                  core_tmr_lun_reset+0x4e3
                  target_tmr_work+0xd1
                  ...

The command *that* thread is waiting for has a t_state of TRANSPORT_WRITE_P=
ENDING, and it's transport_state is CMD_T_ABORTED. However, it still has a =
cmd_kref value of 2, which is why the LUN_RESET command can't proceed. It l=
ooks like it's a write command (execute_cmd is sbc_execute_rw and data_dire=
ction is DMA_TO_DEVICE). I'm still investigating further to try to understa=
nd how this state of offairs could occur. Any insight or information anyone=
 could provide would be greatly appreciated.

________________________________________
From: Paul Dagnelie <paul.dagnelie@perforce.com>
Sent: Wednesday, August 7, 2024 4:17 PM
To: target-devel@vger.kernel.org <target-devel@vger.kernel.org>
Cc: mlombard@redhat.com <mlombard@redhat.com>; David Mendez <david.mendez@p=
erforce.com>
Subject: Re: Leak of tpg->np_login_sem, possibly due to connection interrup=
tions

I think I've come to the conclusion that I initially misdiagnosed the preci=
se issue here. It looks like what's actually happening is that the  iscsit_=
close_connection call is hanging indefinitely.

One thing that confused me about my findings is the flow where connection r=
einstatement was triggered. The "iSCSI security negotiation completed succe=
ssfully" line indicates that we're in iscsi_target_do_authentication, which=
 means we're in iscsi_target_handle_csg_zero. However, after the call to ha=
ndle_csg_zero, we should call into iscsi_target_do_tx_login_io, which alway=
s prints a line about "Sending Login Response". I don't see that in my logs=
. Thus, maybe what's actually happening here is that the `iscsit_cause_conn=
ection_reinstatement` blocks forever. That is supported because we have a (=
somewhat mangled) stack trace of a thread doing that, sitting around for th=
e last several hours:

0xffff909731e2c100 UNINTERRUPTIBLE       1
                  __schedule+0x2bd
                  __schedule+0x2bd
                  schedule+0x69
                  schedule_timeout+0x208
                  wait_for_completion+0x8e
                  wait_for_completion+0x8e
                  wait_for_completion+0x8e
                  wait_for_completion+0x8e
                  iscsit_cause_connection_reinstatement+0x9e
                  iscsit_stop_session+0x101
                  iscsi_check_for_session_reinstatement+0x1e8
                  iscsi_target_check_for_existing_instances+0x21
                  iscsi_target_do_login+0x344
                  iscsi_target_do_login+0x344
                  iscsi_target_do_login+0x344
                  iscsi_target_do_login_rx+0x24b
                  process_one_work+0x222
                  worker_thread+0x4d
                  kthread+0x127
                  ret_from_fork+0x1f

That stack trace indicates that we're sitting in the conn_wait_comp complet=
ion, which is triggered from iscsit_close_connection. That thread appears t=
o be sitting in iscsit_free_cmd+0x58, and has been again for some time (I r=
emoved some doubled lines this time, number of dupes indicated in brackets)=
:

0xffff9098459d2080 UNINTERRUPTIBLE       1
                  __schedule+0x2bd [2]
                  schedule+0x69
                  schedule_timeout+0x18f
                  wait_for_completion_timeout+0x87 [4]
                  __transport_wait_for_tasks+0xd3 [2]
                  transport_generic_free_cmd+0x11c [2]
                  iscsit_free_cmd+0x58
                  iscsit_close_connection+0x48e [2]
                  iscsit_take_action_for_connection_exit+0x86 [2]
                  iscsi_target_tx_thread+0x1a5
                  kthread+0x127
                  ret_from_fork+0x1f

Doing some reconstruction, it looks like in iscsit_close_connection we call=
ed iscsit_release_commands_from_conn, which calls iscsit_free_cmd, which ca=
lls transport_generic_free_cmd, which calls target_wait_free_cmd, __transpo=
rt_wait_for_tasks, and that's where we're hanging waiting for t_transport_s=
top_comp. We're now well outside of my area of knowledge of how the target =
code works, but hopefully that can give someone some ideas of what could be=
 causing this issue.

________________________________________
From: Paul Dagnelie
Sent: Wednesday, August 7, 2024 1:34 AM
To: target-devel@vger.kernel.org <target-devel@vger.kernel.org>
Cc: mlombard@redhat.com <mlombard@redhat.com>; David Mendez <david.mendez@p=
erforce.com>
Subject: Leak of tpg->np_login_sem, possibly due to connection interruption=
s

Hey all,

I'm investigating an issue that we've been seeing on and off for about a ye=
ar and a half now. We're running on Linux 5.15 with a couple custom patches=
, but none that I think would be relevant to this issue. A customer (usuall=
y with a somewhat flaky network) will report that they're getting constant =
"iSCSI Login timeout on Network Portal 0.0.0.0:3260" messages because the i=
SCSI Target login thread will wait on the np_login_sem  semaphore until it =
gets interrupted by the timer timeout.

We can see a thread blocked on the semaphore if we look at the stack traces=
 on the system:

0xffff8bdf62f2ac80 INTERRUPTIBLE         1
                  __schedule+0x2c1
                  schedule+0x33
                  schedule_timeout+0x205
                  __down_interruptible+0xbb
                  down_interruptible+0x4b
                  iscsit_access_np+0x5a
                  iscsi_target_locate_portal+0x429
                  __iscsi_target_login_thread+0x332
                  iscsi_target_login_thread+0x6f3
                  kthread+0x120
                  ret_from_fork+0x1f

And using bpftrace, we can see that all calls to iscsit_access_np with one =
tpg return -1 when the timeout hits.

I've also managed to run some bpftrace when the problem first starts happen=
ing. The problem first starts when we get a LUN_RESET (XXX here are redacte=
d, but all the lines have the same iqn in the original logs):

Aug  6 23:24:19 HOSTNAME kernel: [24805.722904] LUN_RESET: TMR caller
fabric: iSCSI initiator port iqn.1991-05.com.XXX:XXX.XXX.XXX
Aug  6 23:24:19 HOSTNAME kernel: [24805.722907] LUN_RESET: TMR starting for=
 [iblock], tas: 1
Aug  6 23:24:19 HOSTNAME kernel: [24805.722919] LUN_RESET: ITT[0x96786300] =
-  pr_res_key: 0x0000000000000000

Twenty seconds later, we then start doing the iscsi login flow. The bpftrac=
e that shows that an access_np call comes in for that tpg, but no correspon=
ding deaccess_np call ever comes in. This system also has pr_debug printing=
 enabled for various files, which allows us to see that iscsit_take_action_=
for_connection_exit was called, it looks like because connection reinstatem=
ent was triggered:

Aug  6 23:24:39 HOSTNAME kernel: [24825.690817] iSCSI security negotiation =
completed successfully.
Aug  6 23:24:39 HOSTNAME kernel: [24825.690826] Normal iSCSI Session SID 20=
 is still active for iqn.1991-05.com.XXX:XXX.XXX.XXX, performing session re=
instatement.
Aug  6 23:24:39 HOSTNAME kernel: [24825.690844] Moving to TARG_CONN_STATE_C=
LEANUP_WAIT.
Aug  6 23:24:39 HOSTNAME kernel: [24825.690847] Performing cleanup for fail=
ed iSCSI Connection ID: 1 from iqn.1991-05.com.XXX:XXX.XXX.XXX

As a result, it seems like there is a way for the np_login_sem hold to leak=
.  It seems like what's happening is that after the LUN_RESET, the session =
somehow wasn't closed. As a result, the login process decides to try to rei=
nstate the old session, which tries to reinstate the old connection. This k=
ills the tx and rx thread, and one of them invokes iscsit_take_action_for_c=
onnection_exit, cancelling the login attempt and killing the delayed worker=
 (who would usually be responsible for calling deaccess_np). As a result, t=
he semaphore is never released.

My current best idea for how to fix this (if it is the issue I think it is)=
 is to somehow detect in the connection exit code that we're holding the se=
maphore, and forcibly release it in that case. However, I'm not familiar en=
ough with this code path to know if that idea is feasible, or if it would b=
reak another valid flow through this code. I would welcome any alternative =
explanation for the symptoms and logging I've been seeing, as well as any o=
ther proposals on a way to fix this. We have a customer system that reliabl=
y hits this state within a couple hours after booting, which is causing the=
m a lot of grief.

Thanks,
Paul Dagnelie

This e-mail may contain information that is privileged or confidential. If =
you are not the intended recipient, please delete the e-mail and any attach=
ments and notify us immediately.

