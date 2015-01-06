From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] vhost-scsi: Add missing virtio-scsi -> TCM attribute
 conversion
Date: Tue, 06 Jan 2015 13:46:03 -0800
Message-ID: <1420580763.6927.36.camel@haakon3.risingtidesystems.com>
References: <1420575485-16447-1-git-send-email-nab@daterainc.com>
	 <20150106210741.GA14536@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36409 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbbAFVqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 16:46:05 -0500
In-Reply-To: <20150106210741.GA14536@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>

On Tue, 2015-01-06 at 23:07 +0200, Michael S. Tsirkin wrote:
> On Tue, Jan 06, 2015 at 08:18:05PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > While looking at hch's recent conversion to drop the MSG_*_TAG
> > definitions, I noticed a long standing bug in vhost-scsi where
> > the VIRTIO_SCSI_S_* attribute definitions where incorrectly
> > being passed directly into target_submit_cmd_map_sgls().
> > 
> > This patch adds the missing virtio-scsi to TCM/SAM task attribute
> > conversion.
> > 
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Cc stable as well?
> 

That makes sense here, but anything < v3.19-rc will need to use the old
MSG_*_TAG defines.

Will fix up that once Greg-KH complains about the compile failure(s).

--nab



