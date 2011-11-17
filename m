From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sd: protection difficulties
Date: Thu, 17 Nov 2011 12:54:56 -0500
Message-ID: <4EC54A70.20406@interlog.com>
References: <4EC536D1.6080501@interlog.com> <yq1vcqifzt5.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:42494 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab1KQRzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2011 12:55:04 -0500
In-Reply-To: <yq1vcqifzt5.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

On 11-11-17 12:01 PM, Martin K. Petersen wrote:
>>>>>> "Doug" == Douglas Gilbert<dgilbert@interlog.com>  writes:
>
> Doug,
>
> Doug>  Now with zeros filling the user data part of each logical block
> Doug>  and a LB guard field of 0xffffffff that means any attempt to read
> Doug>  a LB before it is written will result in an error like this [lk
> Doug>  3.1.0]:
> Doug>   sd 6:0:0:0: [sdb]
> Doug>     Target Data Integrity Failure
> Doug>      Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE Sense Key :
> Doug>      Aborted Command [current] Add. Sense: Logical block guard
> Doug>      check failed CDB: Read(10): 28 20 00 00 00 00 00 00 08 00
> Doug>      end_request: I/O error, dev sdb, sector 0
>
> I'm guessing you are using an mpt2sas with recent firmware?

Yes:
   mpt2sas version 09.100.00.00 loaded

Whenever I report a bug to LSI (who are much better
than most) they always say to upgrade to the latest
firmware and re-test :-)

  LSI changed
> behavior to always check PI even when the app tag contains 0xFFFF (which
> means "don't check" this block).

That useful piece of information is well hidden!
[sbc3r29.pdf section 4.21.3 top of page 61]
You learn something every day.

> I have some patches that LSI haven't signed off on yet. Which is why I
> haven't posted them...

Hopefully this thread expedites matters.

Doug Gilbert


