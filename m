From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] Split SCSI header files
Date: Mon, 13 Apr 2015 11:44:38 +0200
Message-ID: <20150413094438.GA5259@lst.de>
References: <5523CE55.3090401@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60194 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbbDMJok (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 05:44:40 -0400
Content-Disposition: inline
In-Reply-To: <5523CE55.3090401@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

although I think patch 1 really should be split into two: one just
for the proto.h move, and one for the common module.
