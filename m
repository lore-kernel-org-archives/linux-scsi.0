From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: kexec and aacraid broken
Date: Wed, 30 May 2007 15:11:59 -0700
Message-ID: <86802c440705301511vb8b2065xeb59e1b06aff2fea@mail.gmail.com>
References: <86802c440705301422h4e1fe90fra5a809cede5903a8@mail.gmail.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A551D3@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:60122 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbXE3WMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 18:12:01 -0400
Received: by nz-out-0506.google.com with SMTP id n1so1676416nzf
        for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 15:12:00 -0700 (PDT)
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A551D3@otce2k301.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@in.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

On 5/30/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> Yinghai Lu [mailto:yhlu.kernel@gmail.com] writes:
> > aacraid_commit_reset.patch is in the mainline already.
>
> But aacraid_commit_reset.patch is not in 2.6.22-rc3 (to which you report
> the issue). Does the aacraid_commit_reset.patch work to resolve this
> issue all by itself in the kexec'd kernel? Or alternatively did you try
> aacraid.startup_timeout=540 as one of the kernel parameters passed to
> the kexec'd kernel?

No, still get adapter kernel panic

>
> The '[PATCH] aacraid: fix shutdown handler to also disable interrupts'
> patch (you refer to this as patch 4) is not to be in the picture because
> it will hide the root cause. I believe I have you correct in stating
> that this patch (4) resolves the problem... but I expect the problem to
> remain with kdump.

Oh.
without patch(4), latest kernel still can use kexec to 2.6.21.3
will try to load 2.6.22-rc1 etc.

YH
