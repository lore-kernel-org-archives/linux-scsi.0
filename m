From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SCSI enclosure black list
Date: 13 Nov 2002 22:50:16 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037227816.11996.203.camel@irongate.swansea.linux.org.uk>
References: <1037225713.16638.85.camel@dell_ss3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1037225713.16638.85.camel@dell_ss3.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <shemminger@osdl.org>
Cc: Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org

On Wed, 2002-11-13 at 22:15, Stephen Hemminger wrote:
> > Thanks to Matt Domsch and Mark Haverkamp. Don't give up the good work
> > the megaraid driver still needs better error handling.
> 
> The HP disk enclosures have the same behavior so use this patch instead:

Do they do the same with other drivers with known good error handling ?

