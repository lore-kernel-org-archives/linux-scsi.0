From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Wed, 11 Jun 2008 23:04:11 +0200
Message-ID: <48503DCB.7050104@s5r6.in-berlin.de>
References: <200806010415.05290.chris2553@googlemail.com> <200806111858.05114.chris2553@googlemail.com> <20080611191533.GA6189@kroah.com> <200806111951.09275.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:38254 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYFKVFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2008 17:05:15 -0400
In-Reply-To: <200806111951.09275.chris2553@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chris2553@googlemail.com
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org

Chris Clayton wrote:
> On Wednesday 11 June 2008, Greg KH wrote:
>> Try commenting out the rule that does this and see if things are fixed.
> 
> Yes, that's it. It's this rule, which appears as the second rule in the 
> slackware rules file that's distributed with udev (and it's been there since 
> udev-97 in August 2006):
> 
> ACTION=="add", SUBSYSTEM=="scsi", WAIT_FOR_SYSFS="ioerr_cnt"
> 
> Commenting that rule out eliminates the pause in the boot and in the appearance 
> of icons on my desktop.

It's called a workaround, not a fix.
-- 
Stefan Richter
-=====-==--- -==- -=-==
http://arcgraph.de/sr/
