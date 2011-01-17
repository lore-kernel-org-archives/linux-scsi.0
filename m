From: Jeff Garzik <jeff@garzik.org>
Subject: Re: PMP and SEMB messages to SEP
Date: Mon, 17 Jan 2011 13:55:15 -0500
Message-ID: <4D349093.6070902@garzik.org>
References: <20110113192558.GE16039@MAIL.13thfloor.at> <20110114142018.GA978@htj.dyndns.org> <20110114165957.GH16039@MAIL.13thfloor.at> <20110114170407.GE978@htj.dyndns.org> <20110114173759.GI16039@MAIL.13thfloor.at> <20110117154042.GG27123@htj.dyndns.org> <1295281131.3015.44.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1295281131.3015.44.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Herbert Poetzl <herbert@13thfloor.at>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/17/2011 11:18 AM, James Bottomley wrote:
> On Mon, 2011-01-17 at 16:40 +0100, Tejun Heo wrote:
>>> - the SiI3726 supports GPIO pins, which can be reached via
>>>    the General Status and Control Register [130] and accoring
>>>    to the docu, the Read/Write Port Multiplier command can
>>>    be used to read/write that register.
>>>
>>>    + how would I go about issuing such a command and where
>>>      should it be done? i.e. what about interference with
>>>      other commands? what about retrieving return values?
>>
>> The problem is that the PMP device itself is currently not allocated a
>> userland visible device, so it doesn't have any /dev/* node.  Hmmm...
>
> So perhaps it should be.  If you look at the equivalent topology on SAS,
> our expanders have a bsg device node precisely so that we can do this.
>
> That said, SAS expanders have a defined protocol (SAS Management
> Protocol) to talk to the outside world, so they are real visible objects
> always in our topology ... I'm not sure PMP has this ... it seems that
> all PMP visibility is an extension to the standard?

Yes, we do need a way to address these devices.

	Jeff



