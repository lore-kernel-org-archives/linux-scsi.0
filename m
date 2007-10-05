From: David Miller <davem@davemloft.net>
Subject: Re: generating a Linux WWN?
Date: Fri, 05 Oct 2007 15:49:01 -0700 (PDT)
Message-ID: <20071005.154901.88487279.davem@davemloft.net>
References: <1191622488.3475.54.camel@localhost.localdomain>
	<20071005.151711.112302061.davem@davemloft.net>
	<4706BDA4.7090106@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45331
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbXJEWtC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 18:49:02 -0400
In-Reply-To: <4706BDA4.7090106@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: James.Bottomley@SteelEye.com, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 05 Oct 2007 18:41:40 -0400

> And that's been my plan from day one...  which is remarkably a lot like 
> the behavior of several net drivers.  :)
> 
> * attempt to read WWN during module load
> * admin may optionally choose to manually specify OR auto-generate a WWN
> * fail, if no WWN [stating the obvious]

And like with networking cases, we have situations where a platform
might be able to assist.

There are several systems that provide a "system MAC address"
to use when you can't obtain one for a specific device.  This
valus is provided via a firmware property.

Similarly, we could ask an interface that goes to platform to
ask them for a WWN.

We have code which does this in some of the qlogic FC drivers
already.

