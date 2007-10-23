From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/4] aic7xxx: Enable 16-bit CDBs
Date: Tue, 23 Oct 2007 12:56:52 -0400
Message-ID: <1193158612.6294.9.camel@localhost.localdomain>
References: <20071019083239.D88FE18C61E@pentland.suse.de>
	 <1192983563.3339.4.camel@localhost.localdomain>
	 <20071022034605.GB8421@parisc-linux.org> <471C4845.20708@suse.de>
	 <20071022112345.GC8421@parisc-linux.org>  <471C9030.6030700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42780 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752365AbXJWQ4z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 12:56:55 -0400
In-Reply-To: <471C9030.6030700@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Mon, 2007-10-22 at 13:57 +0200, Hannes Reinecke wrote:
> Matthew Wilcox wrote:
> > On Mon, Oct 22, 2007 at 08:50:45AM +0200, Hannes Reinecke wrote:
> >> That's what I thought, too. Hence the patch.
> >> But if we set the default to 16 byte cdbs you can of course ignore
> >> the patch.
> > 
> > I think the comment in hosts.c explains why we shouldn't do that ...
> > 
> _I_ certainly wouldn't. But if the maintainer says so :-)

Actually, I misremembered.  I thought I did a commit a few years ago
that automatically raised the cutoff to 16 byte cdbs and forced drivers
who couldn't do that to lower the limit, but apparently it was never
merged.

So, just pick either 16 or 32 for both drivers and add that as the max
cdb size.

James


