From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sun, 09 Sep 2007 17:00:21 -0400
Message-ID: <1189371621.3526.28.camel@localhost.localdomain>
References: <20070907124800.GP16806@vanheusden.com>
	 <p73fy1p9m57.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33835 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754087AbXIIVA0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 17:00:26 -0400
In-Reply-To: <p73fy1p9m57.fsf@bingen.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2007-09-08 at 18:07 +0200, Andi Kleen wrote:
> Folkert van Heusden <folkert@vanheusden.com> writes:
> 
> > Hi,
> > 
> > Maybe it is a nice enhancement for make menuconfig to more explicitly
> > give a pop-up or so when someone selects for example a sata controller
> > while no 'scsi-disk' support was selected?
> 
> This has also bitten me one or two times. A reasonable way would
> be to just select SD automatically for !EMBEDDED
> 
> Here's a patch:
> 
> -Andi
> 
> Select BLK_DEV_SD for all SCSI/libata drivers
> 
> This avoid a common user mistake.

I can see where you're coming from, but logically, this is wrong.
There's a huge slew of enterprise machines that only have DVD on SATA.
On the other hand, all of these machines will have SCSI disk devices on
various other transports, so no harm is done, it's just an inelegant
solution.

James


