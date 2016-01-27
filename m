From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] mptlan: add checks for dma mapping errors
Date: Wed, 27 Jan 2016 08:23:41 -0800
Message-ID: <1453911821.2322.13.camel@HansenPartnership.com>
References: <56A6568B.9020707@ispras.ru>
	 <1453744944-4065-1-git-send-email-khoroshilov@ispras.ru>
	 <56A79FD3.2060200@redhat.com> <yq1pownhibu.fsf@sermon.lab.mkp.net>
	 <ef60565bb858fae9ddede39bbf1ebd73@mail.gmail.com>
	 <56A8ECCD.2010102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56A8ECCD.2010102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Sathya Prakash <sathya.prakash@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-27 at 17:14 +0100, Tomas Henzl wrote:
> On 27.1.2016 06:44, Sathya Prakash wrote:
> > There is no fusion based network card and resources exists today in
> > Avago(LSI) to test this patch so we prefer to leave it as is. We
> > would
> > like to prevent any new changes on MPT (FC/SCSI/SAS/LAN) drivers as
> > we
> > don't have support for those cards anymore,  is there a way we
> > could
> > remove those drivers from newer kernels or mark them as
> > unmaintained?.
> 
> There still are users of some of those drivers (mptsas for example)
> in certain distributions, so even if in fact they aren't
> directly maintained, we should keep them in mainline.

Agreed: the last gen PA-RISC has a mptspi controller ... they'd get a
bit annoyed if we remove it because they wouldn't be able to update
their build machines to newer kernels.

James
