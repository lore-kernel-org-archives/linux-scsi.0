From: Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH V2] scsi: storvsc: Allow only one remove lun work item to
 be issued per lun
Date: Tue, 31 Oct 2017 08:31:15 -0400
Message-ID: <59F86D13.1010708@redhat.com>
References: <1508261721-24144-1-git-send-email-cavery@redhat.com>
 <20171019153510.GA7633@infradead.org>
 <20171021154444.GK1302522@devbig577.frc2.facebook.com>
 <yq1shdzcxo3.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1shdzcxo3.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, kys@microsoft.com, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, dan.carpenter@oracle.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/31/2017 08:24 AM, Martin K. Petersen wrote:
>>> If you use alloc_ordered_workqueue directly instead of
>>> create_singlethread_workqueue you can pass a format string and don't
>>> need the separate allocation.
>>>
>>> But I'm not sure if Tejun is fine with using __WQ_LEGACY directly..
>> The only thing that flag does is exempting the workqueue from possible
>> flush deadlock check as we don't know whether WQ_MEM_RECLAIM on a
>> legacy workqueue is intentional.  There's no reason to add it when
>> converting to alloc_ordered_workqueue().  Just decide whether it needs
>> forward progress guarantee and use WQ_MEM_RECLAIM if so.
> Cathy?
>

Sorry for the delay. Long was working on a similar problem and we needed 
to add a couple of extra patches. I was thinking of sending all three in 
series but I can send the V3 of this now and follow up with the 
additional patches. Does that make sense?
