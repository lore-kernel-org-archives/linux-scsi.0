From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [usb-storage] Re: MPIO HS200 Gigabox weird behaviour again
Date: Fri, 11 Feb 2005 11:18:01 -0500
Message-ID: <1108138682.5773.23.camel@mulgrave>
References: <Pine.LNX.4.44L0.0502111054040.937-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:31925 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262266AbVBKQSK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 11:18:10 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502111054040.937-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-02-11 at 11:00 -0500, Alan Stern wrote:
> SCSI developers: Is there any hope of this?

Well, IBM also has some old buggy piece of hardware that apparently
gives fatal errors but actually wants them retried:

http://marc.theaimsgroup.com/?t=110088696100005

After a bit of argument, they agreed to do it as a blacklist flag, so
you should be able to add the same flag to your gigabox.

I planned to put the patch in just as soon as they managed to send the
patch unmangled by a mailer, but they went very quiet.

James


