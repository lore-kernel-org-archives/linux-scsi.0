From: Philippe Troin <phil@fifi.org>
Subject: Re: mptsas drops then re-adds hard drive
Date: 13 Jul 2007 09:26:08 -0700
Message-ID: <87abu0nucf.fsf@old-tantale.fifi.org>
References: <87hcodourq.fsf@old-tantale.fifi.org>
	<664A4EBB07F29743873A87CF62C26D702A99CD@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from old-tantale.fifi.org ([64.81.30.200]:36604 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbXGMQ0P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 12:26:15 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D702A99CD@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

"Moore, Eric" <Eric.Moore@lsi.com> writes:

> The mpt_linux_developer@lsi.com has been deleted, and replaced with
> distribution list.  This was done about a month back, and should be
> updated in the MAINTAINERS file by now.

It was not updated in the 2.6.22's MAINTAINERS file.
 
> A return code of 0x1000 means DID_NO_CONNECT.  Do you have the
> entire dmesg log, as it would be interesting to know wether the
> driver recieved asyn events from the firmware notifing that the
> device has been deleted and/or added back.  The link is going down
> over load testing, most likely firmware issue (controller or SATA
> device). Are you creating RAID using integrated RAID provided with
> the fusion controller, or are you using linux software RAID?  Which
> company do you represent, or are you an end user?  I would need to
> get this assinged to an Systems Engineer inorder to help with
> replication efforts, and/or analyzing bus traces.

Eric,

Thanks a lot for your reply.  I am glad to see that LSI is standing
behind its products and its Linux drivers.

In the end, after a lot of troubleshooting and hardware swapping, the
hard drives and the controller have been ruled out.  It turned out
that the problem was with the server's power supply.  It was supplying
a very wobbly and low 5V between 4.3 and 4.7V.  The Seagate hard
drives were not liking it and were resetting I suppose.  We could hear
the click from the heads parking and the drive recalibrating.

For the record, the PSU was an Antec "TruePower" (ahem) 550W.  Which
should have been plenty of ooomph for the server and 8 drives.  A
power meter plugged onto the box showed a steady 280W power
consumption with peaks at 320W when the drives were spinning up
(staggered).  It is the second Antec PSU that we've seen crapping out
in this way, and my personal opinion and experience are that Antec
PSUs are prone to do this.  I would not recommend Antec.

Again thank you very much for your reply.  It is appreciated.

Phil.
