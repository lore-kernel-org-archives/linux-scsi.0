From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: request to add aic94xx to -mm
Date: Fri, 28 Apr 2006 10:55:21 -0700
Message-ID: <20060428175521.GB18383@us.ibm.com>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com> <20060428172736.GA11321@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:30399 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751107AbWD1Rz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:55:26 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3SHtP0n001412
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 13:55:25 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3SHtPOk106478
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 13:55:25 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k3SHtOPe007078
	for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 13:55:25 -0400
Content-Disposition: inline
In-Reply-To: <20060428172736.GA11321@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Apr 28, 2006 at 11:54:05AM -0500, James Bottomley wrote:
> > Could you send any bugs found back to linux-scsi (not the kernel
> > bugzilla)?
> 
> not a bug strictly speaking, but it should stop including the firmware
> blob and use request_firmware, similar to the discussion we had about
> qla2xxx recently.  It would be even nicer if adaptec continued publishing
> their sequencer code as with aic7xxx and aic79xx which look remarkably
> similar, of course.

I added Rob to this thread so he could comment on this.

It would also be good before we put another card through this process that
at least a few distros have the request_firmware infrastructure fully
functional. I have seen indications that there where a few bumps in the
road in getting this working.

-andmike
--
Michael Anderson
andmike@us.ibm.com
