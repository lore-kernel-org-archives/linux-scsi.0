From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/4] libata: implement libata.spindown_compat
Date: Tue, 17 Apr 2007 10:01:57 -0500
Message-ID: <1176822118.3671.32.camel@mulgrave.il.steeleye.com>
References: <20070320150718.GF6152@htj.dyndns.org>
	 <20070320151359.GG6152@htj.dyndns.org>
	 <20070320152533.GH6152@htj.dyndns.org>
	 <20070320155548.GI6152@htj.dyndns.org>  <4624DD95.3070608@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48913 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932117AbXDQPCJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2007 11:02:09 -0400
In-Reply-To: <4624DD95.3070608@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br

On Tue, 2007-04-17 at 10:45 -0400, Jeff Garzik wrote:
> ACK patches 3-4 for upstream.  I'm dropping them, and requesting resend 
> when patches 1-2 are applied (which I also ACK).  Or, alternately, I 
> could apply all four patches with the other subsystem owner's assent, or 
> the other subsystem owner could apply all four patches now that I have 
> ACK'd them.  Pick any of the three options. :)

I've got 1 and 2 upstream to -mm via scsi-misc-2.6 already.
Unfortunately they're not simply separable since there's a bad
interaction with the sd messages rework that's also in scsi-misc.

James


