From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/9] block: Consolidate scsi sense buffer usage
Date: Thu, 02 Aug 2018 16:21:28 -0400
Message-ID: <yq18t5ozfhz.fsf@oracle.com>
References: <20180731195155.46664-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-1-keescook@chromium.org> (Kees Cook's
        message of "Tue, 31 Jul 2018 12:51:45 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutroni>
List-Id: linux-scsi@vger.kernel.org


Kees,

> This is a follow-up to commit f7068114d45e ("sr: pass down correctly
> sized SCSI sense buffer") which further cleans up and removes needless
> sense character array buffers and "struct request_sense" usage in favor
> of the common "struct scsi_sense_hdr".

This looks good to me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
