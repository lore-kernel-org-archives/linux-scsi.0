From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: 28 Sep 2004 15:53:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096401196.2008.97.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org>
	<20040928193614.GB192475@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46209 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267765AbUI1Tx2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 15:53:28 -0400
In-Reply-To: <20040928193614.GB192475@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-28 at 15:36, Jeremy Higdon wrote:
> I was trying to be conservative -- I didn't know the reason for
> that limit.  By all means, let's remove it then.
> 
> Would you like me to regenerate the patch, or do you just want
> to apply it to your internal source that will eventually be
> fed back to us?

Well, don't go overboard on this ... there is a limit to the number of
outstanding requests any queue can have at one time...there's not much
point going over that since the block layer will throttle you when you
reach it.  I think it's 128, but it might be 256 ... but anyway, not
much larger.

James


