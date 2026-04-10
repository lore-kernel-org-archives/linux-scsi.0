Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022131.outbound.protection.outlook.com [52.101.101.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A4C150997;
	Fri, 10 Apr 2026 19:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775849492; cv=fail; b=u+cGcHdpGXO409R6LrAlIPxQPAyDcDALnSxClS30pqoeYcEFEGEvMUUW/nk+Zdt+398TE1iumF9v1vyV4jGLi5PtVy/U1aG4EtlutiVniM1+Mqb22C0rbKqe64oICrBDszY7/U0vA/vA40cmlgbfgKtdn9B/1lxIxIcs47ru3eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775849492; c=relaxed/simple;
	bh=RLZKFCIvr4s1+jw/MgsE//Vu/OnQiYDcouRKppeadGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FfF6FQiJAeQRwDuHC3IZ79Xr5QbLopIO1Ef4jhJB2kLi2qEnUomjr15iYr+g6iTXyQrPzXRhEyD19N8nAQBCkdC7DoOuiD7e7eU3MjyJkISJSsof3ApcSd6JCsOWeUuRwPzkV53JaBSGcgl9SVO23Y0Kvt8dDDRO6S1uxpoHwvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.101.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rnPRBDIzAD7EoawlNuuYGsHyrueG+Nr8o5+8l2okajNiBYwMvuh+8sarLCUJaE6jT24BCPwuuahldEGL7tSAPZIq41jIjUfuH45bj2OgiLcSBtk5G40+WPkI1vQtyXj5SrLisGu4aI00N0SW+vB6Yh81TNZQ0s+JrBa5d0v3RH4yWCeQre4e3lxXXI96vnL/kPEBK9ebRoprlGod4jFgUqQOIyj2CID+ulSm3L0IZDTvhhKBx/YxcEeyrTz37kkgNXyhAMupkuH/ZaQ2KBA8uJHSm4om5Z9pI/CB//DY0vipnSYFQB8kYyo/604WHWhmIZazTBRfS8kglEWUL+pu6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aN+iqz1D+rKY6m+3GMhmbywHrbXvzNdNU15YhKcPeBY=;
 b=j0JwUzgpOqg/JIPGvNslpovFc4jANyJQslY3sfCK6Suz9Av4MD2erS0ySCM6RtEBFgsB6cZ3UHj1RoLtZE87iuxvQTBIaeo5NvXXPmrjJrai5gsAkmN1YeGvJUd2OAEd/bHKigaKCU95M2AWZFPoDrS5Vwir7MeK3FuULw1zu7yDX3aAcHgTfyo0wLAOgesBiD+RdzW/1Lw818369Hah+wV184fDFychILQ/ZkMrQZVztBLcXiqmLLEVVel9oarjoFDBd02lMagfJlUoXNvcTfpxTlFjOEi7Ex3LjBJDSQv/zUi2zxMDih5o1ygvwdMNY3gxYFBJy0RIMyvceaensg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3924.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.46; Fri, 10 Apr
 2026 19:31:27 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.044; Fri, 10 Apr 2026
 19:31:27 +0000
Date: Fri, 10 Apr 2026 15:31:22 -0400
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
Message-ID: <dzpxscrhibmi5okkozf5jfull4dcajgpctldvdyfcjgmpeetk5@tkeyqouyabzy>
References: <20260401222312.772334-1-atomlin@atomlin.com>
 <20260401222312.772334-14-atomlin@atomlin.com>
 <ac8l-w8ERG1YN2Wm@fedora>
 <nxe24ixebb4lm2d5w4aubhtwr23df6mumqd663axj35oswdiyv@amtqhtsidyr4>
 <adMoon3Zf6gO-UbA@fedora>
 <zawhqvn53mcp4wf7axsmuq4cg73upxs5h2zgrfta5dpat3sfy4@zctfbz2ttz5m>
 <CAFj5m9JE5e4DRGbzQFxDdZWU76ZPQ3G+C9JpLu0mhTB6aesZ9g@mail.gmail.com>
 <a566smu6morqeefqal23eek4ibezfuiwhs774xtxhyyclpbtsx@uzzwgbzmwdjd>
 <adhj_w11cpMfeEgN@fedora>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="keld3sctnoz6tzs5"
Content-Disposition: inline
In-Reply-To: <adhj_w11cpMfeEgN@fedora>
X-ClientProxiedBy: MN2PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:208:239::24) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3924:EE_
X-MS-Office365-Filtering-Correlation-Id: f052a662-c4e7-4371-e7f4-08de9737c1cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|56012099003|22082099003|27256017;
X-Microsoft-Antispam-Message-Info:
	JcicWBwxtt2VdRhxksfWJo16GmQPLWodCX5uDezRiFrfEnqBTsg+jU5y+1yTZGyrsA+8GhWhZJemTkMI8vkGCOvVSAsfao2gdVBwXV223ourOwLCZVMHXqlS0DfSMz3btm5MsY8LqIIbPNWISImSm2c+pWW1wS7qneC6Evu7sdFQQlq9vfuJPJEDwaS2DBmZpJZ5NjHMyf4e4YxNswJRZEoISCa64x/h4X7rB0g8DEttZ46GM1Tjf0cl6IO09a8UXcqthiobh/XHgP+1zuFsaA+ajWc3imPYNh1KRVwtBmztL69RmLFg/moS6IdD5IB0Bk+WDc06i/YS5biopFUsZZVGhdCCd+Ps6RG3yJ03bVo/TKSseHuVYQpqgcFvygJJX+bsisIjZ6V3aRYw6zAIKEJYLN4O24PJvNcKL6rgCBWp8af0OUBMVX4BBEezosQeGHEfDub1Bvi+JLnZG7r+wW3/s21C44ITPsDDxQ0EcvNMp1QJQ18bYQvAT9d9S7bhsqWJpc7J0hTXJ7QG5VpvDDjJtu1nhnICBS2bSrsMtGuDLm/+sxg0Lf02k/DwlCLqEMaQfdYwjBkTxDgNlsxg7k1AvGNLz9ZuA1jxyqjwoCLcXJu1agFLNMbVffTh1PMSt5wGGEcylU40kk69sBbcDZaYcZVpqxElNt2IazJy55Vt0F0j2Lt9mt4YrGVHpyP8S4o7oZdY0m7NwIT4wup56cHGntSWxUc3539ftqUj6Jbzz6d3rhe2p5ac0Iq2QBg0LEZApaaE/FuRd8DY9wpHns+G/Oib+UTe0ggqT8zu6Vs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(56012099003)(22082099003)(27256017);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVpHeGk3ZXJZNXhNYnE5d0VkRnpwQ3hKVGpJQ2Z3T2p5QndHemtKUnpDc2ZR?=
 =?utf-8?B?OXpSR0ZDN3V3N1JlRHVKaUhKT2lTVEczSGhlSFVqMFVaVklNczdPRC90NWM1?=
 =?utf-8?B?dHpjUFVkQjJKSWFtTC9oTVN0elNQb1ZuSUlURm1iMm5xQyt0eWhuZDc1Z1N0?=
 =?utf-8?B?UU5hS1B2Vzc1RUxWM2xkQ3laeDc3bGJrMDh1ZWhPcUJibmNSYXhPSnVScy9l?=
 =?utf-8?B?Q2RmKzBFKzhQdEx2K08zTTI4cjFlTWhVSElST3RCWEV6cEJwV0RwT2kyNjN3?=
 =?utf-8?B?MzlyMUQxWFR2YmhJbkZSRDEwRGpQVUNoVGpRdGp1ZkhWc2h5bGpQM0N6dGR3?=
 =?utf-8?B?SG16bkhwRVkrSkhQRDNWckpzTVNSM1Uxc2JZR1VQeXNHRnY1YUlUUmppM2Ja?=
 =?utf-8?B?bExRTzgrNkc5Y0h2dXRPdmg3a3RSZTNVMTFyWXhEbkJabXhscW5jcFpadUM3?=
 =?utf-8?B?bUQ2S1dRaDZ1M0ZhTnErZ3FnQTlnbEh3Qjk5dDFNNU1BNGRHTW85YUUvNDhH?=
 =?utf-8?B?VVRSeXNvNFZpT2ZRWTJRaTlMeFVrT2dNU2owVTlDTnZHZnZCM2hVR3ZPZFhP?=
 =?utf-8?B?Z0lFa3dUaTBnQ1I3QjN1NVo1dTBxckFNcEtqRjg3MmM5NUpyQTEyTUJEbHJQ?=
 =?utf-8?B?V011ZlhIVXJxWEU4UzN4Q0JvOGh6UUYrNU1qTXJLdEpaU2oxQTNkRStpaDFX?=
 =?utf-8?B?YXh6bjZoZnVINCtTQW9NOVVNalZ6V0wyRjhyNm5UY2FkV2xlamswMFBCWFVF?=
 =?utf-8?B?dWtzOG55dGp1UGxGR1VOT2gxaGY3bHlqdnZ3amIzejJWWkt3Tyt5eXVmR0Ix?=
 =?utf-8?B?TFB2ODRZUVBCdHU4TW5taWs4SktDN2NKUGdUZWlQVGJacnZiV1VCU3kvYjVw?=
 =?utf-8?B?dDg2ZHRkUkFTUzFVWEpHeVN5NmZPV0k4WkZCdjZOVm52TFNuTGxmYm1EV0Qr?=
 =?utf-8?B?dEptY1p1dk0zMDFTVG14OXBRZVVMMEdsU3JmT00zc1hkWGZCcjkvajUranZE?=
 =?utf-8?B?N2xGUjhURlVwa0xFQnFtVWdqNFZIK25adTlHeHJ5djBMWGE3ekNHa1VFaXZN?=
 =?utf-8?B?M1RsOHorOXdDOEZRUFlJaW1rZnphZExsY0toNlMzaUw0cUtUcURHd0dVNVpz?=
 =?utf-8?B?ZExBbHRYVnl0MkIwWTF4YmRpY2NUSVpGVGpkb2IxbStYblRKUWRHWGN6MVFG?=
 =?utf-8?B?ek1HU1psbmU4bmQ2VThQZ3AxOHVDdGFkaThJMUwrU3A5MjMzUzVqNFJzNzdi?=
 =?utf-8?B?NW1Jd2puSmNPUjhCeDNodCtMd29QNFpQd2RWSHlqcFR6b1kycFZFd3RKTVEw?=
 =?utf-8?B?aDZBN1hHTnhYTW9DNXo3R3RodmQ2eDFtdy9hRGNUUWQvZk8rdk1HSzZHOEtX?=
 =?utf-8?B?UzE1VkdsdVZvYldPT2l1MllNbDB2MVcrSnN5YTFzNXNCaU9LQ1pMMmhjSzI3?=
 =?utf-8?B?VldaYUU2YnFYOGxWZit4a01kODBhVUxqZ1hpTjlUbnI1TzNmbjVnaC9UMmpU?=
 =?utf-8?B?anYySjJwYlZiYWRoNmxYWDFLSmdIR2J2ckJrSHVCamdqZStaMll5UzlrVkZR?=
 =?utf-8?B?VExXNUI5WStWY2kxQ1h2TDdmV3lkMXNlcmEzV0FWajB0MnA0Vi9DUUt6SGF0?=
 =?utf-8?B?MHhrQzRoUVdDeGtqVk9WTXQzMUZ3aUx6U0o4a0ZUZUFqSHd1MHpzWFViU1Js?=
 =?utf-8?B?RXRmcXdSeHlHb3FyNTVEMDJUbG5KSFhURjk0RjNKZ1hWcm0vQjBROWhwTi9D?=
 =?utf-8?B?V2xxV0U5V1ZyUVFwaURIS1NXaWRHcVRNc0FkeTJCMThobjY1WDltNmtxQjlm?=
 =?utf-8?B?UjZKYnVqL0NqZklxaGtxMDlISnlac2lxYmhITXQvTFAybmRSNmlmK0dwUWJt?=
 =?utf-8?B?YWhhN1hiUjBPblp6UnhCV2hDSmlNMlhTb3c5WUFMNXJHWGNUemVNWlMrY2Yz?=
 =?utf-8?B?UnFJK2dZNDg2ajFXYm5uaE15OGw3SEpoZlJOalpsTzh6U1JsUXRSa0p2a1JJ?=
 =?utf-8?B?c1RCWktmbW9LdjVQd0tzd0lXd2tYaEdGem9YeDZRdEJCbEs5dEpMVFNrdXNH?=
 =?utf-8?B?bThPbVRIUVBTSzBlZ2hkT0djMk9OK2RTUkVQdXorWlBNbEFESVk1Tnd4Z0dp?=
 =?utf-8?B?SDNIOHIyNHhNbUwwdU94enVoelpobHdzOHd0MzFyL2VSTVlvS3JTU3lOWWo0?=
 =?utf-8?B?WEJZd0ZiZDFYR0kzUlVza0tIZDQzc3EzU0huTW1DS0s5UEx2ZzZjRC9kRlhq?=
 =?utf-8?B?bjVnQkRuWUd5MFVOKzBWN2RRajJYZmNVNW5ENEhqc0xoYTZCZUhHT202MzlF?=
 =?utf-8?B?YVQrVTAzVUFWbnQ4T2d0Q3Z1Vklvb2hEVE1aOTdhZzN6MGZFeHo3QT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f052a662-c4e7-4371-e7f4-08de9737c1cc
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 19:31:27.5299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/opH2gVWXJr0gOWGJgw7UJTPsHN4QFdFMOPLPnmheVEwHmwo1VaDe9e1OmLVy7ncbKXPwDtGw3ghimrtYe36w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3924

