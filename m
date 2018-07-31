From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 1/9] ide-cd: Drop unused sense buffers
Date: Tue, 31 Jul 2018 14:29:59 -0700 (PDT)
Message-ID: <20180731.142959.500369535656671181.davem@davemloft.net>
References: <20180731195155.46664-1-keescook@chromium.org>
        <20180731195155.46664-2-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731195155.46664-2-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: keescook@chromium.org
Cc: axboe@kernel.dk, hch@infradead.org, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, tj@kernel.org, bp@alien8.de, manoj@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, nab@linux-iscsi.org, tglx@linutronix.de, pombredanne@nexb.com, sboyd@codeaurora.org, cyrille.pitchen@free-electrons.com, jgross@suse.com, viresh.kumar@linaro.org, u.kleine-koenig@pengutronix.de, sdharia@codeaurora.org, rdunlap@infradead.org, vinod.koul@intel.com, david.kershner@unisys.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Tue, 31 Jul 2018 12:51:46 -0700

> This drops unused sense buffers from:
> 
> 	cdrom_eject()
> 	cdrom_read_capacity()
> 	cdrom_read_tocentry()
> 	ide_cd_lockdoor()
> 	ide_cd_read_toc()
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Acked-by: David S. Miller <davem@davemloft.net>
