From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 09:32:09 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B694682@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64980 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262081AbUKROcN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 09:32:13 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

But scsi_rescan_device and scsi_scan_host_selected both target specific
ids though? As long as we stay away from the wildcards for
scsi_scan_host_selected, or am I mistaken?

MarkH, can you reissue the patch?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, November 18, 2004 9:26 AM
To: Salyzyn, Mark
Cc: James.Smart@Emulex.Com; linux-scsi@vger.kernel.org; Mark Haverkamp
Subject: Re: [PATCH] LLDD dynamic scan aids

On Thu, Nov 18, 2004 at 09:11:55AM -0500, Salyzyn, Mark wrote:
> The add/delete/change device interfaces are still not exported, and I
am
> still getting customer pressure to provide a means to bring arrays
> on-line or off-line without needing the users themselves to talk to
the
> dangerous /proc/scsi/scsi node or requiring an intervening reboot.
RAID
> and Storage networks require this functionality.
> 
> Christoph, we need closure on this now to allow LLDD to provide Plug
and
> Play notifications. MarkH as submitted patches to expose these
> (scsi_rescan_device & scsi_scan_host_selected) interfaces and they are
> still hidden.

And the rationale is the same as before, we really don't want to go wild
and do a full bus scan if we know that only a single target or lun
(or a container that the driver maps to scsi datastructures in the
aacraid
case) has been added/removed.

What patch from MarkH did you refer to?