--keld3sctnoz6tzs5
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v10 13/13] docs: add io_queue flag to isolcpus
MIME-Version: 1.0

On Fri, Apr 10, 2026 at 10:44:15AM +0800, Ming Lei wrote:
> For unmanaged interrupts, user can set irq affinity on housekeeping cpus
> from /proc or kernel command line.
>=20
> Why is unmanaged interrupts involved with this patchset?

Thank you for your continued engagement and for ultimately supporting the
progression of this series.

To clarify the handling of unmanaged interrupts, while it is entirely true
that an administrator could attempt to manually configure "irqaffinity=3D" =
or
via procfs after the fact, this series actively address unmanaged interrupt=
s.

> > CPUs, thereby breaking isolation. By applying the constraint via io_que=
ue
> > at the block layer, we restrict the hardware queue count and map the
> > isolated CPUs to the housekeeping queues, ensuring isolation is maintai=
ned
> > regardless of whether the driver uses managed interrupts.
> >=20
> > Does the above help?
>=20
> As I mentioned, managed irq already covers it:
>=20
> - typically application submits IO from housekeeping CPUs, which is mapped
>   to one hardware, which effective interrupt affinity excludes isolated
>   CPUs if possible.
>=20
> I'd suggest to share some real problems you found instead of something
> imaginary.

