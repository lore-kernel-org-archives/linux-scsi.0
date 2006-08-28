From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] aic94xx: convert to request_firmware interface
Date: Mon, 28 Aug 2006 14:04:03 -0700
Message-ID: <20060828210403.GA1445@us.ibm.com>
References: <20060828155254.64027.qmail@web31809.mail.mud.yahoo.com> <1156780789.3465.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:34008 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S932122AbWH1VGa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 17:06:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7SL6Tsx017513
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 17:06:29 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7SL6Tuj274982
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 15:06:29 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7SL6SJX023069
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 15:06:28 -0600
Content-Disposition: inline
In-Reply-To: <1156780789.3465.13.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Mon, 2006-08-28 at 08:52 -0700, Luben Tuikov wrote:
> > --- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > 
> > > Re: [PATCH] aic94xx: convert to request_firmware interface
> > > This patch is too big to inline, so I attached it compressed.
> > 
> > This will not work.
> 
> It's currently working in my x86 system.
> 
> I haven't managed to test on a BE system yet to make sure I got all the
> swaps correct, though.

The firmware loading is working on my ppc64 system.

-andmike
--
Michael Anderson
andmike@us.ibm.com
