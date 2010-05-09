From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 15950] New: Hang in dc395x driver
Date: Sun, 09 May 2010 16:31:49 -0500
Message-ID: <1273440709.4466.3.camel@mulgrave.site>
References: <bug-15950-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab0EIVby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 May 2010 17:31:54 -0400
In-Reply-To: <bug-15950-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sun, 2010-05-09 at 21:19 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> I'm not sure when this problem started, but it's somewhere in the 2.6.2x
> region.
> 
> I'd be happy to recompile, test and debug if needed.

Retesting isn't necessary.  There have only been nine changes to that
driver in 2.6.2x.  The versions of interest (as in works/doesn't work)
should be

2.6.26 (should be identical to 2.6.31, so just a something else changed
sanity check)
2.6.25 (lots of pointless changes + sense buffer replacement)
2.6.34 (pid removal and sg chaining)
2.6.23 (accessors change)
2.6.22 (spelling only fix!)

James


