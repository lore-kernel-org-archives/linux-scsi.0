From: Rob Landley <rob@landley.net>
Subject: Re: Questions about scsi.c
Date: Thu, 25 Oct 2007 13:25:37 -0500
Message-ID: <200710251325.37586.rob@landley.net>
References: <200710250606.03301.rob@landley.net> <20071025084039.971383af.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40031
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750803AbXJYRZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 13:25:54 -0400
In-Reply-To: <20071025084039.971383af.rdunlap@xenotime.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

On Thursday 25 October 2007 10:40:39 am Randy Dunlap wrote:
> On Thu, 25 Oct 2007 06:06:03 -0500 Rob Landley wrote:
> > The rest sort of seems to make sense, although the kerneldoc comments in
> > include/scsi/scsi_device.h are before #defines instead of before function
> > definitions so the make xmldocs infrastructure (something in either
> > scripts/basic/docproc.c or scripts/kernel-doc) skips right over it
> > because it can't figure out the argument types.  Separate issue, todo
> > item for later...
>
> scripts/kernel-doc is supposed to (and usually does) handle
> kernel-doc notation of a #define macro.  Are these 2 not working?

Not when I tried it.

> $ make xmldocs
> make -C /home/landley/linux/hg O=/home/landley/linux/temp xmldocs
>   DOCPROC Documentation/DocBook/scsi_midlayer.xml
> Warning(/home/landley/linux/hg//include/scsi/scsi_device.h): no structured
> comments found 

Entirely possible I'm doing something wrong:

   <sect1 id="scsi_device.h">
      <title>include/scsi/scsi_device.h</title>
      <para>
      </para>
!Einclude/scsi/scsi_device.h
    </sect1>

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
