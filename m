From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Reimplement the SG_FLAG_LUN_INHIBIT flag in sg's SG_IOCTL.
Date: Sat, 17 Dec 2005 12:28:02 +0000
Message-ID: <20051217122802.GA12725@infradead.org>
References: <20051216215447.GA25090@porkrind.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61062 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932570AbVLQM2D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Dec 2005 07:28:03 -0500
Content-Disposition: inline
In-Reply-To: <20051216215447.GA25090@porkrind.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Caldwell <david@porkrind.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 16, 2005 at 01:54:51PM -0800, David Caldwell wrote:
> scsi.c will normally overwrite the second byte of the command with the
> appropriate LUN info if the device is a SCSI 2 device. I have a device
> that uses the second byte of the cdb for something other than the LUN
> (yes, it is a stupid broken device). This flag allows such broken
> devices work.

scsi_request is hopefully not going to survive 2.6.16 so at this point
this patch is not interesting in this form.

