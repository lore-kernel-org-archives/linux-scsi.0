Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011026.outbound.protection.outlook.com [52.101.52.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907FE1D798E;
	Tue, 23 Sep 2025 19:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758656454; cv=fail; b=PR81Hdz4dlvo88d/Uri+Egu8TuxdId/Vi8LWdcWdngES8oa6iHvL+mey5+pbBg1CVJLj+DGzQN3M3uDo4PKBgczMmMdtmhiTPL2QcLiLoURIgzP8kq7uNlzP+AT8llkoyiCCtndjFD4KJuk0CoKGov8niIMsO+KkKDHyAUxw5mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758656454; c=relaxed/simple;
	bh=xPYGSZdMOJs19zsvr7Flz4VQyVi5ai5IWh9EaCAewQE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KJFWJ0Hc29M96vWbtnzouhRLCE3d5Lrpf49xepb+BzUP57DBFXHIgq1Tm/eYLUu6jnCJzRdLQmC7foZbVsxlcliPNJm0ksTaMwm5mohixCCaurLtjYnXz98IW9ap0vJbYhAddaY5y8dXe2VxW3zL/i5/wgxCeYDxaT9mULgq4XM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=WWjFHBGb; arc=fail smtp.client-ip=52.101.52.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="WWjFHBGb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uX+TFhCffOamRPlJUlqbrntVxW/vedSmoipWO9sQl8By5AEWREF1nyzUf4h18gxiYX0Wi9biG3kWw+AbtXmpfBrG8ILP+QawCdGJnIH6/JAMDNaeqPP9Jny3+tGFOewiy/T8GddqUwcyquA+KIBdx/qa5V90IuVRBBd/47FoOnkLChz92TGJxXZ9CEnN37E8ysoZJEYgPSD31PaQFYmi0oULMNOheKgI4u6Wcs+5ZqhRr+swTysYPqKNjw/bGDiDLETMRNJflakOI1du7+LBBZ6QDD3+VgvV+M/9rD3HxHnJt+Ni/zzsVtoxDTOODjgr1TlwAvvgcRgNHPbtp6BYIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPYGSZdMOJs19zsvr7Flz4VQyVi5ai5IWh9EaCAewQE=;
 b=nFmSbPOHS9sSzRLGgJlucBWfkXaAMQO/lvZcrgdWSmD/5NbIGsNl+ekl495jqbValn5EGSfKHGrbflN4kphbgDk5lagzvwkigIaqgLRxg5HjEVu57uBJ9c/EW9MKNKhd0PFhdqh4Bty3Z24feVAq5iUdT+ohl5zimgtKYT6tZ1NQ92PpjqdX4UgBTDonFgI82iSbw0yk+Pxee66MPbXgSU3TT46COOa2QKYsSoRgTnAkMiRTVlYt+YrNQMoHwvAxDjkosdBZxVL0ugKnuPcLHzpvWMoKux6pERGyMj01s+VWoOj7QeQ7nGhc9chfS79Hrx9+QiAOVu+/D76ltVsAwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPYGSZdMOJs19zsvr7Flz4VQyVi5ai5IWh9EaCAewQE=;
 b=WWjFHBGbnzMd3NhDxcRGIAAXpiMUdn3/cjJ5ChE1aggbwEz7l7vidLC45TClRKHzWg1y16cX5ahMoZNdbkyjKxwviVVmrTC+fdUBEUE5x0bCEM6TGyZ6sKVWdS00J5QL2pbnu3Y8yRQlnYzx1bsU+OdPDbHLbolwRBuq47icCAL/toO9tA55J9u2VBVaMCGoLJa6TSbW5AVH4BOumD6iO6pfjN6saCSlU3XsAJa9joUZMIqw//wC9tJO2GK6bl7dX2IBPJVBFwGjYk08fqymxXkHO69Yi72aBo2aqioLrXNI2A6O+OK8oDhcf8kY1+1qokLWjOBGXtxoWpwcxuVTqQ==
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com (2603:10b6:a03:53d::16)
 by DS7PR11MB6272.namprd11.prod.outlook.com (2603:10b6:8:94::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 19:40:48 +0000
Received: from SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628]) by SJ2PR11MB8369.namprd11.prod.outlook.com
 ([fe80::4db1:768a:9a46:3628%4]) with mapi id 15.20.9137.017; Tue, 23 Sep 2025
 19:40:48 +0000
