Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19010030.outbound.protection.outlook.com [52.103.23.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04374207A32;
	Fri, 31 Jul 2026 03:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.23.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785467211; cv=fail; b=Un7TPwIenjVGLbVV5GW5BYN2tcKwIDRESc6trFeC0RmkrLmX1KeGm9jPOyuShl/btczlNzN06sDxSKg5GynttbeJP/A1BZPAcng5Wn81QPnIdCdEc5O8CanjLf/tda5ptLGoIZVWfpLTSs0p2lSoKe4eHB4buUHdMIMEvmgZTMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785467211; c=relaxed/simple;
	bh=MD4/XQ9NOINeQsLGpA7qXpBgv26eYNy7xH+tJrcmfzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K8ov065Tptxk/aLBeGimoVjELWTy/HyhBohejVBoRNyOb9UwntLCYSeTanGy0yIv6JPv9dVIuJ4rB5bAUtE6FthR21JOQPyDYCTyATwzuYAy15uz42p6wT05LwbM5Kv51KSm/FxZaJVAB48P/rBX7Eg2nJNAd7JJ0Hk3PjgI7qM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=g6O2kNW5; arc=fail smtp.client-ip=52.103.23.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="g6O2kNW5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kEAStBwV+8sc9sPWmjvgAO0mpkD8eqlLv1XutzcwB6+fD5KID32/w8LhFipeH163X6kBmxOite8zRyWj6fPv4LeHcVMGaRXDDDQ+7KSiKsXzBlAF3uwCh9ae3LrU1r5y29d+I9DlwvhpMGgk/esNEduodkEzQ/ehHp9sCbL/W74H4E6XJfPEGEm9y5XZofaauIbsin++uk46b1IVeYkk3CSK/VtrffsH305SlwBajP4u2exkMXDRZUczfox8lvKU+e+j4MfkYSWSDvnvInHvkOUmaq+87iAxj+Hn3lABQYTz/yxBh+ihkyMMQZfYRbkkW4OEvm3uxsoC9I3cDc194g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MD4/XQ9NOINeQsLGpA7qXpBgv26eYNy7xH+tJrcmfzo=;
 b=UoqgVWNr8Sw0qWtBWhcy/JnD6Wy4n/Tn5pBe7bzlE4uGVfn+FVBcTfFo1pw0zUCJwPjaq5MG52UU8gyseCvR+jyjBzHRoIwBpM0E5xa3ms4BMdtyN9CRZMOeLNhCs7EzZ4dizr72E/6yjDHR5rfXIDyEj82PF8Er0vYFaZvNF+b2N/gu5qz8AIOt9MhanIhTteAUn0ylTFMndSte+AOhhYe91ZwgYeqYS8mcAR0mITWcsjSGFz1WvPIqp7laoXd2Aq3hut8aHqweLQzmWVxI5o7bBgTyeOOMEsk/8U/mSNq98vdDI0Qr8CcFlBTgnC6lTg8/NekDB2jj0swZf55Y7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MD4/XQ9NOINeQsLGpA7qXpBgv26eYNy7xH+tJrcmfzo=;
 b=g6O2kNW5hFUfU3nFf3Ndw7c02VuzxZeNPWlyi9nKdfFEBE5TExsZOCFbDti6guqR5k2+J7yAAGyZXebTd0NTJtAJjm5SshqSS0gRnmMizbe+4Zep/NLsZ96JYV08yNf4lI+ny1tVmA8/hllKqXdzaLk+S+tFuUOnUr80Q3LQrL/ZNfFBqSzYVQ+C1gz4neL5No6g88XThbRLQhzCkIalcMUpTrVb5yQ0Viam/L7pRDVI+uZqHHp9vN/n5qBSezyOvx9RWtHeAxc9yMt2SoIzB6sw2cHOJFc1SuvgGJ6H3uaMkRmZMsJlnfrq0DQVJdFayj4UzmSt0KVlEP340kOufg==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by CYYPR02MB9685.namprd02.prod.outlook.com (2603:10b6:930:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 03:06:46 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::900:1ccf:2b1e:52b6%3]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 03:06:46 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: "kys@microsoft.com" <kys@microsoft.com>, "haiyangz@microsoft.com"
	<haiyangz@microsoft.com>, "wei.liu@kernel.org" <wei.liu@kernel.org>,
	"decui@microsoft.com" <decui@microsoft.com>, "longli@microsoft.com"
	<longli@microsoft.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "daniel.lezcano@kernel.org" <daniel.lezcano@kernel.org>,
	"ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "tzimmermann@suse.de"
	<tzimmermann@suse.de>, "airlied@gmail.com" <airlied@gmail.com>,
	"simona@ffwll.ch" <simona@ffwll.ch>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"James.Bottomley@hansenpartnership.com"
	<James.Bottomley@hansenpartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "sgarzare@redhat.com" <sgarzare@redhat.com>,
	"horms@kernel.org" <horms@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>
Subject: RE: [RESEND PATCH net-next 2/6] hv_sock: Remove check for old Hyper-V
 hosts
Thread-Topic: [RESEND PATCH net-next 2/6] hv_sock: Remove check for old
 Hyper-V hosts
Thread-Index: AQHykTBh5c+ZTCJ8JdYW7ttKg4YPnAIuoQHQtkoxtoCAAGoZwA==
Date: Fri, 31 Jul 2026 03:06:45 +0000
Message-ID:
 <SN6PR02MB4157870F1FB0D16332CDFF3ED4C82@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
 <20260730201123.1767-3-mhklinux@outlook.com>
 <04e5274c-b44c-4b59-998c-1af2f58883c1@lunn.ch>
In-Reply-To: <04e5274c-b44c-4b59-998c-1af2f58883c1@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|CYYPR02MB9685:EE_
x-ms-office365-filtering-correlation-id: 029a53bc-cc29-4ac0-aba0-08deeeb0c17d
x-microsoft-antispam:
 BCL:0;ARA:14566002|51005399006|12121999013|31061999003|13091999003|8060799015|19110799012|8062599012|37011999003|24021099003|55001999006|15080799012|25010399006|10035399007|40105399003|1602099012|2607281247196008|102099032|3412199025|440099028|4302099013;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?Nqg3HQohJbFI2lMmAZwhEi3e/AVkSNJrvF98wpizP8s8Sr6Umgt0PBW/IkVi?=
 =?us-ascii?Q?S+3RZkvjzviOd9EWynx6xTQcOT3wEQhrnhCmk4HylUFw9t2V/oBW6MeOsyNF?=
 =?us-ascii?Q?CvpCPXX7qdqj2keRvLGmVaOVGxFuW4SlESG6cpTDCffSpRgVYY4edCaRjIwp?=
 =?us-ascii?Q?8Ie99aSXdOjJLIZdRwCjghWvWtzyDC0IbQZP8nDK5vd2ZRzgsE8KLxuHKy92?=
 =?us-ascii?Q?j/tlcHyu69Do6JtgMnkpKmLy/AdoSqow7T4nxBnVm72miU2KjrqNeuTDI0l2?=
 =?us-ascii?Q?irBCZnQ5+yh83a9Ikd3FwawXR7AqSZUZiMBs8sdixvE5gc2i+7kZJCZqPtg7?=
 =?us-ascii?Q?MQl3YHMzbUj60RDxeMVEme2FMQRjWFE+IJNraAaJoxCzufDODW80MppWRbg4?=
 =?us-ascii?Q?pA49r2CiOxZWf0qS7tjQ79AcqD+Vn0Vq6gl7mj/5PsE8fBrUM4cB/ojqW0nt?=
 =?us-ascii?Q?MA/jndzyIRFuY/E3BRMeTD7MEz92m+jljpNLM32qF6L3jFXFyF5cu6w/cI+T?=
 =?us-ascii?Q?Xqo7RI/MeSEXQ5finMxFm4pS6N9PhcsyxAgjQr7uPLByDY6rObJc/7iLrzXs?=
 =?us-ascii?Q?d5V371jURoPfYDS+hq2zvHUDaMsP1N/E1pIWiyeLy/hj5TAFsicJQDiYrVRT?=
 =?us-ascii?Q?o5aQ8seN3136TfMDA6P8k6v7FrQ3Il7KGqjYKbxSGzM4BUJoqskNySBabhKs?=
 =?us-ascii?Q?F7dVq2fwIvy71smgjheM2zqdomiv6bkvkoxGciH9Pv3FoX8RVqINddMyg8ok?=
 =?us-ascii?Q?Tio6Z0QsHbM5RA8J+oQ/AKHsVqK8Roni1fV/8Q/dVi6VAAHjWpmPwNmc3KYw?=
 =?us-ascii?Q?WQ+KljLgnclUf89BNHWBLLQuIKEfqYt+oGnOIjS4mxAJZSQLawGPbrloN7KY?=
 =?us-ascii?Q?bTZcnYZbJAchiFWiSMAzWjZGePyw7gbvs1wS4RjF9sIMfVOyDbLNusM9GFCn?=
 =?us-ascii?Q?z7jyJw6f0JzHYTTOoNVjAtEkleDun1YdWziOWO6+tQ3Cs9n82TsJdZ5AuN2q?=
 =?us-ascii?Q?4aMg5nUR94sJcrKbVIh4iWe+rM3XpV2mAm5wdIVdhLsy8qJULA7t33olyoO5?=
 =?us-ascii?Q?XFnenhsQOHB8EiXEf4sNxxe0bzLtQCusrDEftYF1Hzr4pamJGMTzdXqbPCUK?=
 =?us-ascii?Q?MZ9V+d7xWQLQ8+GyCoYCoW0mI/+nfDxtKg=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?KhtSQNmyMZr1VJn7rzRdfv49m5dPcT0Nf7XWzcPXu7YxlelRE5C0i6ivvTKI?=
 =?us-ascii?Q?NtRyejhor6aj/bAatxsCHic4aTFqkM5wWhgTrb3clmui8RN3nSvUpHUKuUEe?=
 =?us-ascii?Q?Z6GT4tGFHnfFWqvjLlRVab0Sjawlp3+LITaxtZlfaeBp1ilt9erbF37bciN4?=
 =?us-ascii?Q?npkAHnYOGGU9mBDfQfwD2G1h3ZYwRqsUAGOK436Orodg3O6I5HYYcEZP+Nyr?=
 =?us-ascii?Q?SugnYNkOXMn1bck5LWzGXzVxSg6WcUc1IbX1TD1mFF1OQZM+YoT/Vv8dOWlS?=
 =?us-ascii?Q?473viDrSMr+XSEb46AkaVJTuMbsyM8HEINs6R6nQd6320P1eT6ATxzspDAkl?=
 =?us-ascii?Q?6But6pqswH+mcZxvcas2Vm0ile5kWyDAh3P9drpZc9BxF0WIAGacfMbRTTz2?=
 =?us-ascii?Q?mpHk/X+yZckcNt/NpO6jZGHhgnzR37KYuBTzS+9aNzpcFQgSU6JJvBH7Ko2z?=
 =?us-ascii?Q?rJa8V+zGp6VEr3x4sKItu8Cc//+usagqSRvN1bxRTZCQjnMGPq741ulUc7Lq?=
 =?us-ascii?Q?YVYsVBiZ1c5j+hJ0d9ZPhMSlfMlDcE94COXxnYPOejtdEeFWGeA/Bh7+o16d?=
 =?us-ascii?Q?LODqMuyFXEXRbiZ4/qxMu1YBEK7Yqlu08DZao1gFiPkw1MJ3HpD1SdBRcvWH?=
 =?us-ascii?Q?YwiQVyurxRct7Y20mXj9h3nbV7cvEiSNMcvKwBooJDRlOXn1THyHjIEpwzKB?=
 =?us-ascii?Q?0ORSTYOJeOyVJ0BkmNtua0SRY9251wanSBV3/dMKFkxYxJXeUKY7bdtce/z5?=
 =?us-ascii?Q?KA5nhEJgyIpg2EpvvymXXLPPCclb/w/sgo2Pd03NTSDhbJ/wu810bNkpoEaS?=
 =?us-ascii?Q?WbOA5E6+5z7LqCyWwil2ByIOPo/Lb3qgmB33gIh9qwU5z92I0W3SIgG5pgzf?=
 =?us-ascii?Q?+nK3aV+bQD0XKeYmt2J15BpfmtXp/3gJCsEozjSOiT+0g48LCPTy20fK+Hlf?=
 =?us-ascii?Q?ON/+CEwTNNcmo43LVa6PwWIizZfgFL/ZDisxzK953CD7zG8HYaR+yBrO5+Mt?=
 =?us-ascii?Q?CLC3RundMLKMVK9n6bo87z8bVFRbkS/NWx5ymtNjA+k0li6ZZhOg1Fzumqyc?=
 =?us-ascii?Q?wEq3e/udOSXnq3ueVYcEOnSfJ13r7Ex4t3xn4yB/M8dS7XMzUDMWZU5hk2fJ?=
 =?us-ascii?Q?QOAJNWmqrwdN4X0Duo0cmGuyWQXpogG8HVAbbYsjvlhfmNxEveRUaF71/759?=
 =?us-ascii?Q?dvCAEKdDYzUJFNFDW5Ear9tCq3FtYhPFn4xSvALI3NWyemAWgn39u7hxfm8O?=
 =?us-ascii?Q?vRJpK7Nf2Nw7GyOhgxsXI9/GpZZSeEQLx9ULhfANhV1ad3yb15R4UkarLt18?=
 =?us-ascii?Q?7XT9gH5N3gtWvx9FFQ0Fnm95yn6Wf9serUFsxmUXhrRzF+p2nbndpFHUWccg?=
 =?us-ascii?Q?ULB/BFU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 029a53bc-cc29-4ac0-aba0-08deeeb0c17d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2026 03:06:46.0351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9685

From: Andrew Lunn <andrew@lunn.ch> Sent: Thursday, July 30, 2026 1:47 PM
>=20
> On Thu, Jul 30, 2026 at 01:11:19PM -0700, Michael Kelley wrote:
> > With the overall removal of Linux support for running on Hyper-V
> > hosts earlier than WS2016 and Windows 10, the check for such versions
> > during hv_sock initialization is no longer necessary. Remove the
> > check.
>=20
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
>=20
> Please don't send new versions of a patchset within 24 hours. You need
> to give reviewers time to review your patches. And if there is
> discussion, please wait for it to reach a conclusion.
>=20

Acknowledged. This was a resend of the initial version because an
email server problem caused the full patch series to not be sent
out, and what was sent out didn't reach all the intended recipients.

Michael
