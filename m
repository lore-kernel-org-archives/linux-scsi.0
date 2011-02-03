From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/06] mptfusion : Description Patch
Date: Thu, 03 Feb 2011 11:29:12 -0600
Message-ID: <1296754152.3022.15.camel@mulgrave.site>
References: <20110203095823.GA23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42214 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756586Ab1BCR3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 12:29:18 -0500
In-Reply-To: <20110203095823.GA23502@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Thu, 2011-02-03 at 15:28 +0530, Kashyap, Desai wrote:
> MPT Fusion driver updates. Please consider it for next rc update.
> 
> [PATCH 01/06] mptfusion: Added new sysfs parameters for handle, sas_addr and
> haldles.
> [PATCH 02/06] mptfusion: Support SAS2.0 Devices with SAS1.0 Controllers
> [PATCH 03/06] mptfusion: Remove bus reset for mptsas module

These are all enhancements; they're not eligible for rc-fixes because
they're not bug fixes.

James


> [PATCH 04/06] mptfusion: mptctl_release is required in mptctl.c
> [PATCH 05/06] mptfusion: Fix Incorrect return value in mptscsih_dev_reset
> [PATCH 06/06] mptfusion: Bump version 03.04.18
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


