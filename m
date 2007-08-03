From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Thu, 2 Aug 2007 20:39:02 -0400
Message-ID: <200708022039.02387.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <200707271729.11422.rob@landley.net> <46B2256A.3070902@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48506
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751638AbXHCAjN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 20:39:13 -0400
In-Reply-To: <46B2256A.3070902@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thursday 02 August 2007 2:41:46 pm Douglas Gilbert wrote:
> > I'm still trying to figure what the other options _are_.
> >
> >> James
> >
> > Rob
>
> Interesting discussion.

I'm trying to pull together documentation of the scsi layer and link it into 
the index I'm trying to put up at http://kernel.org/doc, but I'm working 
under the handicap of never having used scsi hardware.

Technically I still don't own any scsi hardware except a scanner I've never 
gotten to work, but the scsi layer has now eaten my ide devices, it's 
handling my new sata hard drive which makes sas look even more hilarious than 
it did in 2005, and my vague impression is that the bsg patch turns my 
intended-as-joke question to James at OLS (so when do ramdisks start going 
through the scsi layer?) into a potential reality.  (Not that I pretend to 
understand the bsg code.)

I also didn't understand the rest of your message well enough to comment on 
any of it (does my USB key have a LUN?  The scsi layer grabbed it...)

> ** As noted above "all" is an overestimate. The pass-through
> only gets to map to devices that the sysfs/udev mess decides
> are relevant.

Don't get me started on udev.  As far as I can tell, Greg KH disagrees with me 
on every topic I've ever raised with him...

> Doug Gilbert

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
