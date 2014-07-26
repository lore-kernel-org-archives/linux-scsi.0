From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH V2 0/4] Add XEN pvSCSI support
Date: Sat, 26 Jul 2014 09:28:55 +0200
Message-ID: <53D358B7.6050706@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com> <20140725173833.GE11179@laptop.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140725173833.GE11179@laptop.dumpdata.com>
Sender: target-devel-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/25/2014 07:38 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 25, 2014 at 01:37:29PM +0200, jgross@suse.com wrote:
>> This series adds XEN pvSCSI support. With pvSCSI it is possible to use physical
>> SCSI devices from a XEN domain.
>>
>> The support consists of a backend in the privileged Domain-0 doing the real
>> I/O and a frontend in the unprivileged domU passing I/O-requests to the backend.
>>
>
> About the question that Christopher Hellwig asked - was that ever answered?

Sure. That's the first item under "Changes in V2".

>
>> The code is taken (and adapted) from the original pvSCSI implementation done
>> for Linux 2.6 in 2008 by Fujitsu.
>>
>> [PATCH V2 1/4] Add XEN pvSCSI protocol description
>> [PATCH V2 2/4] Introduce xen-scsifront module
>> [PATCH V2 3/4] Introduce XEN scsiback module
>> [PATCH V2 4/4] add xen pvscsi maintainer
>>
>> Changes in V2:
>> - use core target infrastructure by backend instead of pure SCSI passthrough
>> - add support for larger SG lists by putting them in grant page(s)
>> - add command abort capability
>