From: <Don.Brace@microchip.com>
To: <thorsten.blum@linux.dev>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>
CC: <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] scsi: hpsa: Replace kmalloc + copy_from_user with
 memdup_user
Thread-Topic: [PATCH RESEND] scsi: hpsa: Replace kmalloc + copy_from_user with
 memdup_user
Thread-Index: AQHcLK2kRRp7eIrX60GIXHhyv7loWrShKh+J
Date: Tue, 23 Sep 2025 19:40:48 +0000
Message-ID:
 <SJ2PR11MB8369DC643759199AD1642C1FE11DA@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <20250923171505.1847356-1-thorsten.blum@linux.dev>
In-Reply-To: <20250923171505.1847356-1-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8369:EE_|DS7PR11MB6272:EE_
x-ms-office365-filtering-correlation-id: 4470574f-106c-47fe-b6d3-08ddfad91899
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?CVsebYOPB1kHRLebY1vA9JwhGjVB8ATDEq+9EUslBErjqb96zILqqx7kL+?=
 =?iso-8859-1?Q?l0yK51EuXc0WbFYeXIgG8N9OltpfKwGsDrV5pPjYrftpZyp9zoOuFVODmW?=
 =?iso-8859-1?Q?WB1kJjk++ifG+89OxO6PT48rGLXp6haECtuup37Xo6b0s6PVcX+GJTrqkg?=
 =?iso-8859-1?Q?unIKw4Bj0+HrOcxLG0VPkwfMsiGvYQwqVqfXoo/Ezyomlx8QRAo/3eblV1?=
 =?iso-8859-1?Q?38eX5e7CR5IzmcPy+IqexOBeBnuCRzCjmCTWP/j8aJTCf46MVrgMOSXg0M?=
 =?iso-8859-1?Q?fuffABQXtb1wHaMyloUVXZS59brKFsfZjvSQTNfo5Q9Irae/cKYwoujmiI?=
 =?iso-8859-1?Q?m+pA8CCyvbdRtWDz2xvL302l3oKHDRQkZmjDtiUlGn2m9l4JwQnJs72cox?=
 =?iso-8859-1?Q?9Bexrsn5hd2ZMvQ1oasMMXLg6y9t5nYGVclzx9bjPBLq+ixnaSXvbhoLgh?=
 =?iso-8859-1?Q?hJOvhsYNX9Sh7GDZ1Uh9nnemSkGIM5iTIzWIZ/Zp7C2AU/y8UG15ChXpHV?=
 =?iso-8859-1?Q?pn1aDPcBzwT5x0DFe5ZFcA6B+GzD0cUL6mtUq8NMr9XdSJHo8u+UcZCVpi?=
 =?iso-8859-1?Q?lzJ5Jf3/MAg/E/T0eJTM0bUhkdomW/3ucJhJRh6KWaRe5hDaIkMQFKupfB?=
 =?iso-8859-1?Q?rjIMJ+jg2/nJWLmtKxSxdj6RreVbndmS8waXa6duuqryNiu2yEw0sGqk8W?=
 =?iso-8859-1?Q?PoAmvjJfCB7pk7ewkZsVoB9hFDvW6L//9jfgzGiaBbSUGId0urnz3CleTO?=
 =?iso-8859-1?Q?BtXC8K7jWq80QAm4+p64JwgKFidkXVvCyEaH0uaNTCTYSgHIlr8oWp3qH/?=
 =?iso-8859-1?Q?cHbIzYu5djimQaXow8zuagmojX/BZnC1XqsH5JCrAdJ9Ze4t8b2O1vATBl?=
 =?iso-8859-1?Q?qS/TcKvJcD8orWr48NRVGj+ac6cuv1MyyuIm0d4kVjMNbCKgH/6PY6gSfZ?=
 =?iso-8859-1?Q?AdEPFX6IJnoo2WxRodUy+DvBUE89XVecc1zl8SHL1CPET86gmb7DVUfKjL?=
 =?iso-8859-1?Q?7mOVsEuP59z+E97/6OcLcPUWBC+3PVQL8v12NvMMKnCkt7bfyoD0UE1UQr?=
 =?iso-8859-1?Q?S7hQkQwrRq9xXE+z2hfhoJqYrU3Dce7KkFxAW/vHYqKKIdAifjY3K9TFnX?=
 =?iso-8859-1?Q?83Yq7hpy6WitBvYrmi10hPonChvysYcht2d7B0VzNMvevEZj3qryA8IZXh?=
 =?iso-8859-1?Q?r8IlF+hfHIxW6y3UuJQVRLtYK4mEhnq7kU834YkCoFTnmUCwDu3dyUQM3J?=
 =?iso-8859-1?Q?TskqPcZXCcvrXSuY44qM67LKmmVuBhRjeyamXn8eZibPsMHiE1wBuKHnSS?=
 =?iso-8859-1?Q?n1Hxdmj5W+mJAVNf53GK2WhTVtBh7ilehw7EP7k/WSadHPKDl35ttnwDd6?=
 =?iso-8859-1?Q?LznPXYilhkP8+mAfACDx6HvCiaOwe0p+Ad3xOPcr7a7IoKs/qsy3XzZ1ti?=
 =?iso-8859-1?Q?z/b5vmVK38KJHHfYbANJxUnn3Lqm4bhENDLYqzS9cAr4gJka2lHHG+CJ+3?=
 =?iso-8859-1?Q?zlTtUlzT0y5aeC9qt8rhOsdkq86UbWh9fYv7+5JYmBQQ=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8369.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Q5VPEMqXNXPg/IpJb+o4E0q1pELziO2kXi/hpKshXf8OiPQApqT8n+99he?=
 =?iso-8859-1?Q?rlcLwMdRlZ3CzexdYj6sBjQuudr32/3rh6rC1tsh80VZNMogI2wnZ3EaKW?=
 =?iso-8859-1?Q?wscrVhjTfWbsiLmblESQjYdFlQx37B1mF5H4lxeb7cQv1vD2Ik8ZQHm9cK?=
 =?iso-8859-1?Q?/mgilQgR3kwWZs96dQq+6DNWd77eCthUNNnecx2V/boz6tiB4RubXN/G2U?=
 =?iso-8859-1?Q?if2to5jm1IJVz8Cv4aTjtMFGkPok0zZ0KYTdwsbaljb9mduTLjl2BXRA8W?=
 =?iso-8859-1?Q?0gcxdm1xzLTM3dbHPkwE6bQTe3uHSRLMUSlHUmFF20SjtNcU6J/clK4Ktb?=
 =?iso-8859-1?Q?QNc0+23Ww143vSrDvoXTasKkOajInnVHwkr4Di1QQBDWSlG0dx2tgptmBR?=
 =?iso-8859-1?Q?a7cOY2Vgyra4sw5r4ZQG7wcTNawkH/v0t/yDsoLep5cGjdNa+Ad0pbXSns?=
 =?iso-8859-1?Q?+TsC7yD+YnhuN/yk+tGYaJZPKmnTM6++Bu7pXcfXeLnLASDDMAOFPb5TtR?=
 =?iso-8859-1?Q?0AswBHyl5feXBYihGnJmuZTjO8wlIeoVnUv/xwYMefyjNWAhkhfpmGJVuY?=
 =?iso-8859-1?Q?Q8S/12emDzElaqMqpXPV0m3as4J3EZxuy/Cefb5XGG1i3DiSETVRO0JzMA?=
 =?iso-8859-1?Q?9Ir2CQwzxnplI7m++6dd7jHAr9UVSgGQGlWuzgkKbTYbeYKNwEIzoF22CK?=
 =?iso-8859-1?Q?vTzTdcImnR1nmYY8qHhF3wS7BrCrtV0BXOT2B0+7vUU+0CFbzcRQnMoS5V?=
 =?iso-8859-1?Q?lvE7AX8aTDxMTXjaRNfmu8V6ZthdER3XRR38OX/VwjXY5Qe9/ymv1Id8DF?=
 =?iso-8859-1?Q?UAwrB+Wwf4oVDEgbjZ0NU/PZQP+fD7+YvE3bM5WDjQwwq7yjKbvXXa5g98?=
 =?iso-8859-1?Q?6fGrUBp8w8mXAK4NLN3f+Ic7xt+4G2SgRSfmuqWNnFOMIMzUXRKoL+X/Rc?=
 =?iso-8859-1?Q?dOMi0pFVef9zvTuybp7STXMCBpy2omabTvciOqEBXr9lurCDgEVDZVSlHj?=
 =?iso-8859-1?Q?BGBYf9l7PxzXTA1xF4DjhSDAzqNMLG9U8v5a4E8zpg5Zd/B7FJQ7Ss7paW?=
 =?iso-8859-1?Q?iqhvRYtTZQcMr5wU+z7iuZEg81LY/zKW2ma7PkIV1dzEdIYHNBlC/uvHSv?=
 =?iso-8859-1?Q?/ogSDNV7Nn3wfIdYDVZIsWyEmCsjsEZvVvbDIjGy6I6I+bdyWt433890eY?=
 =?iso-8859-1?Q?s3RihcMQR/Z0hRScjNDGugtlK+8cF8QyuAPGg7bIHAFAwLnCmwaRST9E+g?=
 =?iso-8859-1?Q?NV9B9qPK9r/QDyr8ytWpnUMerbjzSEiHa3wOiPhgmgjxn95bbdTaCKfJcK?=
 =?iso-8859-1?Q?txxrwS0WFTp6KG8ml12Ymi7j4618VMvOKPfoXRVAx5FJOxMIkKHhUjtbrR?=
 =?iso-8859-1?Q?s0jrdkU0YPGA5IND1M3wXhZryfdLaCDhUuH0yvIYAeZS9YneeIrqa4bCrd?=
 =?iso-8859-1?Q?BEHAaXwgeLmH4gwy+0mrjsohxqYJ7Sr7W7xxvTa/KstgtpQF0Ebzm+8Rqu?=
 =?iso-8859-1?Q?8GBLHtbjXOxpd5+FUCl4s0bJO4KfwYjvSQ8nr/vqrRNVOrVWgAwErcLISC?=
 =?iso-8859-1?Q?o/uYeCJ+k1NpB4F6awFWokRKmMlu+iQo4/qsxRg+S5UnkDOePivMYGjMZZ?=
 =?iso-8859-1?Q?hlMqHoUa5CnX3xUkxjKNhuCbwWeH7gx1nB?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4470574f-106c-47fe-b6d3-08ddfad91899
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 19:40:48.3476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nq1PaZuEKj9eGahh3Wphb0q1wJ4Hrq4d4ovC+erg/M7OzQQ2G6cYVQvtD6/9+f5yxSCf8FqnhqPu+AQXGeYljg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6272

