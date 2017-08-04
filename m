From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v2 1/5] aic7xxx: remove empty function
Date: Fri, 4 Aug 2017 10:37:41 +0200
Message-ID: <220ad65d-7c8d-695e-ba80-36dc04a232c5@suse.com>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
 <14906cad961fe7ccb19276b1d1c5d332af7c8ef9.1501802727.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:37889 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdHDIhn (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 4 Aug 2017 04:37:43 -0400
In-Reply-To: <14906cad961fe7ccb19276b1d1c5d332af7c8ef9.1501802727.git.mirq-linux@rere.qmqm.pl>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 08/04/2017 01:28 AM, Michał Mirosław wrote:
> 
> ahc_platform_dump_card_state() does nothing. Remove it.
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/scsi/aic7xxx/aic7xxx_core.c | 1 -
>  drivers/scsi/aic7xxx/aic7xxx_osm.c  | 5 -----
>  drivers/scsi/aic7xxx/aic7xxx_osm.h  | 1 -
>  3 files changed, 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
