From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] mvumi: remove fake transport template
Date: Mon, 30 Jan 2017 16:29:26 +0100
Message-ID: <f9b9f1ee-2a4f-4a7b-0a9e-f66b60a70038@suse.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
 <1485778739-29036-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41687 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753657AbdA3Par (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 10:30:47 -0500
In-Reply-To: <1485778739-29036-2-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 01/30/2017 01:18 PM, Christoph Hellwig wrote:
> These days we can specify an eh_timed_out handler in the host_template,
> so don't have a transport_template defintion just for it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/mvumi.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
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
