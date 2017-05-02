From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: fixup error message in
 target_tg_pt_gp_alua_access_type_store()
Date: Mon, 01 May 2017 22:16:51 -0700
Message-ID: <1493702211.23202.59.camel@haakon3.risingtidesystems.com>
References: <1493366618-8460-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55354 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdEBFQy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 01:16:54 -0400
In-Reply-To: <1493366618-8460-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, Bart van Assche <bart.vanassche@sandisk.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, 2017-04-28 at 10:03 +0200, Hannes Reinecke wrote:
> When setting up a target the error message:
> 
> Unable to do set ##_name ALUA state on non valid tg_pt_gp ID: 0
> 
> is displayed.
> Apparently concatenation doesn't work in a string; one should be using
> implicit string concatenation here.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>
> ---
>  drivers/target/target_core_configfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied.

Thanks Hannes.
