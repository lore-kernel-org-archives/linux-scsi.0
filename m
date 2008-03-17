From: brooks@netgate.net
Subject: Re: Bug in the scsi_id (0.9 version) utility
Date: Mon, 17 Mar 2008 11:38:41 -0700 (PDT)
Message-ID: <alpine.LRH.1.00.0803171135420.30028@ss.netgate.net>
References: <alpine.LRH.1.00.0803130824450.30028@ss.netgate.net>  <20080314060831.GA18884@linux.vnet.ibm.com> <1205501914.2904.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <1205501914.2904.9.camel@localhost.localdomain>
Sender: linux-hotplug-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-hotplug@vger.kernel.org, Brian.Fehling@citrix.com, xen@netgate.net, cases.634568.7962_21175.de8b732451@cases.netsuite.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> This is incorrect; SPC does specify zero in reserved fields.
>
>> The SAM definitions section and the SPC Keywords section provides a
>> definition of what should be in a reserved field.

Thanks for the clarification.  I've submitted the bug to OpenSolaris.

>> That said we are not required to be checking the reserved fields for zero
>> but in this case we are doing so to work around another device issue.
>>
>> Instead of adding yet another device work around to the "if" which
>> makes it hard to rework the code in the future as you do not know how many
>> vendor, models are running through certain non compliant checks (i.e. more
>> than the intend models may exhibit like behavior).
>>
>> We possible should look at updating how we handle not compliant behavior.
>> scsi_id.config is available but that must not be useful in all cases as
>> the standard page 83 code has a check for the pre-spc3-83 case even though
>> it is selectable through the config file and command line.
>
> Some type of blacklist might work: we're already starting to find USB
> devices that aren't too happy with VPD inquiries.

That makes sense.  Please let me know what you decide, and if there's 
anything more I can do to help.

Kevin
