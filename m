From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH resend] include/linux: Add bsg.h to the Kernel exported headers
Date: Mon, 19 Jan 2009 10:37:48 +0100
Message-ID: <20090119093746.GF30821@kernel.dk>
References: <496EFA69.3050007@panasas.com> <20090115202155G.fujita.tomonori@lab.ntt.co.jp> <496F26DF.9050303@panasas.com> <20090115212942R.fujita.tomonori@lab.ntt.co.jp> <20090115164824.e637b8c6.akpm@linux-foundation.org> <20090116065003.GU30821@kernel.dk> <4972E6FD.8070405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:18238 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbZASJjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2009 04:39:16 -0500
Content-Disposition: inline
In-Reply-To: <4972E6FD.8070405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dougg@torque.net, stable@kernel.org

On Sun, Jan 18 2009, Boaz Harrosh wrote:
> 
> bsg.h in current form is perfectly suitable for user-mode
> consumption. It is needed together with scsi/sg.h for applications
> that want to interface with the bsg driver.
> 
> Currently the few projects that use it would copy it over into
> the projects. But that is not acceptable for projects that need
> to provide source and devel packages for distros.
> 
> This should also be submitted to stable 2.6.28 and 2.6.27 since bsg had
> a stable API since these Kernels and distro users will need the header
> for these kernels a swell
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Ack-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> CC: stable@kernel.org
> ---
>  include/linux/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 12e9a29..2124c06 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -41,6 +41,7 @@ header-y += baycom.h
>  header-y += bfs_fs.h
>  header-y += blkpg.h
>  header-y += bpqether.h
> +header-y += bsg.h
>  header-y += can.h
>  header-y += cdk.h
>  header-y += chio.h

Applied

-- 
Jens Axboe

