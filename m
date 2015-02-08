From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Sun, 08 Feb 2015 12:07:58 -0500
Message-ID: <87r3u0mivl.fsf@hobgoblin.ariadne.com>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:32843 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbbBHRIC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2015 12:08:02 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net> (shane.seymour@hp.com)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: linux-scsi@vger.kernel.org

One feature of tape statistics is that they're as much about the *tape*
as they are about the *drive*, which is uncommon for block devices.  It
might be useful to have a set of counters which is cleared every time a
new tape is inserted into the drive.  In particular, "bad reads since
this tape was inserted" would be very useful for monitoring the quality
of tapes.

Dale
