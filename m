From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Fri, 6 Feb 2015 11:49:52 -0600
Message-ID: <54D4FEC0.8090101@tributary.com>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net> <DDB9C85B850785449757F9914A034FCB3BF3C359@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay05.mycloudmailbox.com ([199.244.76.202]:39381 "EHLO
	relay05.mycloudmailbox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbbBFR6U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 12:58:20 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3C359@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "jeffm@suse.com" <jeffm@suse.com>

On 1/26/2015 6:11 PM, Seymour, Shane M wrote:
> I was wondering if anyone had any feedback or had any chance to review the changes?

	Per the other discussion about having the same stat format forever. It seems to
me that you might want to preemptively add a few additional counters.
	
A counter for WRITE_FILEMARKS, particularly non immediate count=0 ones, which
are often used to flush the drive write buffer. A counter for movement related
commands like SPACE/LOCATE/REWIND would also be helpful. Finally, abnormal read
conditions like, ILI's, and hit FMs should have their own stat. Those three
should provide a better view into how the drive is being used and why
performance may not be what is expected.

There may be others, but those three are high on my list of things I want to
know about a tape stream that is not performing up to expectations.





