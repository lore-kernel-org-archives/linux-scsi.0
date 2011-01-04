From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/10] mpt2sas: Description Patch
Date: Tue, 04 Jan 2011 10:00:48 -0600
Message-ID: <1294156848.4726.8.camel@mulgrave.site>
References: <20110104060032.GA5751@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57597 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab1ADQAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2011 11:00:54 -0500
In-Reply-To: <20110104060032.GA5751@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Tue, 2011-01-04 at 11:30 +0530, Kashyap, Desai wrote:
> MPT2SAS driver changes.
> These patches are taken from 2.6.37-rc5.
> Please consider this patch set for next kernel release.

That's a bit unlikely considering we're probably only a day or so away
from a 2.6.37 kernel release.  It takes time to go through the
linux-next and code inspection process.

I can add them to scsi-misc with a cc stable (at least for the ones that
are bug fixes):

> [PATCH 01/10] mpt2sas: Device removal handshake even though the
> PHYSTATUS_VACANT bit is set in the PhyStatus
> [PATCH 02/10] mpt2sas: Internal device reset complete event is not
> supported for older firmware prior to MPI Rev K
> [PATCH 03/10] mpt2sas: Correct resizing calculation for max_queue_depth
> [PATCH 04/10] mpt2sas: Revision P MPI Header Update

This is an update not a bug fix

> [PATCH 05/10] mpt2sas: Add support for Customer specific branding messages

This is an update, not a bug fix

> [PATCH 06/10] mpt2sas: Fix the race between broadcast asyn event and scsi
> command completion.

This patch seems to contain half the branding stuff from 5/10 ... please
separate them

> [PATCH 07/10] mpt2sas: Prevent access to freed memory from port enable process
> [PATCH 08/10] mpt2sas: Basic Code Cleanup in mpt2sas_base

A code cleanup is not a bug fix.

> [PATCH 09/10] mpt2sas: Call the _scsih_ir_shutdown prior to reporting the
> volumes missing from the OS
> [PATCH 10/10] mpt2sas: Bump version 08.100.00.00
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>

So that's 1-3 bug fixes, rework 5,6 so it becomes a clean separation
between enhancement and bug fix and 7,9 are bug fixes.

James


