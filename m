From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 03/18 ver4] libosd: OSDv1 Headers
Date: Thu, 13 Nov 2008 10:16:54 -0800
Message-ID: <20081113101654.f2f25b1b.randy.dunlap@oracle.com>
References: <491073BB.4000900@panasas.com>
	<1225817046-5946-1-git-send-email-bharrosh@panasas.com>
	<4916F934.4090205@panasas.com>
	<20081110092940.57b4c169.randy.dunlap@oracle.com>
	<491AD697.9030305@panasas.com>
	<20081112105945.f4ec0089.randy.dunlap@oracle.com>
	<491C1CBF.6080504@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:45494 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYKMSSW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2008 13:18:22 -0500
In-Reply-To: <491C1CBF.6080504@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, open-osd development <osd-dev@open-osd.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sami.Iren@seagate.com, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 13 Nov 2008 14:25:35 +0200 Boaz Harrosh wrote:

> Headers only patch.
> 
> osd_protocol.h
> 	Contains a C-fied definition of the T10 OSD standard
> osd_types.h
> 	Contains CPU order common used types
> osd_initiator.h
> 	API definition of the osd_initiator library
> osd_sec.h
> 	Contains High level API for the security manager.
> 
> [Note that checkpatch spews errors on things that are valid in this context
> and will not be fixed]
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Reviewed-by: Benny Halevy <bhalevy@panasas.com>

OK by me.  Thanks for the changes.

> ---
>  include/scsi/osd_initiator.h |  332 ++++++++++++++++++++++++++++
>  include/scsi/osd_protocol.h  |  497 ++++++++++++++++++++++++++++++++++++++++++
>  include/scsi/osd_sec.h       |   45 ++++
>  include/scsi/osd_types.h     |   40 ++++
>  4 files changed, 914 insertions(+), 0 deletions(-)
>  create mode 100644 include/scsi/osd_initiator.h
>  create mode 100644 include/scsi/osd_protocol.h
>  create mode 100644 include/scsi/osd_sec.h
>  create mode 100644 include/scsi/osd_types.h

---
~Randy
