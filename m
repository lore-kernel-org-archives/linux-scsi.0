From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by sd_read_cache_type
Date: Sun, 26 Feb 2006 09:11:08 +0100
Message-ID: <4401629C.8070803@s5r6.in-berlin.de>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de> <20060225021009.GV3883@sorel.sous-sol.org> <4400E34B.1000400@s5r6.in-berlin.de> <20060225232201.GK27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:29384 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751259AbWBZIMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 03:12:46 -0500
In-Reply-To: <20060225232201.GK27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Linus Torvalds <torvalds@osdl.org>, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Al Viro wrote:
> Speaking of sbp2 problems...  Why the _hell_ are we blacklisting on
> firmware revision alone?  Especially with entries like "all firmware
> with 2.<whatever> as version is broken"...

The firmware_revision CSR key value has so far been a good method to 
guesstimate the bridge chip. I don't know a better one.

> Case in point: Initio bridge, firmware revision 2.21.  Couldn't care
> less about long INQUIRY, doesn't need skip_ms_page_8, *DOES* need
> correctly detected cache type.
...

I agree.

I posted an improved blacklisting patch a few days ago. Among other 
small cleanups, I removed skip_ms_page_8 from the Initio blacklist entry.
http://marc.theaimsgroup.com/?l=linux1394-devel&m=114065678722190
-- 
Stefan Richter
-=====-=-==- --=- ==-=-
http://arcgraph.de/sr/
