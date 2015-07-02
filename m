From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 0/6] Fixes for memory corruption in mpt2sas
Date: Thu, 2 Jul 2015 13:22:27 -0600
Message-ID: <55958F73.5070208@fb.com>
References: <20150506184852.GA1007288@mail.thefacebook.com> <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25432 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754104AbbGBTW4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2015 15:22:56 -0400
In-Reply-To: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Christoph Hellwig <hch@infradead.org>

On 05/14/2015 09:41 PM, Calvin Owens wrote:
> Hello all,
>
> This patchset attempts to address problems we've been having with
> panics due to memory corruption from the mpt2sas driver.
>
> I will provide a similar set of fixes for mpt3sas, since we see
> similar issues there as well. "Porting" this to mpt3sas will be
> trivial since the part of the driver I'm touching is nearly identical
> between the two, so I thought it would be simpler to review a patch
> against mpt2sas alone at first.
>
> I've tested this for a few days on a big storage box that seemed to be
> very susceptible to the panics, and so far it seems to have eliminated
> them.

Guys, can someone outside of FB please review this? We're hitting random 
memory corruptions without these fixes.

-- 
Jens Axboe

