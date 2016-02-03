From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM TOPIC] multiqueue and interrupt assignment
Date: Wed, 3 Feb 2016 15:32:35 +0200
Message-ID: <56B20173.10006@dev.mellanox.co.il>
References: <56B0D9CF.1080001@suse.de> <56B0F41B.8010706@sandisk.com>
 <56B1F951.5010001@dev.mellanox.co.il> <56B1FCFC.2010104@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37653 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbcBCNck (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 08:32:40 -0500
Received: by mail-wm0-f52.google.com with SMTP id l66so70516831wml.0
        for <Linux-scsi@vger.kernel.org>; Wed, 03 Feb 2016 05:32:39 -0800 (PST)
In-Reply-To: <56B1FCFC.2010104@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>


> Indeed, something like this.
> Quite some issues would be solved if we could push a hctx mapping
> into blk-mq, instead of having it assign its own made-up one.

For that you can provide your own .map_queue in blk_mq_ops I think
(no one does that at the moment). This requires every driver to
implement it's own routine (probably with a similar logic) though...
