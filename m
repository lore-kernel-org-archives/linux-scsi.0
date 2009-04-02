From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/9] exofs: Kbuild, Headers and osd utils
Date: Wed, 01 Apr 2009 21:13:00 -0400
Message-ID: <49D4111C.3010905@garzik.org>
References: <49D374A1.5010303@panasas.com> <1238594963-9880-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53356 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbZDBBNT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 21:13:19 -0400
In-Reply-To: <1238594963-9880-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>, Evgeniy Polyakov <zbr@ioremap.net>, Marcin Slusarz <marcin.slusarz@gmail.com>, Pavel Machek <pavel@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>, Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> This patch includes osd infrastructure that will be used later by
> the file system.
> 
> Also the declarations of constants, on disk structures,
> and prototypes.
> 
> And the Kbuild+Kconfig files needed to build the exofs module.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  fs/exofs/Kbuild   |   16 +++++
>  fs/exofs/Kconfig  |   13 ++++
>  fs/exofs/common.h |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/exofs/exofs.h  |  127 ++++++++++++++++++++++++++++++++++++
>  fs/exofs/osd.c    |  153 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 493 insertions(+), 0 deletions(-)
>  create mode 100644 fs/exofs/Kbuild
>  create mode 100644 fs/exofs/Kconfig
>  create mode 100644 fs/exofs/common.h
>  create mode 100644 fs/exofs/exofs.h
>  create mode 100644 fs/exofs/osd.c

After building "osdblk", a block driver using libosd, it is my opinion 
that all functions inside fs/exofs/osd.c should be moved to libosd.

I find myself copying most of that file, to use in osdblk.

	Jeff



