From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 4/9] target: don't depend on SCSI
Date: Tue, 7 Aug 2018 07:44:49 +0200
Message-ID: <20180807054449.GA31556@lst.de>
References: <20180731195155.46664-1-keescook@chromium.org> <20180731195155.46664-5-keescook@chromium.org> <111cb1b0-24ba-bcb2-53d5-9665d2b4c421@infradead.org> <CAGXu5jKNeep01VOwC-dWsT4iDXrkBOhHJX0+4BEBotYOx1D0Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKNeep01VOwC-dWsT4iDXrkBOhHJX0+4BEBotYOx1D0Tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 06, 2018 at 04:59:04PM -0700, Kees Cook wrote:
> I wonder if LOOPBACK_TARGET is just missing a "depends on SCSI" as was
> added for TCM_PSCSI?

That is eactly the case.  LOOPBACK_TARGET is a scsi driver that
feeds commands into the target layer, so it needs a depends on SCSI.

Sorry for missing that earlier.
