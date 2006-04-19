From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.14 regression: aic7xxx hangs on boot
Date: Wed, 19 Apr 2006 08:49:45 -0500
Message-ID: <1145454585.3465.5.camel@mulgrave.il.steeleye.com>
References: <44461FB5.8060705@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30868 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750756AbWDSNty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 09:49:54 -0400
In-Reply-To: <44461FB5.8060705@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Wed, 2006-04-19 at 12:32 +0100, Daniel Drake wrote:
> It's a bit of an odd one. 2.6.13 works (even in the present day), 2.6.14 
> does not. On 2.6.14, these messages appear during early boot:
> 
> 	<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> 	Recovery code sleeping
> 	Recovery code awake
> 	aic7xxx_abort returns 0x2003
> 	aic7xxx_dev_reset returns 0x2003
> 	Recovery SCB completes
> 
> These kind of mesages repeat quickly in a seemingly infinite loop, the 
> boot does not complete.

Really, 2.6.13-16 are the kernels around which the aic7xxx driver
changed rapidly.  What happens with 2.6.17-rc1?

James


