From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bugme-new] [Bug 10915] New: echo min_power > /sys/class/scsi_host/host0/active_mode causes problem
Date: Mon, 16 Jun 2008 14:48:20 +0200
Message-ID: <87wskpwnor.fsf@basil.nowhere.org>
References: <bug-10915-10286@http.bugzilla.kernel.org/>
	<20080615180146.8abb9450.akpm@linux-foundation.org>
	<1213581610.3517.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:25283 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYFPMsW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2008 08:48:22 -0400
In-Reply-To: <1213581610.3517.44.camel@localhost.localdomain> (James Bottomley's message of "Sun, 15 Jun 2008 21:00:10 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, cijoml@volny.cz

James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>
> Um ... actually, maybe not.  The active_mode file is read only (it has a
> NULL store method).  It's designed to show what mode the host is
> activated in "initiator", "target" (or both or unknown).  If echoing
> something to a read only sysfs file with no actual store method is
> causing this behaviour, the root cause has to be somewhere in sysfs.
>
> However, since the file has nothing to do with power saving ... unless
> some driver I can't find is trying to duplicate it, so there's no reason
> to try to echo "min_power" to it, so some of the details on this report
> might bear further investigation ...

I remember hitting something like this in the past when write() returned 0.
Some versions of echo loop in this case.

-Andi
