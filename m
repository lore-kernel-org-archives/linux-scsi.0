From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v2 18/31] scsi/aic7xxx: Clean up timer usage
Date: Thu, 21 Sep 2017 09:35:17 +0200
Message-ID: <a7be1d3a-fd4b-4b85-7308-1e33db2713e5@suse.com>
References: <1505950075-50223-1-git-send-email-keescook@chromium.org>
 <1505950075-50223-19-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:33068 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbdIUHff (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Thu, 21 Sep 2017 03:35:35 -0400
In-Reply-To: <1505950075-50223-19-git-send-email-keescook@chromium.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 09/21/2017 01:27 AM, Kees Cook wrote:
> stat_timer only ever assigns the same function and data, so consolidate to
> a setup_timer() call and drop everything else used to pass things around.
> 
> reset_timer is unused; remove it.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/scsi/aic7xxx/aic79xx.h      |  5 +----
>  drivers/scsi/aic7xxx/aic79xx_core.c | 29 ++++++++---------------------
>  2 files changed, 9 insertions(+), 25 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
