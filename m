From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 14:26:03 +0000
Message-ID: <20041118142603.GB23189@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458B694670@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:55047 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262044AbUKRO0H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 09:26:07 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B694670@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

On Thu, Nov 18, 2004 at 09:11:55AM -0500, Salyzyn, Mark wrote:
> The add/delete/change device interfaces are still not exported, and I am
> still getting customer pressure to provide a means to bring arrays
> on-line or off-line without needing the users themselves to talk to the
> dangerous /proc/scsi/scsi node or requiring an intervening reboot. RAID
> and Storage networks require this functionality.
> 
> Christoph, we need closure on this now to allow LLDD to provide Plug and
> Play notifications. MarkH as submitted patches to expose these
> (scsi_rescan_device & scsi_scan_host_selected) interfaces and they are
> still hidden.

And the rationale is the same as before, we really don't want to go wild
and do a full bus scan if we know that only a single target or lun
(or a container that the driver maps to scsi datastructures in the aacraid
case) has been added/removed.

What patch from MarkH did you refer to?
