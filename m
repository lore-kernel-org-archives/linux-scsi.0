From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/9] mpt fusion: error recovery improvements,andsynchronizing
 internal commands
Date: Tue, 25 Sep 2007 19:31:53 -0400
Message-ID: <46F99A69.6010304@garzik.org>
References: <664A4EBB07F29743873A87CF62C26D709D940E@NAMAIL4.ad.lsil.com> <46F95586.2020504@garzik.org> <46F98DDB.8070407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36752 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbXIYXcA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 19:32:00 -0400
In-Reply-To: <46F98DDB.8070407@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Michael Reed wrote:
> Jeff Garzik wrote:
>> Moore, Eric wrote:
>>> On Tuesday, September 25, 2007 11:32 AM,  James Bottomley  wrote:
>>>  
>>>>> Youve rejected the error recovery patchs, which is fair enough.  
>>>> Just the separation ... the actual patch looks OK.
>>>>
>>> I'll will continue working to separate the "error recovery
>>> improvements:" into smaller feature add, but will take some time.   I
>>> want some constructive feedback, and too big of patch is deterring some
>>> people from looking at it.
>> I think it's fair to break it up, as long as its clearly noted that the
>> patch is for review only.
> 
> Any chance the changes, properly documented, could be accepted as
> one big patch?  Breaking this code into smaller patches, when it's
> really intended as a driver update, could prove problematic.

I'll let James provide an authoritative answer, but in general, that's a 
bad way to do Linux engineering.  The worst case would be appearing 
every month or two, posted a single, huge "driver update" patch.  That 
set of changes is bi-sectable, but it does not fully collect the changes 
within the driver update.

Some consolidation of changes is just plain natural, so you strike a 
balance.  Nothing but big driver-update patches?  Bad.  Four bazillion 
individual patches, each for a single whitespace change, cleanup, etc.? 
  Also unwise.  The true balance is somewhere in the middle.

The more important or intrusive the change, within the overall driver 
update, the more important it is to separate out that logical change.

	Jeff



