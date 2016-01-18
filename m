From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 23/24] scsi_dh_alua: update 'access_state' field
Date: Mon, 18 Jan 2016 18:52:15 +0100
Message-ID: <20160118175215.GF24303@lst.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de> <1452672599-9820-24-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33495 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbcARRwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 12:52:17 -0500
Content-Disposition: inline
In-Reply-To: <1452672599-9820-24-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

Looks fine, although it will require some minor changes for the different
RCU usage that needs to go into the earlier patches.
