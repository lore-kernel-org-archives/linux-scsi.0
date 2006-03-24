From: Michael Stone <mstone@mathom.us>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Fri, 24 Mar 2006 07:32:30 -0500
Message-ID: <20060324123229.GH15140@mathom.us>
References: <20051114224512.GF9905@mathom.us>
 <20060323180909.GD15140@mathom.us>
 <1143139044.3415.26.camel@mulgrave.il.steeleye.com>
 <20060324122715.GG15140@mathom.us> <4423E65E.20005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms042pub.verizon.net ([206.46.252.42]:30009 "EHLO
	vms042pub.verizon.net") by vger.kernel.org with ESMTP
	id S932192AbWCXMch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 07:32:37 -0500
Received: from osgiliath.mathom.us ([151.200.254.241])
 by vms042.mailsrvcs.net (Sun Java System Messaging Server 6.2-4.02 (built Sep
 9 2005)) with ESMTPA id <0IWM007JSTI8L294@vms042.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Fri, 24 Mar 2006 06:32:33 -0600 (CST)
In-reply-to: <4423E65E.20005@suse.de>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 24, 2006 at 01:30:22PM +0100, Hannes Reinecke wrote:
>Well, yes. You can limit the transfer speed in the BIOS for that device.
>With the latest patches from scsi-misc we're finally picking them up :-)

I actually thought I had done that at one point when I was testing, but 
I'll double check next time I reboot at the console.

Mike Stone
