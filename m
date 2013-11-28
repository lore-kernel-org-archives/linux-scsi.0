From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3.13] genetlink/pmcraid: use proper genetlink multicast
 API
Date: Thu, 28 Nov 2013 18:27:02 -0500 (EST)
Message-ID: <20131128.182702.413058319099526285.davem@davemloft.net>
References: <1385323766-30356-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3K1X1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2013 18:27:04 -0500
In-Reply-To: <1385323766-30356-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, anil_ravindranath@pmc-sierra.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, johannes.berg@intel.com

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 24 Nov 2013 21:09:26 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> The pmcraid driver is abusing the genetlink API and is using its
> family ID as the multicast group ID, which is invalid and may
> belong to somebody else (and likely will.)
> 
> Make it use the correct API, but since this may already be used
> as-is by userspace, reserve a family ID for this code and also
> reserve that group ID to not break userspace assumptions.
> 
> My previous patch broke event delivery in the driver as I missed
> that it wasn't using the right API and forgot to update it later
> in my series.
> 
> While changing this, I noticed that the genetlink code could use
> the static group ID instead of a strcmp(), so also do that for
> the VFS_DQUOT family.
> 
> Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied, thanks Johannes.
