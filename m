From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/4] scsi_dh_alua: do not call BUG_ON when updating
 port group
Date: Sun, 21 May 2017 00:19:36 -0700
Message-ID: <20170521071936.GA23589@infradead.org>
References: <20170512131508.3231-1-mwilck@suse.com>
 <20170512131508.3231-4-mwilck@suse.com>
 <1494606261.14477.3.camel@sandisk.com>
 <1494836189.4728.2.camel@suse.com>
 <1494864202.2567.1.camel@sandisk.com>
 <1494873019.4728.11.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdEUHTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2017 03:19:40 -0400
Content-Disposition: inline
In-Reply-To: <1494873019.4728.11.camel@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, May 15, 2017 at 08:30:19PM +0200, Martin Wilck wrote:
> please be assured that I'm not trying to paper over anything. Your
> concern about sdev->handler_data is justified. While I think that it's
> a separate issue from what my patches were supposed to address, let me
> see if I can come up with something more comprehensive.
> 
> It will take time, though, until I fully comprehend the locking concept
> of scsi_dh_alua.c.

I think a simple call_rcu for the cleanup in alua_bus_detach should
do the job.  And I agree with Bart that we need to sort this out
properly..
