From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: Re: [PATCH 1/2] codafs: Fix build using bare-metal toolchain
Date: Wed, 29 Aug 2018 17:03:44 +0300
Message-ID: <CAKaJLVvhGGoVnWxaDGN60ySiZ_y4xOUkamNQRnad3V7SNsNL-A@mail.gmail.com>
References: <20180828142421.15335-1-semen.protsenko@linaro.org>
 <20180828142421.15335-2-semen.protsenko@linaro.org> <20180829063347.GB32392@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180829063347.GB32392@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 29, 2018 at 9:33 AM, Christoph Hellwig <hch@infradead.org> wrote:
> Please just drop the ifdef entirely.  The file is part of the kernel
> tree and can't be used for anything non-Linux.

I have better idea :) We can modify include/linux/coda.h instead, by
checking for __KERNEL__ (along with existing check for __linux__).
This way we can leave user-space API header alone. Don't know how come
I didn't notice that in the first place... Anyway, will send v2
shortly. Thanks for the review.
