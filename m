From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] scsi: replace broken specification URL
Date: Fri, 9 Sep 2016 15:53:46 -0700
Message-ID: <e0b5167f-4150-1978-6020-5d1c4065a6e6@gmail.com>
References: <1467442596-31310-1-git-send-email-michael.opdenacker@free-electrons.com>
 <1467470971.2400.7.camel@HansenPartnership.com>
 <c7b4c63e-af53-401c-3854-d3edea258e53@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:32782 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754738AbcIIWxu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 18:53:50 -0400
In-Reply-To: <c7b4c63e-af53-401c-3854-d3edea258e53@free-electrons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 09/09/2016 01:16 AM, Michael Opdenacker wrote:
> Hi James,
> 
> Thank you very much for your help...
> 
> On 02/07/2016 16:49, James Bottomley wrote:
>> On Sat, 2016-07-02 at 08:56 +0200, Michael Opdenacker wrote:
>>> The t10.org website containing SCSI-2 draft specifications now
>>> requires to be from a member company to access the documents.
>>>
>>> This replaces the now broken link with another public resource
>>> where the specifications can be found.
>> Just because T10 implemented a pay wall for standards, doesn't mean
>> they're not still the definitive source.
>>
>> Adding a note about where you can get free versions is a useful
>> service, please do, but we have to keep the official links.  To be
>> honest the Duisberg site doesn't seem useful because it only has the
>> CAM standard.
> 
> Understood. I found another location where all the documents seem to be 
> available:
> http://www.csit-sun.pub.ro/~cpop/Documentatie_SMP/Standarde_magistrale/SCSI/

This link is just a blank page with the CSIT background image when I
follow it. This worked for me though:

http://www.csit-sun.pub.ro/~cpop/?dir=./Documentatie_SMP/Standarde_magistrale/SCSI

-Tyrel

>>
>> The Wayback machine is more useful because it keeps a copy of the site
>> (with the attached standards) just before the paywall went up:
>>
>> https://web.archive.org/web/20080828112749/http://t10.org/drafts.htm
> 
> However, the PDF file from 
> https://web.archive.org/web/20080828112749/http://t10.org/ftp/t10/drafts/cam/cam-r12b.pdf 
> fails to load at a 130810 byte limit. Other people have reported a 
> similar file size issue in the past.
> 
> So, should we only that the cam-r12b document can be found from 
> http://www.t10.org/t10docs.htm (registration required)?, and tell that a 
> copy can be found on 
> http://www.csit-sun.pub.ro/~cpop/Documentatie_SMP/Standarde_magistrale/SCSI/?
> 
> I'm trying to fix broken links in kernel documentation, which I publish 
> on http://free-electrons.com/kerneldoc/ . I have a broken link checker 
> for the http://free-electrons.com/ website, and it finds all the broken 
> links on http://free-electrons.com/kerneldoc/ . That's a good thing, 
> isn't need, but it means I have to get rid of the broken links :)
> 
> Thanks again for your help,
> 
> Cheers,
> 
> Michael.
> 

