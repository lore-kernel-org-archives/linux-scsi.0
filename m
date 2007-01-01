From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: [Fwd: Re: aic79xx+ASC39320A crash]
Date: Mon, 01 Jan 2007 00:18:25 -0800
Message-ID: <1167639505.27998.25.camel@home-desk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-nPmx8QqnAhD+HaEHMddO"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:39906 "EHLO iron2.pdx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933249AbXAAIS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jan 2007 03:18:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


--=-nPmx8QqnAhD+HaEHMddO
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-nPmx8QqnAhD+HaEHMddO
Content-Disposition: inline
Content-Description: Forwarded message - Re: aic79xx+ASC39320A crash
Content-Type: message/rfc822

Return-Path: <bjarne.thomsen@get2net.dk>
Delivered-To: 16-sean.bruno@dsl-only.net
Received: (qmail 31997 invoked from network); 1 Jan 2007 00:12:22 -0800
Received: from mx0.pdx.net (HELO silicon.pdx.net) (69.64.224.80) by
	iron2.pdx.net with (AES256-SHA encrypted) SMTP; 1 Jan 2007 00:12:22 -0800
Received: from mailfe08.tele2.dk ([212.247.154.227] helo=swip.net) by
	silicon.pdx.net with esmtp (Exim 4.50) id 1H1IHM-0000iU-EM for
	sean.bruno@dsl-only.net; Mon, 01 Jan 2007 00:12:25 -0800
X-Cloudmark-Score: 0.000000 []
Received: from [83.72.33.52] (account mp56609@get2net.dk HELO
	tycho.astronomy.dk) by mailfe08.swip.net (CommuniGate Pro SMTP 5.0.12) with
	ESMTPA id 369649050 for sean.bruno@dsl-only.net; Mon, 01 Jan 2007 09:12:17
	+0100
Subject: Re: aic79xx+ASC39320A crash
From: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
To: Sean Bruno <sean.bruno@dsl-only.net>
In-Reply-To: <1167593383.27998.16.camel@home-desk>
References: <1167559635.5863.28.camel@tycho.astronomy.dk>
	 <1167593383.27998.16.camel@home-desk>
Content-Type: text/plain
Date: Mon, 01 Jan 2007 09:12:16 +0100
Message-Id: <1167639136.6025.8.camel@tycho.astronomy.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-Spam-Checker-Version: SpamAssassin 3.1.7-pdx (2006-10-05) on
	silicon.pdx.net
X-Spam-Status: No, hits=-2.5, required=7  tests=BAYES_00=-2.599,
	FORGED_RCVD_HELO=0.135  autolearn=no version=3.1.7
X-Spam-Level: --
Content-Transfer-Encoding: 7bit

On Sun, 2006-12-31 at 11:29 -0800, Sean Bruno wrote:
> On Sun, 2006-12-31 at 11:07 +0100, Bjarne Thomsen wrote: 
> > The symptom is the same: the system freezes during the copy
> > of files from an IDE harddisk to a SCSI disk on the 39320 controller.
> 
> Is there any crash dump or panic information on your screen?
> 
> Also, try resetting the board to defaults in it's BIOS and see if that
> makes a difference.
> 
> Sean
> 
There is no crash dump or panic information.
The keyboard and mouse are dead.
Only the reset button works.

I tried to reset the 39320A BIOS to its default values.
The result of a cp from the IDE drive to the SCSI drive
was again a crash without a trace in the syslog file,
or on the screen.

 -- Bjarne



--=-nPmx8QqnAhD+HaEHMddO--

