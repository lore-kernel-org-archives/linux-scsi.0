From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 20:17:37 -0700
Message-ID: <20050823031737.GA31361@us.ibm.com>
References: <1124723180.5211.25.camel@mulgrave> <20050822214617.GA26441@us.ibm.com> <1124747956.5211.38.camel@mulgrave> <20050822221427.GA26767@us.ibm.com> <1124750826.5211.46.camel@mulgrave> <1124753185.5211.50.camel@mulgrave> <20050823003938.GA29211@us.ibm.com> <1124762584.5211.53.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58786 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932068AbVHWDRj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 23:17:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7N3Hc2t001868
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 23:17:38 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7N3HcpD234214
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 23:17:38 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7N3Hbpx008971
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 23:17:38 -0400
Content-Disposition: inline
In-Reply-To: <1124762584.5211.53.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Mon, Aug 22, 2005 at 09:03:03PM -0500, James Bottomley wrote:
> On Mon, 2005-08-22 at 17:39 -0700, Patrick Mansfield wrote:
> > But, we have to pass in a struct kref, to affect put/get_device, correct?
> 
> Correct.  Let me post the code mods to drivers/base/core.c so you can
> see how it works.

OK ... I thought that was what you intended but could not quite see it.

> Incidentally, it now passes your dev_child test without causing a slab
> corruption.

Great, tested with your two patches applied on recent 2.6.13-rc6-git tree,
and modprobe -r qla2300 now works fine.

-- Patrick Mansfield
