From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
Date: Tue, 25 Sep 2012 08:06:59 +0400
Message-ID: <1348546019.2457.3.camel@dabdike>
References: <20120924210049.GA18527@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38824 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab2IYEHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 00:07:04 -0400
In-Reply-To: <20120924210049.GA18527@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, 2012-09-24 at 17:00 -0400, Jeff Garzik wrote:
> 
>  drivers/scsi/sd.c |    4 ++++
>  drivers/scsi/sd.h |    2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)

I'm not opposed in principle to doing this (except that it should be a
sysfs parameter like all our other controls), but what's the reasoning
behind needing it changed?

James


