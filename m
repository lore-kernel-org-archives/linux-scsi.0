Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022105.outbound.protection.outlook.com [52.101.101.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D59123643F;
	Fri, 10 Apr 2026 01:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775785514; cv=fail; b=sOMtgQ+B67O+IwobUB7cQcZ/cLcRaIzeKXkcjWhvsLlOMiUi6iJKtaDyfth3umhpJ6DJMpCw7ktxTv1xcKxa11D9bWo4bgS4nHDjsKvmAVcgHGTMBH+wpxX8+1FaSLDlNKs/YZxWBHbsWepKLIlrdiBaBlboVt+NAry7wVnTZi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775785514; c=relaxed/simple;
	bh=F/Gdx4BXIvks7MOJdabhYqJ/vjcq9DO4ueVoE+jTfIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A76O83thz8BXtnf1/Nvb1BvqiLAXH2Nmuhf1ffxL1P7tnn/or/3YVbNGVKCUa9mVZbnlvEYgVu6/FVad153agcjM6653VnJQthoziigKRzCRH3i1WwJt4VdFlJaxjw+GugFFWho0GL5BIXKUbgKp5eCWe6zHzGzCk40pSv072s8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UYe9l2Bm48Eb+YkhlzgB5AOPn4sZMEgP18ug18wrodosxqAregtLH7MxSVAtKDdRRJQ5uR8hKrBO9eF3U6XITxrq26QVQmnEW0Ak8ewIReyQyw5mp3F8LyOfpcZQLX6MJUYhBO4N4TqXCahBgr0y3zIDkgJ3bTIoY0LJiHb7miXnR0bgFTIpx+lNmotnVttm12ns+VivqA12bPMnK4yK16+q//PaPdebfw8P8DEApVwhlqWZhF7Uo7y4ltbBKFM+naLDIrXP2gC+k9T0xO24p+91gDF3AJTgHfEEXgw21r4kqcgPLYcDIOZrzlUl5xjNDgM6Vte/fvpH5he7sgEAug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFMNKhMdRGHeqKO5vXnAM8NLbjLbIYXeXyu4djBfaQw=;
 b=km3L/I+KziTcbJahEQ/yreqFYajL/U0vEjezbWrVf8J8wAk2mpjZqXwgKSRq0uq3KJ/0x+8RV27XaSWHTQG/i/8kUUhmhiZZuVDnmQ03nUCdl4GgNPss6zouwKr5vMFZedvgvx5Lfh/y0BLuF0vab/RTh58Mh9K0auSA8X2ri0tA9AbGJntG+n5lFqS2fGEezmFm6CcKGdFxuhzUb0vC5ur8g0AZuLDJ26UowsxddRorSn5DixDYDtrOYLR5NW/I1VqEvTwehWan7kMhDAn3X3Z4WehVLcsQJ+2c59uIS4+8h8AnSW8FsgI6nD6YtMpF7ykQqE54vMYRKkI/MT3nMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO7P123MB8196.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:44c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Fri, 10 Apr
 2026 01:45:09 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Fri, 10 Apr 2026
 01:45:09 +0000
Date: Thu, 9 Apr 2026 21:45:04 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com, aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	bigeasy@linutronix.de, yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, 
	longman@redhat.com, chenridong@huawei.com, hare@suse.de, kch@nvidia.com, 
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com, "Lei, Ming" <tom.leiming@gmail.com>
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
Message-ID: <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora>
 <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eqiicvxqwilyoveh"
Content-Disposition: inline
In-Reply-To: <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:408:f4::23) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO7P123MB8196:EE_
X-MS-Office365-Filtering-Correlation-Id: cf731fe7-fd99-45bc-6248-08de96a2cbe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|22082099003|56012099003|27256017;
X-Microsoft-Antispam-Message-Info:
	UA3HiWTYzewFpOIVSlaaooAymhoIkYoDr1OEnPwSXLYdwM3wd5cARuGFtfh/WFoGsD2rvu6t6dYqkFwQdK7kQBVlcyhDAYj96XXj3SRHfPDoU1bj/ehmaBrC7b8iUCm/Pd3IleINWOysMG1Bv2ytQfhs8kst+3ygmrJtLYaEQ1cD/Z5uYwftORpt03hA6p7HQ+o/0NtfVrt8FNZ7sIeCmlNJfThXyvsX6Mxnf3C2aZTA6TNex0NAj+hGlOdunoexD+tB/HQH83I1zQBcl3LK/ALU3RK30vnQxsqXNlHPSnJ6J6l/hyk6FOkqxoXvQxceOnMvINcg2O57ITijP7Fjt/RGrrMoq0f424uprO9uxdVnz3FehdmyQg3qd63c46mWarwQDirjpOkq7zztaLqm03HyxqDoxuYIMKX8SFnErC+PGIvr7ZP3xjupANWvhN3nVfZms4cY4PIgO3anj6ttyHyZFzoL/LpTQLMin8T/zGdWjBnFsJCiJVdIW3EClju9AEoqwAy2mDUZYEksgtLa+5OTSkAxVB4pAC1gm3cXNv4KoOWDnliH7uCRjNYa+tFvjA7SUcmd7QIfs8lkOhDcDUkGtZYBaKWak0FcH37rAGZiexsLnzfODyhjzpWF6EgI4iyFyEgwAC37nMPV2jOOCVT/Xt1HuLBSHRgJ8rzSnmUtjqrSN434DSw01xbMWOqvD5uH6FWyjWU+JXxo3r1IHM55n9D65iCnGiJpTIHt20P13ZLXUvYIYe+wMjP6Q4NjPQH2wgcY+ZQPekHnK9naLgwHJuxdzuCa6RyNBnAf/FI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(56012099003)(27256017);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1BqcVI0aDN1ZUhCOUlsbkc0SXFtMFVwcWpLMzk0emgyeHA3WjJUd0RNVGVU?=
 =?utf-8?B?R2V1enIydSs1aWsyYnhjR1RGQjQyNHpEM0VDQWQ3OUxGOWswRVlKWU9DSy93?=
 =?utf-8?B?MTRWblRTVTgvQkU5K21kWXhGRVN5blRoaXRtN2VtK2pKK3FzeDJQNFZLekhQ?=
 =?utf-8?B?UTV1Q3RUYkdlTEJpYmNnZUZlMnExU0cxN2hnUDRFblA2Y3FwS2ozUUcrZXJL?=
 =?utf-8?B?d0Q1NEQ3M0VKbDNjdURrcC9GcVIxd2VYQ2xFQ3QwdlQ3UndHUmFXVGpNTUUy?=
 =?utf-8?B?RFlwQmgrazBFbTJTZ2xHNDNrL0JaWURadnNlV3pvc2RHSkZSNUsrWFBINWhG?=
 =?utf-8?B?SjFuOGdyTDU1bEM1M0lMRU5rMW94a3Z6QjFhT0I0YXNvQzUxQ3psUzBzOFFw?=
 =?utf-8?B?RXd4WGdLeTNhdlVmakMzVHdscnV1Mm5MMW1DeTVlNUZzeWoyR3ljaTZjejFF?=
 =?utf-8?B?LzJyeUZqU2twakJMdFJCVHorekhHdmJBRjhlaXpnVFRCZmFTZHgyUC9aZzdZ?=
 =?utf-8?B?eUdBRnJLNVBGOFJmM3NyTHQrTXdyZEtOS2tKSXc5R3V2YlRtVFZRMmdpby9F?=
 =?utf-8?B?Yy94MTM2d01YUWhJemhOYU5leEUyL25lYkVjM1FaQ1hFOWVXU1R2NHNEQW1N?=
 =?utf-8?B?UWdSeEw1VnpXK25nMVdaUC9WWFltZmplVnh5cy9HbnNTbFdYNkJRUkxsUjdn?=
 =?utf-8?B?SG9jc09ScHVTQUVHZ1JuNVg0WWZiSHZxZnFJZlQ3VTJYS1lTWitKS3VuQWVD?=
 =?utf-8?B?Q0Y2emF6YUFFUVAxL01DY0VHUHdmWWRRUmlidGhtUDdlQlBsVitkb3A3RXF3?=
 =?utf-8?B?QnVKcmp3bjlkaDFkSXEveWtqSzg4SUVvejZUbFk1MHd6eTRSNys1MWpmbk9I?=
 =?utf-8?B?dENIRENzMFhFcEZ0aERROWc3US83L044Z0JQcjJ5aDlMTmlVaHkvSHJIUnhp?=
 =?utf-8?B?enMwa041YXhoVmozNTRxSm9JMjlwajZpQlA4YlB4UUU3ZStMNDNWeXYxQi9K?=
 =?utf-8?B?TVpOSURVT1lyS0kwZzcwWWk3ZWRzMEI0a2dvVWxML3VEblVqLzJMeE1YKyta?=
 =?utf-8?B?bmQ3ZlAyRnVQUEljVW93NUtxaEQ2Wng3clRQYXZuQ0lWR3hydjJ5R0ZJNjN4?=
 =?utf-8?B?NWt0Wlcwc0FGYXVNb09jZTVaZVJOMXo2RFlUNE1tWTRvbFliUStKTGw4dzJS?=
 =?utf-8?B?RzZJams4aEdRVWN3clFDMGZqRGJValArQkx6QTZpN3JLbHduVmZPZjlEUVF4?=
 =?utf-8?B?Yyt4Z3ZKaDBwS01PRjd1R0FBTDRHZ2ZjMEQwUzZ2akt6ck1sUjVUUDBoWi9J?=
 =?utf-8?B?RU9aMzBJdXFDTjBhc2FsSzlsSjdZcTNQanorVTF6S29Wa25Vc0k1U3FPVUdj?=
 =?utf-8?B?VEQxWjJscGVvK2pzalIzS2JrSFFPS3N0a0psL0JBWFFBYVpjVnM3RVV0ckpk?=
 =?utf-8?B?OUNuS1N4c09kU0MrOWU2a29tQjhqTUs2dlVWMm5wVWJWQ3FjajFqbXRuOGNY?=
 =?utf-8?B?TzlRU1NnMVRVRHNkaThlNzBxTy9iOWwzbzBsMHY1b3RLTmR5ZzhNY0ZJTVkz?=
 =?utf-8?B?Z29lVVR4c2ZqQ1BYTDhPYnlCcEhERlVJWnlwQU4yWk9jcnhtRk9yaHhmQTlQ?=
 =?utf-8?B?UWlhNk1ZSnRMRHBUTm81NXVQaDFNZW9lbWZyeVo1V0NISGpXZklTZ2h1OVkw?=
 =?utf-8?B?cjFyRk4rZjdDQVZmS2Q1RmdpY3RERllsdmR0b2xvZG9NZFJ1Qm4zVWI3a0tS?=
 =?utf-8?B?UHA0U2JUaWhLSUdWU2h0ZTdseWY4NFN6SWE1MDUxMlRnRmlLai84Z3pMRUJ6?=
 =?utf-8?B?VTVKRGpHRW00M0pqakRzcC9tYVBKQS8vL2xqUTlQZDlDaWdrNGY0VW81bmwz?=
 =?utf-8?B?TUVkdmlsejEzZHBmbkF2Z2hnY1g0U3BmVUJrMUtJUzBNckRnODNYVGhWVDVP?=
 =?utf-8?B?aGxVSkV4SlZEVXNsdWtYc0VRUk1WajgwUmNiUjZTRnFPM2Nnbno5Z0NQTDBV?=
 =?utf-8?B?VnpKSytGK2tpUHNYdGNmV25VNEsvV25vdEo4QTJwUW14SVBWZW9sd0JzN005?=
 =?utf-8?B?Nk9QMTBmSnhRbWkrVmV6NlBwU0VVV3M1cEJrclhsbHI4NkhMWUNxdFJFZDNG?=
 =?utf-8?B?NktyT2haNlhFUllxU1E4a2FtN0JqSkdtbW9mT1YyeU9vUGVJVWM5dHE4ank1?=
 =?utf-8?B?YXdyaXp6K1V2RGVRTmNISUFwazcvd3hxUmlLOU9PWE1rekQvNGJUQTNuTm5Z?=
 =?utf-8?B?dEtrZDVEWDRmWTdkWkthWGsxY0NQRmNya25VemRxc2VicndveHZMLzJ5Qmpw?=
 =?utf-8?B?OENMTTBOd2FiVnhEREhqWlhlNEc2SUtQQ01kNXF6ZkZxL2VQZ1AyZz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf731fe7-fd99-45bc-6248-08de96a2cbe1
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 01:45:08.8779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1R4FXNrUX/wgtwTIHSLj+hdgTsGYpceaaLrrd2YbdTA8k1dblAWxGx0kUTvs7WubgQdBqv+M8UmUw3QYrFVp9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO7P123MB8196

