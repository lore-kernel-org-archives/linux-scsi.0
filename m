From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 9/9] scsi: Check sense buffer size at build time
Date: Wed, 1 Aug 2018 01:25:16 -0700
Message-ID: <20180801082516.GE26378@infradead.org>
References: <20180731195155.46664-1-keescook@chromium.org>
 <20180731195155.46664-10-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180731195155.46664-10-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutro>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 31, 2018 at 12:51:54PM -0700, Kees Cook wrote:
> To avoid introducing problems like those fixed in commit f7068114d45e
> ("sr: pass down correctly sized SCSI sense buffer"), this creates a macro
> wrapper for scsi_execute() that verifies the size of the sense buffer
> similar to what was done for command string sizes in commit 3756f6401c30
> ("exec: avoid gcc-8 warning for get_task_comm").
> 
> Another solution could be to add a length argument to scsi_execute(),
> but this function already takes a lot of arguments and Jens was not fond
> of that approach.
> 
> Additionally, this moves the SCSI_SENSE_BUFFERSIZE definition into
> scsi_device.h, and removes a redundant include for scsi_device.h from
> scsi_cmnd.h.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
