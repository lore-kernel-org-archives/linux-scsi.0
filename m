From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 0/3] varlen extended and vendor-specific cdbs
Date: Thu, 20 Dec 2007 21:39:09 +0200
Message-ID: <476AC4DD.8010703@panasas.com>
References: <4767CC3E.8000309@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:57905 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbXLTUkw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 15:40:52 -0500
In-Reply-To: <4767CC3E.8000309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm>
Cc: Benny Halevy <bhalevy@panasas.com>, Matthew Wilcox <matthew@wil.cx>

On Tue, Dec 18 2007 at 15:33 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Submitted is a patchset for adding support for variable-length, extended, and 
> vendor specific CDBs. It should now cover the entire range of the
> SCSI standard.
> 
<snip>

ping James.
I understand that this is the last thing on your mind. But could we at least
agree at the scsi_cmnd API, which is, No API.

That is: scsi_cmnd->cmnd changes to a pointer that can point to a user buffer.


Andrew Hi!
It would be grate if you could put these patches in next -mm for testing.
the first patch in this series has a potential of been dangerous.
Since I changed an embedded array to a pointer, places that did &cmd->cmnd
will no longer work. I have scanned all occurrences of \bcmnd\b but
I might have missed a place.

Thanks
Boaz
