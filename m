From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Symbios-NCR 6285-3621 + Adaptec 2944W multilun problem
Date: Fri, 12 May 2006 08:56:52 -0700
Message-ID: <20060512155652.GA24900@us.ibm.com>
References: <44648D9C.2090602@cooperativaobrera.com.ar> <1147442986.3769.2.camel@mulgrave.il.steeleye.com> <44649CE5.7070604@cooperativaobrera.com.ar> <1147446596.3769.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:41904 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751293AbWELP5E
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 11:57:04 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4CFuthP017903
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 11:56:55 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4CFutck165556
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 09:56:55 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k4CFusBO028647
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 09:56:54 -0600
Content-Disposition: inline
In-Reply-To: <1147446596.3769.25.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Gabriel Gomiz <gomita@cooperativaobrera.com.ar>, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-05-12 at 11:34 -0300, Gabriel Gomiz wrote:
> > I'm attaching dmesg output. I'm sorry I forgot to attach it in the
> > last 
> > email. The I/O errors occur when the devices are being detected and 
> > whenever I try to access them. For example to do 'fsidk -l /dev/sdc'.
> 
> Well, what I was hoping for was mode sense messages but, unfortunately,
> there aren't any.  My suspicion is that the 6285 is dual controller
> running in RDAC mode and you're attached to the inactive controller (in
> that configuration it allowed INQUIRY and MODE SENSE through but errors
> out on all other I/O operations).  I think you can verify by physically
> removing one of the controllers and rebooting the array (or just attach
> the SCSI cable to the other controller)

I would agree with your suspicion as the error signature is similar to
ones I receive using some FC based storage in RDAC mode. This problem is
showing up more as we have more storage support move from other multipath
solutions implemented in the mid-layer to using device mapper.

-andmike
--
Michael Anderson
andmike@us.ibm.com
