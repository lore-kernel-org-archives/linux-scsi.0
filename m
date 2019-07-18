From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in
 ses_enclosure_data_process()
Date: Thu, 18 Jul 2019 14:29:08 -0400
Message-ID: <d00a1ace-bc05-301b-cd61-600b6dabf51e@redhat.com>
References: <20190501180535.26718-1-longman@redhat.com>
 <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
 <1558363938.3742.1.camel@linux.ibm.com>
 <729b0751-01a6-7c0b-ce0d-f19807b59dee@redhat.com>
 <yq1blxrxkpy.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1blxrxkpy.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 7/18/19 2:26 PM, Martin K. Petersen wrote:
> Waiman,
>
>> Is someone going to merge this patch in the current cycle?
> I was hoping somebody would step up and patch all the bad accesses and
> not just page 10.
>
I see.

Thanks,
Longman
