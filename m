From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: read only scsi disk
Date: Thu, 09 Feb 2006 20:54:04 +0100
Message-ID: <43EB9DDC.2000108@s5r6.in-berlin.de>
References: <1139504647.9367.57.camel@localhost.localdomain> <20060209190225.GI1593@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56984 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750747AbWBITyf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 14:54:35 -0500
In-Reply-To: <20060209190225.GI1593@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ming Zhang <mingz@ele.uri.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Damian Pietras <daper@daper.net>

Matthew Wilcox wrote:
> Surely all iSCSI discs are removable, since anyone could unplug the
> network cable at any time ...

AFAIU, sdev->removable is about the medium, not about the device. Media 
can be hot-removed, devices can be hot-unplugged. (Of course an iSCSI 
target could implement removable media too.)
-- 
Stefan Richter
-=====-=-==- --=- -=--=
http://arcgraph.de/sr/
