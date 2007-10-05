From: David Miller <davem@davemloft.net>
Subject: Re: generating a Linux WWN?
Date: Fri, 05 Oct 2007 15:11:31 -0700 (PDT)
Message-ID: <20071005.151131.125883267.davem@davemloft.net>
References: <344765.55522.qm@web31815.mail.mud.yahoo.com>
	<20071003.151729.95504687.davem@davemloft.net>
	<1191622146.3475.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45368
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXJEWLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 18:11:33 -0400
In-Reply-To: <1191622146.3475.51.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: ltuikov@yahoo.com, jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 05 Oct 2007 18:09:06 -0400

> For the record, what the current in-kernel aic94xx driver does for this
> case is allow a parameter override to specify the WWN in the case where
> the card burned in one has gone missing or is corrupt.  I think this is
> the correctly balanced approach to the problem.

Let's then provide a global and consistent knob for the user to set in
this situation, instead of a different one per-driver.

auto_wwn=1 or somthing like that
