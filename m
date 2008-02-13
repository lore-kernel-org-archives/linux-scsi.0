From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx: wrong order of SATA disks
Date: Tue, 12 Feb 2008 18:32:56 -0600
Message-ID: <1202862777.3137.176.camel@localhost.localdomain>
References: <20080212232240.3ffc9770@vingilot.sergknet>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45353 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763174AbYBMAdG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 19:33:06 -0500
In-Reply-To: <20080212232240.3ffc9770@vingilot.sergknet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Kononenko <sergk@sergk.org.ua>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-02-12 at 23:22 +0200, Sergey Kononenko wrote:
> Hello,
> 
> I have server with motherboard Supermicro X7DBR-3 (AIC-9410 onboard).
> And there are three SATA disks in following order:
> 1st drive bay: WD800AAJS-60
> 2nd drive bay: WD2500YS-01S
> 3rd drive bay: WD2500YS-01S
> in BIOS they listed in the same order.
> 
> But after I've loaded linux (2.6.23.14 and 2.6.24 tested) I had
> WD800AAJS-60 named as sdc, and two WD2500YS-01S as sda and sdb.
> Moreover then i've booted second time with same kernel and settings
> names for WD2500YS-01S swapped. Disk which had name sda become sdb and
> vice versa. I've noticed that through disk's serial numbers, because
> models are same.

I'm afraid this reordering of sdX is pretty much a fact of life on
hotplug storage busses, which SAS/SATA is.  The way around it is to use
udev and mount by id or uuid to keep stable device names.

James


