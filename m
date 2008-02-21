From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: fix error handling
Date: Thu, 21 Feb 2008 09:33:07 -0600
Message-ID: <1203607987.3208.9.camel@localhost.localdomain>
References: <541691.92554.qm@web31804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42569 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYBUPdM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 10:33:12 -0500
In-Reply-To: <541691.92554.qm@web31804.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-02-20 at 21:51 -0800, Luben Tuikov wrote:
> A similar change went into the SAS/SATL layer I support
> shortly after I posted the version which you forked off.
> The git date of the commit is: Tue Feb 7 22:14:54 2006 -0800.

Look, Luben; I don't mind you making an arse of yourself on the mailing
lists; that's about par for the course nowadays.

However, failing to report serious bugs you knew about in your code, and
have known about for two years, is tantamount to sabotage ... especially
when you've been reading the bug reports on the mailing list.  I have to
wonder how many more such bugs you've left in the code for users to
find.

> BTW, the problem you're "debugging" may require a protocol
> trace and a sequencer update by Adaptec.

I think you're fully aware that my test rig consists of a couple of SAS
cards and drives donated by IBM and two expanders donated by LSI, plus a
bit of equipment scavenged from Intel.  I have no access to
sophisticated tools like protocol analyzers.  However, thanks for the
advice and help.

James


