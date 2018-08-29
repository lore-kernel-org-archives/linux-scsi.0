From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] codafs: Fix build using bare-metal toolchain
Date: Tue, 28 Aug 2018 23:33:47 -0700
Message-ID: <20180829063347.GB32392@infradead.org>
References: <20180828142421.15335-1-semen.protsenko@linaro.org>
 <20180828142421.15335-2-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180828142421.15335-2-semen.protsenko@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Jan Harkes <jaharkes@cs.cmu.edu>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, Paul Sokolovsky <paul.sokolovsky@linaro.org>, Miklos Szeredi <mszeredi@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, Ruslan Bilovol <ruslan.bilovol@gmail.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Please just drop the ifdef entirely.  The file is part of the kernel
tree and can't be used for anything non-Linux.
