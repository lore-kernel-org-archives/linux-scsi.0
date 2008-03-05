From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Wed, 05 Mar 2008 22:47:28 +0100
Message-ID: <47CF14F0.6060803@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0803051625450.4161-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48953 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbYCEVrh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 16:47:37 -0500
In-Reply-To: <Pine.LNX.4.44L0.0803051625450.4161-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Wed, 5 Mar 2008, Stefan Richter wrote:
>> sg, st, ch could be callers as well, but I suppose you don't really need 
>> them.  And for me, sd and sr already cover 99.9% of the use cases.
> 
> Those drivers don't export a block-device interface, do they?  So you 
> can't mount a filesystem on a device they control.

That's right, but users can "use" those devices.  ;-)
Anyway, go ahead with sd and sr only; I don't really care about having 
those calls in the other drivers.
-- 
Stefan Richter
-=====-==--- --== --=-=
http://arcgraph.de/sr/
