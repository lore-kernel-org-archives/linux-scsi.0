From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/20] scsi_dh_alua: call alua_rtpg() if stpg fails
Date: Wed, 30 Dec 2015 12:10:42 +0100
Message-ID: <20151230111042.GC13951@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49164 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475AbbL3LKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 06:10:44 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2015 at 08:37:24AM +0100, Hannes Reinecke wrote:
> If the call to SET TARGET PORT GROUPS fails we have no idea what
> state the array is left in, so we need to issue a call to
> REPORT TARGET PORT GROUPS in these cases.

Reviewed-by: Christoph Hellwig <hch@lst.de>
