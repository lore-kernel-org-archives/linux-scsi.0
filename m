From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] MTP FUSION: resending patch to disable MSI interrupt	by
 defualt.
Date: Mon, 23 Feb 2009 10:13:21 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C140E15ED69@inbmail01.lsi.com>
References: <20090222104911.GA6142@lsi.com>
 <1235314098.4531.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:55018 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZBWEne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Feb 2009 23:43:34 -0500
In-Reply-To: <1235314098.4531.7.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

Sorry for mail id problem. It is Kashyap.desai@lsi.com I used alias instead of SMTP mail id. I will make sure I use SMTP mail id in future.

Patch  by Yinghai at http://marc.info/?l=linux-scsi&m=123498532419609
and which I have sent is similar. It is ACK for Yinghai's patch. 

Thanks
Kashyap

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Sunday, February 22, 2009 8:18 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH] MTP FUSION: resending patch to disable MSI interrupt by defualt.

On Sun, 2009-02-22 at 16:19 +0530, Kashyap, Desai wrote:
> This Patch is submitted to with reference to MSI issue with some of LSI
> controller. Disabling it by default when module is loaded. 

Point of order here: this is *not* a resend of a previous patch.  This
is a bug fix of a previously sent patch (With a change in intended
behaviour).

> Signed-off-by: Kashyap Desai <kadesai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 96ac883..ea3aafb 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -91,9 +91,9 @@ MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
>  		controllers (default=0)");
>  
>  static int mpt_msi_enable_sas;
> -module_param(mpt_msi_enable_sas, int, 1);
> +module_param(mpt_msi_enable_sas, int, 0);

This is the actual bug fix, which isn't mentioned anywhere in the change
log

>  MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
> -		controllers (default=1)");
> +		controllers (default=0)");

This entire patch is also functionally identical to the second patch in
this email from Yinghai Lu:

http://marc.info/?l=linux-scsi&m=123498532419609

Open Source is a co-operative effort: The only thing you get at the end
of the day is kudos for finding (and possibly fixing) a bug, so since
Yinghai Lu did all the heavy lifting in this regard, I'll take this as
an ack of his patch.

James



Internal Virus Database is out of date.
Checked by AVG - http://www.avg.com 
Version: 8.0.233 / Virus Database: 270.6.6/1631 - Release Date: 8/24/2008 12:15 PM
