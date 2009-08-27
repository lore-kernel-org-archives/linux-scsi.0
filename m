From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Thu, 27 Aug 2009 12:35:34 +0300
Message-ID: <4A965366.7080409@panasas.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>	<1251267481-24135-6-git-send-email-martin.petersen@oracle.com>	<4A952D54.5010102@panasas.com> <yq1ab1l91zy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:38873
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752141AbZH0Jfk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 05:35:40 -0400
In-Reply-To: <yq1ab1l91zy.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 08/27/2009 09:58 AM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
>>> + *lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
>>> + (u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
>>> + (u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
>>> + (u64)cmd[13] << 48 | (u64)cmd[12] << 56;
> 
> Boaz> get_unaligned_be64()
> 
> As you noticed further down in that patch I do generally use the
> get_unaligned_* macros in "my own" code.
> 
> However, when I update somebody else's code I try to match the existing
> style.  And in this case rest of get_data_transfer_info() is using
> explicit shifts and to me it looks absolutely horrendous to mix the two.
> 
> I generally avoid mixing cleanups and new functionality.  I don't have a
> problem with switching over to the macros, but in that case I think the
> whole function should be updated.  And that should be an orthogonal
> patch.
> 

I don't know. For me it is like checkpatch. I do not submit code over 80
chars even if surrounding code does. "The new code rule".

I generally agree with what you say but I think there is a balance.
Personally, I think this is over the balance point, but it's your call.

Thanks
Boaz
