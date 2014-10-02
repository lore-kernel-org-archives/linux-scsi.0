From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] uas: Reduce number of function arguments for
 uas_alloc_foo functions
Date: Thu, 2 Oct 2014 04:24:13 -0700
Message-ID: <20141002112413.GB17628@infradead.org>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJBLYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 07:24:14 -0400
Content-Disposition: inline
In-Reply-To: <1412244280-15111-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 12:04:39PM +0200, Hans de Goede wrote:
> The stream_id and pipe are already present in uas_cmd_info resp uas_dev_info,
> so there is no need to pass a copy along.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
