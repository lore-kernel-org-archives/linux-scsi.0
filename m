From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage -
	pass	larger receive buffer
Date: 13 Nov 2003 17:16:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068769001.2851.2.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131702560.949-100000@ida.rowland.org>
	 <1068766852.2851.155.camel@patrh9>
	 <1068767483.3fb418fb45b65@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:27285 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264472AbTKNARQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 19:17:16 -0500
In-Reply-To: <1068767483.3fb418fb45b65@webmail.netregistry.net>
List-Id: linux-scsi@vger.kernel.org
To: dmitrik@users.sourceforge.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org

> > > > Anybody able to clue me in quickly as to why classifying a
> device as
> > > > writable or not, rather than a disc, can ever be meaningful?
> > > 
> > > The notion makes sense for tape drives as well.
> > 
> > Re write-protect, personally I know only of discs that have
> > write-protect tabs.
> 
> Memory sticks have write-protect switches on them.

Ouch again I feel confused sorry.

The memory stick is like a disc, yes?  We insert the stick into a slot,
yes?  The slot does not itself have a switch - only the stick has a
switch.  We cannot speak of the slot being write-protected, we can only
speak of the stick being write-protected, yes?

Therefore, with a memory stick as with a classic "1.44MB" floppy, we say
the "disc" has a write-protect tab but the "drive" does not?

Pat LaVarre


