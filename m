From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Tue, 18 Dec 2012 16:30:51 +0800
Message-ID: <50D029BB.7060408@intel.com>
References: <1353906191.2523.25.camel@dabdike> <21511277.LLinyDpbAK@vostro.rjw.lan> <20121128013928.GB15971@htj.dyndns.org> <1354092969.2276.49.camel@dabdike> <20121203081321.GA9990@mint-spring.sh.intel.com> <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com> <20121203162323.GB19802@htj.dyndns.org> <1354623100.3206.34.camel@dabdike.int.hansenpartnership.com> <50C1891A.7040900@intel.com> <50C5564F.8030000@intel.com> <20121211051027.GB1932@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20121211051027.GB1932@mtj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Everyone,

Due to lack of information, I think I'll go ahead and pick up a simple
solution for this(i.e. the code I attached previously to set a flag
event_driven in scsi_device to let sr skip events poll) and send a new
series out for you to review. After all, I can't wait forever...

Please feel free to let me know if you don't think I should send a new
series with the above mentioned solution.

Thanks a lot for your(all of you) kind help and comments.

-Aaron

On 12/11/2012 01:10 PM, Tejun Heo wrote:
> Hello, guys.
> 
> On Mon, Dec 10, 2012 at 11:26:07AM +0800, Aaron Lu wrote:
>>>>> The problem here is there's no easy to reach genhd from libata (or the
>>>>> other way around) without going through sr.  I think we're gonna have
>>>>> to have something in sr one way or the other.
>>>>
>>>> Can't we do that via an event? It's a bit clunky because we need the
>>>> callback in the layer that sees the sdev, which is libata-scsi, we just
>>>> need an analogue of ata_scsi_media_change_notify, but ignoring and
>>>> allowing polling is essentially event driven as well, so it should all
>>>> work.  We'll need a listener in genhd, which might be trickier.
> 
> I'm not really following what you mean.  Can you please elaborate?
> One way or the other, doesn't the notification have to bubble up
> through SCSI?
> 
>> A colleague of mine reminded me that it's impolite to write something
>> like this, and here is my apology. I didn't mean to be rude, I'm sorry
>> for this if it made you feel uncomfortable.
> 
> Oh, no, it's not rude at all. I was just being distracted w/ other
> stuff and lazy.  Sorry about that.
> 
> Thanks.
> 

