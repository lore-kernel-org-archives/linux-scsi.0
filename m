From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 18 Jul 2003 14:15:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EC7F@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:43951 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S271872AbTGRVAy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 17:00:54 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>

Christoph,

<snip>
> >   with some creative structure overlays, etc.  Secondly, bundling
> >   firmware for all ISP types can lead to a rather large binary
> >   module (21xx - ~64kbytes, 22xx - ~90kbytes, 23xx - ~110kbytes).
> 
> Well, support for each of the subtypes can be conditional or even in
> their own submodules that share a common "library" module.
> 
> >   Unfortunately, it is support that ultimately becomes the
> >   overriding factor in maintaining the three-module build process.
> 
> Well, the current build process is horrible :)
>

I don't believe we are going to disagree on any of the technical or
maintainability aspects of having a single binary (or as you mention
selectable ISP configuration options).

> > Until a policy change, the 8.x driver in its current form will
> > have the limitation of only one driver, qla2100, qla2200, or
> > qla2300, can be built as part of the kernel at any given time.
> 
> This is not acceptable for a driver in mainline, just FYI.
> 

I've been (and currently am) pushing for some resultion on this issue.

Regards,
Andrew Vasquez
