From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 4/4] scsi_debug: make dump_sector static
Date: Mon, 23 Feb 2015 13:23:55 -0500
Message-ID: <54EB703B.5060908@interlog.com>
References: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com> <1424298699-2581-5-git-send-email-tomas.winkler@intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51892 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbbBWSYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 13:24:11 -0500
In-Reply-To: <1424298699-2581-5-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 15-02-18 05:31 PM, Tomas Winkler wrote:
> fixes warning:
> warning: no previous prototype for =E2=80=98dump_sector=E2=80=99
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 80410f9588ba..ccbe1282e975 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2685,7 +2685,7 @@ resp_read_dt0(struct scsi_cmnd *scp, struct sde=
bug_dev_info *devip)
>   	return 0;
>   }
>
> -void dump_sector(unsigned char *buf, int len)
> +static void dump_sector(unsigned char *buf, int len)
>   {
>   	int i, j, n;
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
