From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] scsi_dh_alua: add 'state' callback function
Date: Fri, 24 Jul 2015 16:42:31 +0200
Message-ID: <20150724144231.GB28970@lst.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55811 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbbGXOmd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:42:33 -0400
Content-Disposition: inline
In-Reply-To: <1436353788-104911-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

As per the comment on patch 3 I'd rather expose the ALUA state in the core
SCSI code.  But having this alua_state attribute in core SCSI code sounds
fine to me.
