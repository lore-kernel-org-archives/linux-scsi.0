From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/9] block: Switch struct packet_command to use struct
 scsi_sense_hdr
Date: Wed, 1 Aug 2018 01:22:20 -0700
Message-ID: <20180801082220.GA26378@infradead.org>
References: <20180731195155.46664-1-keescook@chromium.org>
 <20180731195155.46664-6-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180731195155.46664-6-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutro>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 31, 2018 at 12:51:50PM -0700, Kees Cook wrote:
> There is a lot of needless struct request_sense usage in the CDROM
> code. These can all be struct scsi_sense_hdr instead, to avoid any
> confusion over their respective structure sizes. This patch is a lot
> of noise changing "sense" to "sshdr", but the final code is more
> readable to distinguish between "sense" meaning "struct request_sense"
> and "sshdr" meaning "struct scsi_sense_hdr".

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
