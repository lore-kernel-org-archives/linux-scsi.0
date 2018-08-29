From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: Re: [PATCH 2/2] scsi: aic7xxx: Fix build using bare-metal toolchain
Date: Wed, 29 Aug 2018 17:01:00 +0300
Message-ID: <CAKaJLVsPYG8CvOj1NjBuH4GrfobfXvsLeQE6kFEiyRkSZ_Omaw@mail.gmail.com>
References: <20180828142421.15335-1-semen.protsenko@linaro.org>
 <20180828142421.15335-3-semen.protsenko@linaro.org> <20180829063244.GA32392@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180829063244.GA32392@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 29, 2018 at 9:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Aug 28, 2018 at 05:24:21PM +0300, Sam Protsenko wrote:
>> Bare-metal toolchains don't define __linux__, so aic7xxx build with
>> bare-metal toolchain is broken. Let's check __KERNEL__ definition
>> instead of __linux__ (as this code won't be build for user-space anyway)
>> in order to fix that.
>
> Please just drop the ifdefs entirely.  The codebase used to be partially
> shared with at least FreeBSD, but these days there is no point in
> keeping the compatibility around.

Thanks, Christoph. Will do in v2.
