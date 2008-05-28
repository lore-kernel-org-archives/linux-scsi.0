From: Maarten Vanraes <maarten.vanraes@telenet.be>
Subject: Re: megaraid_sata vs megasr
Date: Wed, 28 May 2008 16:17:44 +0200
Message-ID: <200805281617.45169.maarten.vanraes@telenet.be>
References: <0631C836DBF79F42B5A60C8C8D4E8229010EF0FD@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from powered.by.e-leven.be ([88.82.32.98]:59739 "EHLO
	queen.hive.selfip.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYE1O0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2008 10:26:20 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229010EF0FD@NAMAIL2.ad.lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

So in effect, you are telling me that we bought fakeraid cards... since this 
is the "recommended driver"? is the card a hardware raid? or software.

We had specifically asked for hardware raid... :-(

Sincerely,

Maarten

Op Tuesday 27 May 2008 22:32:55 schreef Moore, Eric:
> On Tuesday, May 27, 2008 3:56 AM,  Maarten Vanraes wrote:
> > and lastly: mpt fusion? that sounds like a totally different
> > driver, any
> > reason as why to use that one?
>
> No, mpt fusion is not for megaraid controllers.    The megasr driver is
> the "software raid" driver stack over mpt fusion controller,  which is
> closed source, you should contact the megaraid team to get the entire
> driver.   The megaraid team also have their own bios to be used with
> these controllers, this bios will create a default raid volume when no
> one is present, thus corrupting the data,  hense you don't want to use
> the mpt fusion drivers for that megaraid controller.  The megasas driver
> is full hardware raid solution, like raid levels 0, 1, 5, 6, 10, 50, and
> 60.
>
> Eric


