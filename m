From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/6] mpt fusion: fix for previous patch taskmgmt in
	progress should be cleared before return
Date: Fri, 03 Apr 2009 12:38:28 -0500
Message-ID: <1238780308.3359.58.camel@mulgrave.int.hansenpartnership.com>
References: <20090403114943.GB17721@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58692 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736AbZDCRic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 13:38:32 -0400
In-Reply-To: <20090403114943.GB17721@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-04-03 at 17:19 +0530, Kashyap, Desai wrote:
> -
> -       mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
> -       if (mf == NULL) {
> +       if ((mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc)) == NULL) {
>                 dfailprintk(ioc, printk(MYIOC_s_WARN_FMT

This is making a clear statement (assignment then check) less clear for
no practical purpose that I can see.

James


