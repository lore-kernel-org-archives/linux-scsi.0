From: Mark Haverkamp <markh@osdl.org>
Subject: Re: SCSI enclosure black list
Date: 14 Nov 2002 08:20:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037290824.30367.11.camel@markh1.pdx.osdl.net>
References: <1037225713.16638.85.camel@dell_ss3.pdx.osdl.net>
	 <1037227816.11996.203.camel@irongate.swansea.linux.org.uk>
	 <1037289000.30355.6.camel@markh1.pdx.osdl.net>
	 <1037291446.16000.37.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1037291446.16000.37.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Hemminger <shemminger@osdl.org>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org

On Thu, 2002-11-14 at 08:30, Alan Cox wrote:
> On Thu, 2002-11-14 at 15:50, Mark Haverkamp wrote:
> > On Wed, 2002-11-13 at 14:50, Alan Cox wrote:
> > > On Wed, 2002-11-13 at 22:15, Stephen Hemminger wrote:
> > > > > Thanks to Matt Domsch and Mark Haverkamp. Don't give up the good work
> > > > > the megaraid driver still needs better error handling.
> > > > 
> > > > The HP disk enclosures have the same behavior so use this patch instead:
> > > 
> > > Do they do the same with other drivers with known good error handling ?
> > > 
> 
> Ok so its triggering a megaraid bug, and the blacklist isnt appropriate

Wouldn't it still be reasonable to have the enclosure in the blacklist
since it doesn't seem to handle the report luns command?
-- 
Mark Haverkamp <markh@osdl.org>

