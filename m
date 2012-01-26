From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out
 of the staging area
Date: Thu, 26 Jan 2012 10:07:13 -0600
Message-ID: <1327594033.2965.2.camel@dabdike.int.hansenpartnership.com>
References: <1327516187-21793-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327516187-21793-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-01-25 at 10:29 -0800, K. Y. Srinivasan wrote:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> 
> This patch is based on the storvsc patches that are already on Greg's queue
> for the staging tree. This patch-set addressed Christoph's review comments.
> If need be, I can re-send this patch-set in Greg's queue
> or I can  send the fully patched storvsc_drv.c.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/Kconfig                       |    7 +++++++
>  drivers/scsi/Makefile                      |    3 +++
>  drivers/{staging/hv => scsi}/storvsc_drv.c |    0
>  3 files changed, 10 insertions(+), 0 deletions(-)
>  rename drivers/{staging/hv => scsi}/storvsc_drv.c (100%)

This doesn't compile:

make[3]: *** No rule to make target `drivers/staging/hv/storvsc_drv.o',
needed by `drivers/staging/hv/hv_storvsc.o'.  Stop.
make[3]: *** Waiting for unfinished jobs....
  LD      drivers/staging/hv/built-in.o
make[2]: *** [drivers/staging/hv] Error 2
make[1]: *** [drivers/staging] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

You need to remove the staging Kconfig/Makefile remnants as well.

James
