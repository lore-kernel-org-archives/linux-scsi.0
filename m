From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 1/6] scsi: fix a header to include linux/types.h
Date: Tue, 10 Jan 2012 19:02:48 -0500
Message-ID: <1326240168.3264.88.camel@dabdike.int.hansenpartnership.com>
References: <20120110234227.E28795C013D@hpza9.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58486 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756641Ab2AKACw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2012 19:02:52 -0500
In-Reply-To: <20120110234227.E28795C013D@hpza9.eem.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, virtuoso@slind.org

On Tue, 2012-01-10 at 15:42 -0800, akpm@linux-foundation.org wrote:
> From: Alexander Shishkin <virtuoso@slind.org>
> Subject: scsi: fix a header to include linux/types.h
> 
> For headers that get exported to userland and make use of u32 style
> type names, it is advised to include linux/types.h.
> 
> This fixes a headers_check warning.

Well, this patch isn't correct as I've said several times (we really
need someone to take a serious look at all the problems with exporting
scsi.h to userspace).  The warning was finally fixed by this patch
instead:

commit 7407e5bba2cc821950344fd1391d9ad1b7e0b397
Author: Tom Rini <tom_rini@mentor.com>
Date:   Tue Apr 27 14:11:47 2010 -0700

    [SCSI] Unexport scsi/scsi.h from headers_install
 
But if someone wants to step up and make scsi/scsi.h exportable, I'm
very open ...

James


