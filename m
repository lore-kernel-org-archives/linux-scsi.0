From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 12/24] mpt fusion: [2.6.30-rc6] fix for previous patch
	taskmgmt in progess should be cleared before return
Date: Wed, 27 May 2009 18:44:38 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A260AF5@inbmail01.lsi.com>
References: <20090522110235.GF16331@lsi.com>
 <1243011716.2873.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:54156 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255AbZE0NOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 09:14:39 -0400
In-Reply-To: <1243011716.2873.24.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

I have included all your review comments in my next submission.

Thanks
Kashyap

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, May 22, 2009 10:32 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 12/24] mpt fusion: [2.6.30-rc6] fix for previous patch taskmgmt in progess should be cleared before return

On Fri, 2009-05-22 at 16:32 +0530, Kashyap, Desai wrote:
> Small fix for previous Patch applied on 26/02/2009: subject line :
> "mpt fusion: config, Taskmgmt cmd, Internal cmd, Ioctl cmd changes".

OK, so this seems to be completely bogus as well since there's no such
patch in any of the trees.

If I look at what the patch is doing, it seems it should be merged with
your 11/24 "rewrite of ioctl_cmds internal generated function" which
introduces the bug?

James


