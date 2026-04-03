Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020112.outbound.protection.outlook.com [52.101.196.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D189225403;
	Fri,  3 Apr 2026 00:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775177463; cv=fail; b=imydDa2xwatGSSgeOX+1QuR+FS6qnrKjlyGFsifktAicCZxbKp3NgEupw1pJTPLHkgPxjQzJctqoghuA6OyKSR0/U7i5cJ5g4nchbmgKn/Tghx1Qkw+vVrt4+/W0kziy9dmx7325BniEsMnzhm1cJnuwHbFWcVNYKUplWbAdBkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775177463; c=relaxed/simple;
	bh=Cv9jqKdgLGgwv7HZBo2TChvqucM6/UMrNvjw+M8ODzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YZ42yhHcCORzsNFUc/BsJosp8/4pJBbS1Shch1J2FN2oWxHRiYiJKx5375xrhQZK+WGl0Yr3x6zIG9cU375HNfxbGEAWFQrZ5827iTzhVVLVk5FYxvtHnSpzOp93bzQ+AsW1vpOztbVFMf+LQ9KYfQ4Ko0OetFnIlVpGrg25oqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AD6Wua1umsX5aC5bXlN+JQ9uR2ROuzsz54IHnGzOU69rXYv8UMYv5uyY/3qB1lNpb0HCt4bmcNl3KQk7FKkoU49oUxSaTTQqVEkkzNLSiVx87+r2FkD8F5vJ6L+uwUhT+mgPowUOV8kSaiUW3+20P7A56WdMseyybPnlG7J5LLOVtw5dSUwtHs1jc6/yIkiXUkGVN/0T0rTtySj7bPBWPocHTJBNJAFf90+tx7J90LpRghc9QxfmzPGHv00fHD7/y91SzsRuJRlerTSYA6RCEdahLXXVj/qIjQjS0XChjBWf9/b9wSwDm3EqDAad9OovkUZm5YL43U4YW8x3lPskJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GkknelYFp6HtN4XE3xL83ceBm5cEE9hrZFfrC0l2T2k=;
 b=Pseop/Jb7+Uf08j+R9sQKx93ACKIEUW79qpyhBwtiyMfbRaT6lS3/k6MJyprpmfaCCc6BNeORcKGKhS207mB7NcDlWU5QU2OzLSuadEJyohJ2d7oXK2xoEHjGGtry8NMm28h/ammafZNtyQ/QhetikdO9b5sumfTbqStX8yr8hyWChgT2vviizK7YsaW4zD+LZP1LATJvWehRsOYt/qnWPCMy/4bPQrEnOIe+uNFzgUtCXViSoA0EQSZRpCbNFPYVjkTAX+msptUrYufJm39k26XckKts5Tx3QFrtOOC+2As795AZ6iWNhpbIRvjWaIq0F5OJ531z3nkxgaRoa/C/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by LO9P123MB7855.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3e4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Fri, 3 Apr
 2026 00:50:58 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9769.016; Fri, 3 Apr 2026
 00:50:58 +0000
Date: Thu, 2 Apr 2026 20:50:55 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, 
	mst@redhat.com, aacraid@microsemi.com, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, liyihang9@h-partners.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, 
	chandrakanth.patil@broadcom.com, sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com, ranjan.kumar@broadcom.com, jinpu.wang@cloud.ionos.com, 
	tglx@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, maz@kernel.org, ruanjinjie@huawei.com, 
	yphbchou0911@gmail.com, wagi@kernel.org, frederic@kernel.org, longman@redhat.com, 
	chenridong@huawei.com, hare@suse.de, kch@nvidia.com, ming.lei@redhat.com, 
	steve@abita.co, sean@ashe.io, chjohnst@gmail.com, neelx@suse.com, 
	mproche@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v9 09/13] isolation: Introduce io_queue isolcpus type