If we trace how mpi3mr sets up its ISRs, it relies heavily on the core
grouping logic:

mpi3mr_setup_isr
{
  unsigned int irq_flags =3D PCI_IRQ_MSIX

  struct irq_affinity desc =3D { .pre_vectors =3D  1, .post_vectors =3D 1, }

  pci_alloc_irq_vectors_affinity(mrioc->pdev, min_vec,
                                 max_vectors, irq_flags, &desc)
  {
    if (flags & PCI_IRQ_MSIX) {
      // affd !=3D NULL
      __pci_enable_msix_range(dev, NULL, min_vecs, max_vecs, affd, flags)
      {

        for (;;) {

          msix_capability_init(dev, entries, nvec, affd)
          {
            msix_setup_interrupts(dev, entries, nvec, affd)
            {
              // affd
              irq_create_affinity_masks(nvec, affd)
              {
                for (i =3D 0, usedvecs =3D 0; i < affd->nr_sets; i++) {
                  unsigned int nr_masks, this_vecs =3D affd->set_size[i]
                  struct cpumask *result =3D group_cpus_evenly(this_vecs,
                                                             &nr_masks)
                  if (!result) {
                    kfree(masks)
                    return NULL
                  }

                  for (int j =3D 0; j < nr_masks; j++)
                    cpumask_copy(&masks[curvec + j].mask, &result[j])
                  kfree(result);

                  curvec +=3D nr_masks
                  usedvecs +=3D nr_masks
                }
              }
            }
          }
        }
      }
    }
  }
}

