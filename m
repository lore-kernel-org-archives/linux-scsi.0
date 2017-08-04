From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 4/5] aic7xxx: regenerate firmware files
Date: Fri, 4 Aug 2017 10:44:58 +0200
Message-ID: <2aa8e151-f7e2-646a-cd96-124c6eb17d6f@suse.de>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
 <082db9a483cb081834005fc18c2b333cb6cf3b0b.1501802727.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38863 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751291AbdHDIpA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 04:45:00 -0400
In-Reply-To: <082db9a483cb081834005fc18c2b333cb6cf3b0b.1501802727.git.mirq-linux@rere.qmqm.pl>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 08/04/2017 01:28 AM, Michał Mirosław wrote:
> Regenerate firmware files to make cleaner base for following fix.
> This removes some unused definitions and reorders some #defines, but
> the code remains the same.
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/scsi/aic7xxx/aic79xx_reg.h_shipped       | 1267 ++++------------------
>  drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped |   34 +-
>  drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped       |   44 +-
>  3 files changed, 235 insertions(+), 1110 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
