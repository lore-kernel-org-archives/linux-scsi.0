From: Matthew Wilcox <matthew@wil.cx>
Subject: Needed: advansys driver testers
Date: Sun, 23 Sep 2007 08:16:57 -0600
Message-ID: <20070923141657.GH10625@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46571 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXIWOQ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Sep 2007 10:16:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


I've removed all uses of bus_to_virt[1] and virt_to_bus from the advansys
driver for the narrow card; it's now at the point where I can get 8MB/s
on a parisc machine [2].  But I don't have a wide advansys card, and the code
paths in the driver are very, very different.  I think I know everything
that needs to be done to make it work, but not having a card to test with,
and not being infallible makes life tricky.

So, anyone got a *wide* advansys card that they would like to test with?
Bonus points if you have ethnic hardware to plug it into; something with
an IOMMU like ia64, parisc or sparc64 would be a real bonus.  Or if you
have such a card, and don't want it any more, I'll take it off your hands.

[1] A highly evil interface from the bad old days when machines only had
one bus and no iommus.
[2] 10MHz bus, 8 bits wide ... I'm at 80% bus utilisation, that's not too
shabby.  I've not looked into performance yet, only getting it working.
I've got a scsi analyser, and this seems like a great opportunity to
learn how to use it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
