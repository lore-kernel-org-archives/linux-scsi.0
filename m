From: David Zeuthen <david@fubar.dk>
Subject: Re: scsi "target1:0:0"
Date: Tue, 16 Nov 2004 12:23:03 -0500
Message-ID: <1100625783.4546.4.camel@davidz>
References: <1100622096.8606.104.camel@localhost.localdomain>
	 <1100622800.2574.41.camel@mulgrave>
	 <1100624154.8606.122.camel@localhost.localdomain>
	 <20041116171018.GK26623@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40353 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262064AbUKPRVK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 12:21:10 -0500
In-Reply-To: <20041116171018.GK26623@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <jejb@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-11-16 at 17:10 +0000, Matthew Wilcox wrote:
> There you go, it's just another example of this one.  It's just faulty
> assumptions in hald by the looks of things.
> 

Please explain how you expect userspace to keep track of the device tree
and enforce policy if we don't get hotplug events for things in the
middle of the tree?

Thanks,
David


