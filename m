From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: aic7xxx: Fix build using bare-metal toolchain
Date: Tue, 28 Aug 2018 23:32:44 -0700
Message-ID: <20180829063244.GA32392@infradead.org>
References: <20180828142421.15335-1-semen.protsenko@linaro.org>
 <20180828142421.15335-3-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180828142421.15335-3-semen.protsenko@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 28, 2018 at 05:24:21PM +0300, Sam Protsenko wrote:
> Bare-metal toolchains don't define __linux__, so aic7xxx build with
> bare-metal toolchain is broken. Let's check __KERNEL__ definition
> instead of __linux__ (as this code won't be build for user-space anyway)
> in order to fix that.

Please just drop the ifdefs entirely.  The codebase used to be partially
shared with at least FreeBSD, but these days there is no point in
keeping the compatibility around.
