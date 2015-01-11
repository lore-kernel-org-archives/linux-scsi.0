From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] vhost-scsi: Add missing virtio-scsi -> TCM attribute
	conversion
Date: Sun, 11 Jan 2015 12:45:21 +0100
Message-ID: <20150111114521.GA11971@lst.de>
References: <1420575485-16447-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39257 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAKLpZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jan 2015 06:45:25 -0500
Content-Disposition: inline
In-Reply-To: <1420575485-16447-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

On Tue, Jan 06, 2015 at 08:18:05PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> While looking at hch's recent conversion to drop the MSG_*_TAG
> definitions, I noticed a long standing bug in vhost-scsi where
> the VIRTIO_SCSI_S_* attribute definitions where incorrectly
> being passed directly into target_submit_cmd_map_sgls().
> 
> This patch adds the missing virtio-scsi to TCM/SAM task attribute
> conversion.

Btw, ehat is your plan on ordered tag handling in the target code?
It's fairly broken as it doesn't respect 100% ordering, and as far as I can
tell it's always been like that.  Maybe it's better to not even advertise
it?
