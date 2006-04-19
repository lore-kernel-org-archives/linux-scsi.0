From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.14 regression: aic7xxx hangs on boot
Date: Wed, 19 Apr 2006 11:02:07 -0500
Message-ID: <1145462527.6183.5.camel@mulgrave.il.steeleye.com>
References: <44461FB5.8060705@gentoo.org>
	 <1145454585.3465.5.camel@mulgrave.il.steeleye.com>
	 <444658BE.5080309@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:26265 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750969AbWDSQCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 12:02:15 -0400
In-Reply-To: <444658BE.5080309@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Wed, 2006-04-19 at 16:35 +0100, Daniel Drake wrote:
> James Bottomley wrote:
> > Really, 2.6.13-16 are the kernels around which the aic7xxx driver
> > changed rapidly.  What happens with 2.6.17-rc1?
> 
> Exactly the same.

OK ... so more details, like the dmesg up to the problem (primarily to
diagnose the transport parameters and what's on the bus).  Plus, what
were the transport parameters in the case where it worked
(from /proc/scsi/aic7xxx/*)

Also, if it's a multi-device bus is the problem caused by a single
device (as in do a binary search pulling things off the bus).

James


