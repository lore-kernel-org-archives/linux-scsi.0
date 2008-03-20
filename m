From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] fix media change events for polled devices
Date: Thu, 20 Mar 2008 02:18:53 +0100
Message-ID: <1205975933.5498.11.camel@lov.site>
References: <1205928287.8810.18.camel@lov.site>
	 <1205945642.11527.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:56901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYCTBTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 21:19:08 -0400
In-Reply-To: <1205945642.11527.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: scsi <linux-scsi@vger.kernel.org>, David Zeuthen <david@fubar.dk>, kristen accardi <kaccardi@gmail.com>, Jeff Garzik <jeff@garzik.org>

On Wed, 2008-03-19 at 11:54 -0500, James Bottomley wrote:
> On Wed, 2008-03-19 at 13:04 +0100, Kay Sievers wrote:
> > we like to see this in 2.6.25, as "change" events for polled devices are
> > broken at the moment.
> 
> I'm not happy just killing the code, since when the AN infrastructure
> gets fixed, it will work.

Who is going to fix what and when? Jeff did not even reply the last two
weeks to the simple question why he added this filter, and why events
need to dropped if something wants to send them. :)

These events are for non-AN devices, which we still poll for media
changes. Userspace wants the same kind of events for both types of
devices.

> How about this instead as a fix for 2.6.25?

We are currently working on a the next generation of the storage part of
the hal daemon, which needs these events. So it would be nice, if we can
make them working now, like they worked with Kristens original patches.

Thanks,
Kay

