From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fusion - mptspi - reset handler shouldn't be	called	for
 other bus protocals
Date: Thu, 18 May 2006 10:11:03 -0500
Message-ID: <446C8E87.5040102@sgi.com>
References: <20060517221724.GA8700@lsil.com>	 <1147907212.3463.99.camel@mulgrave.il.steeleye.com>	 <446C8884.4030102@sgi.com> <1147964096.3475.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:56978 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751111AbWERPLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 11:11:09 -0400
In-Reply-To: <1147964096.3475.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>



James Bottomley wrote:
> On Thu, 2006-05-18 at 09:45 -0500, Michael Reed wrote:
>> This patch looks as though it will result in not calling
>> the reset handler for MPTBASE_DRIVER, MPTCTL_DRIVER, or
>> MPTLAN_DRIVER.  The base and control drivers aren't
>> associated with any particular board type.
> 
> I don't believe it will ... what makes you think that?

Mis-reading the code.  :(

I'll test this patch in my config this morning.
(I'll pull Eric's fix so that I know for sure
it works as intended.)

Mike
