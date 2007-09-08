From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sat, 8 Sep 2007 09:50:08 -0700
Message-ID: <20070908095008.08eb4930.randy.dunlap@oracle.com>
References: <20070907124800.GP16806@vanheusden.com>
	<p73fy1p9m57.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:21752 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXIHQud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Sep 2007 12:50:33 -0400
In-Reply-To: <p73fy1p9m57.fsf@bingen.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 08 Sep 2007 18:07:00 +0200 Andi Kleen wrote:

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

I'd say that someone needs to use a vendor kernel, or at least
begin with a vendor .config file...


> Signed-off-by: Andi Kleen <ak@suse.de>

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
