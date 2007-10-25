From: Rob Landley <rob@landley.net>
Subject: Re: Questions about scsi.c
Date: Thu, 25 Oct 2007 14:30:10 -0500
Message-ID: <200710251430.10481.rob@landley.net>
References: <200710250606.03301.rob@landley.net> <200710251325.37586.rob@landley.net> <20071025103241.546b35ec.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54292
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753197AbXJYSa1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 14:30:27 -0400
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

Ah, that did it.  Thanks.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
