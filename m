From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Patch] scsi_dh_rdac.c: add Dell product information into rdac
	device handler
Date: Thu, 02 Oct 2008 10:31:05 -0500
Message-ID: <1222961465.3222.14.camel@localhost.localdomain>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF38@AUSX3MPC128.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40204 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbYJBPbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 11:31:37 -0400
In-Reply-To: <00FE57DD11E3A94893D5BD54C3358BE884BF38@AUSX3MPC128.aus.amer.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yanqing_Liu@Dell.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sekharan@us.ibm.com, Shyam_Iyer@Dell.com

On Thu, 2008-10-02 at 10:11 -0500, Yanqing_Liu@Dell.com wrote:
> Hi all,
> 
> Re-send this patch in the proper format. Thanks for James's email about
> this.
> ---
> 
> The following patch is to add Dell Powervault storage arrays into device
> list of rdac device handler.
> 
> 
> Signed-off-by: Yanqing Liu <yanqing_liu@dell.com>

This is all much better, thanks!

> --- linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 2008-09-29 02:31:26.000000000 -0400
> +++ linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c
> 2008-09-30 02:06:26.000000000 -0400
> @@ -590,6 +590,8 @@
> {"STK", "OPENstorage D280"},
> {"SUN", "CSM200_R"},
> {"SUN", "LCSM100_F"},
> + {"DELL", "MD3000"},
> + {"DELL", "MD3000i"},
> {NULL, NULL},
> };

This, unfortunately, is still  unapplyable ... looks like exchange has
eaten the initial TABs.  No-one seems to have managed to get outlook to
behave properly as a patch submission tool, so if you can't use an
alternative email tool (see Documentation/email-clients.txt) then just
attach the patch (until someone works out how to get outlook to behave,
it's the one case where only mime email works).

James


