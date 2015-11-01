From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Sat, 31 Oct 2015 21:56:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1510312152350.24212-100000@netrider.rowland.org>
References: <1446284350.4085.6.camel@giantmonkey.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:33197 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751060AbbKAB4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Oct 2015 21:56:12 -0400
In-Reply-To: <1446284350.4085.6.camel@giantmonkey.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <paul.menzel@giantmonkey.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, "James E. J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, 801925@bugs.debian.org

On Sat, 31 Oct 2015, Paul Menzel wrote:

> > Well, that didn't help much.  Paul hit another oops, this time in
> > sd_mod but again apparently related to runtime PM.  My patch only
> > touched sr_mod.
> > 
> > This time he sent photos of the complete oops; see
> > <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=801925;filename=20151020_005.jpg;att=4;msg=15>
> > and
> > <https://bugs.debian.org/cgi-bin/bugreport.cgi?filename=20151020_006.jpg;bug=801925;att=3;msg=15>
> 
> after backing up my data, I tested a little bit more, and using Linux
> 3.19 the drive is detected and the system boots.
> 
> Does anything stand out what changed in this area between Linux 3.19 and
> 4.1?

I believe the problem shown in that photo was fixed by commit
49718f0fb8c9 ("SCSI: Fix NULL pointer dereference in runtime PM"),
which was merged in 4.2 and has been back-ported to various stable 
releases.

Alan Stern

