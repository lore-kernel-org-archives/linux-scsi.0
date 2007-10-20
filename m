From: Pavel Machek <pavel@ucw.cz>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Sat, 20 Oct 2007 09:48:17 +0000
Message-ID: <20071020094817.GA7271@ucw.cz>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au> <200710150452.30939.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1667 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752871AbXJTJtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Oct 2007 05:49:01 -0400
Content-Disposition: inline
In-Reply-To: <200710150452.30939.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Hi!

> > Would an oom-kill-someone-now sysrq be of help, I wonder?
> 
> *shrug* It might.  I was a letting it run hoping it would complete itself when 

sysrq-f, IIRC.

> it locked solid.  (The keyboard LEDs weren't flashing, so I don't _think_ it 
> paniced.  I was in X so I wouldn't have seen a message...)
> 
> (To be honest, I can never remember how to trigger sysrq on a laptop keyboard.  
> Presumably X won't intercept it the way it does alt-f1 and ctrl-alt-del...)

sysrq works even in X, and should be pressable on todays laptop
keyboards...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
