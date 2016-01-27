From: Sathya Prakash <sathya.prakash@avagotech.com>
Subject: RE: [PATCH v3] mptlan: add checks for dma mapping errors
Date: Tue, 26 Jan 2016 22:44:21 -0700
Message-ID: <ef60565bb858fae9ddede39bbf1ebd73@mail.gmail.com>
References: <56A6568B.9020707@ispras.ru>	<1453744944-4065-1-git-send-email-khoroshilov@ispras.ru>
	<56A79FD3.2060200@redhat.com> <yq1pownhibu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1pownhibu.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

There is no fusion based network card and resources exists today in
Avago(LSI) to test this patch so we prefer to leave it as is. We would
like to prevent any new changes on MPT (FC/SCSI/SAS/LAN) drivers as we
don't have support for those cards anymore,  is there a way we could
remove those drivers from newer kernels or mark them as unmaintained?.

Thanks
Sathya

-----Original Message-----
From: mpt-fusionlinux.pdl@avagotech.com
[mailto:mpt-fusionlinux.pdl@avagotech.com] On Behalf Of Martin K. Petersen
Sent: Tuesday, January 26, 2016 7:23 PM
To: Tomas Henzl
Cc: Alexey Khoroshilov; Sreekanth Reddy;
MPT-FusionLinux.pdl@avagotech.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; ldv-project@linuxtesting.org
Subject: Re: [PATCH v3] mptlan: add checks for dma mapping errors

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> Other than that - previous patch for this driver came in in 2010
Tomas> - six years ago and the driver seems unmaintained now.  I'm not
Tomas> sure if we should fix hw we can't test and when there is not an
Tomas> user bug report. This example nicely shows how easy it is to add
Tomas> new bugs even when a fix looks trivial.

Yeah, I'm inclined to leave it as is.

If somebody provides a Tested-by: I'll reconsider.

-- 
Martin K. Petersen	Oracle Linux Engineering
