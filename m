From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/9] scsi_dh: integrate into the core SCSI code
Date: Tue, 5 May 2015 17:25:58 +0200
Message-ID: <20150505152558.GA4692@lst.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de> <1430415151-30948-6-git-send-email-hch@lst.de> <554724CE.1090002@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44104 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993382AbbEEP0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 May 2015 11:26:00 -0400
Content-Disposition: inline
In-Reply-To: <554724CE.1090002@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Mon, May 04, 2015 at 09:50:38AM +0200, Hannes Reinecke wrote:
> This doesn't compile; 'scsi_dh' is still at it's old location.

What error do you get?  While I haven't move the scsi_dh.c file it
now is built from driver/scsi using a relative path in the makefile,
and I needed this change for it to compile.