=0A=
________________________________________=0A=
From:=A0Thorsten Blum <thorsten.blum@linux.dev>=0A=
Sent:=A0Tuesday, September 23, 2025 12:15 PM=0A=
To:=A0Don Brace - C33706 <Don.Brace@microchip.com>; James E.J. Bottomley <J=
ames.Bottomley@HansenPartnership.com>; Martin K. Petersen <martin.petersen@=
oracle.com>=0A=
Cc:=A0Thorsten Blum <thorsten.blum@linux.dev>; storagedev <storagedev@micro=
chip.com>; linux-scsi@vger.kernel.org <linux-scsi@vger.kernel.org>; linux-k=
ernel@vger.kernel.org <linux-kernel@vger.kernel.org>=0A=
Subject:=A0[PATCH RESEND] scsi: hpsa: Replace kmalloc + copy_from_user with=
 memdup_user=0A=
=A0=0A=
EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe=0A=
=0A=
Replace kmalloc() followed by copy_from_user() with memdup_user() to=0A=
improve and simplify hpsa_passthru_ioctl().=0A=
=0A=
Since memdup_user() already allocates memory, use kzalloc() in the else=0A=
branch instead of manually zeroing 'buff' using memset(0).=0A=
=0A=
Return early if an error occurs and remove the 'out_kfree' label.=0A=
=0A=
No functional changes intended.=0A=
=0A=
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>=0A=
---=0A=
=0A=
Acked-by: Don Brace <don.brace@microchip.com>=0A=
=0A=
Thanks for your patch.=0A=
=0A=
We do not normally make changes to this driver as it is in maintenance mode=
.=0A=
=0A=
