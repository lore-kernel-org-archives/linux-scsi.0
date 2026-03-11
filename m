Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7021A6807
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773191713; cv=none; b=KVdncHSnDJE5nbO1+9itzTLTH7AtZ1HZB24GyUfiOyvYMUEV9IU7INVXYWdzQFYUsMKJypc5on95ts4NeDyngOO2sptE++eu0BPJqkgZiqi6NqcmeydsJRtZGxMoM0p6VvR2n2MTpPiQH+RFW8kbbfU3HgMjC8JB3kCmCCe4Iik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773191713; c=relaxed/simple;
	bh=/oF/doq6oyWwDTCyW1l4hS1E5POtzgyvQYrb/7hmVZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oZe9RkpwxO8ojKCnC/IlTGsc4MjbJktxpZMAw3HejpBvrfl1C6t+jr3hB+alqoDV3AXDSPqOTnpfL9eRIsVqa/4nK6P3nXq+MqWvKZ5mxmv/p/VtRMxybXbrOHzLR+Va6KKo135OzQD7fQaKyo/e8bZLFu9MduD1T8dPJjzNllg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-660d77cacc2so1099820a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 18:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773191710; x=1773796510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/oF/doq6oyWwDTCyW1l4hS1E5POtzgyvQYrb/7hmVZg=;
        b=ksyxN+BZe9Pe6kdallusJBV8n2GRPzsRiBT0UV7iQqYKn7pmXH4xrSUxMgjVcbspy2
         90z1BJ1XlaaIL44OlTNONigJdjJON5Wi+ljlVi5ObvK+hJTgbuju4Aqo8adamwyxFko4
         wiQF9IBdcXzNAezilQeo0UdkA+KYzgE9iNaastkBv2ZAn1bGsEUs7Z2732aQghyHvxQX
         O93q6pOk7zHYQiH3IxZbmdthW8pnfePCfkMMZsBT6ifynFQ7SF0JXMsFnbwdl68uNxAD
         nFFYZPLkO/haQlwANXJy+JdN46GrGIkeUjYvdXc2Ve6nGP0khN7FOXSg4OwFMLfDsBy4
         MpSA==
X-Forwarded-Encrypted: i=1; AJvYcCUDKETElj4M/Z2AeuNh/p2VsHVlro/7Ol63NCjnNoMXPAaOzSRRK/58EtQTRSLTnTpKww+pJHlNOpRZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9kAkqkHLi8/3EWM1IiTn+qLzKD2HElpmW5q6cd8nBa03X3Sax
	yKypCYVTlpnx2ChDeOrjbFgDZDQod/9KKSEESWZFVdEEnzmGNn35XhGnFADxkwnniuQ=
X-Gm-Gg: ATEYQzwUXvplJ/ASGHTvgrhDT9BuhYc42QTUIxjCFqq4KnEq+tAO834X2EhDRpbD9AP
	kJRVdJNt7MA4He2nI5VWz363g2mJWR4Femi4jrlz9WN+YrsT5wB3c6pX5Dr0ErQN/+vrcTpn46K
	6mPhOnAM+SlYCqFejPM2ijd0bJysA9mdIGvzuGSsGaI0J/ts3sGGU5aR5gcKz0Vahbz65/RPftC
	qQeh1vniVsY7PqZcgGsYLFNoPLPiNi6GQcevCi7B+pvfz4A+TAUA8uYbqXoOR6vpHFfmOidz11s
	ragbPgUdKB0abE1wWD5MNgJU57RjCuNB8QNKC1Y7+FMZXnZQmuJ3CFD04u/aKn0pdzLd7dtlE4T
	NDGx/nDwsSpK+cCkIfPS30scci+zz7Omba/MX2Q5txNZmbb6nNSuu3LxdjqJmZMdOLkAwnbzSYc
	HKRCOBy+o42HmZbCpXydP/XwzJ+9Hu6FalyoNBcIwqhJplenG38gb1oao=
