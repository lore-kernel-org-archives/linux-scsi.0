From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] storvsc: Don't set the
 SRB_FLAGS_QUEUE_ACTION_ENABLE flag
Date: Mon, 31 Aug 2015 08:01:58 -0600
Message-ID: <1441029718.13930.4.camel@HansenPartnership.com>
References: <1441034514-18853-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1441034514-18853-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, stable@vger.kernel.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-08-31 at 08:21 -0700, K. Y. Srinivasan wrote:
> Don't set the SRB_FLAGS_QUEUE_ACTION_ENABLE flag since we are not specifying
> tags.

What's the actual problem description this causes?

James


> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/storvsc_drv.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 40c43ae..ad8c4bc 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1647,8 +1647,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>  	vm_srb->win8_extension.time_out_value = 60;
>  
>  	vm_srb->win8_extension.srb_flags |=
> -		(SRB_FLAGS_QUEUE_ACTION_ENABLE |
> -		SRB_FLAGS_DISABLE_SYNCH_TRANSFER);
> +		SRB_FLAGS_DISABLE_SYNCH_TRANSFER;
>  
>  	/* Build the SRB */
>  	switch (scmnd->sc_data_direction) {
