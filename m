From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 05:08:36 -0500
Message-ID: <200710150508.37332.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52093
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbXJOKIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 06:08:41 -0400
In-Reply-To: <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Monday 15 October 2007 4:06:20 am Julian Calaby wrote:
> On 10/15/07, Rob Landley <rob@landley.net> wrote:
> > I note that the eth0 and eth1 names are dynamically assigned on a first
> > come first serve basis (like scsi).  This never causes me a problem
> > because the driver loading order is constant, and once you figure out
> > that eth0 is gigabit and eth1 is the 80211g it _stays_ that way across
> > reboots, reliably. Yeah, it's a heuristic.  Hands up everybody relying on
> > such a heuristic in the real world.
>
> Umm, not quite, from my experiences with pre-production wireless
> drivers, (another story, another time) fancy stuff is being done in
> udev to make sure that your gigabit card is always assigned to eth0.

I remember building a 2.4 kernel, statically linking in all the drivers, and 
getting the ethernet devices showing up in a reliable order for years.  Where 
does the need for fancy stuff come in?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
