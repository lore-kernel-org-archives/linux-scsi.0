From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: RE: [PATCH] Don't change direction flags in struct request.
Date: Thu, 18 Mar 2010 19:21:23 -0700
Message-ID: <233671224A0FED4688218FFDBED26E1A5537FE3E37@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <1268976690-3386-1-git-send-email-hdasch@broadcom.com>
 <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
 <4B9ABA84.9020801@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2004 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0CSCVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 22:21:37 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, Eddie Williams <Eddie.Williams@steeleye.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hugh Daschbach [mailto:hdasch@broadcom.com] wrote:
> Mike Christie [mailto:michaelc@cs.wisc.edu] writes:

>> On 03/19/2010 12:31 AM, Hugh Daschbach wrote:
>>> The EMC multipath device handler should not change the I/O direction
>>> flags of its trespass command request.

...

>> Did you try the patch I linked to the last time you posted about this?

> I have not.  When I read it, I believed it would fix the issue.

>> I think there should be a patch which fixes this problem here:
>> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=6c71dcb28ff9b63b814a0b76a256f5dae08d3e0d;hp=3a5b27bf6f29574d667230c7e76e4b83fe3014e0
>> I think it got into 2.6.34-rc1.

> Then I'll pull it and test it.

>> With that patch mode selects should get set up as writes.
>>
>> Does it work? If it does then I think we just need the attached cleanup 
>> patch which removes the cmd_flags setting. The patch that got merged 
>> fixed the problem of initializing the request properly, but it forgot to 
>> remove the cmd_flags setting.

> Agree.  I'll test it early next week and confirm.

I have pulled and tested this patch.  It does fix my issue.

Thanks,
Hugh

