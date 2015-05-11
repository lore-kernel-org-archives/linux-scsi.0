From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/17] scsi_dh_alua: use flag for RTPG extended header
Date: Mon, 11 May 2015 08:50:38 +0200
Message-ID: <20150511065038.GE30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38999 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbbEKGuk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 02:50:40 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

>  /* flags passed from user level */
>  #define ALUA_OPTIMIZE_STPG		1
> +#define ALUA_RTPG_EXT_HDR_UNSUPP	2

The comment is now incorrect.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
