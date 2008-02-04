From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sd: make error handling more robust (v2)
Date: Mon, 04 Feb 2008 15:22:08 -0600
Message-ID: <1202160128.3096.118.camel@localhost.localdomain>
References: <228743.69246.qm@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41788 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbYBDVWO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 16:22:14 -0500
In-Reply-To: <228743.69246.qm@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Tony Battersby <tonyb@cybernetics.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>

On Mon, 2008-02-04 at 01:11 -0800, Luben Tuikov wrote:
> Looks good except that "End LBA" is usually defined
> to be something of the sort of "the LBA of the last
> logical block accessed by the command" or "the LBA
> of the logical block on which the command failed".
> 
> A spec savvy editor of this code would be
> "pleasantly" surprised if they had to use "end_lba",
> and didn't pay attention that it was actually
> "End LBA" + 1.

Heh, well, that's where spec people and programmers part company.  The
universal expectation of a programmer in looping is

for (a = beginning; a < end; a++)

rather than <= if end were actually to point to last rather than last +
1.

James


