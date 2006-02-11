From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 11 Feb 2006 13:05:40 +0000
Message-ID: <20060211130540.GR27946@ftp.linux.org.uk>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:18379 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1751419AbWBKNFl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Feb 2006 08:05:41 -0500
Content-Disposition: inline
In-Reply-To: <43EDB35F.40709@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sat, Feb 11, 2006 at 10:50:23AM +0100, Stefan Richter wrote:
> Interesting. Many PL3507 come with buggy firmware which is noticed under 
> other OSs too. Newer hardware revisions can be reprogrammed but I don't 
> know where the latest firmware is available and whether it fixes this 
> INQUIRY related bug.

Newer hardware revisions can be reprogrammed, but it's Windows-only and
price of OXFW911-based enclosure was lower than that of Windows install
media or a new box that would have it preinstalled.  If somebody in nc.us
wants to experiment with that junk, they are welcome to it; I don't have
Windows boxen and have better things to spend time and money on...

> Do you think a workaround (like perhaps "reject all INQUIRY commands 
> except the first one after login") would be justified?

Not really...  Blacklisting that FPOS and recommending to replace it
with real bridge is saner solution, IMO.