--eqiicvxqwilyoveh
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Thu, Apr 09, 2026 at 11:00:09PM +0800, Ming Lei wrote:
> How can the isolated core be scheduled for running polling task?
>=20
> Who triggered it?
>=20
> > loop waiting for the hardware completion. This would completely monopol=
ise
> > the core and destroy any real time isolation guarantees without the user
> > space application ever having requested it.
>=20
> No.
>=20
> IOPOLL queue doesn't have interrupt, and the ->poll() is only run from
> the submission context.  So if you don't submitted polled IO on isolated
> CPU cores, everything is just fine.  This is simpler than irq IO actually.

Yes, you are entirely correct. The ->iopoll() is indeed executed strictly
within the submission context. In the example below, the file operations
iopoll callback is iocb_bio_iopoll():

      // file->f_op->iopoll(&rw->kiocb, iob, poll_flags)
      iocb_bio_iopoll(&rw->kiocb, iob, poll_flags)
      {
        struct bio *bio

        bio =3D READ_ONCE(kiocb->private)
        if (bio)
          bio_poll(bio, iob, flags)
            if (queue_is_mq(q))
              blk_mq_poll(q, cookie, iob, flags)
              {
                if (!blk_mq_can_poll(q))
                  return 0

                blk_hctx_poll(q, q->queue_hw_ctx[cookie], iob, flags)
                {
                    int ret

                    do {
                        ret =3D q->mq_ops->poll(hctx, iob)
                        if (ret > 0)
                            return ret
                        if (task_sigpending(current))
                            return 1
                        if (ret < 0 || (flags & BLK_POLL_ONESHOT))
                            break
                        cpu_relax()
                    } while (!need_resched())

                    return 0
                }
              }

If an application on an isolated CPU does not explicitly submit a polled
I/O request, it will not poll. Thank you for correcting me on this.

> Can you share one example in which managed irq can't address?

Without io_queue, the block layer maps isolated CPUs to these queues, and
the device will fire unmanaged interrupts that can freely land on isolated
CPUs, thereby breaking isolation. By applying the constraint via io_queue
at the block layer, we restrict the hardware queue count and map the
isolated CPUs to the housekeeping queues, ensuring isolation is maintained
regardless of whether the driver uses managed interrupts.

Does the above help?

> > >
> > > IMO, only two differences from this viewpoint:
> > >
> > > 1) `io_queue` may reduce nr_hw_queues
> > >
> > > 2) when application submits IO from isolated CPUs, `io_queue` can com=
plete
> > > IO from housekeeping CPUs.
> >
> > Acknowledged.
>=20
> Are there other major differences besides the two mentioned above?

