From: "Seymour, Shane M" <shane.seymour@hp.com>
Subject: RE: [PATCH] st: implement sysfs based tape statistics v2
Date: Sun, 8 Feb 2015 23:19:32 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3BF3F1BF@G9W0766.americas.hpqcorp.net>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net>
 (shane.seymour@hp.com) <87r3u0mivl.fsf@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:8065 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbBHXTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2015 18:19:55 -0500
In-Reply-To: <87r3u0mivl.fsf@hobgoblin.ariadne.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Both of those things would have to be futures and require discussion - the very original version cleared stats on a device open but I got asked to keep it the stats cumulative so they would be more similar to disk stats. I'm not sure about the bad reads idea I'd have to look and see if some other layer provided device error information. I've got some changes to make and don't want to change it into a moving target that needs more discussion at this point.

-----Original Message-----
From: Dale R. Worley [mailto:worley@alum.mit.edu] 
Sent: Monday, February 09, 2015 4:08 AM
To: Seymour, Shane M
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2

One feature of tape statistics is that they're as much about the *tape* as they are about the *drive*, which is uncommon for block devices.  It might be useful to have a set of counters which is cleared every time a new tape is inserted into the drive.  In particular, "bad reads since this tape was inserted" would be very useful for monitoring the quality of tapes.

Dale
