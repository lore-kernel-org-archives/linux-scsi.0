From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 16:40:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068766852.2851.155.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131702560.949-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:1425 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264468AbTKMXlZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 18:41:25 -0500
In-Reply-To: <Pine.LNX.4.44L0.0311131702560.949-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> > Anybody able to clue me in quickly as to why classifying a device as
> > writable or not, rather than a disc, can ever be meaningful?
> 
> The notion makes sense for tape drives as well.

Re write-protect, personally I know only of discs that have
write-protect tabs.

Are we saying some SCSI drives have write-protect switches also?  Only
tape drives or also the disk drives of sd and the disc drives of cdrom/
sr/ ide-cd?

Are we saying for some reason that we prefer detecting the write-protect
of such a drive once at plug in rather than again after each disc
insertion?  For what reason?

Pat LaVarre