Message-ID: <sluplntvagevh6ehfm3kqinbh23d2gnin7stkptxk6drvogh2g@4hpz74fidrq2>
References: <20260330221047.630206-1-atomlin@atomlin.com>
 <20260330221047.630206-10-atomlin@atomlin.com>
 <20260401124947.-d4D5Cr-@linutronix.de>
 <c7phvlvohdn2ksc2jymxk5foolwlqaqq2jzcdv7oic4uzomh3j@yjimbwcnnst3>
 <20260402090940.5j0WmVX_@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260402090940.5j0WmVX_@linutronix.de>
X-ClientProxiedBy: BN9PR03CA0574.namprd03.prod.outlook.com
 (2603:10b6:408:10d::9) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|LO9P123MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: 511c72d1-3b8d-4141-664c-08de911b11f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	E/JeTplHmm5B8CmZkmz/BIEERu5Sox3xZmnitQQ3sVrXsHW7MjgksEhXLHWfgfobpxxJSTPu+fUNNigQjCg8Qb7tgwLq1AnBxUxYYoUTAMer4Rp1MdCkQ9g5WE3fNKp4vlRsEQHmamXXYrL3zgGeSh1fwigLaJ+1G1zZ86+MmC44DBHAQrQggDmCIYHg+GroYe7ZJMMha9AxHnx++zgdy/VLplfYxMMQwC9Mssxyd7Q1eAU+Ya30iZlue7hGK+v8w7Zl/MiEGFRX4e+0pe26UX8tHj/QY9WkqPEdhP4QMBM8tN9sAWQR62cwD4WdO+4INQHpBj1J6pfp7nTMPDp05pMyFxwSoSlWNmUOIjBlHz59rbDcAQgfmKXWwv9TzEES2VnA24iogk9Pengaxfs52z9sxpHmf4jsxhJdsc1zZGhG3uX8lzCVuX7o9daj37xlf6avaXGJimVpq2Pw965Z4/VBZNFiYiY5Fsqejb4J9jsDm7u2xFXFEVq/30ejRluolhjsMDlLqUhnbjF9O4NGTArknn4qst/HDzO/qXCCH6oVidnKLIoTiJHJ3oPBWr9XEpLNfRnAM9S4TNSj9hbwKWyGjFR8zbwHKkXYd5fJxota8+TDWDkkGXaa//OpF2PAVn8u4BHxS6YSra9h0qFjXSx+XrcAaLjIybO1lX5Dxk9+3XLzgWPL99T6WhG/Al0Xn2itqV6XDJjSNrhpNM9+jVzk/Gdum90oS57RafYq60w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1BNN1FyR3lZUlBXNzNWa3dRRUVta2tBTnB0TVNWY2k4UkhZS0VsMzJwNXVn?=
 =?utf-8?B?T25PR0lMQjE3anNuc2d6bFphblkvUnNKRjc1TmMrL0dZMm5nL2N6czhBT0FW?=
 =?utf-8?B?ZG1jd01BQ1VwZTZnUUQvVndyNkZOYzF4dUpxT0lKZG1hemFpeDNKdExMc0Ji?=
 =?utf-8?B?QWVOUDVNRWJ4VGtqaFdkZ2cxWC9hbjdxZnNabXhxT1NDQlo3T2dwek11QUhj?=
 =?utf-8?B?SGtQVzB6djhpWGxRaWlXbWZWZi9CUzVnR3F6aW9NT3J2MDR3V3RvSnh0b0NZ?=
 =?utf-8?B?bjFEL0w3aUNTaDVGaEtqOGlMaHhCVkhEaVVzcTlYeksrdFNSVFVGYVZPakd5?=
 =?utf-8?B?bmhnT2pqcG4vMUFlVWovdlVuWDNXWTZsaS9iU0JyZHZONDNPUWZmMjdNN3o3?=
 =?utf-8?B?WklxUFhUWmROZTNGV0ZXOTJncWwrR01JdmFrdndHQkJhSDQ3SmpIV3lsSTkx?=
 =?utf-8?B?NFF2NmNKQ3dqSG9kYm5hamtlUk9aODZaWmlMdGxkdjZieEQxR1c3WDRBbTNN?=
 =?utf-8?B?eDVweVpEUjVoNnhKODAzOW9tTlNUdS9qYUxKTG5wUVppdmlYOHNYSlZCZHB1?=
 =?utf-8?B?UjBLaGw5K3I0N0xHcURiRVZ6VWYxRlB4bVRqUXhFUjFuTm5UNGhhMkdLdk9l?=
 =?utf-8?B?K1d0Mk0rZTFyYUZlemNPUVdRbTB4ZGo1RFF5QjJyRm9BRk5iTzd6K0ZibmMy?=
 =?utf-8?B?WGtlM3VKWkVLaytpOC9YcDNrYWw4clB3dDE5THJGbG5ZVmw4eFIxMzhFbGZy?=
 =?utf-8?B?SEdzaUNCZW1NUkZ0Zk9wMkRRMEJhZzVwK1h5TXlwR2pvLzZrVGM1YnVMTC9j?=
 =?utf-8?B?bXQ5ZVg4V1VlMVVrOThSYkJJRTVhL0xJbGVxTG95b3d0djNEYndiZlQyT2li?=
 =?utf-8?B?SDlKcnVSZVRoempXV2V2VWhxQnZoeEcxRG5KZk1PSzRSVFd6SWgzemRtT2Y2?=
 =?utf-8?B?ODM4ZmM4ZlJNaTNIRXUxd3RweXpGd1hoYktNSXprZFBFdmp4US9iNmV4Y1U1?=
 =?utf-8?B?M21kc0F3cTZZNk9pOXd5eWVUWm9oUC90V2lHN2x2dElrQ0p2YlQrdUZtcm5L?=
 =?utf-8?B?T3JZSnZJRUhXYUdqUDd3VmIrNFgrRlJyei9lN0dLTmxTWTBRUkRSWnI3aHlV?=
 =?utf-8?B?U3E5QkRvS0FMYnZVLy8rV1hhQ0tLL3d1Zy9vU3crd1FMczhYdmZLaXl3bjVz?=
 =?utf-8?B?YjlMMll5N1NpUm9zMGtEVEhpajc0RStpRnQ0QmVlWXRLQmFBR012VExxampS?=
 =?utf-8?B?V3BOME9pejgza1pIS2xzUS9XS1Y4N1RVQUg2N0FBVkUxUWl3c0dqU1J4azhT?=
 =?utf-8?B?aDNzWjkvQmJSZGRBRk16eEtpWUkzVkNXUWtHNkxJOUthWVQ0M1J4NDVqbVd2?=
 =?utf-8?B?Z0M2aWx3VjdrZ2NxQUJqa1FVeGp0YjdZUm8wNE1xYUVwNnhHaWh0VFM3U25V?=
 =?utf-8?B?YU5CZHptUWRiVmdDRk9PcGVGU0kyRHliaDBxNVYrazJkQWs5QTN1TnR6VnNN?=
 =?utf-8?B?MlZsSURsbmdSdCtrbk12QXFxNERmNUUvMVlTWWNHWGFsb09vYXloVHIzOCs2?=
 =?utf-8?B?OGhaMFpDbmFleWZPL3VVUHcvcHNQU1l4eFpwY2tsZ21sV2l1RHBDUkFGQysr?=
 =?utf-8?B?TEpldVFXMkNaMDl2azM5MTQ5YTl2N3h5U2lRQWZaUm5vUk5FWVBjK3FEQ1Vk?=
 =?utf-8?B?VENGYWsrY0szOGVEVlVlWUcrcGtQWGxJSnYxQjhiZWk1UUFJRzZUM1h0Y0Zh?=
 =?utf-8?B?VWxzK1dIUlNzOEJIdnJBQjlTUlRQNDZXcktyTGxOckFDOUpVYlMwV2dmTGRW?=
 =?utf-8?B?Lzdva3VPeTg3T01lNGlUalFTdXhDL0dpSzkveWsySFIvVnlnM1NkWFhBMCtC?=
 =?utf-8?B?RHV2dnBROEU2K0MzV1NzVEhqV3VudGgwb1BITGZUNWZFN2ZHNmJ6OEx0VDNR?=
 =?utf-8?B?cHRFVU43MFJXZklkNWl3TlA5SkxsWnZuTHh2a0FQQVF2c3VmRzcyR0VZT3Ft?=
 =?utf-8?B?eGxoYk5WTEpVY0ZMcHcvNG43cjhESnpsTlpVTUJnWCs4WDkvdzhvc3pqWFcy?=
 =?utf-8?B?Wld5Q0FkRVF1WUxLWHBOOXlPbVh6SE4xbStYKytBZngyY3Rrb1ExZVRYNHFu?=
 =?utf-8?B?RWhXaUJ2dWZiY0JadW5xUWEyNUw1U08xT1R3eWV4TWNzUWRzeVp5bnRlOTZD?=
 =?utf-8?B?aVBpdklRTEZZZ0lVazB6Q0ttSm1VZVRkbllTSHkwUmp3L2RCcURYZ0dEbTBo?=
 =?utf-8?B?THhkenFrQ3hvWXNRMWE0MmlZVGZBSUpCakRDSUt5SEkrbzkySkVNeThKYlky?=
 =?utf-8?B?UDBkb3pFcjA2Q0toYnhoQmszYzFvR0ZPbWZBNHNPazN2NGlZZUhaZz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 511c72d1-3b8d-4141-664c-08de911b11f4
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 00:50:58.7055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDWem7TqXyyT6Xw42g9oI/duz/C/Xn3MqaYiPQdZGZo7W47FMZuzvTwW4UEiuKn3BRn4m/3wPmAPhomYHWFfEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO9P123MB7855

