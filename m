From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 11:04:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609110413.A15239@beaverton.ibm.com>
References: <20030609162056.GA1857@lst.de> <20030609094130.A14870@beaverton.ibm.com> <20030609165157.GA2079@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:60628 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261323AbTFIRzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 13:55:01 -0400
Content-Disposition: inline
In-Reply-To: <20030609165157.GA2079@lst.de>; from hch@lst.de on Mon, Jun 09, 2003 at 06:51:57PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

On Mon, Jun 09, 2003 at 06:51:57PM +0200, Christoph Hellwig wrote:

> eek, this one would still need ->command for some devices it appears.
> Looks like I should crap this patch or just disable support for that
> hw until soneone steps up to fix it.

The patch is a good idea, we ought to keep it.

We could move the ->command code (check for can_queue == 0) into the
drivers queuecommand function, and let them call their own "command"
function.

-- Patrick Mansfield
