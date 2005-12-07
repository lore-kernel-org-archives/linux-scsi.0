From: James.Smart@Emulex.Com
Subject: RE: 2.6.15-rc4 error messages with multiple qla2300 hba ports on fabric
Date: Wed, 7 Dec 2005 16:41:04 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276CEE@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:16344 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030367AbVLGVl1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Dec 2005 16:41:27 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mdr@sgi.com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, hch@lst.de

> > My inclination is to look at what we have on the work queue 
> and see if we can
> > circumvent some of the flush calls.
> 
> Snooping the work queue?  That sounds a little, um, like a hack?
> If the code is correct, and the end result is correct, is the
> test for recursion level and the associated dump_stack() necessary?
> (Yeah, I know, newbie questions. :)

Well, my thinking is along the same lines... Also too much other work on
the sdevs, etc to really get a good feel for things. Plus that should be
handled by default in the other layers. However, I wouldn't address
it via eliminating the recursion level check.

We're testing a patch that deals with the recursion by not doing it. Oldest
trick in the book :)   Will keep you posted once we know the results.

-- james s
