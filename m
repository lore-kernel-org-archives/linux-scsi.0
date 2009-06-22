From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH update 2] SCSI: explain the hidden scsi_wait_scan
	Kconfig variable
Date: Mon, 22 Jun 2009 05:02:30 -0600
Message-ID: <20090622110229.GR19977@parisc-linux.org>
References: <4A384FE4.9090703@gmail.com> <20090617021254.GQ19977@parisc-linux.org> <tkrat.ad6f8fb712020451@s5r6.in-berlin.de> <1245338486.7586.13.camel@mulgrave.site> <20090618165926.GA13229@uranus.ravnborg.org> <tkrat.da2728358fccf96e@s5r6.in-berlin.de> <20090622095701.72c22150@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47139 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFVLC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2009 07:02:28 -0400
Content-Disposition: inline
In-Reply-To: <20090622095701.72c22150@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Sam Ravnborg <sam@ravnborg.org>, Changli Gao <xiaosuo@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jun 22, 2009 at 09:57:01AM +0100, Alan Cox wrote:
> On Thu, 18 Jun 2009 21:03:23 +0200 (CEST)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
> > People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> > item.  These patches aren't accepted upstream, so let's stop the ongoing
> > irritation of people due to the unconditionally installed module and its
> > Kconfig symbol.
> 
> How about the other possibility. People keepmaking it tunable because it
> makes sense for it to be tunable. Far better IMHO to make it tunable "if
> EMBEDDED"

It doesn't make sense for it to be tunable.

All it does is control whether or not scsi_wait_scan.ko is built.
Everyone who's complained about it has been of the form "I turned off
all modules, but this module gets built anyway".  For them, the answer
is simple: Don't run "make modules_install".

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
