From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 16:57:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3zn3ah25m.fsf@merlin.emma.line.org>
References: <4159611C.4030106@adaptec.com>
	<20040928141228.A1815@infradead.org> <415964D2.80808@adaptec.com>
	<20040928142133.A1956@infradead.org> <41596793.6040900@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:44937 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S267746AbUI1O52 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 10:57:28 -0400
In-Reply-To: <41596793.6040900@adaptec.com> (Luben Tuikov's message of "Tue,
	28 Sep 2004 09:30:59 -0400")
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Luben Tuikov <luben_tuikov@adaptec.com> writes:

> Hm, ok, you're the first one to mention doing it like this.
> From our previous emails I thought you wanted to see
> a gradual progression.

Ideally, yes, that is what will happen, it is desired that you show the
list (or the maintainer) in what order the patches are to be applied so
the intermediate steps all compile.

> BTW, I've never tried generating such a patch -- not sure
> what would it look like and/or if it would be possible to
> subdivide it into logical pieces.

For instance, if some part of the driver uses a new function in a
different file, send patch 1 of 2 which add the function to file A and
patch 2 of 2 which makes file B use the new function.

For instance, if you move one function or declaration to another file,
send one patch that does just the move (remove from one file and add to
the other file) and nothing else.

Another example, if you are adding orthogonal/independent features, say
A. a debug option for negotiation and B. support for a new chip, send
one debug patch and one "new chip supported" patch, not one that does
both, even if they both touch the same file.

Does that help?

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
