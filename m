From: Lee Duncan <lduncan@suse.com>
Subject: Re: Clarification for Persistent Reservation + All Registrants
Date: Wed, 17 Dec 2014 15:46:45 -0800
Message-ID: <549215E5.905@suse.com>
References: <1418425163.10743.61.camel@haakon3.risingtidesystems.com>	 <1418428361.2270.13.camel@HansenPartnership.com>	 <1418435595.10743.130.camel@haakon3.risingtidesystems.com>	 <1418456023.2351.1.camel@HansenPartnership.com> <1418538447.5431.56.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1418538447.5431.56.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "t10@t10.org" <t10@t10.org>, target-devel <target-devel@vger.kernel.org>, Ilias Tsitsimpis <i.tsitsimpis@gmail.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Sorry to come to this late, but I have one addition ...

On 12/13/2014 10:27 PM, Nicholas A. Bellinger wrote:
> On Sat, 2014-12-13 at 08:33 +0100, James Bottomley wrote:
>> On Fri, 2014-12-12 at 17:53 -0800, Nicholas A. Bellinger wrote:
>>> On Sat, 2014-12-13 at 00:52 +0100, James Bottomley wrote:
>>>> On Fri, 2014-12-12 at 14:59 -0800, Nicholas A. Bellinger wrote:
> lots of SNIP
>>
>> There is no reservation until a reserve command is issued.  Once an all
>> registrants reservation is issued, by any registered initator, all
>> registered initators then become the reservation holder.
>>
> 
> So based on the above, the issue raised by Ilias where once the original
> All Registrants reservation is released, the other registrations lose
> their 'implicit' reservation until someone does another RESERVE +
> type=All Registrants is a bug.

U belive your target Nicholas is working correctly. See that other
thread for more details.

> 
> Working on a proper bugfix for this now.
> 
> Thanks James!
> 
> --nab
> 


-- 
Lee Duncan
