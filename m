From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Sat, 31 Oct 2015 22:05:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1510312200080.24212-100000@netrider.rowland.org>
References: <1446284350.4085.6.camel@giantmonkey.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:51254 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751060AbbKACFd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2015 22:05:33 -0400
In-Reply-To: <1446284350.4085.6.camel@giantmonkey.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <paul.menzel@giantmonkey.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, "James E. J. Bottomley" <JBottomley@odin.com>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org

On Sat, 31 Oct 2015, Alan Stern wrote:

> I believe the problem shown in that photo was fixed by commit
> 49718f0fb8c9 ("SCSI: Fix NULL pointer dereference in runtime PM"),
> which was merged in 4.2 and has been back-ported to various stable 
> releases.

On second thought, it seems more likely that this issue probably was
_caused_ by that commit.  The fix can be found in these two emails:

	http://marc.info/?l=linux-scsi&m=144185206825609&w=2
	http://marc.info/?l=linux-scsi&m=144185208525611&w=2

which have not been merged yet as far as I know even though they were
submitted back in September.

Alan Stern

