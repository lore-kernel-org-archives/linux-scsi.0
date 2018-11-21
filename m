From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: Re: [PATCH v2] codafs: Fix build using bare-metal toolchain
Date: Wed, 21 Nov 2018 18:31:47 +0200
Message-ID: <CAKaJLVu0h5woVtN5=Mh38ajACBZZQ3JHfRhkjNrwMwYXHEG-NQ@mail.gmail.com>
References: <20181030202713.26203-1-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030202713.26203-1-semen.protsenko@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, kernel-janitors@vger.kernel.org, Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Andy Shevchenko <andy.shevchenko@gmail.com>, Praneeth Bajjuri <praneeth@ti.com>, Ruslan Bilovol <ruslan.bilovol@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 30, 2018 at 10:27 PM Sam Protsenko
<semen.protsenko@linaro.org> wrote:
>
> The kernel is self-contained project and can be built with bare-metal
> toolchain. But bare-metal toolchain doesn't define __linux__. Because of
> this u_quad_t type is not defined when using bare-metal toolchain and
> codafs build fails. This patch fixes it by defining u_quad_t type
> unconditionally.
>
> Cc: Jan Harkes <jaharkes@cs.cmu.edu>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
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
> 2.19.1
>

+ Jan Harkes, + Ruslan Bilovol

Hi Jan,

Can you please apply this? Nobody seems to be interested in taking
this patch, so I'm not sure how to proceed further. Please advice.

Thanks!
