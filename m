From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] scsi: add support for request batching
Date: Fri, 5 Jul 2019 13:58:39 +0200
Message-ID: <6c2cf159-9ba2-da39-6e1c-95dea7e111ba@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <746ad64a-4047-1597-a0d4-f14f3529cc19@redhat.com>
 <yq1lfxnk8ar.fsf@oracle.com>
 <48c7d581-6ec8-260a-b4ba-217aef516305@redhat.com>
 <80dd68bf-a544-25ec-568f-cee1cf0c8cfd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80dd68bf-a544-25ec-568f-cee1cf0c8cfd@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jejb@linux.ibm.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 05/07/19 09:13, Hannes Reinecke wrote:
> On 6/27/19 10:17 AM, Paolo Bonzini wrote:
>> On 27/06/19 05:37, Martin K. Petersen wrote:
>>>> Ping?  Are there any more objections?
>>> It's a core change so we'll need some more reviews. I suggest you
>>> resubmit.
>> Resubmit exactly the same patches?
>> Where is the ->commit_rqs() callback invoked?
> I don't seem to be able to find it...

Stefan answered, and the series now has three reviews!  It may be late
for 5.3 but I hope this can go in soon.

Thanks,

Paolo
