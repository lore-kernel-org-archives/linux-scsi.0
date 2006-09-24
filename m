From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] async scsi scanning, version 11
Date: Sun, 24 Sep 2006 14:40:01 -0600
Message-ID: <20060924204000.GE2595@parisc-linux.org>
References: <20060924190623.GB2595@parisc-linux.org> <20060924130253.48f90fe5.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:65184 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S932076AbWIXUkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 16:40:03 -0400
Content-Disposition: inline
In-Reply-To: <20060924130253.48f90fe5.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

On Sun, Sep 24, 2006 at 01:02:53PM -0700, Randy Dunlap wrote:
> Do parts of Documentation/scsi/scsi_low_mid_api.txt need to be
> updated also?
> or are all of these changes outside of the low_mid realm?

There's no interface changes at this point.  Once we start to get into
fixing the FC/SAS drivers, there'll be some documenting to be done.

> > +struct async_scan_data * scsi_prep_async_scan(struct Scsi_Host *shost)
> 
> whitespace violation (*scsi_prep_async_scan)

Hmm?  Wouldn't that be a function pointer?  Did you mean to say I should
use:

struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)

?  I don't particularly mind either way.

> and thanks for adding/using kernel-doc.

I like it.  Documenting an earlier version of the interface made me
realise it had bad semantics, so I fixed it rather than try to document
its quirks.
