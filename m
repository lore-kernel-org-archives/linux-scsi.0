From: Pankaj B <xpankajbx@gmail.com>
Subject: Re: How to get scsi_device structure for /dev/sda
Date: Fri, 14 Oct 2011 13:16:51 +0530
Message-ID: <CALSejh6Q9Qbivar0JUKscut2ibQ13obbhAEoWAje5ZLtkq6xZg@mail.gmail.com>
References: <CALSejh5tmhtRLLni3mOGC3iCqJDy2rOgPxn2JVx7M3ni+FpR7Q@mail.gmail.com>
	<20111014073328.GA8541@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35083 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab1JNHqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2011 03:46:52 -0400
Received: by wyg34 with SMTP id 34so2695870wyg.19
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2011 00:46:51 -0700 (PDT)
In-Reply-To: <20111014073328.GA8541@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 14, 2011 at 1:03 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Oct 14, 2011 at 09:59:43AM +0530, Pankaj B wrote:
>> Hi,
>> Is it possible to get scsi_device structure for a disk attached to system?
>
> No.
>
>
Okay. Actually I want to issue ATA_16 CDB on /dev/sda through kernel module.
Any pointers, how it can be achieved?

Thanks,
Pankaj
