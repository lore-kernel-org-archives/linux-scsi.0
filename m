From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] SAS domain layout for Linux sysfs
Date: Mon, 25 Apr 2005 19:18:31 +0100
Message-ID: <20050425181831.GA14190@infradead.org>
References: <425D392F.2080702@adaptec.com> <20050424111908.GA23010@infradead.org> <426D1572.70508@adaptec.com> <20050425161411.GA11938@infradead.org> <426D2723.8070308@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61088 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262713AbVDYSSk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2005 14:18:40 -0400
Content-Disposition: inline
In-Reply-To: <426D2723.8070308@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, andrew.patterson@hp.com, Eric.Moore@lsil.com, mike.miller@hp.com, dougg@torque.net, Madhuresh_Nagshain@adaptec.com

On Mon, Apr 25, 2005 at 01:21:39PM -0400, Luben Tuikov wrote:
> You're are stating that:
> 1) You "only ever care about what's seen from a HA",
> 2) "if you have muliple SPI cards that are on a single parallel
>     bus you'll have the same bus represented twice"
> 3) "we have a scsi_device object for every lun
>     that's seen from a hba, linked to the HBAs Scsi_Host object
>     and not one shared by multiple HBAs"
> 
> So in effect, you _want_ duplication, right?  This is perfectly OK.
> In fact it is desirable (and has never been under question).

Yes.

> This isn't directly related to the RFC.  The RFC basically
> outlines the result of *a SAS discovery process*.  The discovery
> process/LLDD can register the LU many times.  This has *never* been an
> issue of discussion.

The point is that discovery must happen for each HBA separately because
we absolutely do not want to have global state.

