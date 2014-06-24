From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Tue, 24 Jun 2014 08:52:38 -0700
Message-ID: <20140624155238.GA27828@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140611120143.GA26071@infradead.org>
 <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
 <20140611143128.GA30904@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34568 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaFXPwn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2014 11:52:43 -0400
Content-Disposition: inline
In-Reply-To: <20140611143128.GA30904@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

I've pushed another update to the core-for-3.16 branch.  This includes
the two error handling fixes (Ewan verified that Hannes patch fixes the
issues he was seeing), and the fix for the iscsi regression:

Hannes Reinecke (1):
	scsi_error: set DID_TIME_OUT correctly

Martin K. Petersen (1):
	scsi: use the scsi data buffer length to extract transfer size

Ulrich Obergfell (1):
	scsi_error: fix invalid setting of host byte

 drivers/scsi/scsi_error.c |   20 ++++++++++----------
 include/scsi/scsi_cmnd.h  |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

