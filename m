From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sat, 09 Jul 2005 11:35:01 -0500
Message-ID: <1120926901.5008.12.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709162712.GB27347@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:55938 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261230AbVGIQfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Jul 2005 12:35:05 -0400
In-Reply-To: <20050709162712.GB27347@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, 2005-07-09 at 12:27 -0400, Ben Collins wrote:
> THese changes break sbp2, and we'll need to revert them in the main stream
> kernel until the patch is tested and fixed in our tree.

They cannot be simply reverted.  The API has changed from the EH
routines being called with the host lock held to being called lockless.
If you need the lock, you have to take it yourself, which is what the
changes do from my reading of the code.

What's the breakage?

James


