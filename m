From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Sun, 24 Aug 2014 10:39:41 +0200
Message-ID: <53F9A4CD.4030001@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53F8B674.2090103@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaHXIjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Aug 2014 04:39:47 -0400
In-Reply-To: <53F8B674.2090103@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>

Hi,

On 08/23/2014 05:42 PM, Douglas Gilbert wrote:
> On 14-08-23 10:52 AM, Hans de Goede wrote:
>> Hi All,
>>
>> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
>> I'm getting quite a few bug reports about issues with UAS drives.
>>
>> One if the issues is that there might be a number of bugs in the
>> abort handling path, as I don't think that was ever tested properly.
>>
>> So I'm wondering is there a way to test the abort path with a real
>> drive? E.G. submit some command which is known to take a significant
>> amount of time, and then abort it right after submitting ?
> 
> Hi,
> You might experiment with starting a streaming read
> from one shell (e.g. with dd or ddpt) and while that
> is underway, from another shell issue a
> 'sg_reset --device' and see what happens. If nothing then
> try 'sg_reset --target'.
>
> Aborting a single, long duration command from the user
> space (and only that command, assuming other processes might
> be using that disk) is not easy to do.

Thanks, I'll give sg_reset a try.

Regards,

Hans
