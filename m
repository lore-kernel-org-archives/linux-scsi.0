From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] trivial: scsi: Fix warning on make htmldocs caused by
 scsi_transport_srp.c
Date: Mon, 03 Feb 2014 15:55:39 +0100
Message-ID: <52EFADEB.3030806@acm.org>
References: <1391438065-22267-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391438065-22267-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>, JBottomley@parallels.com, trivial@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/03/14 15:34, Masanari Iida wrote:
> This patch fixed following warnings on make htmldocs.
> 
> Warning(/drivers/scsi/scsi_transport_srp.c:819):
> No description found for parameter 'rport'
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/scsi/scsi_transport_srp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index d47ffc8..664eb38 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -811,6 +811,8 @@ EXPORT_SYMBOL_GPL(srp_remove_host);
>  /**
>   * srp_stop_rport_timers - stop the transport layer recovery timers
>   *
> + * @rport: SRP remote port to be removed
> + *
>   * Must be called after srp_remove_host() and scsi_remove_host(). The caller
>   * must hold a reference on the rport (rport->dev) and on the SCSI host
>   * (rport->dev.parent).

The comment added by this patch is wrong. That is easy to see by having
a look at the function name and function description.

In case anyone is wondering why this kerneldoc warning was not addressed
by commit 0c7f821: that patch was prepared against kernel v3.12-rc7 and
the warning reported above is new in kernel v3.14-rc1.

Bart.
