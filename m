From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 17 Dec 2007 14:24:46 +0200
Message-ID: <47666A8E.7090600@panasas.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <20071217031841.f483e5ac.akpm@linux-foundation.org> <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com> <47666904.8060605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6991 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935644AbXLQMY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 07:24:58 -0500
In-Reply-To: <47666904.8060605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Filippos Papadopoulos <psybases@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Dec 17 2007 at 14:18 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Mon, Dec 17 2007 at 13:41 +0200, "Filippos Papadopoulos" <psybases@gmail.com> wrote:
>> On Dec 17, 2007 1:18 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Mon, 17 Dec 2007 11:39:47 +0200 "Filippos Papadopoulos" <psybases@gmail.com> wrote:
>>>
>>>> Hi,
>>>> I have got an INITIO 9100 UW SCSI Controller with an IBM
>>>> IC35L036UWD210-0 scsi hard disk on a 32 bit x86 system.
>>>> Currently i have SUSE 10.1 (Kernel 2.6.16).
>>>>
>>>> I tried to install OpenSUSE 10.3 (kernel 2.6.22.5) and the latest
>>>> OpenSUSE 11.0 Alpha 0  (kernel 2.6.24-rc4) but although the initio
>>>> driver
>>>> gets loaded during the installation process, yast reports that no hard
>>>> disk is found. I believe that this isnt a bug in suse's yast but a
>>>> problem
>>>> in the initio scsi driver because i also tried to install Fedora 8
>>>> (kernel 2.6.23) with the same problem.
>>>> I have seen the relevant thread "Conflict when loading initio driver"
>>>> and i suppose that the initio driver isnt fixed yet.
>>>> I can help testing the new patches in the initio driver if someone is
>>>> interested.
>>> initio doesn't seem to have a maintainer...
>>>
>>> Are you able to identify any earlier kernel which worked OK?
>>>
>> I have this PC configuration since 2002. The initio driver worked
>> perfectly with 2.4 kernel series.
>> With the release of 2.6 kernel series the driver had been marked as
>> BROKEN and fixed at 2.6.9
>> (see at http://www.gossamer-threads.com/lists/linux/kernel/482582?search_string=SCSI%20updates%20for%202.6.9;#482582
>>   Christoph Hellwig  ->don't mark the initio 9100 driver broken)
>>
>>
>>> Maybe it's a new device?  If you can get the `lspci -vvxx' output
>>> for that device we can take a look.
>>>
>> No its not a new device.
>> -
> 
> I have found one problem. Please try patch [2] below and report.
> If it still fails try to enable debugging by setting with patch [1]
> these values at top of drivers/scsi/initio.c. And send dmsgs.
> 
> Boaz
> 
I forgot to ask. 2.6.22 should work. If still fails could you try
this 2.6.22.xx kernel?

Boaz

