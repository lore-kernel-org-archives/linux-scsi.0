From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
Date: Tue, 17 Jul 2012 12:49:01 -0600
Message-ID: <5005B39D.6030905@cs.wisc.edu>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com> <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com> <50044D56.6000400@redhat.com> <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com> <50052390.7030908@redhat.com> <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com> <5005285E.8060706@redhat.com> <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com> <20120717163612.GA15995@infradead.org> <50059713.7090606@redhat.com> <5005B2AC.6020102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5005B2AC.6020102@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/17/2012 12:45 PM, Mike Christie wrote:
> On 07/17/2012 10:47 AM, Paolo Bonzini wrote:
>> Il 17/07/2012 18:36, Christoph Hellwig ha scritto:
>>>>> There's no such thing in the market today as a removable disk that's
>>>>> resizeable.  Removable disks are for things like backup cartridges and
>>>>> ageing jazz drives.  Worse: most removeable devices today are USB card
>>>>> readers whose standards compliance varies from iffy to non existent.
>>>>> Resizeable disks are currently the province of storage arrays.
>>> The virtual disks exported by aacraid are both marked removable and
>>> can be resized.
>>
>> Do they report resizing via unit attention?  I can skip this part on
>> removable virtio-scsi disks if that's what real hardware does, it would
>> also work.
>>
> 
> Not sure if we are talking about the same thing.
> 
> So can virtio-scsi send a UA with asc/ascq that indicates the lun
> changed size? Other drivers do this. I updated Hannes's patches the
> other day to support UAs like those in userspace.
> 
> I just saw the code in the patch where virtio-scsi gets that event.

Was not done. I meant I saw that patch where virtio-scsi gets that
virtio_scsi_event and kicks of a rescan based off of that.
