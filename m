From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Fix a scsi_host_dev_release() memory leak
Date: Wed, 25 Nov 2015 23:35:41 -0800
Message-ID: <20151126073541.GA23925@infradead.org>
References: <564F910E.9070306@sandisk.com>
 <yq137vtjumb.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbKZHfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2015 02:35:45 -0500
Content-Disposition: inline
In-Reply-To: <yq137vtjumb.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Nov 25, 2015 at 10:40:44PM -0500, Martin K. Petersen wrote:
> I gave a bunch of reviews for v1 but no takers for v2 of the second
> patch.

I think v1 is the right thing to do.  Sorry for leading Bart in the
wrong direction - the two different device structures in Scsi_Host
confused me.
