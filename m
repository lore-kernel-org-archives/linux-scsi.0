From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] ibmvscsis: Use list_move_tail instead of list_del/list_add_tail
Date: Wed, 31 Aug 2016 00:19:08 -0400
Message-ID: <yq14m617epv.fsf@sermon.lab.mkp.net>
References: <1469196226-17333-1-git-send-email-weiyj.lk@gmail.com>
        <57C48A06.4000806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57C48A06.4000806@linux.vnet.ibm.com> (Tyrel Datwyler's message
        of "Mon, 29 Aug 2016 12:16:22 -0700")
Sender: target-devel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, "Bryant G . Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tyrel" == Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:

Tyrel> On 07/22/2016 07:03 AM, Wei Yongjun wrote:
>> Using list_move_tail() instead of list_del() + list_add_tail().
>> 
>> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>

Tyrel> Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
