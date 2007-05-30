From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: kexec and aacraid broken
Date: Wed, 30 May 2007 14:19:49 -0700
Message-ID: <86802c440705301419g2ed59773vda15c3d2a9e90479@mail.gmail.com>
References: <20070530141723.GB3773@in.ibm.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:42335 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbXE3VTu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 17:19:50 -0400
Received: by wa-out-1112.google.com with SMTP id j4so1230421wah
        for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 14:19:49 -0700 (PDT)
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: vgoyal@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

On 5/30/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> Vivek Goyal [mailto:vgoyal@in.ibm.com] writes:
> > So most likely if we start disabling the interrupts
> > in .shutdown routine we might skip resetting adapter
> > on every kexec without any side affects?
>
> Not that simple. The .shutdown would need to perform more resource
> cleanups of the .remove call to prevent side effects. I need to move
> some of the .remove activity into the .shutdown handler to make sure the
> adapter is quiesced.
>
> I will hold off on submitting any of these changes until they are
> evaluated and tested; I am waiting for feedback from Yinghai on the
> other mitigations that I feel are closer to the root cause.
>
1. [SCSI] aacraid: superfluous adapter reset for IBM 8 series
ServeRAID controllers
2. [SCSI] aacraid: kexec fix (reset interrupt handler)
3. aacraid_commit_reset.patch
4. [PATCH] aacraid: fix shutdown handler to also disable interrupts

the kernel with this patch -4  and even without 1, 2, 3

can load other kernel with or without patch 1,2,3

YH
