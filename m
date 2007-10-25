From: Rob Landley <rob@landley.net>
Subject: Re: Questions about scsi.c
Date: Thu, 25 Oct 2007 16:40:35 -0500
Message-ID: <200710251640.35758.rob@landley.net>
References: <200710250606.03301.rob@landley.net> <200710251325.37586.rob@landley.net> <20071025103241.546b35ec.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56402
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753228AbXJYUkw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 16:40:52 -0400
In-Reply-To: <20071025103241.546b35ec.rdunlap@xenotime.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

On Thursday 25 October 2007 12:32:41 pm Randy Dunlap wrote:
> > Entirely possible I'm doing something wrong:
> >
> >    <sect1 id="scsi_device.h">
> >       <title>include/scsi/scsi_device.h</title>
> >       <para>
> >       </para>
> > !Einclude/scsi/scsi_device.h
> >     </sect1>
>
> !E is for exported symbols and that file has none.
> USe !I instead.

So how do I handle a case like drivers/ata/libata-core.c which has 
EXPORT_SYMBOL() calls for functions that live in (and are documented in) 
other files, such as ata_scsi_ioctl() in drivers/ata/libata-scsi.c?

> ---
> ~Randy

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