I believe the above is sufficient. Please let me know your thoughts.


Kind regards,
--=20
Aaron Tomlin

--eqiicvxqwilyoveh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnYVhkACgkQ4t6WWBnM
d9ZSbA/8CZNdD84tEd3KyK9aESSg/qlPagoo/aiIOy4PxSX0614Eoa5iFzfvGl42
jKSNIOzxsOcAlN0ZTFCuZtgJQygbpfWRmpwL/nohztWj0zKNg5Zri87NsigOgcIL
BlQK+7IZ7zFhw6iTDHZeFI4cBYy+kCFZftCNf5pUV4Zi1tWoskepYpgSvZAf/x/J
stOOELM+SKXWOiDKf08sRgs4WMTBLhuhj+zONk0H6jgXA877pZh5ZMuwEXf7Y62L
MHPdiIMxm+TK5gVoCTeEzFrQ2dAimTHtHW14I7B2Jxr+HBxQiPeCWtR4iQUb5EIE
0JYUAP23ol6GstoZiIh5HSvGQgVx19/jg5Z9kAq9jhEtqQhptXt4DiR2R2F3oNjP
FjSxpOIK2O+UEC9kfmUbV5ABP9TnOMYGTeQrHpIVuuCxoifzTD4Vl7TP93wJhVdX
ZP2o69x/fK0kmD4fAHRQ0cmC1fh6kAPjW3VAcDXQDxvsU2/A3Cic9AoQXoIwOFli
qsTptHR4ZFDcWpXHx6vwRK4MArK7DoffoVxQQPgFmmOTzRlANIE8NWv1C3xgO716
Up4bZvQmJ7nmQ/UJwErp68JHqU+Ce2YuxbDqBLbgz2s1b4gcCKmF6rDl843nJ0UQ
Yw3coz6GX/Ok2omD4UXF4MogU7A6A83BPYJzfgWdtec1QHx2vvc=
=BM0O
-----END PGP SIGNATURE-----

--eqiicvxqwilyoveh--
