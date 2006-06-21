From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 13:18:43 -0400
Message-ID: <44997F73.7040903@emulex.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F0290B5BB@otce2k03.adaptec.com>	 <20060621164150.GM31472@vienna.egenera.com>	 <20060621165057.GW1630@parisc-linux.org> <1150909340.20655.37.camel@gator.sc.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:27596 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750901AbWFURSu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 13:18:50 -0400
In-Reply-To: <1150909340.20655.37.camel@gator.sc.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@steeleye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

I agree with Eddie's points, with another small recommendation:

scsi <2:0:1:0> x00:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:

where x00 is byte 1 of the inquiry data - device type and qualifier.
Clarifies the H:C:T:L as well.

-- james

Eddie Williams wrote:
> Do you need the labels?  How about
> scsi 2:0:1:0:DASD:HP 18.2G:ATLAS10K3_18_SCA:HP05:02:
> 
> This keeps it short.  For those that are probably looking at this data
> the labels are not needed anyway.  It is easy to parse if someone wants.
> I used "DASD" just because that is what was referenced before.  I think
> I would prefer the number or "direct access" but either way I would not
> lose any sleep.
> 
> Eddie
> On Wed, 2006-06-21 at 10:50 -0600, Matthew Wilcox wrote:
>> On Wed, Jun 21, 2006 at 12:41:50PM -0400, Philip R. Auld wrote:
>>>>     scsi 2:0:1:0: Device: DASD HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 02
>>> Parsing this, (and the Matt's earlier version), there are 5 tokens
>>> there in the middle for 4 fields. How does one know what the vendor
>>> string is for example?
>> 1) This is not for parsing, it's informational for users.  Do tools
>> really still parse through /var/log/dmesg?
>>
>> 2) This information is available other ways, such as through sysfs and
>> procfs.
>>
>> 3) I know it's not obvious from the above example (damn HP firmware),
>> but these are actually fixed-size fields.  The first is 8 bytes, "HP 18.2G"
>> the second 16 bytes are "ATLAS10K3_18_SCA", the third is "HP05" and then
>> the ANSI ver is at the end.
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
