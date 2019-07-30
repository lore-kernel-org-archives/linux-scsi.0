From: "Matthew R. Ochs" <mrochs@linux.ibm.com>
Subject: Re: [PATCH] scsi: cxlflash: Mark expected switch fall-throughs
Date: Tue, 30 Jul 2019 13:52:13 -0500
Message-ID: <20190730185213.GA10811@p8tul1-build.aus.stglabs.ibm.com>
References: <20190729002119.GA25068@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190729002119.GA25068@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "Manoj N. Kumar" <manoj@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 28, 2019 at 07:21:19PM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings:
> 
> drivers/scsi/cxlflash/main.c: In function 'send_afu_cmd':
> drivers/scsi/cxlflash/main.c:2347:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    if (rc) {
>       ^
> drivers/scsi/cxlflash/main.c:2357:2: note: here
>   case -EAGAIN:
>   ^~~~
> drivers/scsi/cxlflash/main.c: In function 'term_intr':
> drivers/scsi/cxlflash/main.c:754:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    if (index == PRIMARY_HWQ)
>       ^
> drivers/scsi/cxlflash/main.c:756:2: note: here
>   case UNMAP_TWO:
>   ^~~~
> drivers/scsi/cxlflash/main.c:757:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 2, hwq);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/cxlflash/main.c:758:2: note: here
>   case UNMAP_ONE:
>   ^~~~
> drivers/scsi/cxlflash/main.c:759:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 1, hwq);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/cxlflash/main.c:760:2: note: here
>   case FREE_IRQ:
>   ^~~~
> drivers/scsi/cxlflash/main.c: In function 'cxlflash_remove':
> drivers/scsi/cxlflash/main.c:975:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    cxlflash_release_chrdev(cfg);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/cxlflash/main.c:976:2: note: here
>   case INIT_STATE_SCSI:
>   ^~~~
> drivers/scsi/cxlflash/main.c:978:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    scsi_remove_host(cfg->host);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/cxlflash/main.c:979:2: note: here
>   case INIT_STATE_AFU:
>   ^~~~
> drivers/scsi/cxlflash/main.c:980:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    term_afu(cfg);
>    ^~~~~~~~~~~~~
> drivers/scsi/cxlflash/main.c:981:2: note: here
>   case INIT_STATE_PCI:
>   ^~~~
> drivers/scsi/cxlflash/main.c:983:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    pci_disable_device(pdev);
>    ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/cxlflash/main.c:984:2: note: here
>   case INIT_STATE_NONE:
>   ^~~~
> drivers/scsi/cxlflash/main.c: In function 'num_hwqs_store':
> drivers/scsi/cxlflash/main.c:3018:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    if (cfg->state == STATE_NORMAL)
>       ^
> drivers/scsi/cxlflash/main.c:3020:2: note: here
>   default:
>   ^~~~~~~
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Matthew R. Ochs <mrochs@linux.ibm.com>
