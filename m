From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 09:11:55 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B694670@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:56519 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262020AbUKROL6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 09:11:58 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

The add/delete/change device interfaces are still not exported, and I am
still getting customer pressure to provide a means to bring arrays
on-line or off-line without needing the users themselves to talk to the
dangerous /proc/scsi/scsi node or requiring an intervening reboot. RAID
and Storage networks require this functionality.

Christoph, we need closure on this now to allow LLDD to provide Plug and
Play notifications. MarkH as submitted patches to expose these
(scsi_rescan_device & scsi_scan_host_selected) interfaces and they are
still hidden.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Thursday, November 18, 2004 5:46 AM
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] LLDD dynamic scan aids

On Wed, Nov 17, 2004 at 02:03:01PM -0500, James.Smart@Emulex.Com wrote:
> This patch contains the following 2 modifications:
> 
> - Allows scsi_scan_host() to be called at times other than just first
attachment.

I'm not too happy about that, and we had that discussion already when
discussing the aacraid dynamic container addition / removal. 
