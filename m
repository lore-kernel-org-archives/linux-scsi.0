From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: add link error counts to the expander phys
Date: Mon, 28 Aug 2006 09:40:46 -0500
Message-ID: <1156776046.3465.11.camel@mulgrave.il.steeleye.com>
References: <20060828142028.97355.qmail@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25236 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751011AbWH1Olt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 10:41:49 -0400
In-Reply-To: <20060828142028.97355.qmail@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-08-28 at 07:20 -0700, Luben Tuikov wrote:
> --- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > Unfortunately, the aic94xx seems to keep none of these mandatory
> error
> > counts for the HBA phys,
> 
> That's not true.

OK, so where are they?  I did grep the aic94xx source code for the SAS-2
specified names for these things and didn't turn up anything.  I can see
the sequencer would keep these counts, but they don't seem to be
exported to the driver.

James


