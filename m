From: Douglas Gilbert <dougg@torque.net>
Subject: Re: MegaSAS Hang on Smart Query
Date: Thu, 29 Jun 2006 23:03:26 -0400
Message-ID: <44A4947E.2090802@torque.net>
References: <3541.10.0.0.113.1151627385.squirrel@webmail.metacarta.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:14495 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964935AbWF3DDk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 23:03:40 -0400
In-Reply-To: <3541.10.0.0.113.1151627385.squirrel@webmail.metacarta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Baker <krbaker@metacarta.com>
Cc: linux-scsi@vger.kernel.org

Keith Baker wrote:
> I've been having a hang with 2.6.16.22 and the megasas driver.  I'm pretty
> sure it has to do with a smartctl -a <logical drive>.  The SCSI layer gets
> all sorts of in a twist.

Keith,
Could you add '-r ioctl,3' to the smartctl command line
to get a full debug output. Then we can see which SCSI
commands the megasas driver or hardware doesn't like.

> megasas: waiting for 2 commands to complete
> - repeats a bunch of times then -
> sd 0:2:0:0: rejecting I/O to offline device
> 
> Given a bit of wisdom in a driver distributed by dell which mentioned the
> controller not responding to a cache inqury...  isn't the correct thing to
> do respond with some sort of unsupported response?  not just ignore the
> query?

Correct. I'm sure the vendor knows what should be done.

> I've hunted around for patches around this problem but haven't found any,
> of course "don't use smart against a logical drive" works, but I'm not the
> only one using these boxes and it does cause the system to go down.

Doug Gilbert


