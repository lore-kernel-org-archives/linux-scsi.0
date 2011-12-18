From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT 3.2-rc PATCH 0/8] isci: platform and hardware enabling
 updates
Date: Sun, 18 Dec 2011 07:49:28 -0600
Message-ID: <1324216168.3091.7.camel@dabdike.int.hansenpartnership.com>
References: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53743 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615Ab1LRNtc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2011 08:49:32 -0500
In-Reply-To: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2011-12-16 at 16:53 -0800, Dan Williams wrote:
> These are priority updates, targeted for inclusion in 3.2-final, for the
> driver to honor the latest definition of oem parameters and support the
> latest revision of silicon.  The oem parameter format (phy configuration
> settings passed along from platform firmware) has been updated to
> revision 1.3, current driver only supports 1.0.  The C1 silicon update
> involves updates to the per-silicon-revision hard-coded phy tuning
> recipes.

The -rc tree is for bug fixes only, not whatever you choose to call
"priority updates".  We have long established the position that a driver
update, even to support new hardware, isn't a bug fix ... the
distributions apply it through their enhancement processes. See below
for the individual comments

> This also updates the driver version from v1.0 to v1.1 to remove the
> stale EXPERIMENTAL tag and reflect the C1 level of silicon support.
> 
> A performance fix and a fix for a crash that can be triggered by
> enabling a dev_dbg() statement are also included.
> 
> Please apply, or pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git fixes
> 
> ...to receive:
> 
> Dan Williams (2):
>       isci: cleanup oem parameter and recipe handling

This isn't a bug fix

>       isci: update version to 1.1
> 
> Dave Jiang (1):
>       isci: oem parameter format v1.1 (ssc select)
> Jeff Skirvin (3):
>       isci: update afe (analog-front-end) recipe for C1
>       isci: oem parameter format v1.3 (cable select)

New silicon support is an enhancement not a bug fix (last three patches)

>       isci: link speeds default to gen 2

This might be viewed as a but fix ... with a better description.

> Maciej Trela (1):
>       isci: remove unused 'isci_tmf->device' field

This isn't a bug fix.

> Marcin Tomczak (1):
>       isci: performance-fix, shorten default "no outbound task" timeout

I don't quite see from the description how this is a performance
enhancement?  It does nothing in the single initiator case, right?

James



