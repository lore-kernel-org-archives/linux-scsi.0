From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] scsi/mvsas/mv_sas.c: Use dma_pool_zalloc
Date: Thu, 18 Oct 2018 18:18:40 +0200
Message-ID: <CAMGffE=sKUZS=soSgT_ki9JQ7bVdCdVyrzQ8W+m5F4FSPEopFQ@mail.gmail.com>
References: <5bc8af85.1c69fb81.3eebc.a22b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bc8af85.1c69fb81.3eebc.a22b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sabyasachi.linux@gmail.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, John Garry <john.garry@huawei.com>, jrdr.linux@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 18, 2018 at 6:06 PM Sabyasachi Gupta
<sabyasachi.linux@gmail.com> wrote:
>
> Replaced dma_pool_alloc + memset with dma_pool_zalloc
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
Thanks!
> ---
>  drivers/scsi/mvsas/mv_sas.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)



--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
