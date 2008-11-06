From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] qla2xxx: Updated qla functions
Date: Thu, 06 Nov 2008 08:57:52 -0600
Message-ID: <1225983472.4703.68.camel@localhost.localdomain>
References: <alpine.OSX.1.00.0810161759460.903@n4012av9w19yf1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42718 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbYKFO56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 09:57:58 -0500
In-Reply-To: <alpine.OSX.1.00.0810161759460.903@n4012av9w19yf1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: James.Smart@emulex.com, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Thu, 2008-10-16 at 18:08 -0700, Anirban Chakraborty wrote:
> Following changes have been made:
> 1. Outstanding commands are based on a request queue, scsi_qla_host
> does not 
> maintain it anymore.
> 2. Interrupt registrations are done using response queue instead of
> device id.
> 
> Thanks,
> Anirban
> 
> Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

This patch gives rejections over current linus.  Additionally, it looks
like we get merge conflicts with scsi-rc-fixes (it has qla bug fixes in
it).  Could you respin these patches above scsi-rc-fixes?  I'll still
put them in scsi-misc-2.6 but I'll fold scsi-rc-fixes into scsi-misc as
well.

Thanks,

James


