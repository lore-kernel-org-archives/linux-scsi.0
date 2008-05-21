From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 2/3][-mm] reclassify the sg_sysfs_class mutex
Date: Wed, 21 May 2008 09:25:58 +0800
Message-ID: <a8e1da0805201825w4c8e35d7o55db8af9e04981df@mail.gmail.com>
References: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
	 <20080520172259.GB11666@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:28021 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbYEUB0C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 21:26:02 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1276566tic.23
        for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 18:25:58 -0700 (PDT)
In-Reply-To: <20080520172259.GB11666@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, matthew@wil.cx, kay.sievers@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 1:22 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, May 20, 2008 at 05:58:51PM +0800, Dave Young wrote:
>> [Please first apply the patch 1/3 before this]
>>
>> To please lockdep here we use class_reclassify to change
>> the lock class of sg_sysfs_class
>
> Are you suggesting we do this for every struct class in the kernel?  If
> so, why not just do it in the class core, instead of having to modify
> every single caller?

I don't think it necessary to do this for every class, because only
class_interface_* calls could cause the issue, and the
class_interface_* are only used by pcmcia & scsi, do you think there
will be other users of them?

>
> I don't think the overall idea of this patch set is acceptable anyway :(
>
> thanks,
>
> greg k-h
>
