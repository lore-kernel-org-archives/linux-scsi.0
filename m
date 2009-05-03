From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 3 May 2009 09:11:54 -0600
Message-ID: <20090503151153.GS8822@parisc-linux.org>
References: <49FDA2CA.4040601@tremplin-utc.net> <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58198 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZECPLy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 11:11:54 -0400
Content-Disposition: inline
In-Reply-To: <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ?ric Piel <eric.piel@tremplin-utc.net>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Sun, May 03, 2009 at 09:57:15AM -0500, James Bottomley wrote:
> Actually, I'd really rather not alter the default value of this setting.
> Multi-lun is rapidly becoming obsolete: any modern devices conforming to
> SCSI-3 use REPORT LUNS instead of doing LUN scanning, which gets us out
> of the issue.  Conversely, the ancient devices which rely on correctly
> setting this are more likely to get upset about any change in the
> balance.

Yes, but USB devices are prohibited from being SCSI-3 devices, so it's
not becoming obsolete.

> In your case, just add the changer's inquiry strings with a
> BLIST_FORCELUN.

I wonder if we should make USB devices set that by default?  What does
Windows do here?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
