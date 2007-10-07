From: David Miller <davem@davemloft.net>
Subject: Re: generating a Linux WWN?
Date: Sat, 06 Oct 2007 19:48:36 -0700 (PDT)
Message-ID: <20071006.194836.66070475.davem@davemloft.net>
References: <1191679870.3338.17.camel@localhost.localdomain>
	<47079D64.3070000@garzik.org>
	<1191683096.3338.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42949
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751332AbXJGCsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Oct 2007 22:48:37 -0400
In-Reply-To: <1191683096.3338.29.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jeff@garzik.org, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Sat, 06 Oct 2007 10:04:55 -0500

> If you remember Rusty's guide to interfaces, this is a level 14 easy to
> misuse interface: "The obvious use is wrong"; since the obvious use is
> to put it in module parameters and have the problem go away (for
> now ...).  Actually, I could be harsher and say it's level 17 "There's
> no correct use" because statistically every time you use it, you expose
> yourself to potential duplicate WWNs.

Every time you use GIT you expose yourself to potential duplicate SHAs
which will corrupt the tree.

This argument borders on lunacy, give it up :-)
