From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/20] scsi_dh_alua: update all port states
Date: Wed, 30 Dec 2015 14:23:54 +0100
Message-ID: <20151230132354.GD15270@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49480 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbbL3NXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 08:23:55 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2015 at 08:37:34AM +0100, Hannes Reinecke wrote:
> When we read in the target port group state we should be
> updating all affected port groups, otherwise we risk
> running out of sync.

Why would we ever have multiple alua_port_group structures for the
same port that we'd need to iterate here?
