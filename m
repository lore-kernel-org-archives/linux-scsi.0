From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: use_sg != 0 assumption (was Re: [PATCH 5/9] Drop single buffer
 request support.)
Date: Thu, 10 May 2007 15:09:55 +0200
Message-ID: <464319A3.3070905@s5r6.in-berlin.de>
References: <11787529952207-git-send-email-krh@redhat.com> <11787530023454-git-send-email-krh@redhat.com> <11787530031570-git-send-email-krh@redhat.com> <11787530031450-git-send-email-krh@redhat.com> <11787530043878-git-send-email-krh@redhat.com> <4642F627.5040400@s5r6.in-berlin.de> <20070510114411.GA17971@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:37620 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbXEJNKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 09:10:55 -0400
In-Reply-To: <20070510114411.GA17971@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kristian H?gsberg <krh@redhat.com>, linux1394-devel <linux1394-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, May 10, 2007 at 12:38:31PM +0200, Stefan Richter wrote:
>> Would a BUG_ON(cmd->use_sg == 0); be in order?
> 
> I don't think we should put this into every driver.  If you want to
> be sure this doesn't happen anymore put it just in front of the queuecommand
> call.

Thanks for the pointer.  I'm just noticing that Jens Axboe has a patch
which puts BUG_ON(!cmd->use_sg); into scsi_lib.c's sg table allocation
path.  (The "Chaining sg lists for bio IO commands v3" patchset from a
few hours ago, part 11/13 "SCSI: support for allocating large
scatterlists".)
-- 
Stefan Richter
-=====-=-=== -=-= -=-=-
http://arcgraph.de/sr/
