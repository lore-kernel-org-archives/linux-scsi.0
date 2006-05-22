From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/6] mpt fusion - fibre channel target discovery	prematurely terminates
Date: Mon, 22 May 2006 11:45:40 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7011BBDE@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4507 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751088AbWEVRpo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 13:45:44 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



On Monday, May 22, 2006 11:35 AM,  Michael Reed wrote:
> > 
> > It's not so transient during reset processing.  I've measured 10 to
> > 15 seconds of elapsed time.  But, it always eventually succeeds.
> 
> Well, I should have said that the event occurs with some regularity
> during reset processing.  And that the duration of the EAGAIN response
> is 10 to 15 seconds.  I'd rather reschedule than msleep.
> 

Why?

Anyways ... if were going to sleep, I'd rather the sleeping/waiting be
done
from mpt_config when were are calling mpt_get_msg_frame(), instead
of the calling functions. Perhaps mpt_get_msg_frame triggering a signal
or something when its having a freed mf.

Eric 
