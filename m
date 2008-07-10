From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: Fix for problems introduced by enabling MSI by default for MPT
	SPI controllers
Date: Thu, 10 Jul 2008 16:38:34 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72405@hkgmail01.lsi.com>
References: <1215612637.3293.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48644 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYGJIjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 04:39:08 -0400
In-Reply-To: <1215612637.3293.1.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

We have some known cases of MSI not working with FC and SPI controllers, that is the reason we don't want to enable the MSI for them by default.
Thanks
Sathya

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Wednesday, July 09, 2008 7:41 PM
To: Prakash, Sathya
Cc: linux-scsi@vger.kernel.org; Moore, Eric
Subject: Re: Fix for problems introduced by enabling MSI by default for MPT SPI controllers

On Wed, 2008-07-09 at 14:54 +0800, Prakash, Sathya wrote:
> Recently there are some issues posted in the list with regards to failure of booting or failure of driver loading  when the MSI is enabled by default for MPT SPI controllers.
>
> James has already provided the patch for fixing the panic.
>
> But the reason for IOC bring up failure is enabling the MSI by default for SPI controllers.  The issue is introduced by the following patch. Which is intended for enabling the MSI only for SAS controllers but enables MSI for SPI, FC and SAS controllers.
> http://marc.info/?l=linux-scsi&m=120488594802569&w=4
>
> I have already posted another patch to rectify this so that MSI will not be enabled by default for SPI and FC controllers. The link for the correction patch is as below.
> http://marc.info/?l=linux-scsi&m=121131228827682&w=4

Is there an actual fault in the MSI controller on the SPI and FC fusion?
I'm asking because usually we just follow the platform defaults unless there's a specific reason to blacklist the individual device.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
