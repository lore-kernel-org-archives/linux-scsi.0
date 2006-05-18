From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fusion - mptspi - reset handler shouldn't be called for
 other bus protocals
Date: Thu, 18 May 2006 10:46:12 -0500
Message-ID: <446C96C4.5030800@sgi.com>
References: <20060517221724.GA8700@lsil.com>	 <1147907212.3463.99.camel@mulgrave.il.steeleye.com>	 <446C8884.4030102@sgi.com> <1147964096.3475.5.camel@mulgrave.il.steeleye.com> <446C8E87.5040102@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:1688 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751021AbWERPqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 11:46:18 -0400
In-Reply-To: <446C8E87.5040102@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>



Michael Reed wrote:

> 
> I'll test this patch in my config this morning.
> (I'll pull Eric's fix so that I know for sure
> it works as intended.)

Initial testing suggests that this patch is correct.
(Got a rag for the egg?)  mptctl_ioc_reset, mpt_ioc_reset are
entered when resets are induced.  mptfc_ioc_reset (new, coming)
is entered, mptspi_ioc_reset is NOT entered.

James, your patch is arguably more correct.

Eric?

Mike
