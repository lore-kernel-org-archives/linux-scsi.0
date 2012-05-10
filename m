From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/5] scsi_dh: add scsi_dh_attached_handler_name
Date: Thu, 10 May 2012 02:55:48 -0400
Message-ID: <20120510065548.GA5728@infradead.org>
References: <1336612366-30794-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41408
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569Ab2EJGzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2012 02:55:53 -0400
Content-Disposition: inline
In-Reply-To: <1336612366-30794-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, hare@suse.de, babu.moger@netapp.com, sekharan@us.ibm.com

On Wed, May 09, 2012 at 09:12:46PM -0400, Mike Snitzer wrote:
> Originally posted to dm-devel but Chandra reminded me to post to
> linux-scsi for James to pick it up.
> 
> -------8<-------
> 
> Introduce scsi_dh_attached_handler_name() to retrieve the name of the
> scsi_dh that is attached to the scsi_device associated with the provided
> request queue.  Returns NULL if a scsi_dh is not attached.
> 
> Also, fix scsi_dh_{attach,detach} function header comments to document
> @q rather than @sdev.

Wha'ts the use case for this?  The name is stale as soon as the function
returns.

