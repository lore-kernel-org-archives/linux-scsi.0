From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/20] scsi_dh_alua: Allow workqueue to run
	synchronously
Date: Wed, 30 Dec 2015 14:20:10 +0100
Message-ID: <20151230132010.GB15270@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-13-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49471 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbbL3NUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 08:20:13 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-13-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2015 at 08:37:32AM +0100, Hannes Reinecke wrote:
> Some arrays may only capable of handling one STPG at a time,

Which arrays?  We should have a quirk for them in the devinfo database
instead of a module option.
