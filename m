From: James.Smart@Emulex.Com
Subject: RE: [PATCH 1/11]  lpfc 8.1.1: Miscellaneous Cleanups
Date: Mon, 28 Nov 2005 16:52:38 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B77@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15273 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751324AbVK1Vwo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 16:52:44 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

> Once you start touching these could we please get rid of the 
> bitfield for
> hardware registers abuse?  These should be proper 8/16/32 bit 
> members and
> then using bitmask as in all proper written drivers.

Agreed. A coding style that I've preached as well. But with 
existing code, it takes a while to adapt.

> That beeing said there's tons of sparse warnings in lpfc, in 
> large parts
> due to things like this.  Would be nice if someone at emulex 
> could get the
> driver sparse and endianess clean.

We'll add this to our todo list. Given the volume of the change,
don't look for this to be resolved too quickly. 

-- james s