X-Received: by 2002:a05:6402:2788:b0:65f:a47f:6e9c with SMTP id 4fb4d7f45d1cf-6631739d4bemr327538a12.3.1773191710513;
        Tue, 10 Mar 2026 18:15:10 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-66314482d9asm200920a12.11.2026.03.10.18.15.08
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 18:15:09 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439bc14dcf4so330580f8f.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 18:15:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWz5hPc7uxIfmjX3ImgolmSa4t7e0E6h7BUXITtY12Ij2jh1aVztCYDzEkXen3DC/ez3jeWoQpcU8Fu@vger.kernel.org
X-Received: by 2002:a5d:5d05:0:b0:439:bb46:7457 with SMTP id
 ffacd0b85a97d-439eff518c7mr10359487f8f.16.1773191708627; Tue, 10 Mar 2026
 18:15:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309062840.2937858-2-iam@sung-woo.kim> <CADUfDZorSQCVtQyfjBuaziwG2Jo28yZiiqLKbp9PkFFw-9VgfQ@mail.gmail.com>
 <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com> <CADUfDZppWyOOPME0eJbmO1q+qvehxGiCk8Zz_nVxaQk08aukFw@mail.gmail.com>
In-Reply-To: <CADUfDZppWyOOPME0eJbmO1q+qvehxGiCk8Zz_nVxaQk08aukFw@mail.gmail.com>
From: Sungwoo Kim <iam@sung-woo.kim>
Date: Tue, 10 Mar 2026 21:14:52 -0400
X-Gmail-Original-Message-ID: <CAJNyHpLU7sTJRtDqTbczTz0iayj-Nm8bPHrPaOcsKVb6nQyw1A@mail.gmail.com>
X-Gm-Features: AaiRm51cz7xo1V1erpi09gKFdY9TTILawmEFCzQE55oadwxdss7qBUImRUPZq3I
Message-ID: <CAJNyHpLU7sTJRtDqTbczTz0iayj-Nm8bPHrPaOcsKVb6nQyw1A@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	Ulf Hansson <ulf.hansson@linaro.org>, Richard Weinberger <richard@nod.at>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chao Shi <cshi008@fiu.edu>, 
	Weidong Zhu <weizhu@fiu.edu>, Dave Tian <daveti@purdue.edu>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Mar 9, 2026 at 4:55=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> wro=
te:
> >
> > On Mon, Mar 9, 2026 at 11:31=E2=80=AFAM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > On Sun, Mar 8, 2026 at 11:30=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim=
> wrote:
> > > >
> > > > The numa_node can be < 0 since NUMA_NO_NODE =3D -1. However,
> > > > struct blk_mq_hw_ctx{} defines numa_node as unsigned int. As a resu=
lt,
> > > > numa_node is set to UINT_MAX for NUMA_NO_NODE in blk_mq_alloc_hctx(=
).
> > >
> > > The node argument to blk_mq_alloc_hctx() comes from
> > > blk_mq_alloc_and_init_hctx(), which is called by
> > > blk_mq_alloc_and_init_hctx() with int node =3D blk_mq_get_hctx_node(s=
et,
> > > i). node =3D NUMA_NO_NODE would suggest that blk_mq_hw_queue_to_node(=
)
> > > doesn't find any CPU affinitized to the queue. Is that even possible?
> >
> > Thanks for your review, Celeb.
>
> While I'm flattered you consider me a celebrity, my name is Caleb :)

My apologies, Caleb. I'll be more careful.

>
> >
> > blk_mq_hw_queue_to_node() can return NUMA_NO_NODE if the device queues
> > exceed the
> > number of CPUs. Afterward, it is adjusted on the caller side to
> > numa_node =3D set->numa_node.
>
> I thought the NVMe driver capped the number of queues so every queue
> is affinitized to some CPU (see nvme_max_io_queues()). What am I
> missing?
>
> Best,
> Caleb

You are right, every hw queue should be affinitized. It seems I'm
missing a lot. I'll look into the reasons and get back with V2.

I appreciate your review again.

Sungwoo.