The critical issue lies at the invocation of group_cpus_evenly(). Without
this patchset, the core logic lacks the necessary constraints to respect
CPU isolation. It is entirely possible, and indeed happens in practice, for
an isolated CPU to be assigned to a CPU mask group.

The newer implementation of irq_create_affinity_masks() introduced by this
series resolves this. It considers the new CPU mask added to the IRQ
affinity descriptor. When group_mask_cpus_evenly() is called, this mask is
evaluated [1], guaranteeing that isolated CPUs are entirely excluded from
the mask groups.

[1]: https://lore.kernel.org/lkml/20260401222312.772334-8-atomlin@atomlin.c=
om/

> > > > > IMO, only two differences from this viewpoint:
> > > > >
> > > > > 1) `io_queue` may reduce nr_hw_queues
> > > > >
> > > > > 2) when application submits IO from isolated CPUs, `io_queue` can=
 complete
> > > > > IO from housekeeping CPUs.
> > > >
> > > > Acknowledged.
> > >=20
> > > Are there other major differences besides the two mentioned above?
> >=20
> > I believe the above is sufficient. Please let me know your thoughts.
>=20
> Both two are small improvement, not bug fixes. However the user has to pay
> the cost of potential failing of offlining CPU. Not mention the little=20
> complicated change: `19 files changed, 378 insertions(+), 48 deletions(-)`
>=20
> But I won't object if you can update the commit log/kernel command line
> doc and fix the issue found in review.

