From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/5] scsi: Add 'access_state' attribute
Date: Thu, 9 Jul 2015 10:22:17 +0200
Message-ID: <20150709082217.GA1419@lst.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51783 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbbGIIWT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 04:22:19 -0400
Content-Disposition: inline
In-Reply-To: <1436353788-104911-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Wed, Jul 08, 2015 at 01:09:46PM +0200, Hannes Reinecke wrote:
> Add an 'access_state' attribute to display the LUN access state.

Should we just reuse the ALUA values here as they part of the spec
and map the legacy implemetation values to it?

I'd also really love to store the access_state variable in
struct scsi_device so we can perform the checks for it in core code
instead of the device handlers.
