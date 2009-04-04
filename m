From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/6] mpt fusion: fix for previous patch taskmgmt in
	progress should be cleared before return
Date: Sat, 4 Apr 2009 15:15:15 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410E52A59@inbmail01.lsi.com>
References: <20090403114943.GB17721@lsi.com>,<1238780308.3359.58.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:58954 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbZDDJp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2009 05:45:27 -0400
In-Reply-To: <1238780308.3359.58.camel@mulgrave.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

After creating patch, I usually run check_patch script available in scripts directory of linux source tree.
Below changes are just to remove warning and error related to coding standards  from generated patch. 

If you suggest, not to have those changes merge with actual logical patch then please let me know. I can rework and resubmit.


Thanks
Kashyap
________________________________________
From: James Bottomley [James.Bottomley@HansenPartnership.com]
Sent: Friday, April 03, 2009 1:38 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 1/6] mpt fusion: fix for previous patch taskmgmt in progress should be cleared before return

On Fri, 2009-04-03 at 17:19 +0530, Kashyap, Desai wrote:
> -
> -       mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
> -       if (mf == NULL) {
> +       if ((mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc)) == NULL) {
>                 dfailprintk(ioc, printk(MYIOC_s_WARN_FMT

This is making a clear statement (assignment then check) less clear for
no practical purpose that I can see.

James


