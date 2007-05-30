From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: kexec and aacraid broken
Date: Wed, 30 May 2007 14:22:15 -0700
Message-ID: <86802c440705301422h4e1fe90fra5a809cede5903a8@mail.gmail.com>
References: <20070529191347.9b1edd8b.akpm@linux-foundation.org>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FB1@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:40512 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbXE3VWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 17:22:16 -0400
Received: by nz-out-0506.google.com with SMTP id n1so1666251nzf
        for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 14:22:15 -0700 (PDT)
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FB1@otce2k301.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@in.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

On 5/30/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> I believe this issue is a result of the aacraid_commit_reset patch (as
> posted for scsi-misc-2.6, enclosed to permit testing) not yet propagated
> to the 2.6.22-rc3 tree.
>
> This is the adapter taking longer than 3 minutes to start after a reset.
> I seriously doubt either of these patches suggested below will have an
> affect. And if they do, they are not root cause, one reduces the chances
> that the card will be reset during initialization (thus applied would
> likely mitigate this problem), the other prevents a panic when the
> Adapter is reset (removed, would result in dogs and cats sleeping with
> each other).
>
> Please use kernel parameter aacraid.startup_timeout=540 (merely larger
> than the default 180 seconds) when spawning the kexec or see if the
> aacraid_commit_reset.patch resolves the issue to confirm my hunch.
>

aacraid_commit_reset.patch is in the mainline already.

YH
