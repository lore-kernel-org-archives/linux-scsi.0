From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] [RESEND] [SCSI] misc drivers: remove deprecated IRQF_DISABLED
Date: Tue, 18 Mar 2014 06:32:43 +0100
Message-ID: <5327DA7B.7060200@free-electrons.com>
References: <1386584710-5564-1-git-send-email-michael.opdenacker@free-electrons.com> <1393998313-4240-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393998313-4240-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linuxdrivers@attotech.com, achim_leubner@adaptec.com, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 03/05/2014 06:45 AM, Michael Opdenacker wrote:
> This patch removes the use of the IRQF_DISABLED flag
> in several drivers in drivers/scsi/
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/scsi/dtc.c                | 2 +-
>  drivers/scsi/esas2r/esas2r_init.c | 2 +-
>  drivers/scsi/g_NCR5380.c          | 2 +-
>  drivers/scsi/gdth.c               | 6 +++---
>  drivers/scsi/in2000.c             | 2 +-
>  drivers/scsi/initio.c             | 2 +-
>  drivers/scsi/pas16.c              | 2 +-
>  drivers/scsi/pm8001/pm8001_init.c | 2 --
>  drivers/scsi/t128.c               | 2 +-
>  9 files changed, 10 insertions(+), 12 deletions(-)
As the maintainers don't seem to have time for this, I will trying to
get my IRQF_DISABLED patches merged through Andrew Morton.

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098
