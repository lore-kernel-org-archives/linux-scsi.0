From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: Re: [PATCH v2 1/2] codafs: Fix build using bare-metal toolchain
Date: Tue, 11 Sep 2018 19:53:59 +0300
Message-ID: <CAKaJLVvSHZq9eZd2uqojHb9bdLOnLhQn1X-i=YBWMXMeexrWYg@mail.gmail.com>
References: <20180829170015.7729-1-semen.protsenko@linaro.org> <20180829170015.7729-2-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180829170015.7729-2-semen.protsenko@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 29, 2018 at 8:00 PM, Sam Protsenko
<semen.protsenko@linaro.org> wrote:
> The kernel is self-contained project and can be built with bare-metal
> toolchain. But bare-metal toolchain doesn't define __linux__. Because of
> this u_quad_t type is not defined when using bare-metal toolchain and
> codafs build fails. This patch fixes it by defining u_quad_t type
> unconditionally.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> ---
>  include/linux/coda.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/coda.h b/include/linux/coda.h
> index d30209b9cef8..0ca0c83fdb1c 100644
> --- a/include/linux/coda.h
> +++ b/include/linux/coda.h
> @@ -58,8 +58,7 @@ Mellon the rights to redistribute these changes without encumbrance.
>  #ifndef _CODA_HEADER_
>  #define _CODA_HEADER_
>
> -#if defined(__linux__)
>  typedef unsigned long long u_quad_t;
> -#endif
> +
>  #include <uapi/linux/coda.h>
>  #endif
> --
> 2.18.0
>

Hi guys,

It's been a while since I sent this patch. Can we please merge it if
there is no objections?

Thanks.
