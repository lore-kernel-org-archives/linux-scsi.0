From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Tue, 24 Sep 2013 14:08:23 +0200
Message-ID: <524180B7.7090307@gmail.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com> <20130920203222.GA14306@kroah.com> <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On 09/21/2013 07:24 AM, KY Srinivasan wrote:
> 
> 
>> -----Original Message-----
>> From: Greg KH [mailto:gregkh@linuxfoundation.org]
>> Sent: Friday, September 20, 2013 1:32 PM
>> To: KY Srinivasan
>> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
>> ohering@suse.com; jbottomley@parallels.com; hch@infradead.org; linux-
>> scsi@vger.kernel.org
>> Subject: Re: Drivers: scsi: FLUSH timeout
>>
>> On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
>>> The SD_FLUSH_TIMEOUT value is currently hardcoded.
>>
>> Hardcoded where?  Please, more context.
> 
> This is defined in scsi/sd.h:
> 
> #define SD_FLUSH_TIMEOUT        (60 * HZ)
>>
>>> On our cloud, we sometimes hit this timeout. I was wondering if we
>>> could make this a module parameter. If this is acceptable, I can send
>>> you a patch for this.
>>
>> A module parameter don't make sense for a per-device value, does it?
> Currently, the 60 second timeout is applied across devices. Ideally, I want to be
> able to control the FLUSH TIMEOUT as we currently do I/O timeout. If this is 
> acceptable, I can work on a patch for that as well.
> 
> Regards,
> 
> K. Y
>>
>> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hi,

Back to 2010, Mike(cc-ed) try to add a flush time out interface, similar
to what you want here, no idea why it's just ignored?
http://www.spinics.net/lists/linux-scsi/msg45017.html

Jack