Thank you again for your rigorous review, patience, and invaluable
guidance.


Kind regards,
--=20
Aaron Tomlin

--keld3sctnoz6tzs5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAmnZUAYACgkQ4t6WWBnM
d9bYtg//ezxLS+33NSYa3jugqrQclQ2NymsjO1Np8yfQJgItc0uwWSZ2h4dbCq/N
or0zeCnulJrd1sLPfmMG1ANuRYVdxLMdYjMBTHIKVhnoeZUG31fknVqLH94uqpZS
GEzPNa9KHfM7/x/l1shJ2UfSPd6xqCtK7KOrqIC3oZpswtdwc50ul9VjtkY1rB3d
hcW9agmrIZsiCy34+3Rf7I/Q+zQYHeKKLCsuzYgCjMRF3SvfJFe8EYfM33QYvlzG
osK7hjYa6BH9FvKFaA8Bgcp+yrmWS2or9TWE1bZzdXH+suUgiUzEbsoMzPz5R8vH
ezZ+oEheBiBXGCMb8U7VFleGyZdRyIvsrhMouknzCrrd2jACgiHPlWfc6PtJZbFJ
2IT9GHg2g1UMegc42vJE+M+R5/nnij9fB48wwZO22u0mxXhdMa232EddGR97IAxx
mQlsOtCNJ27nRQZkMbkWUXqJ1PaCClBdqheUtP6OrJtDp07yUS1WRaBG7mtBXYFr
Q2h8xpSw4AsbRNfiGXw3Er4S3ovvKgmYFr6ULzaAPKxGJZGhnlb5YxBlBFcS1kMT
SUDpFu0S7aLjqQZIv2L9xnPD89OVr/jDaKNG5ACTn698DgWS5g1vP/RDDWtts+tI
Su81BdV5WRkGKCzYKGgaBomKi9AHswcMiNoiGFKwOkaNc0IVeTA=
=oEK5
-----END PGP SIGNATURE-----

--keld3sctnoz6tzs5--
