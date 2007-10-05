From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: generating a Linux WWN?
Date: Fri, 05 Oct 2007 18:14:48 -0400
Message-ID: <1191622488.3475.54.camel@localhost.localdomain>
References: <344765.55522.qm@web31815.mail.mud.yahoo.com>
	 <20071003.151729.95504687.davem@davemloft.net>
	 <1191622146.3475.51.camel@localhost.localdomain>
	 <20071005.151131.125883267.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53232 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbXJEWOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 18:14:51 -0400
In-Reply-To: <20071005.151131.125883267.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: ltuikov@yahoo.com, jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

On Fri, 2007-10-05 at 15:11 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Fri, 05 Oct 2007 18:09:06 -0400
> 
> > For the record, what the current in-kernel aic94xx driver does for this
> > case is allow a parameter override to specify the WWN in the case where
> > the card burned in one has gone missing or is corrupt.  I think this is
> > the correctly balanced approach to the problem.
> 
> Let's then provide a global and consistent knob for the user to set in
> this situation, instead of a different one per-driver.

Agreed; we can shift the parameter to the transport class so it's
consistent for all SAS drivers

> auto_wwn=1 or somthing like that

I'd far prefer

override_wwn = <fully specific WWN>

since I assume auto_wwn means get the kernel to generate one?

James


