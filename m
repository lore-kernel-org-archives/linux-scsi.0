From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix sym2 negotiation
Date: 22 Aug 2004 14:03:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093197825.1974.29.camel@mulgrave>
References: <1093113450.1732.334.camel@mulgrave>
	<m3hdqvt6x2.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8895 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268054AbUHVSEt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 14:04:49 -0400
In-Reply-To: <m3hdqvt6x2.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-08-22 at 13:32, Matthias Andree wrote:
> is the patch available in a BK tree that the public can pull from?
> 
> I can't seem to get it to apply even with either or both of the patches
> Matt mentioned in another thread.

Yes, they're all in the SCSI BK tree:

bk://linux-scsi.bkbits.net/scsi-misc-2.6

But if you're just looking for a quick fix for the atlas problem, it's
here (and should apply to the vanilla kernel).

http://marc.theaimsgroup.com/?l=linux-scsi&m=109297058118127

James


