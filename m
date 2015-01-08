From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 3/3] scsi: Remove scsi_ioctl.h
Date: Thu, 08 Jan 2015 13:26:18 -0800
Message-ID: <54AEF5FA.2030104@redhat.com>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com>	 <1420746479-25949-4-git-send-email-agrover@redhat.com> <1420749302.5830.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbbAHV0X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 16:26:23 -0500
In-Reply-To: <1420749302.5830.31.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de

On 01/08/2015 12:35 PM, James Bottomley wrote:
> On Thu, 2015-01-08 at 11:47 -0800, Andy Grover wrote:
>> Now that we have uapi/scsi/scsi.h, that is the logical place for SCSI ioctl
>> definitions to go. The kernel-specific stuff that remains is so little that
>> it can be folded into scsi/scsi.h, and scsi_ioctl.h removed.
>>
>> Remove all scsi_ioctl.h #includes since they all also include scsi/scsi.h,
>> except for ide-floppy_ioctl.c where we just replace it with including
>> scsi/scsi.h.
>
> What's the transition plan for userspace?  If you look at glibc
> currently, it supplies both scsi.h and scsi_ioctl.h.  If we're
> persuading the glibc folks to go with our versions from uapi, I think
> removing a file which is an effective compile breaker for userspace is a
> really bad idea.  Duplicating scsi_ioctl.h definitions in scsi.h would
> also cause them problems.

I will consult with the glibc devs and see what they think, and get back 
to you.

Thanks -- Andy
