From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: USB storage devices and SAT
Date: Sun, 03 Aug 2008 20:33:13 -0500
Message-ID: <1217813594.4179.70.camel@localhost.localdomain>
References: <489656EC.5000602@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34513 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbYHDBdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 21:33:19 -0400
In-Reply-To: <489656EC.5000602@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Mon, 2008-08-04 at 03:10 +0200, Douglas Gilbert wrote:
> USB storage devices that support SAT (the T10 SCSI to ATA
> translation standard) are beginning to appear.

Um, confused.  The USB devices that were ATA under the covers already
have to do SAT since the USB storage transport mandates SCSI.

You mean they're now supporting ATA-12/16 pass through?  And will this
become standard for non-ATA USB storage (like flash)?

James


