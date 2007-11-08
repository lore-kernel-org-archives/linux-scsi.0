From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] sym53c8xx: fix setflag user command to control
	disconnects
Date: Thu, 08 Nov 2007 09:47:14 -0800
Message-ID: <1194544034.4018.6.camel@localhost.localdomain>
References: <4732221B.1000104@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:55375 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760063AbXKHRrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 12:47:18 -0500
In-Reply-To: <4732221B.1000104@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Wed, 2007-11-07 at 15:37 -0500, Tony Battersby wrote: 
> This patch fixes the sym53c8xx "setflag" user command to control
> disconnect privilege, which has been broken for a long time.

The first observation is that the sym specific setflags interface is
being replaced by the parallel transport specific sysfs interface.
However, as you've probably noticed, the SPI transport has no flag for
disconnect permission, so how important actually is this?  If it's
important, then we can put it in scsi_transport_spi ... if not, then we
should probably just eliminate it from sym2.

James


