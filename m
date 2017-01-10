From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC ATTEND] kernel booting using remote storage is a
 mess
Date: Tue, 10 Jan 2017 15:02:49 +0100
Message-ID: <20170110140249.GC3721@linux-x5ow.site>
References: <ee864cdd-11c3-63d6-51b7-b23b984fdbc6@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938830AbdAJOC5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Jan 2017 09:02:57 -0500
Content-Disposition: inline
In-Reply-To: <ee864cdd-11c3-63d6-51b7-b23b984fdbc6@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: lsf-pc@lists.linux-foundation.org, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jan 03, 2017 at 03:44:48PM -0800, Lee Duncan wrote:
> The process of booting a Linux kernel with remote storage (such as iSCSI
> or FCoE) seems unnecessarily complicated if end users can even figure
> out how to do it. This is of course exacerbated by the fact that every
> company seems to CNA cards differently despite the iBFT standard.
> 
> If you add DM-Multipath on top of that, most bets are off on your
> chances of getting it to reliably work.
> 
> I'd like to discuss how we can get this to work in a general way given
> the world of systemd that we live in now.

As this applies to FCoE as well as iSCSI I'd be very interested in this
session as well.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
