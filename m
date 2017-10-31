From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] scsi: storvsc: Allow only one remove lun work item to
 be issued per lun
Date: Tue, 31 Oct 2017 08:24:44 -0400
Message-ID: <yq1shdzcxo3.fsf@oracle.com>
References: <1508261721-24144-1-git-send-email-cavery@redhat.com>
 <20171019153510.GA7633@infradead.org>
 <20171021154444.GK1302522@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20171021154444.GK1302522@devbig577.frc2.facebook.com> (Tejun
 Heo's message of "Sat, 21 Oct 2017 08:44:44 -0700")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, devel@linuxdriverproject.org, dan.carpenter@oracle.com
List-Id: linux-scsi@vger.kernel.org


>> If you use alloc_ordered_workqueue directly instead of
>> create_singlethread_workqueue you can pass a format string and don't
>> need the separate allocation.
>> 
>> But I'm not sure if Tejun is fine with using __WQ_LEGACY directly..
>
> The only thing that flag does is exempting the workqueue from possible
> flush deadlock check as we don't know whether WQ_MEM_RECLAIM on a
> legacy workqueue is intentional.  There's no reason to add it when
> converting to alloc_ordered_workqueue().  Just decide whether it needs
> forward progress guarantee and use WQ_MEM_RECLAIM if so.

Cathy?

-- 
Martin K. Petersen	Oracle Linux Engineering
