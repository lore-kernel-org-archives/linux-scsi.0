From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 03 May 2009 10:21:08 -0500
Message-ID: <1241364068.5596.55.camel@mulgrave.int.hansenpartnership.com>
References: <49FDA2CA.4040601@tremplin-utc.net>
	 <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
	 <20090503151153.GS8822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58998 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866AbZECPVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 11:21:09 -0400
In-Reply-To: <20090503151153.GS8822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Sun, 2009-05-03 at 09:11 -0600, Matthew Wilcox wrote:
> On Sun, May 03, 2009 at 09:57:15AM -0500, James Bottomley wrote:
> > Actually, I'd really rather not alter the default value of this setting.
> > Multi-lun is rapidly becoming obsolete: any modern devices conforming to
> > SCSI-3 use REPORT LUNS instead of doing LUN scanning, which gets us out
> > of the issue.  Conversely, the ancient devices which rely on correctly
> > setting this are more likely to get upset about any change in the
> > balance.
> 
> Yes, but USB devices are prohibited from being SCSI-3 devices, so it's
> not becoming obsolete.

No they're not, there's nothing in the USB specs that say this.  UAS
will specifically require it.

The problem is we don't trust USB manufacturers with standards
compliance any further than they could spit a rat, so we assume when
they say they conform to SCSI-3 or above that they must have got it
wrong and push it back down to SCSI-2.

Because of this, no-one actually knows how many working SCSI-3 USB
devices we might have supported.

James


