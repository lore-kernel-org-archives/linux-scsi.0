From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 15:07:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFF38DF.2030502@pobox.com>
References: <3EFE8784.4000101@pobox.com>	<20030629102222.GA14962@win.tue.nl> <3EFF14BD.3030406@pobox.com>	<20030629173632.GA15024@win.tue.nl> <3EFF28AC.104@pobox.com>	<20030629110205.A4728@one-eyed-alien.net>  <3EFF2D45.1040203@pobox.com> <1056911816.10896.207.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9876 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262299AbTF2SxG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 14:53:06 -0400
In-Reply-To: <1056911816.10896.207.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries Brouwer <aebr@win.tue.nl>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> Actually guys, by penguin fiat number:
> 
> torvalds@home.transmeta.com|ChangeSet|20030621190214|57300
> 
> We have been setting use_10_for_ms to one for every device in .73

I noticed this :)


> Now, our current setup can't handle the 10->6 fallback, but I've fixed
> that in the recent BK.
> 
> Given that there have been no reported problems (other than from our
> inability to interpret 10 by mode sense data), I'm inclined to leave it
> this change in.

sr.c is still hardcoded to use mode_sense_6...  even though it's been 
hardcoded to use read/write_10 for years :)

	Jeff



