From: Douglas Gilbert <dougg@torque.net>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 10:59:47 -0400
Message-ID: <4703AE63.3010109@torque.net>
References: <50432.44268.qm@web31802.mail.mud.yahoo.com> <47032C67.8080109@garzik.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44238 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbXJCPAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 11:00:46 -0400
In-Reply-To: <47032C67.8080109@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: ltuikov@yahoo.com, Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Luben Tuikov wrote:
>> --- Jeff Garzik <jeff@garzik.org> wrote:
>>> The admin will have the option to auto-generate a WWN, should they so
>>> desire.
> 
>> What does that mean?  "auto-generate"?  By whom?
> 
> The admin tells the kernel module to auto-generate a WWN, and the kernel
> module happily obliges.
> 
> The generation algorithm is whatever makes people happy.  I would
> probably pick a fixed prefix like 0x6C 0x69 0x63 ("lin"), something that
> doesn't conflict with IEEE org ids for a long time to come.  Then,
> get_random_bytes() or hash some useful machine characteristics for the
> rest of the bytes.
> 
> 
>> What if they don't "auto-generate" (whatever that means)?
> 
> Well, you either have a WWN or you don't :)

Jeff,
It is not quite black and white. As I tried to point
out, when a SAS HBA is run in target mode, there is
a good chance there aren't _enough_ unique SAS addresses
allocated by the manufacturer.

There should be naa-5 addresses for the ports, it is
the target device address and 0 or more lu addresses that
may need to be generated.


Doug Gilbert


