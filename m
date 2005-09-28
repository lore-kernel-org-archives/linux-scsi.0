From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Infinite interrupt loop, INTSTAT = 0
Date: Wed, 28 Sep 2005 11:24:46 -0500
Message-ID: <1127924686.4852.11.camel@mulgrave>
References: <20050928134514.GA19734@dspnet.fr.eu.org>
	 <1127919909.4852.7.camel@mulgrave>
	 <20050928160744.GA37975@dspnet.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:55719 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751108AbVI1QYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 12:24:52 -0400
In-Reply-To: <20050928160744.GA37975@dspnet.fr.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olivier Galibert <galibert@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Hack inc." <linux-kernel@vger.kernel.org>

On Wed, 2005-09-28 at 18:07 +0200, Olivier Galibert wrote:
> scsi1:0:0:0: Attempting to abort cmd ffff8101b1cdf880: 0x28 0x0 0x0
> 0xbc 0x0 0x3f 0x0 0x0 0x8 0x0

Hmm, that message doesn't appear in the current kernel driver.

Is this a non-standard kernel or non-standard aic79xx driver?

James


