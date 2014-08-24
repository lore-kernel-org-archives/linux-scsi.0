From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Debugging scsi abort handling ?
Date: Sun, 24 Aug 2014 14:12:53 -0700
Message-ID: <20140824211253.GA7733@infradead.org>
References: <53F8AAA8.8040407@redhat.com>
 <1408827920.2181.8.camel@jarvis>
 <53F9A681.7080209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaHXVMy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2014 17:12:54 -0400
Content-Disposition: inline
In-Reply-To: <53F9A681.7080209@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, Aug 24, 2014 at 10:46:57AM +0200, Hans de Goede wrote:
> To be clear I believe there may be a bug or 2 in the uas.c abort code
> paths, not in the scsi core or sd drivers.
> 
> But getting more eyes on these definitely makes sense. Should I CC
> linux-scsi@vger on issues like this, or should I get the users
> to file a bug at bugzilla.kernel.org (my own preference would be to
> do the latter, as that keeps all info in a single place).

Please Cc linux-scsi.  I and some others definitively don't have the
pain and patience to deal with bugzilla.

> uas is only enabled in 3.15 and newer so that patch should be present.

There have been a few more important fixes since 3.15:

ac61d19559349e205dad7b5122b281419aa74a82 scsi: set correct completion code in scsi_send_eh_cmnd()
8922a908908ff947f1f211e07e2e97f1169ad3cb scsi_error: fix invalid setting of host byte
a33c070bced8b283e22e8dbae35177a033b810bf scsi_error: set DID_TIME_OUT correctly

make sure you have those as well.
