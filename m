From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi_sysfs: Implement 'is_visible' callback
Date: Tue, 11 Feb 2014 23:57:43 -0800
Message-ID: <20140212075743.GA13498@infradead.org>
References: <1392129294-55235-1-git-send-email-hare@suse.de>
 <1392129294-55235-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1392129294-55235-2-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2014 at 03:34:53PM +0100, Hannes Reinecke wrote:
> Instead of modifying attributes after the device has been created
> we should be using the 'is_visible' callback to avoid races.

Can't say I like the fact that the is_visible function needs is
per-group and not per attribute and thus needs to explicitly check
which attribute we call it for, but that seems to be a design issue in
the driver core and not the patch.

Otherwise looks good with the minor nitpick that it would have looked
cleaner in the patch if you had left the queue_type store function
in the location it previously was.

Reviewed-by: Christoph Hellwig <hch@lst.de>
