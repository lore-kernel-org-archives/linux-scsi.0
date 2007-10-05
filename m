From: David Miller <davem@davemloft.net>
Subject: Re: generating a Linux WWN?
Date: Fri, 05 Oct 2007 15:17:11 -0700 (PDT)
Message-ID: <20071005.151711.112302061.davem@davemloft.net>
References: <1191622146.3475.51.camel@localhost.localdomain>
	<20071005.151131.125883267.davem@davemloft.net>
	<1191622488.3475.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39930
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758492AbXJEWRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 18:17:12 -0400
In-Reply-To: <1191622488.3475.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: ltuikov@yahoo.com, jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 05 Oct 2007 18:14:48 -0400

> On Fri, 2007-10-05 at 15:11 -0700, David Miller wrote:
> > auto_wwn=1 or somthing like that
> 
> I'd far prefer
> 
> override_wwn = <fully specific WWN>
> 
> since I assume auto_wwn means get the kernel to generate one?

I think providing both possibilities (kernel auto-generated and user
specified) is appropriate.
