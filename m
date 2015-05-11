From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/17] scsi_dh_alua: Pass buffer as function argument
Date: Mon, 11 May 2015 08:51:00 +0200
Message-ID: <20150511065100.GF30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39003 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbbEKGvB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 02:51:01 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:13PM +0200, Hannes Reinecke wrote:
> Pass in the buffer as a function argument for submit_vpd() and
> submit_rtpg().

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
