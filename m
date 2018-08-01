From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 8/9] libata-scsi: Move sense buffers onto stack
Date: Wed, 1 Aug 2018 08:45:02 -0700
Message-ID: <20180801154502.GO1206094@devbig004.ftw2.facebook.com>
References: <20180731195155.46664-1-keescook@chromium.org>
 <20180731195155.46664-9-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180731195155.46664-9-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Sagar
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 31, 2018 at 12:51:53PM -0700, Kees Cook wrote:
> To support future compile-time sizeof() checks that will be able to
> validate the length of sense buffers, this removes the only dynamically
> allocated sense buffers in the tree by putting the 96 byte sense buffers
> on the stack.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
