From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: fixup error message in
 target_tg_pt_gp_tg_pt_gp_id_store()
Date: Mon, 01 May 2017 22:17:10 -0700
Message-ID: <1493702230.23202.60.camel@haakon3.risingtidesystems.com>
References: <1493366644-8534-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34227 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdEBFRM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2017 01:17:12 -0400
In-Reply-To: <1493366644-8534-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, Bart van Assche <bart.vanassche@sandisk.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2017-04-28 at 10:04 +0200, Hannes Reinecke wrote:
> When setting up an ALUA target port group with an invalid ID the
> error message
> 
> kstrtoul() returned -22 for tg_pt_gp_id
> 
> is displayed, which is not really helpful.
> Convert it to something sane.
> And while we're at it, join the messages onto a single line.
> 
> Signed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/target/target_core_configfs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Applied.

Thanks Hannes.
