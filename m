From: greg k-h <greg@kroah.com>
Subject: Re: scsi "target1:0:0"
Date: Tue, 16 Nov 2004 11:15:01 -0800
Message-ID: <pan.2004.11.16.19.14.54.941291@kroah.com>
References: <1100622096.8606.104.camel@localhost.localdomain> <1100622800.2574.41.camel@mulgrave> <1100624154.8606.122.camel@localhost.localdomain> <20041116171018.GK26623@parcelfarce.linux.theplanet.co.uk> <1100625783.4546.4.camel@davidz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39631 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S262121AbUKPTby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 14:31:54 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1CU93O-0004RA-00
	for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2004 20:31:50 +0100
Received: from c-67-171-180-138.client.comcast.net ([67.171.180.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2004 20:31:50 +0100
Received: from greg by c-67-171-180-138.client.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2004 20:31:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, 16 Nov 2004 12:23:03 -0500, David Zeuthen wrote:

> On Tue, 2004-11-16 at 17:10 +0000, Matthew Wilcox wrote:
>> There you go, it's just another example of this one.  It's just faulty
>> assumptions in hald by the looks of things.
>> 
> 
> Please explain how you expect userspace to keep track of the device tree
> and enforce policy if we don't get hotplug events for things in the
> middle of the tree?

You do get hotplug events for those devices in the device tree, just no 
bus is assigned to them, right?

That should still work out just fine, as Matthew has pointed out, other
devices in the device tree do not have busses either.

thanks,

greg k-h

