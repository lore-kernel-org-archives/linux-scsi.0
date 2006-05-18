From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fusion - mptspi - reset handler shouldn't be
	called	for other bus protocals
Date: Thu, 18 May 2006 09:54:56 -0500
Message-ID: <1147964096.3475.5.camel@mulgrave.il.steeleye.com>
References: <20060517221724.GA8700@lsil.com>
	 <1147907212.3463.99.camel@mulgrave.il.steeleye.com>
	 <446C8884.4030102@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:12524 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751227AbWEROzA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 10:55:00 -0400
In-Reply-To: <446C8884.4030102@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Thu, 2006-05-18 at 09:45 -0500, Michael Reed wrote:
> This patch looks as though it will result in not calling
> the reset handler for MPTBASE_DRIVER, MPTCTL_DRIVER, or
> MPTLAN_DRIVER.  The base and control drivers aren't
> associated with any particular board type.

I don't believe it will ... what makes you think that?

James


