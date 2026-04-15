Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022104.outbound.protection.outlook.com [52.101.96.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59A133F8CA;
	Wed, 15 Apr 2026 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776265008; cv=fail; b=kilkAQksMQ7lpSDP8xejFdMYVQ5CJNgDs+BgSypIu0afVmBFPLMLS629VbzC/RIfYRoHL6T9pgziNhvT2wFcaYoPZoosaE5kgxlgGWBx0NDsAEgDXbb5YpeVlAx5rL9iZKM4pCFr0rE9Xd47fV6GQTylDV/e74+geQqcE8j5roI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776265008; c=relaxed/simple;
	bh=2VKqWQvWWhmt6FUYUWUD+VAUxpYGB+XwBJUKF+8hg2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SQEBvkxxhz7nGuZ38KSF70Tacu/78XzKT3xFmdnzomNUinJ/ncPNPxvRzKYoS965f0W8DiDqgVUll55M6sK7FeiKOWct3DFsXZh48YBBBXY9XtypdyQAX0Lwl/WhrdUaY/RAcR8AXrRzPxZWU1dlN8pn8iRt/1A18oHndzhEP9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7C1CFe0EAPLAVnWXT5aoFAEHVRrDzlPshxJMUeyg2BfqbgDumPF5r61g7xxDm6nfwUfTIMJxjpJ+pk5VtY1JK3da4gVYC4tzdZGpH2ZujM3ATlmya5bDQFqfiwGDzBaTJF4Hq79jcDQ0ltVm69OX7w5gL0VQBrkJoF7tYiHp746Oi5aJ6WpQB8B9TgmIbJ3FgifrZS6dMBprTNG5pp7FVxCVS80z+EyjS+vhzgITmNJcC6Ut2NizAnLUm8N7jdh9sWqgkDdLucV9IaJdQKkE5vMsvRQP2oEx6UuybGquHLA9WzEDcGj+6jpo40nmUx/fsaTk5uoX8hNo2vuEhy/Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VKqWQvWWhmt6FUYUWUD+VAUxpYGB+XwBJUKF+8hg2c=;
 b=cOB/09uti0OEFhh6gV38VY6/xvBI6dSgCpCkMaM0Y8C4YEwXQDQceWJy42h1mZL/6EJHXX+GbPqnPymv9TYRkrQMB6Juf/x5/vQEtZZdErMc3Um9c0pooxHtpXPNuLJGP+k9er2Jg7ekaMapsOSGFhGmM7z0z9nL6GfAfszEhacwNmdASlH+qcvPcANseiInHgKmud408fYtyQzXvSoSM1C4SdCRZs278OhEpRpa5OrA2YDr8/2tx2tZ+kpQ/2TempMKAwx9RBf/HN+CJ6QWLpeQGaMtrFd4VFY805DgOdkR6OUzzq3a+ISITcFL+wO5i2PG+zzTOz8CqXOZcYkJVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB7266.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1f3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 14:56:42 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 14:56:42 +0000
Date: Wed, 15 Apr 2026 10:56:37 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk, kbusch@kernel.org, 
	hch@lst.de, sagi@grimberg.me, mst@redhat.com, aacraid@microsemi.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, liyihang9@h-partners.com, 
	kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, 
	shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, 
	jinpu.wang@cloud.ionos.com, tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	maz@kernel.org, ruanjinjie@huawei.com, bigeasy@linutronix.de, 
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, longman@redhat.com, 
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com, steve@abita.co, sean@ashe.io, 
	chjohnst@gmail.com, neelx@suse.com, mproche@gmail.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <fouvg7qn7g4yah7jsvzkdmweesbp4aqmhx37gf3ow5medzvuyk@5n3ddkijosr6>
References: <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
 <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
 <adpD8M8cNu3IZzEL@fedora>
 <6glgsbk2djsz4cqtbp2ht4274dw4rveq6fojlnpnuvx6zmpjxw@i43jo2l4qlz4>
 <ad0Hk48y5JEeMlFk@fedora>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lxgz63pggrsijbb3"
Content-Disposition: inline
In-Reply-To: <ad0Hk48y5JEeMlFk@fedora>
X-ClientProxiedBy: BN0PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:408:e4::26) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 1734c122-2b7c-4a32-2373-08de9aff3417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rxvbzDfc6Jv4uDI0rH+9Ag+9eXle1Mk8tzgNpLcLk5Yv9WSG9Fb5GPctfdbu+ayj+AZFZsIJ7q0Iq5W2vkhiIlfWCQJXg1p75jqVdIdorAmnZKH4goyjn0vRyxB1hkVo1OifqP0XCMVC9sFXc6STifej5x7j9KxWmglWoJl1/O0OghHbOJChPsjdkhHZqfDna2+TOkz/cqeDXWUPv0IRU5SwGR+V+igKIYEIx9D6k6LnsHRLMWDM7jbiMoIWZN1GjOODe0paiJphFPBlaPIiWByS3h4tyGXgvtgqkWQbqXGgc3NbYYXhF6wZrnMt6qYuiJUZ1iqD2eASP0Sf8z83Ejz3Jmrj/sgweUc6woujFHCLUv3O0+Tpt9HWzTbGNEzu2M7iqiDMFeh7uhi9ZR8AwjuEJ05e6fxPRTz0XA+YAeq2zhPCBn/NqftJ4Uic1fCW8v89k4rWxS4rs9jxWdwwTKiimOBzk8VYEesQSmicXdiRsDoLnBSMsk8Gt5deEmI36rFNbTTzmVuwAfzRXaDSnFdOZJDehcgUetmGQd6Egim1R33D7NJJmZdXDrH6wOAuv79zjCR3WNTHHUBJHUxEHkIc9Gf+es+gX7mFFHcvs+pDlv3Ak6BaONi+cjHOfKeF+fx5KuwcscJVK7AoSQooOBobRC//NLb04A2DAR8GhaX7e/j4IeTAjfc4kwxwHRzCv7TKXcUrolrqfv0poVJ+uQ+ex++qlgS/+gmKL53ZBbc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnpVT2htc1FJWngxSVNwWktvTEI1a2VGMzV1WExKK2pxdDd4ck1NOVFSRFdl?=
 =?utf-8?B?bURYMWgzVm8ya3VrUTBHYm1WMDdSZmlwN2wzdGFPRVFSdGlJbTdDbkhzRWZY?=
 =?utf-8?B?R0hHVTkvT0VDbU12N0I3UnFZSEVMZ0M5ZjdXQ1lrTlFhQ2VsSkVVeUNKczNm?=
 =?utf-8?B?SjdIeVVFdTd5ZmdFMmVZS0dkaUNEWUwzUFp0K0FldG9yVUhMTHhHQ1pUVHhp?=
 =?utf-8?B?OFZsczE2b0xxWm1tckFaalNKYnMwTUtxMGhtRDRtSmVDSU9zbHplTm9hTSt0?=
 =?utf-8?B?OU5pZG53M0syZW1WVFI3R3hEWXhWRHVjTERlS3liaHVXektSTXBnb0d0NTVS?=
 =?utf-8?B?a0c4eEdHNE9Qb1NHZEVnT0s4Y0VKa3lnMytMM0JXUUVuZFBybXVWaUtUQUpD?=
 =?utf-8?B?RUNobjhWc0MraFJhQ0tXOFhlS21ObWtFcFRLNDdKa1JQV1IyQzYvS1BDb3dz?=
 =?utf-8?B?VThOOTZxVy85SnR2OE1zNlRETFpDblRVNTBiVi9JbjZYWlVLWXFKSjZOZm1o?=
 =?utf-8?B?U2R3T3JPRm9yaFpqZ2ZNV0hZZWVic3JGMUtta1BjWXNtelpkS2RzSVJSRE9j?=
 =?utf-8?B?NlVkMkk2dUU5NlFqUCtnNWlvRjVaMFdiSnpCMGV6ZjZyVklQM0g3aUdpTHgx?=
 =?utf-8?B?a0hBa1FaZVp3Z21jZURuWUxQc0QxSjRFb255SlAzQkJMaVQyTG1mbzRBdzVD?=
 =?utf-8?B?V2lnd214YmRXdWJJSStKZ3BSYy9LMk9vSVJ3dlRtUXhMY0NPWnBtNTE1aEVm?=
 =?utf-8?B?TWg2Vng3TzlVcEZzd2hwNFZ5endoT1JGQkt5TVNvY0JQaHBIdGYyeVgxKzJu?=
 =?utf-8?B?d2NCKzFIeG5IcjMxbDhMbG5LSUI3NitaL1BhUlgxM2RvSU9CL1Z0T0ZXcXY1?=
 =?utf-8?B?cWVhelhITkRzMEdINVdzSGx0bzJtUW1SOXhUd0tsY2dTN3dQZXViKzZKdXRp?=
 =?utf-8?B?RFJZeDVzT3dWMmkzdlEzVWx0UFZBak9ZdmJ3M3lMejgwSlhOMHhEVUl6WlEz?=
 =?utf-8?B?TWRZNDVNNnhGdVlrVnVkUGRmdnBxcllKZHlMdlZrSnVKMzBLUmJlRFAyOHEv?=
 =?utf-8?B?N2dHalFLekFvWGRHZ3VaZEkyOEt6S082ck5tR1U1ZjBOWUwvcXBxeVBSamNT?=
 =?utf-8?B?RnZaSWUxTXNxcEk4S1A5N0ZDcXRhd29Za3R2bFdNRW0vUHk0S3BoQzhGdllv?=
 =?utf-8?B?Um9Tbm5Gd3NxL0RUZ3drTGI1b0dGN3hrSjZOMitrUXFwdjBXNDFRQWNyM1Zk?=
 =?utf-8?B?TzkzVGpKQmtNNk0rVEREMUlHWUhEaWJNekQyTlhrdnRsUDArcEpQaDU2b1No?=
 =?utf-8?B?S3V2M0E1QlowYkxyUlczZnlXelFDdCtaV2tyUEhEd2hzQTVzdVRDT00wQ3BT?=
 =?utf-8?B?VVF1ZjNpNHc1d2x0dlJtUndpZEtPMWYyNmV0SVR2ZVdSZFRXYzVrMXMyUHdQ?=
 =?utf-8?B?TDdBN2IyNWhpWjhGa3g1SjdZZW9RdW50dVRYVzViWE8zUlQrcDdVRVhmUnRV?=
 =?utf-8?B?L2tJR3BKYktmRHQxb09iVDhiTHBFRkJLcmlwZ0dTSHgvWTNpNkRvMDJFeS90?=
 =?utf-8?B?R2MzY2hwYVlSQ3J0aVNQMjFVK3VTbXh0cVYrRC9qSVEzaUJuOUIvbG1uK1hq?=
 =?utf-8?B?M1BIRGNhY2pTOEFIaWFYQWNHc2h1UFhyYUtpeFZZTEovamhMVVhhNFdsWG55?=
 =?utf-8?B?WmpuT291R2VZUnRLNFFYTW8zdFF0OEJtbDA1Q3JtMk1POHRIdWNkYmp2amph?=
 =?utf-8?B?OFNRanFzVHBRaWtjWkw2VU1BdGNDZ21xbjdDbTRBK0xnRFRxYnhTNndkSVlU?=
 =?utf-8?B?VTUzOGJObExkUXkyMVdQdnZ2Tm5XbnNzd1VKL0VseVF3eWRiSU9DMUwzQTBI?=
 =?utf-8?B?VXA1bjFDWCtsRlZOcUF0TFBReWlyZXNQNzlVcFpJVE13aGs1bmFWL2ZlYXZu?=
 =?utf-8?B?V1NTUmZQaGlkc1ZnU1RQeDUza3B6bXFlRGNXSDl6Vy9uSmtPSXpnUk93dVRa?=
 =?utf-8?B?WnJCKzI4UnRyL3k4T25raVhJUFlKQnhod3AzZjFFM09SWHlXUXF4V096Rll3?=
 =?utf-8?B?bnY4WDRNMEFINFJTY0Ztb000T2FPUkV4cTRMb0Ira2dHTitERjd4MHAwRzdB?=
 =?utf-8?B?aE0raGtqaXJlZGNzVWN4RXAzbDBnQ0hWa0ozVW4vTFFxMHIzcDV3dE1Ga3JX?=
 =?utf-8?B?TDM1L2hlL2tqMU1QMW5iL09SMDFiTENGMllVano1cjVKdUlRd3lnbGY3M204?=
 =?utf-8?B?OHBSdmgyOTBlZGFRaG1SQkRuTkNpbm1mUVNGejIvcTlVM2gyd3QrdytCQTMx?=
 =?utf-8?B?STVKVDJKNm53dk1XMmtEaFhQeGxiZFZXZmdVWkFzdVpZbXUwbFR5QT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1734c122-2b7c-4a32-2373-08de9aff3417
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 14:56:42.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhCDpzURx+NKYhCNQbiefXSQYvVFB1jObuZ4m24og85nI7lodWULmmXfyGtI6aib7h8nMpFFcm7ykn02zyL5aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB7266

