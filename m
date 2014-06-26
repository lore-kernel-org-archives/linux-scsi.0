From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: bnx2i: bnx2i_iscsi.c: Cleaning up variable is set
 more than once
Date: Thu, 26 Jun 2014 10:04:57 +0200
Message-ID: <53ABD429.9090306@redhat.com>
References: <1403705059-25834-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<53AADC16.9080301@redhat.com>	<1403716401.10214.2.camel@lbirv-waie-lx2.broadcom.com> <CAFo99gbp-CeoT-3rNkNJX1m79G+5zi7pJLjX9kYq=FEf1isn=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFo99gbp-CeoT-3rNkNJX1m79G+5zi7pJLjX9kYq=FEf1isn=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Eddie Wai <eddie.wai@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 06/26/2014 02:28 AM, Rickard Strandqvist wrote:
> 
> If it's not obvious, I do all my fixes without changing the previous
> intent. But obviously it is not always right, rather it is one of main
> reasons to fix this type of error :)

Yes it is obvious, your patch was correct (it didn't modify the function behaviour)
but helped to spot a defect.

> 
> But I'll make a new patch then, with = 3 ?

Yes, please submit a new patch which sets custom_length = 3 at the end of the function.

Thanks,
Maurizio Lombardi
