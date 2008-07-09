From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Media autochanger driver changed behavior.
Date: Wed, 09 Jul 2008 16:51:14 -0500
Message-ID: <1215640274.3444.42.camel@localhost.localdomain>
References: <487524B9.7000203@krogh.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59951 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbYGIVvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 17:51:18 -0400
In-Reply-To: <487524B9.7000203@krogh.cc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-07-09 at 22:51 +0200, Jesper Krogh wrote:
> Hi.
> 
> Upgrading the OS from an quite old kernel to a newer (2.6.24) changed
> the behavior of the "ch" driver. Now it does a inventory to the changer
> on load. This command makes the barcode-reader scan the entire library
> at driver load time.

Do I take it from this that your old kernel simply didn't auto load the
ch driver?  or that something has changed in the way the driver now
works?

I'm afraid ch.c is a bit of an orphan so tracking down the issue,
particularly if it's buried way back might take a while (on the brighter
side, there haven't been so many commits to the driver, so they can be
tested one by one).

James


