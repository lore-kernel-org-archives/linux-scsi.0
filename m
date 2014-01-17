From: Steve Magnani <steve.magnani@digidescorp.com>
Subject: Re: Why is (2 < 2) true? Is it a gcc bug?
Date: Fri, 17 Jan 2014 09:47:05 -0600
Message-ID: <52D95079.1060803@digidescorp.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com> <CAFLxGvz3FKU4rgjF_uZsggjvw8TQw_Hcp42GC8Zr-wg5kiwc-w@mail.gmail.com> <D9FFE20C522965449E182ACE73889AEB1A6A3592@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35939 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAQPrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 10:47:08 -0500
Received: by mail-ig0-f175.google.com with SMTP id uq10so1896568igb.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2014 07:47:07 -0800 (PST)
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A6A3592@IRSMSX105.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>, Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/17/2014 08:55 AM, Dorau, Lukasz wrote:

> On Friday, January 17, 2014 2:58 PM Richard Weinberger <richard.weinberger@gmail.com> wrote:
>> Can you reproduce this using a standalone test?
>> I.e:
>> #include <assert.h>
>>
>> int main()
>> {
>>          assert(2 < 2 != 1);
>>
>>          return 0;
>> }
>>
> No, I can't of course.
>
The test might need to be more complex in order to prevent the compiler from optimizing away the issue. Or, you could try -O0.

------------------------------------------------------------------------

  Steven J. Magnani               "I claim this network for MARS!

  www.digidescorp.com              Earthling, return my space modulator!"

  #include <standard.disclaimer>