On Thu, Apr 02, 2026 at 11:09:40AM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-04-01 16:58:22 [-0400], Aaron Tomlin wrote:
> > Hi Sebastian,
> Hi,
> 
> > Thank you for taking the time to document the "managed_irq" behaviour; it
> > is immensely helpful. You raise a highly pertinent point regarding the
> > potential proliferation of "isolcpus=" flags. It is certainly a situation
> > that must be managed carefully to prevent every subsystem from demanding
> > its own bit.
> > 
> > To clarify the reasoning behind introducing "io_queue" rather than strictly
> > relying on managed_irq:
> > 
> > The managed_irq flag belongs firmly to the interrupt subsystem. It dictates
> > whether a CPU is eligible to receive hardware interrupts whose affinity is
> > managed by the kernel. Whilst many modern block drivers use managed IRQs,
> > the block layer multi-queue mapping encompasses far more than just
> > interrupt routing. It maps logical queues to CPUs to handle I/O submission,
> > software queues, and crucially, poll queues, which do not utilise
> > interrupts at all. Furthermore, there are specific drivers that do not use
> > the managed IRQ infrastructure but still rely on the block layer for queue
> > distribution.
> 
> Could you tell block which queue maps to which CPU at /sys/block/$$/mq/
> level? Then you have one queue going to one CPU.
> Then the drive could request one or more interrupts managed or not. For
> managed you could specify a CPU mask which you desire to occupy.
> You have the case where
> - you have more queues than CPUs
>   - use all of them
>   - use less
> - less queues than CPUs
>   - mapped a queue to more than once CPU in case it goes down or becomes
>     not available
>   - mapped to one CPU
> 
> Ideally you solve this at one level so that the device(s) can request
> less queues than CPUs if told so without patching each and every driver.
> 
> This should give you the freedom to isolate CPUs, decide at boot time
> which CPUs get I/O queues assigned. At run time you can tell which
> queues go to which CPUs. If you shutdown a queue, the interrupt remains
> but does not get any I/O requests assigned so no problem. If the CPU
> goes down, same thing.
> 
> I am trying to come up with a design here which I haven't found so far.
> But I might be late to the party and everyone else is fully aware.
> 
> > If managed_irq were solely relied upon, the IRQ subsystem would
> > successfully keep hardware interrupts off the isolated CPUs, but the block
> 
> The managed_irqs can't be influence by userland. The CPUs are auto
> distributed.
> 
> > layer would still blindly map polling queues or non-managed queues to those
> > same isolated CPUs. This would force isolated CPUs to process I/O
> > submissions or handle polling tasks, thereby breaking the strict isolation.
> > 
> > Regarding the point about the networking subsystem, it is a very valid
> > comparison. If the networking layer wishes to respect isolcpus in the
> > future, adding a net flag would indeed exacerbate the bit proliferation.
> 
> Networking could also have different cases like adding a RX filter and
> having HW putting packet based on it in a dedicated queue. But also in
> this case I would like to have the freedome to decide which isolated
> CPUs should receive interrupts/ traffic and which don't.
> 
> > For the present time, retaining io_queue seems the most prudent approach to
> > ensure that block queue mapping remains semantically distinct from
> > interrupt delivery. This provides an immediate and clean architectural
> > boundary. However, if the consensus amongst the maintainers suggests that
> > this is too granular, alternative approaches could certainly be considered
> > for the future. For instance, a broader, more generic flag could be
> > introduced to encompass both block and future networking queue mappings.
> > Alternatively, if semantic conflation is deemed acceptable, the existing
> > managed_irq housekeeping mask could simply be overloaded within the block
> > layer to restrict all queue mappings.
> > 
> > Keeping the current separation appears to be the cleanest solution for this
> > series, but your thoughts, and those of the wider community, on potentially
> > migrating to a consolidated generic flag in the future would be very much
> > welcomed.
> 
> I just don't like introducing yet another boot argument, making it a
> boot constraint while in my naive view this could be managed at some
> degree via sysfs as suggested above.

