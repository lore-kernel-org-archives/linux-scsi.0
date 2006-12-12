From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: AIC79XX abort -- hardware fault?]
Date: Tue, 12 Dec 2006 10:39:30 -0600
Message-ID: <1165941570.5903.19.camel@mulgrave.il.steeleye.com>
References: <1165940296.3257.35.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34564 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751546AbWLLQjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 11:39:43 -0500
In-Reply-To: <1165940296.3257.35.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-12-12 at 08:18 -0800, Sean Bruno wrote:
> > G'day.  One of the machines I maintain is having real trouble with the
> > AIC79XX HBA or the tape drive attached to it.  I believe this is a
> > hardware fault, but I am not certain where the problem lies.
> > 
> > Normally I would blame the cable or, maybe, the tape drive, but the
> > early stage of the fault and the reported SCSI driver state make me
> > wonder if this is perhaps an HBA fault?

The first question is what kernel version?  There was an aic79xx fix
that went in just prior to 2.6.19 that might help with this.

James


