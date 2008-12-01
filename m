From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Mon, 1 Dec 2008 13:49:31 -0800
Message-ID: <BA2B0040-C95D-42CE-9D12-EF8E1A752328@qlogic.com>
References: <1227043498.4949.21.camel@ogier> <C49C4ADF-8DA1-4D86-AEBB-AC46A04FCA62@qlogic.com> <492B1685.4020709@emulex.com> <F285E2FA-64A5-4BB6-ACC4-1B31EB19AFE6@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:9006 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYLAVte (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 16:49:34 -0500
In-Reply-To: <F285E2FA-64A5-4BB6-ACC4-1B31EB19AFE6@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Smart <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>

Hi James,

On Nov 25, 2008, at 6:38 AM, Seokmann Ju wrote:
>
> On Nov 24, 2008, at 1:03 PM, James Smart wrote:
[snip]
>>
>>> 2. Would  it be valuable to consider sending requests with
>>>   WWNN:WWPN?
>>
>> I considered this, especially for the fchost ELS request. But it  
>> means the LLDD has to do a nameserver query to find the n_port_id
>> corresponding to the names before it sent the ELS. It started to feel
>> like too much ancillary stuff for the LLDD to do to support the
>> request - so I punted.  However, the app, where we typically don't
>> care if it has to do more work, is free to do this and resolve it to
>> the basic primitives. :)
> Thanks, I've got it.
One minor questions/clarification.
If I understood correctly, ELS only supports single sg. If this is  
true, shouldn't it checked somewhere before the transport layer calls  
LLD?

Thank you,
Seokmann