Hi Sebastian,

I believe it would be more prudent to defer to Thomas Gleixner and Jens
Axboe on this matter.


Indeed, I am entirely sympathetic to your reluctance to introduce yet
another boot parameter, and I concur that run-time configurability
represents the ideal scenario for system tuning.

At present, a device such as an NVMe controller allocates its hardware
queues and requests its interrupt vectors during the initial device probe
phase. The block layer calculates the optimal queue to CPU mapping based on
the system topology at that precise moment. Altering this mapping
dynamically at runtime via sysfs would be an exceptionally intricate
undertaking. It would necessitate freezing all active operations, tearing
down the physical hardware queues on the device, renegotiating the
interrupt vectors with the peripheral component interconnect subsystem, and
finally reconstructing the entire queue map.

Furthermore, the proposed io_queue boot parameter successfully achieves the
objective of avoiding driver level modifications. By applying the
housekeeping mask constraint centrally within the core block layer mapping
helpers, all multiqueue drivers automatically inherit the CPU isolation
boundaries without requiring a single line of code to be changed within the
individual drivers themselves.

Because the hardware queue count and CPU alignment must be calculated as
the device initialises, a reliable mechanism is required to inform the
block layer of which CPUs are strictly isolated before the probe sequence
commences. This is precisely why integrating with the existing boot time
housekeeping infrastructure is currently the most viable and robust
solution.

Whilst a fully dynamic sysfs driven reconfiguration architecture would be a
great, it would represent a substantial paradigm shift for the block layer.
For the present time, the io_queue flag resolves the immediate and severe
latency issues experienced by users with isolated CPUs, employing an
established and safe methodology.

This is at least my understanding.


Kind regards,
-- 
Aaron Tomlin
