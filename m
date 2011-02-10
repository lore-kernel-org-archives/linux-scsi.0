From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/06] mptfusion : (Resend) Description patch
Date: Thu, 10 Feb 2011 15:05:58 +0000
Message-ID: <1297350358.4933.22.camel@mulgrave.site>
References: <20110210061746.GA31424@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47925 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab1BJPGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 10:06:03 -0500
In-Reply-To: <20110210061746.GA31424@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Thu, 2011-02-10 at 11:47 +0530, Kashyap, Desai wrote:
> MPT Fusion driver updates. Please consider it for next rc update.

We still have a basic confusion here:  Things that are enhancements or
optimisations can't go in the next rc update, they have to wait for the
merge window.  What I need are two separate patch sets: one for the
fixes tree and one for the merge window.  As long as the patches below
separate easily, I can do this manually (basically only 4,5 are bug
fixes) ... where do you want the version change to go?  With the entire
patch set (so in the merge window)?

James


> Resending patch set. Corrected posting to stable kernel as requested by
> Greg and following correct process of posting patches to stable kernel.
> 
> First three patches are New  Feature/Optimization. Patch 4,5 are Fixes.
> Removed sas_address sysfs addition as commented by James from patch-1.
> 
> [PATCH 01/06] mptfusion: (New Feature)Added new sysfs parameters for handle
> and haldles.
> [PATCH 02/06] mptfusion: (New Feature)Support SAS2.0 Devices with SAS1.0 Controllers
> [PATCH 03/06] mptfusion: (Optmization)Remove bus reset for mptsas module
> [PATCH 04/06] mptfusion: (Fix) mptctl_release is required in mptctl.c
> [PATCH 05/06] mptfusion: (Fix) Incorrect return value in mptscsih_dev_reset
> [PATCH 06/06] mptfusion: Bump version 03.04.18
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


