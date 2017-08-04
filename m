From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/5] aic7xxx: fix firmware build deps
Date: Fri, 4 Aug 2017 10:41:00 +0200
Message-ID: <ca8144e9-e03f-b639-86e1-fb95fe732617@suse.de>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
 <f97a697901a5a5ada4d8d1c5c0cce3c160f7f5e7.1501802727.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38565 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751285AbdHDIlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 04:41:02 -0400
In-Reply-To: <f97a697901a5a5ada4d8d1c5c0cce3c160f7f5e7.1501802727.git.mirq-linux@rere.qmqm.pl>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 08/04/2017 01:28 AM, Michał Mirosław wrote:
> We need to override Kbuild rules for copying shipped files, otherwise
> aic7xxx_reg.h and aic7xxx_reg_print.c will be ovewritten by old versions.
> 
> Fixes: 516b7db593f3a541e2e98867575c3c697f41a247
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/scsi/aic7xxx/Makefile | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
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