--lxgz63pggrsijbb3
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Mon, Apr 13, 2026 at 11:11:15PM +0800, Ming Lei wrote:
> But typical applications aren't supposed to submit IOs from these
> isolated CPUs, so in reality, it isn't a big deal.

Hi Ming,

While that may be true for general-purpose workloads, it is a fundamentally
incorrect assumption for the highly specialised environments that actually
rely on strict CPU isolation, such as High-Frequency Trading (HFT).

The requirement in these strict environments is not that the isolated CPU
performs zero I/O. Rather, the requirement is that the isolated CPU must be
shielded from the unpredictable latency of the hardware completion
interrupt.


Kind regards,
--=20
Aaron Tomlin

--lxgz63pggrsijbb3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnfpyUACgkQ4t6WWBnM
d9a76w//fMUP2Pi3uS0/j3SqvM+2X30eLD7fkflg5rbrideGH9SRbw1b//cRxfS3
sYnhKdKHYSfGQyTFvBxiF5oOL6bjiYW2yqS9qntf7vgNwZjDjQ/h0Ga9Zm1uWC4d
AuFYCoWdfQKBB7HCpi9o21uT0j5bmx6cE2A6ezw2Rvviq7HJDy4kNhpYSfxuwmIp
6NRMJ+P2ro4UTXqIRGsb2lhN5w7j/Gs8ExQ/FWJEbDWRe2xqURtTyn0fbraQ688k
CngAHR+NfvHIRftYg98/F/Q7qhH9FIzeS5SqXUrus9KPn1iAsTUysp9nnVgOHg2c
kRMV+Z/BrKToJBAI2ExxFYGaO0JogPhRVt2n0oJAnEv+cAew9hNYgz7IuulM6Zmv
g7o0hPP2tOFAqAzXQW64RNf85bC8bs3EgsT3kKfd8c6t47cTvHQ1B4KU4xjsdbvd
B1c19nhIrvGqsaX1BwstiP76s77CA2agB3c1QnAqNJJZVNYiz7g3ebquHbrZp9XY
t1gJxtAukhusKy6MuXoE0ZkSJZ4HC6HZghSSlrSPscW2ofMIo8dUK4aFOagaewte
Wv7DI+ulyuLNfG1bgtq83EJ0Zr3gY6F06Ylr/H7++Pyepe0D6mzNJoA91roqF6by
cJdeIzlXYoEncjr8Js5qgNzz9l0zNwH994k/blJwgguqVpvgu0g=
=3owY
-----END PGP SIGNATURE-----

--lxgz63pggrsijbb3--
