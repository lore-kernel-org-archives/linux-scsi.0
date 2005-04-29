From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] SAS domain layout for Linux sysfs
Date: Fri, 29 Apr 2005 11:05:26 +0100
Message-ID: <20050429100525.GA3342@infradead.org>
References: <425D392F.2080702@adaptec.com> <20050424111908.GA23010@infradead.org> <426D1572.70508@adaptec.com> <20050425161411.GA11938@infradead.org> <426D2723.8070308@adaptec.com> <20050425181831.GA14190@infradead.org> <426E5BAF.4040003@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59030 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262231AbVD2KF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 06:05:28 -0400
Content-Disposition: inline
In-Reply-To: <426E5BAF.4040003@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, andrew.patterson@hp.com, Eric.Moore@lsil.com, mike.miller@hp.com, dougg@torque.net, Madhuresh_Nagshain@adaptec.com

On Tue, Apr 26, 2005 at 11:18:07AM -0400, Luben Tuikov wrote:
> On 04/25/05 14:18, Christoph Hellwig wrote:
> > The point is that discovery must happen for each HBA separately because
> > we absolutely do not want to have global state.
> 
> OK.
> 
> Can you please define "global state"?

Sure, quoting your initial mail:

/----------------------------------------------------------------------
| 2. Sysfs SAS Domain
| -------------------
|
| Represent everything which "sits out there" in the SAS
| domain, irrespective of how you connect to it.
|
| /sys/bus/sas/
| /sys/bus/sas/<WWN_ta0>/
| /sys/bus/sas/<WWN_ta0>/phys/
|
| ...
\----------------------------------------------------------------------

Here you have a global hiearchy.  We are not interested in that, though -
we only care for what's visible from a certain HBA.

> In SAS, when the domain changes, the controller(s) connected to the
> domain get notification and pass it to the discovery process, which
> will run again.

Same as with fibre channel, and that's fine and expected.

> Overall, since the discovery process gets (internally) a "picture"
> of the domain out there, it would be appropriate to show this
> "picture" to the user.

Absolutely. 
