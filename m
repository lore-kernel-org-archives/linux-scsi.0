From: Tobias Lieber <little.tobias@gmx.de>
Subject: Re: Patch for iriver-mp3player
Date: Mon, 28 Jun 2004 21:42:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040628214235.42870de6.little.tobias@gmx.de>
References: <20040606223250.GA15574@one-eyed-alien.net>
	<Pine.LNX.4.44L0.0406071017090.1800-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:16831 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265144AbUF1TnG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 15:43:06 -0400
In-Reply-To: <Pine.LNX.4.44L0.0406071017090.1800-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: mdharm-scsi@one-eyed-alien.net, James.Bottomley@SteelEye.com, lists@marcet.info, linux-scsi@vger.kernel.org

today i compiled todays linux-cvs, an my mp3-player worked, without patching the kernel....thanks to you....good work


Tobias Lieber

On Mon, 7 Jun 2004 10:36:22 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sun, 6 Jun 2004, Matthew Dharm wrote:
> 
> > We're actually trying to figure out the 'right way' to do this now.  Our
> > expectation is that there is some algorithmic way to determine if this bit
> > is "right" or not, as Windows seems to get it right without
> > white/blacklisting.
> 
> The two problems are similar but not quite the same.  The Panasonic
> DMC-LC40 camera reports correctly that it has removable media but then
> gets confused when it receives ALLOW MEDIUM REMOVAL.  The iRiver flash MP3
> player reports _incorrectly_ that it has removable media (that's what
> Javier says) and then gets confused when it receives PREVENT-ALLOW MEDIUM 
> REMOVAL.
> 
> It seems clear that the correct solution for the Panasonic is to clear the 
> sdev->lockable flag.  Is that also the correct solution for the iRiver, or 
> should we change the RMB flag in the INQUIRY response?  Clearing the 
> lockable flag is a lot easier and less invasive.
> 
> Alan Stern
> 
