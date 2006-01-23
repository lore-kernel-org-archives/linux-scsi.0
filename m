From: Kalin KOZHUHAROV <kalin@thinrope.net>
Subject: Re: OOM Killer killing whole system
Date: Mon, 23 Jan 2006 11:56:37 +0900
Message-ID: <dr1gl8$tec$1@sea.gmane.org>
References: <1137337516.11767.50.camel@localhost> <200601202153.27386.chase.venters@clientec.com> <1137817289.11771.85.camel@localhost> <200601202235.48352.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751237AbWAWC5g@vger.kernel.org>
In-Reply-To: <200601202235.48352.chase.venters@clientec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Chase Venters wrote:
> On Friday 20 January 2006 22:21, Anton Titov wrote:
>> On Fri, 2006-01-20 at 21:53 -0600, Chase Venters wrote:
>>> Random guess... Asus P5GDC-V with Firewire and USB turned off?
>> Exactly (Asus P5GDC-V Deluxe actually, with few more things off). So
>> maybe it's ICH6?
> 
> Just a shot in the dark, but in the last few kernel revisions have you 
> experienced any SATA problems with DMA timeouts, in some versions leading to 
> a hang?

I have two of these boards and one of them is constantly hanging, just
simply dead. With 2.6.15 it reports failed I/O (SATA here) and mounts
reiserfs root RO. sky2 works for me, but I had another hang, so sk98lin
might not be the culprit.

The other box (the difference is the SATA drive and the CD) is working OK,
almost 4d uptime now.

Will try to revive the black machine and report more.
(the bad machine is called black and the good is called white :-)

Kalin.

-- 
|[ ~~~~~~~~~~~~~~~~~~~~~~ ]|
+-> http://ThinRope.net/ <-+
|[ ______________________ ]|
