From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8][SCSI] mpt2sas: Infinite loop can occur if
 MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
Date: Mon, 26 Aug 2013 12:41:26 +0400
Message-ID: <1377506486.3469.3.camel@dabdike>
References: <20130725055945.GA29898@lsi.com>
	 <1374760824.1952.1.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59854 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab3HZIlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 04:41:31 -0400
In-Reply-To: <1374760824.1952.1.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com

On Thu, 2013-07-25 at 07:00 -0700, James Bottomley wrote:
> On Thu, 2013-07-25 at 11:29 +0530, Sreekanth Reddy wrote:
> > Infinite loop can occur if IOCStatus is not equal to
> > MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value in the while loops in functions
> > _scsih_search_responding_sas_devices,
> > _scsih_search_responding_raid_devices and
> > _scsih_search_responding_expanders
> > 
> > So, Instead of checking for MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value,
> > in this patch code is modified to check for IOCStatus not equals to
> > MPI2_IOCSTATUS_SUCCESS to break the while loop.
> > 
> > Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> > Cc: stable@vger.kernel.org
> 
> Patches like this aren't acceptable any more: Greg will find this and
> reject it from Stable.
> 
> If there's a bug in the driver, it needs to be in a separate patch set
> for the fixes branch of SCSI to go upstream now rather than waiting for
> the merge window.  Only patches for the fixes branch can be tagged for
> stable.

Ping on this, please.  What do you want me to do?  I can strip the cc:
stable from the series and send it to the misc branch or you can
resubmit as two series: one for fixes with the stable tags and the rest
for misc.

James


