From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 10:07:29 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B694697@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:18921 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262401AbUKRPHc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 10:07:32 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

Agreed!!

Add in EXPORT_SYMBOL(scsi_rescan_device) and the transformation will now
be complete :-)

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, November 18, 2004 9:37 AM
To: Salyzyn, Mark
Cc: James.Smart@Emulex.Com; linux-scsi@vger.kernel.org; Mark Haverkamp
Subject: Re: [PATCH] LLDD dynamic scan aids

On Thu, Nov 18, 2004 at 09:32:09AM -0500, Salyzyn, Mark wrote:
> But scsi_rescan_device and scsi_scan_host_selected both target
specific
> ids though? As long as we stay away from the wildcards for
> scsi_scan_host_selected, or am I mistaken?

scsi_rescan_device should be exported.  For the target scan something
like the second hunk of James' patch looks good to me.

