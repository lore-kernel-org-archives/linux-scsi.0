From: Eric Kerin <eric@bootseg.com>
Subject: Re: 2.6.3 oops at kobject_unregister, alsa & aic7xxx
Date: Tue, 24 Feb 2004 01:05:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077602725.3172.19.camel@opiate>
References: <1077546633.362.28.camel@boxen>
	 <20040223160716.799195d0.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf18.cluster1.charter.net ([209.225.28.218]:15886 "EHLO
	mxsf18.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S262176AbUBXGL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 01:11:28 -0500
In-Reply-To: <20040223160716.799195d0.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Alexander Nyberg <alexn@telia.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2004-02-23 at 19:07, Andrew Morton wrote:
> Alexander Nyberg <alexn@telia.com> wrote:
> >
> > This happens at shutdown when alsa is to close down. I'm running debian
> > sid. NOTE: I recently removed my aic7xxx out of the motherboard, so the
> > driver obviously can't find it. But if I remove aic7xxx from the modules
> > list, this oops does _not_ happen.
> 
> That's useful infomation.  It indicates that the aic7xxx driver is screwing
> up the kobject lists.
> 
> Just to confirm: are you saying that the aic7xxx driver is loaded at the
> tie of the oops, but there is no aic7xxx hardware present in the machine?


I stumbled up this in early January.  I posted a patch to linux-scsi,
but it dosn't seem to be merged at this point.  This problem will also
occur with the aic79xx driver.

Here's the location of the original thread:
http://marc.theaimsgroup.com/?l=linux-scsi&m=107307695430108&w=2

I just tried the patch on 2.6.3, and it still applies cleanly.

Eric Kerin







