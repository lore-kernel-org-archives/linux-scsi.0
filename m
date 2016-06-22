From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] scsi: make asynchronous aborts mandatory
Date: Wed, 22 Jun 2016 15:31:05 +0200
Message-ID: <20160622133104.GE6118@lst.de>
References: <1466415340-104465-1-git-send-email-hare@suse.de> <1466415340-104465-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52034 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbcFVNbc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 09:31:32 -0400
Content-Disposition: inline
In-Reply-To: <1466415340-104465-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Looks fine and probably should move toward the beginning of
the series:

Reviewed-by: Christoph Hellwig <hch@lst.de>
