From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by sd_read_cache_type
Date: Sun, 26 Feb 2006 08:22:06 +0000
Message-ID: <20060226082206.GN27946@ftp.linux.org.uk>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de> <20060225021009.GV3883@sorel.sous-sol.org> <4400E34B.1000400@s5r6.in-berlin.de> <20060225232201.GK27946@ftp.linux.org.uk> <4401629C.8070803@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:60579 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1751262AbWBZIWW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 03:22:22 -0500
Content-Disposition: inline
In-Reply-To: <4401629C.8070803@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Linus Torvalds <torvalds@osdl.org>, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Feb 26, 2006 at 09:11:08AM +0100, Stefan Richter wrote:
> Al Viro wrote:
> >Speaking of sbp2 problems...  Why the _hell_ are we blacklisting on
> >firmware revision alone?  Especially with entries like "all firmware
> >with 2.<whatever> as version is broken"...
> 
> The firmware_revision CSR key value has so far been a good method to 
> guesstimate the bridge chip. I don't know a better one.

Umm...  What about ->vendor_name_kv (plus firmware_revision, obviously)?
 
> I posted an improved blacklisting patch a few days ago. Among other 
> small cleanups, I removed skip_ms_page_8 from the Initio blacklist entry.
> http://marc.theaimsgroup.com/?l=linux1394-devel&m=114065678722190

FWIW, that puppy appears to live just fine without forcing 36byte
inquiry here...
