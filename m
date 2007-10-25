From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Questions about scsi.c
Date: Thu, 25 Oct 2007 08:40:39 -0700
Message-ID: <20071025084039.971383af.rdunlap@xenotime.net>
References: <200710250606.03301.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:42482 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757722AbXJYPkm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 11:40:42 -0400
Received: from midway.site ([71.117.233.180]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 08:40:39 -0700
In-Reply-To: <200710250606.03301.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org

On Thu, 25 Oct 2007 06:06:03 -0500 Rob Landley wrote:

> The rest sort of seems to make sense, although the kerneldoc comments in 
> include/scsi/scsi_device.h are before #defines instead of before function 
> definitions so the make xmldocs infrastructure (something in either 
> scripts/basic/docproc.c or scripts/kernel-doc) skips right over it
> because it can't figure out the argument types.  Separate issue, todo item for 
> later...

scripts/kernel-doc is supposed to (and usually does) handle
kernel-doc notation of a #define macro.  Are these 2 not working?


---
~Randy
