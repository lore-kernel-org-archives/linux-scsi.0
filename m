From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Questions about scsi.c
Date: Tue, 30 Oct 2007 09:43:29 -0500
Message-ID: <1193755409.3321.19.camel@localhost.localdomain>
References: <200710250606.03301.rob@landley.net>
	 <200710251325.37586.rob@landley.net>
	 <20071025103241.546b35ec.rdunlap@xenotime.net>
	 <200710251640.35758.rob@landley.net>
	 <20071025134926.4d209584.rdunlap@xenotime.net> <472724EA.3050502@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46165 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752236AbXJ3Onk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 10:43:40 -0400
In-Reply-To: <472724EA.3050502@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Rob Landley <rob@landley.net>, linux-scsi@vger.kernel.org

On Tue, 2007-10-30 at 08:34 -0400, Jeff Garzik wrote:
> Randy Dunlap wrote:
> > On Thu, 25 Oct 2007 16:40:35 -0500 Rob Landley wrote:
> > 
> >> On Thursday 25 October 2007 12:32:41 pm Randy Dunlap wrote:
> >>>> Entirely possible I'm doing something wrong:
> >>>>
> >>>>    <sect1 id="scsi_device.h">
> >>>>       <title>include/scsi/scsi_device.h</title>
> >>>>       <para>
> >>>>       </para>
> >>>> !Einclude/scsi/scsi_device.h
> >>>>     </sect1>
> >>> !E is for exported symbols and that file has none.
> >>> USe !I instead.
> >> So how do I handle a case like drivers/ata/libata-core.c which has 
> >> EXPORT_SYMBOL() calls for functions that live in (and are documented in) 
> >> other files, such as ata_scsi_ioctl() in drivers/ata/libata-scsi.c?
> > 
> > I don't see ata_scsi_ioctl() documented at all.  Are you looking at
> > a newer tree than I am?  (i'm using 2.6.24-rc1)
> > 
> > Long-term answer is that we prefer EXPORT_SYMBOL() to be used
> > just under the function that is being exported.  In this case,
> > the maintainer may be disagreeing with that.  [cc-ed]
> > 
> > Short-term answer is to use !Isource_filename_where_kernel_doc_is
> > as though it's not EXPORTed.  I think.
> 
> Yeah I tended to prefer that all exports be in one place, rather than 
> scattered around and difficult to evaluate en masse :)

My personal preference (and how I code) is export at the bottom of the
function.  However, it's one of those stylistic things that I'm happy to
have people code however they want (either everything at the bottom of
the file or all exports at the bottom of the exported function) as long
as they follow the current style of whatever file they're patching.

James


