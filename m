From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] mvsas updated for 88SE64xx and 88SE94xx
Date: Fri, 27 Mar 2009 16:53:21 +0000
Message-ID: <1238172801.3292.20.camel@localhost.localdomain>
References: <FE3F06125A99254E8D92161AA4569C6F0693DCE5@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40381 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759206AbZC0QxZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 12:53:25 -0400
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F0693DCE5@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>
Cc: jeff@garzik.org, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Ying Chu <jasonchu@marvell.com>, Ke Wei <kewei@marvell.com>

On Thu, 2009-03-19 at 01:49 -0700, Andy Yan wrote:
> Greetings all,
> 	Here are updated mvsas driver with bugfixes and new features.
> This version contains following main changes
>   - Switch to new layout to support more types of ASIC.
>   - SSP TMF supported and related Error Handing enhanced.
>   - Support flash feature with delay 2*HZ when PHY changed.
>   - Support Marvell 94xx series ASIC for 6G SAS/SATA, which has 2
> 88SE64xx chips but any different register description.
>   - Support SPI flash for HBA-related configuration info.
>   - Other patch enhanced from kernel side such as increasing PHY type
> detection wait time. (http://lkml.org/lkml/2009/1/15/502)
> 
> The first patch is to update the Makefile and Kconfig for layout change.
> The second patch is to add the code for common use with ASICs.
> The thirst patch is to add the code for ASIC specific function and const
> value.
> The subjects of all patches are 
> [PATCH 1/3] Layout changes for new mvsas
> [PATCH 2/3] Common code for init and runtime
> [PATCH 3/3] ASIC specific

This looks fine.

The patch is still wrapped, though.  If you can't fix the mail client,
just do a text/plain attachment ... I can pull that into git.

Thanks,

James


