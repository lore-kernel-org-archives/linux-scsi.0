From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aic94xx: fix routing algorithms
Date: Tue, 11 Jul 2006 12:18:05 -0400
Message-ID: <1152634685.3575.46.camel@mulgrave.il.steeleye.com>
References: <16C8363E16D7234AB844FDB52D4AEA650C2DBB@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57049 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751095AbWGKQSK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 12:18:10 -0400
In-Reply-To: <16C8363E16D7234AB844FDB52D4AEA650C2DBB@ntserv.PacificCodeWorks.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Tarte <robt@PacificCodeWorks.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-07-11 at 08:49 -0700, Robert Tarte wrote:
> [Tarte, Robert] I wrote an expander simulator that I ran in user space
> for the adp94xx.  I extracted the routing code from the adp94xx driver
> and ran through numerous configurations hand checking the table to
> make
> sure that it came up with the right answer.

If you want to do that again, that would be great.  However,
mathematically, I think you'll find the results are identical for every
configuration other than expander S->T connections, for which the old
algorithm was provably wrong.  If the original scan didn't pick this up,
it's probably because that configuration isn't included ... so I think
the results this time around will be completely identical.

James


