From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Fri, 04 Jan 2013 09:04:04 +0800
Message-ID: <50E62A84.2070702@intel.com>
References: <1353906191.2523.25.camel@dabdike> <21511277.LLinyDpbAK@vostro.rjw.lan> <20121128013928.GB15971@htj.dyndns.org> <1354092969.2276.49.camel@dabdike> <20121203081321.GA9990@mint-spring.sh.intel.com> <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com> <20121203162323.GB19802@htj.dyndns.org> <50D2AB1D.9050602@intel.com> <20121225171723.GI10220@mtj.dyndns.org> <50DA55F6.8080706@intel.com> <20121228211635.GB3062@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20121228211635.GB3062@mtj.dyndns.org>
Sender: linux-pm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/29/2012 05:16 AM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 26, 2012 at 09:42:14AM +0800, Aaron Lu wrote:
>>> This is really a round-about way to find out the matching device and
>>> it wouldn't work if the disk device nests deeper.  Doesn't really look
>>> like a good idea to me.
>>
>> I don't quite understand the 'disk device nests deeper' case, can you
>> please elaborate? My understanding is, as long as the disk's part0
>> device has a parent, this function should work. For LLDs want to take
> 
> Hmmm, maybe I misread but it looked like it wouldn't work if there are
> intermediate nodes between the parent device and part0.  It might not
> happen for sata but I don't think it's a good idea to assume that the
> part0 and hardware device are connected directly.
> 
> In general, it's a quite roundabout way to do it.  Let's just push it
> through SCSI.  That's how everything else is routed after all.  It's
> confusing to do this one differently.

OK, thanks for the suggestion.
I'll prepare v11 using the previous demonstrated way(adding the
event_driven flag to scsi_device) to silence the poll.

Best regards,
Aaron

