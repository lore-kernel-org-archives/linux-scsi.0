From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/5] aic7xxx: remove rules for shipped files
Date: Fri, 4 Aug 2017 10:41:47 +0200
Message-ID: <13602e60-f97f-34e3-638c-0a50d221173f@suse.de>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
 <759ba18717a785f8875b74efe01ba26920d55006.1501802727.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38633 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751284AbdHDIlt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 04:41:49 -0400
In-Reply-To: <759ba18717a785f8875b74efe01ba26920d55006.1501802727.git.mirq-linux@rere.qmqm.pl>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 08/04/2017 01:28 AM, Michał Mirosław wrote:
> There are Kbuild rules for that already.
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/scsi/aic7xxx/Makefile | 4 ----
>  1 file changed, 4 deletions(-)
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
