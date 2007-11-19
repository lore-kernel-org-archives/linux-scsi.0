From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: SCSI dynamic power management
Date: Mon, 19 Nov 2007 11:14:57 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAB02@otce2k301.adaptec.com>
References: <20071119154650.GC12494@parisc-linux.org> <Pine.LNX.4.44L0.0711191054360.4806-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:45897 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbXKSQO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 11:14:59 -0500
Content-class: urn:content-classes:message
In-Reply-To: <Pine.LNX.4.44L0.0711191054360.4806-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <matthew@wil.cx>
Cc: Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern sez:
> Sure.  But that won't do any good if the requests get held on 
> the queue
> (or failed immediately) because the disk is supposedly "suspended".
> Somehow those requests have to be allowed to proceed while all others 
> are forced to wait (or to fail).

Not a failure. Not ready is reported back in a check condition on a
media based request, a spin-up request is issued, then a subsequent loop
sits there probing every second with a Test Unit ready to wait for the
drive to spin back up. There is ample time provided in this path for the
drive to spin-up.

Sincerely -- Mark Salyzyn
