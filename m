From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mpt fusion: Power Management fixes for MPT SAS PCI-E
	controllers-revised
Date: Thu, 13 Mar 2008 16:41:55 -0500
Message-ID: <1205444515.2893.77.camel@localhost.localdomain>
References: <20080307104950.GA20496@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44747 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460AbYCMVl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 17:41:59 -0400
In-Reply-To: <20080307104950.GA20496@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com, djwong@us.ibm.com

On Fri, 2008-03-07 at 16:19 +0530, Prakash, Sathya wrote:
> This patch includes the review comments from James on the previous version.
> 
> The system power state changes like hibernation and standby are not happening
> properly with 106XE controllers, this patch modifies the driver to free
> resources and allocate resources in power management entry points

This is supposed to be a bug fix patch to get suspend/resume working.
Because you've made it dependent on the msi_enable patch, which is a
feature enhancement, it still can't go in the scsi-rc-fixes tree.

Isn't it just best at this point to go with Darrick's patch for fixing
2.6.25 and 2.6.24?

James


