From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET #upstream] libata: separate out SFF and BMDMA
Date: Tue, 04 Nov 2008 14:38:12 +0900
Message-ID: <490FDFC4.6090806@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org> <49069317.3000600@garzik.org> <490F09F8.5070802@kernel.org> <490FDF06.80009@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <490FDF06.80009@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Jeff Garzik wrote:
>>> ACK patchset
>>
>> Jeff, are you gonna create #upstream soon?  I have other patches
>> targeted for #upstream and having a branch open and having patch orders
>> fixed there would help a lot.
> 
> Yep, I was waiting on the patchset in $subject to be resent, because
> otherwise there was no content for #upstream.
> 
> #tj-upstream sounded like it contained some work for 2.6.28 and some for
> later kernels, so I didn't want to pull it verbatim.

Ah... it was #tj-upstream before -rc1 opened and just contained fixes
and stuff you already acked.  I probably should have renamed it to
#tj-upstream-fixes.  Are you gonna push in the lost patches into 2.6.28?

Thanks.

-- 
tejun
