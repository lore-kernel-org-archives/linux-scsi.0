From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Tue, 10 Feb 2015 22:38:11 -0500
Message-ID: <87r3txw21o.fsf@hobgoblin.ariadne.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3F1BF@G9W0766.americas.hpqcorp.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:58507 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbbBKDiO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2015 22:38:14 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3F1BF@G9W0766.americas.hpqcorp.net> (shane.seymour@hp.com)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: linux-scsi@vger.kernel.org

"Seymour, Shane M" <shane.seymour@hp.com> writes:
> Both of those things would have to be futures and require discussion -
> the very original version cleared stats on a device open but I got
> asked to keep it the stats cumulative so they would be more similar to
> disk stats.

Yes, this is a futures question.  But in a perfect world, there'd be two
sets of statistics, one cumulative since the last reboot and one that
was cleared every time a tape was unloaded.

Dale
