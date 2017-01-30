From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: remove eh_timed_out methods in the transport
 template
Date: Mon, 30 Jan 2017 16:30:15 +0100
Message-ID: <7f013609-fee9-ee5c-95de-ddf74a7805c0@suse.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
 <1485778739-29036-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753658AbdA3Par (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 10:30:47 -0500
In-Reply-To: <1485778739-29036-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 01/30/2017 01:18 PM, Christoph Hellwig wrote:
> Instead define the timeout behavior purely based on the host_template
> eh_timed_out method and wire up the existing transport implementations
> in the host templates.  This also clears up the confusion that the
> transport template method overrides the host template one, so some
> drivers have to re-override the transport template one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
