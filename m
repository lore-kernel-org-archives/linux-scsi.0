From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] scsi: lpfc: remove useless code in
 lpfc_sli4_bsg_link_diag_test
Date: Thu, 24 Aug 2017 10:26:19 -0500
Message-ID: <7edf46e6-1b3a-52dd-2c15-d72c3f7a9eb9@embeddedor.com>
References: <20170822205353.GA17794@embeddedgus> <yq1d17ladk5.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d17ladk5.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

On 08/23/2017 09:45 PM, Martin K. Petersen wrote:
>
> Gustavo,
>
>> Remove variable assignments. The value stored in local variable _rc_
>> is overwritten at line 2448:rc =
>> lpfc_sli4_bsg_set_link_diag_state(phba, 0); before it can be used.
>
> Applied to 4.14/scsi-queue. Thank you!
>

Glad to help. :)

-- 
Gustavo A. R. Silva
