From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Random scsi disk disappearing
Date: Thu, 17 Aug 2006 15:43:55 +0400
Message-ID: <44E4567B.4080104@tls.msk.ru>
References: <44E44B3E.10708@tls.msk.ru> <20060817113537.GK4340@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:62547 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S964819AbWHQLn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 07:43:59 -0400
In-Reply-To: <20060817113537.GK4340@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Aug 17, 2006 at 02:55:58PM +0400, Michael Tokarev wrote:
[sporadic disk disappearing, no logging]
> 
> I'd recommend turning on scsi logging; it might give you a clue about
> which bit of scanning is failing to work properly.
> 
> Try booting with scsi_mod.scsi_logging_level = 448 (I think I have that
> number right; 7 shifted left by 6) and then you can compare failing and
> non-failing runs and see if there's any difference.

It should be the same as
   echo $((7<<6)) > /sys/module/scsi_mod/parameters/scsi_logging_level
(which indeed is 448) at runtime, right?  (And yes, CONFIG_SCSI_LOGGING
is set to y).

Heh oh those magic numbers!.. ;)

Ok, I've turned on the logging on a bunch of machines (using the sysfs
method), let's see what will happen next.  Thank you!

By the way, should kernel pefrorm at least *some* "minimal" logging of
such a serious events by default?  Well ok, ok, it's not known yet what
the event really is, so I'm shutting up now, at least for a while.. ;)

/mjt
