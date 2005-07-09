From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 09 Jul 2005 10:18:26 -0500
Message-ID: <1120922306.5008.5.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18562 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261499AbVGIPSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 11:18:31 -0400
In-Reply-To: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, 2005-07-09 at 14:37 +0200, Stefan Richter wrote:
> there are a few changes to sbp2 in linux-2.6.13 (-rc2) that were not
> merged back into the linux1394.org repository (and were not tested by
> linux1394 maintainers as far as I have heard). Most of these changes
> deal with TYPE_RBC devices.

That's probably because no-one knows about you: the sbp2 driver is
listed as Orphaned in the MAINTAINERS file.  You're welcome to take over
maintenance, but you need to get that file updated.

> I have one question for now: Is the following part of the diff related
> to the TYPE_RBC issue, or is it unrelated? As you can see, locking is
> removed from sbp2scsi_complete_command() but added to sbp2scsi_reset():

It's from the SCSI reset API changes, as a quick excursion into the
kernel web history viewer would have shown you:

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;h=a92b7b80579fe68fe229892815c750f6652eb6a9;f=drivers/ieee1394/sbp2.c

James




