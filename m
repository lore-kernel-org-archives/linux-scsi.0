From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Fix for problems introduced by enabling MSI by default for MPT
	SPI controllers
Date: Wed, 09 Jul 2008 09:10:37 -0500
Message-ID: <1215612637.3293.1.camel@localhost.localdomain>
References: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72239@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34262 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbYGIOKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 10:10:41 -0400
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72239@hkgmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

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
I'm asking because usually we just follow the platform defaults unless
there's a specific reason to blacklist the individual device.

James


