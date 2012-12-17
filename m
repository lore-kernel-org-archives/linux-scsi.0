From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -next] [SCSI] mpt3sas: remove unused variables
Date: Mon, 17 Dec 2012 11:31:56 +0000
Message-ID: <1355743916.2352.14.camel@dabdike.int.hansenpartnership.com>
References: <20121211205651.GA5312@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51443 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab2LQLcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 06:32:01 -0500
In-Reply-To: <20121211205651.GA5312@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, jejb@kernel.org, yongjun_wei@trendmicro.com.cn, weiyj.lk@gmail.com, Nagalakshmi.Nandigama@lsi.com

OK, so I'll give you a B for effort on this one, but:

On Wed, 2012-12-12 at 02:26 +0530, sreekanth.reddy@lsi.com wrote:
> The variable 'chain_flags' and 'phy_number' are initialized but never
> used otherwise,
> So remove those unused variables.

There has to be a

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

At the beginning of this patch so git gets the authorship correct

> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> Acked-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

And this should be Signed-off-by: you not acked-by, because you sent the
patch to me (signoffs follow the trail of transmission).

I've fixed all of this up, for this one time.

James


