From: Joseph Fannin <jfannin@gmail.com>
Subject: [OT] GMail (was USB regression (and other failures)...)
Date: Sat, 16 Feb 2008 23:10:53 -0500
Message-ID: <20080217041052.GA32381@nineveh.local>
References: <Pine.LNX.4.44L0.0802161756330.3753-100000@netrider.rowland.org> <47B78A08.1020502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:29667 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbYBQEK6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2008 23:10:58 -0500
Received: by an-out-0708.google.com with SMTP id d31so278384and.103
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2008 20:10:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <47B78A08.1020502@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Buehler <abuehler.kernel@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Sat, Feb 16, 2008 at 08:12:40PM -0500, Andrew Buehler wrote:
> [...] and I would not be in the least surprised if this turned out to
> be yet one more problem with gmail

It is; Gmail will refuse to POP more than one copy of a mail to you,
no matter how many copies it recieves via different paths.  Which copy
you get seems to be dependant on which arrives first, so you can't
even hope a mail exchange will consistently arrive in one mailbox or
another.

Note that this also applies to mails cross-posted to multiple lists
you maybe be suscribed to; this breaks threading fantastically.

Google is aware of the issue, and considers it a feature.  If you find
another free mail service which isn't so broken, I'd love to hear
about it.

---

That said, netiquette on the kernel lists is to *never* drop CC's.
Too much traffic crosses the lists for anyone to read it all and note
anything they might be interested and/or implicated in.  Never
dropping CC's allows busy people to keep track of conversations
they've taken part in or that someone thinks they should see
without the worry of missing any important parts of one.

Or at least it does if your mail system isn't broken.  We get what we
pay for.  :-/

--
Joseph Fannin
jfannin@gmail.com
