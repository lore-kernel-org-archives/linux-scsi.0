From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 4/9] mpt2sas: Config request and diag reset deadlock
Date: Fri, 14 Aug 2009 18:19:18 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C14252F674E@inbmail01.lsi.com>
References: <20090807140552.GE5807@lsi.com>
 <1250199417.3901.193.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:41191 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbZHNMuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 08:50:20 -0400
In-Reply-To: <1250199417.3901.193.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "stable@kernel.org" <stable@kernel.org>

James,

I have recreated this patch. This patch was a miss because of difference in baseline on which I have created. Now it is created using
2.6.31-rc6.



- Kashyap


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Friday, August 14, 2009 3:07 AM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya; stable@kernel.org
Subject: Re: [PATCH 4/9] mpt2sas: Config request and diag reset deadlock

On Fri, 2009-08-07 at 19:36 +0530, Kashyap, Desai wrote:
> Moving the setting and clearing of the mutex's to
> _config_request. There was a mutex deadlock when diag reset is called from
> inside _config_request, so diag reset was moved to outside the mutexs.
> ---
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> Signed-off-by: Eric Moore <Eric.moore@lsi.com>

Signoffs go before the --- othewise git ignores them, please

This patch doesn't apply.  The rest all do, so I have the other eight,
please redo this one against scsi-rc-fixes-2.6.git.

Thanks,

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
