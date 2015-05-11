From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/17] scsi_dh_alua: revert commit
	a8e5a2d593cbfccf530c3382c2c328d2edaa7b66
Date: Mon, 11 May 2015 09:00:25 +0200
Message-ID: <20150511070025.GI30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39052 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbbEKHA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 03:00:28 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:19PM +0200, Hannes Reinecke wrote:
> Obsoleted by the next patch.

Please use a descriptive subject, and the mention the commit name in the
message body in the canonical format:  commit a8e5a2 ("[SCSI] scsi_dh_alua:
ALUA handler attach should succeed while TPG is transitioning");
