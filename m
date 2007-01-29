From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: AIC7xxx on 2.6.18
Date: Sun, 28 Jan 2007 19:05:15 -0600
Message-ID: <1170032715.4439.2.camel@mulgrave.il.steeleye.com>
References: <20070128194620.GA6358@animx.eu.org>
	 <20070128162408.9fffb6de.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55908 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932997AbXA2BFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jan 2007 20:05:32 -0500
In-Reply-To: <20070128162408.9fffb6de.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org

On Sun, 2007-01-28 at 16:24 -0800, Andrew Morton wrote:
> Yes, getting the oops traces will help, thanks.  And confirmation on a more
> recent kernel would be good.

Yes, this would be useful, thanks, definitely for the first oops (mixed
U160 and U cards).

I'd be curious to know what the problem with the OF card is, although
the only way to get them to work is to have the driver post the card,
which we don't have the documentation to make happen.

James


