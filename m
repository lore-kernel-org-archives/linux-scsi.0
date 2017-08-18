From: Steve Magnani <steve.magnani@digidescorp.com>
Subject: Re: Sniffing FC traffic
Date: Fri, 18 Aug 2017 09:33:49 -0500
Message-ID: <ea908e37-dfcc-547c-6f7a-704a2fee26df@digidescorp.com>
References: <20170818123717.GB4074@glanzmann.de>
 <CAAzz28iHSJjdTR9J67Wuxfd2b5WV4eDKR6GnM+S+i6CXBTVLrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:37280 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdHROdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2017 10:33:50 -0400
Received: by mail-io0-f175.google.com with SMTP id c74so33486213iod.4
        for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2017 07:33:50 -0700 (PDT)
In-Reply-To: <CAAzz28iHSJjdTR9J67Wuxfd2b5WV4eDKR6GnM+S+i6CXBTVLrg@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>



On 08/18/2017 08:31 AM, Laurence Oberman wrote:
> On Fri, Aug 18, 2017 at 8:37 AM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
>> I would like to create a setup that allows me to sniff FC traffic. Is it
>> possible with Linux or can someone recommend a setup that works. I want
>> to avoid buying a 120kUSD fabric analyzer.
>>
> There is no way to do this using adapters and generic F/C with Linux as the O/S.
> The ability to enable debugging in the F/C drivers will expose some of
> the internals but there is no way to sniff directly as far as I am
> aware.
>
> Many switches allow port level tracing facilities but inline sniffing
> using Linux and generic hosts is not possible.
>
> We have Finisars for inline tracing when we have to debug host and
> fabric issues.
>
> Software based FCOE using libfc and the Intel cards for example will
> allow Wireshark tracing but that is encapsulated F/C in Ethernet
> packets hence the Wireshark ability.
>
>
We have had some success using a (Teledyne) LeCroy analyzer. Its GUI 
(SierraNet) runs only on a Windows host, but it is capable of exporting 
a capture to Wireshark. This mostly shows just the ELS and FCP 
transactions; to debug low-level link issues you'd have to work with the 
original capture in SierraNet.

Like any other kind of analyzer the cost will be proportional to the 
speed of the link you're trying to sniff and the amount of capture depth 
you need. You may be able to save some money by getting secondhand 
equipment and/or running the link at lower speed when you need to debug 
something.

Regards,
------------------------------------------------------------------------
  Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com Earthling, return my space modulator!"

  #include <standard.disclaimer>
