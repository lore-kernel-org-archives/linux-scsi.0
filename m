From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/8] target_core_alua: disallow READ_CAPACITY when in
	standby
Date: Fri, 19 Jun 2015 08:49:51 +0200
Message-ID: <20150619064951.GC1183@lst.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de> <1434620622-65391-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59559 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbbFSGtx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 02:49:53 -0400
Content-Disposition: inline
In-Reply-To: <1434620622-65391-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>

On Thu, Jun 18, 2015 at 11:43:41AM +0200, Hannes Reinecke wrote:
> Strictly speaking SPC doesn't require READ CAPACITY and friends
> to be supported while in the port is in standby.

But it does allow it.  We should always aim to implement the best
possible behavior instead of aiming for the worst.
