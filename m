From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: use_10_for_ms revisited?
Date: 29 Jun 2003 13:36:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056911816.10896.207.camel@mulgrave>
References: <3EFE8784.4000101@pobox.com>
	<20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com>
	<20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com>
	<20030629110205.A4728@one-eyed-alien.net>  <3EFF2D45.1040203@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:39175 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265724AbTF2SWt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 14:22:49 -0400
In-Reply-To: <3EFF2D45.1040203@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries Brouwer <aebr@win.tue.nl>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Actually guys, by penguin fiat number:

torvalds@home.transmeta.com|ChangeSet|20030621190214|57300

We have been setting use_10_for_ms to one for every device in .73

Now, our current setup can't handle the 10->6 fallback, but I've fixed
that in the recent BK.

Given that there have been no reported problems (other than from our
inability to interpret 10 by mode sense data), I'm inclined to leave it
this change in.

This rather pre-empts the slave_configure setting of the flags, though.

James


