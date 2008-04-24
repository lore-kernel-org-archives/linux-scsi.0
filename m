From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] dpt_i2o: 64 bit support (take 3)
Date: Thu, 24 Apr 2008 10:39:53 -0500
Message-ID: <1209051593.3121.10.camel@localhost.localdomain>
References: <20080424150717.GA21438@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33478 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763448AbYDXPj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 11:39:57 -0400
In-Reply-To: <20080424150717.GA21438@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

Just gave it a cursory glance, and it looks OK, except for things like
this:

On Thu, 2008-04-24 at 17:07 +0200, Miquel van Smoorenburg wrote:
> +#elif defined(__linux__)

Could you get rid it, please?  For inclusion in the kernel, you can take
it as read that we're operating in a Linux environment, so the symbol
will always be defined (so you can just strip out the code that depends
on this symbol not being defined).

Thanks,

James


