From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Questions about scsi.c
Date: Thu, 25 Oct 2007 10:32:41 -0700
Message-ID: <20071025103241.546b35ec.rdunlap@xenotime.net>
References: <200710250606.03301.rob@landley.net>
	<20071025084039.971383af.rdunlap@xenotime.net>
	<200710251325.37586.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:51155 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755383AbXJYRcr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 13:32:47 -0400
Received: from midway.site ([71.117.233.180]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 10:32:41 -0700
In-Reply-To: <200710251325.37586.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org

On Thu, 25 Oct 2007 13:25:37 -0500 Rob Landley wrote:

> On Thursday 25 October 2007 10:40:39 am Randy Dunlap wrote:
> > On Thu, 25 Oct 2007 06:06:03 -0500 Rob Landley wrote:
> > > The rest sort of seems to make sense, although the kerneldoc comments in
> > > include/scsi/scsi_device.h are before #defines instead of before function
> > > definitions so the make xmldocs infrastructure (something in either
> > > scripts/basic/docproc.c or scripts/kernel-doc) skips right over it
> > > because it can't figure out the argument types.  Separate issue, todo
> > > item for later...
> >
> > scripts/kernel-doc is supposed to (and usually does) handle
> > kernel-doc notation of a #define macro.  Are these 2 not working?
> 
> Not when I tried it.
> 
> > $ make xmldocs
> > make -C /home/landley/linux/hg O=/home/landley/linux/temp xmldocs
> >   DOCPROC Documentation/DocBook/scsi_midlayer.xml
> > Warning(/home/landley/linux/hg//include/scsi/scsi_device.h): no structured
> > comments found 
> 
> Entirely possible I'm doing something wrong:
> 
>    <sect1 id="scsi_device.h">
>       <title>include/scsi/scsi_device.h</title>
>       <para>
>       </para>
> !Einclude/scsi/scsi_device.h
>     </sect1>

!E is for exported symbols and that file has none.
USe !I instead.

---
~Randy
