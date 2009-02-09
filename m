From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sun, 08 Feb 2009 19:01:23 -0500
Message-ID: <498F7253.1070002@redhat.com>
References: <20090123041558.GC24652@parisc-linux.org> <4979AF62.7070409@redhat.com> <1232721777.4430.7.camel@macbook.infradead.org> <498DA052.6090605@redhat.com> <87f94c370902081206v71106c5fp9a7ef0400301a1ab@mail.gmail.com> <20090208204434.GF31509@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48747 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZBIABg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Feb 2009 19:01:36 -0500
In-Reply-To: <20090208204434.GF31509@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>

Matthew Wilcox wrote:
> On Sun, Feb 08, 2009 at 03:06:44PM -0500, Greg Freemyer wrote:
>   
>> I found a list of T10 activities just since just Dec. 1, 2008 and it
>> is a bit overwhelming.  (ie. 08-356r4 is but one of many recent
>> reports)
>>
>> http://www.t10.org/new_a.htm
>>
>> For those of us that don't live and breath the SCSI spec, is there an
>> overview site describing what is going on.
>>     
>
> I've been working off 08-149r7.pdf.  I'm sure that's been superseded by
> now.  
>
>   
>> 08-356r4 	SBC-3: WRITE SAME unmap bit 	David L. Black 	PDF (56608)	2008/12/10
>>     
>
> Probably interesting.  Haven't read it myself.
>   

This is only a four page proposal - basically, we would use the write 
same command with a special unmap bit set to tell the target that it may 
(at its option) unmap the blocks. If not, it would in fact have to set 
the data to the indicated pattern in the command which I presume would 
be all zeros in the normal case.
>   
>> 08-356r5 	SBC-3 Thin Provisioning Commands 	Fred Knight, David L.
>> Black 	PDF (387549)	2009/01/15
>>     
>
> Fred Knight seems to be the main coordinator of this effort, so yes.
>   

Fred and David Black both have been quite active.
>   
>> 08-149r7 	SBC - Thin Provisioning 	Frederick Knight 	PDF (281001)	2008/12/08
>>     
>
> That's the one I'm working from.
>
>   
>> 08-149r8 	SBC - Thin Provisioning 	Frederick Knight 	PDF (281387)	2009/01/09
>>     
>
> A newer version ... thought so.
>
>   
>> 09-011r1 	SBC-3 Thin Provisioning Threshold Notification 	Frederick
>> Knight 	PDF (32757)	2009/01/09
>>     
>
> Clearly related.
>
>   
>> 08-149r9 	SBC - Thin Provisioning 	Frederick Knight 	PDF (353888)	2009/01/15
>>     
>
> Even newer version of what I've been working from.
>
>   
>> 09-012r0 	Minutes: CAP - Thin Provisioning 12/4 con-call 	Frederick
>> Knight 	PDF (38063)	2008/12/08
>>     
>
> Probably tedious.
>
>   
>> 08-396r3 	SPC-4: Reporting support for all DIF types 	George Penokie
>> 	PDF (85358)	2009/01/14
>>     
>
> Unrelated, I would think.
>
> I'd go with 08-149r9 to get a good overview.
>
>   

