From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: feral driver in -mm
Date: 27 Jun 2003 15:34:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056746053.1825.174.camel@mulgrave>
References: <20030627132727.024f2bf0.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:26885 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264733AbTF0UUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 16:20:01 -0400
In-Reply-To: <20030627132727.024f2bf0.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: "Martin J. Bligh" <mbligh@aracnet.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-06-27 at 15:27, Andrew Morton wrote:
> Has anyone actually used the linux-isp driver in -mm lately?  I just tried
> it and it didn't seem to be able to locate the HBA.
> 
> James, if you have an update handy I'd like to grab a copy.  Else I'll drop
> it I think.

My latest update in bitkeeper is at

bk://linux-scsi.bkbits.net/scsi-isp-2.5

If you'd prefer, I could email you a diff.  Just let me check to see if
Matt Jacob has a later version (he did also still say that he didn't
consider this ready for prime time).

James


