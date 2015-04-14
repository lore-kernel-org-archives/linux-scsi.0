From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection
 information code.
Date: Tue, 14 Apr 2015 20:20:59 +0300
Message-ID: <552D4C7B.9000402@dev.mellanox.co.il>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com> <CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 4/14/2015 3:17 PM, Akinobu Mita wrote:
> 2015-04-14 2:19 GMT+09:00 Sagi Grimberg <sagig@mellanox.com>:
>> Hey All,
>>
>> This set follows the patchset from Akinobu Mita that addresses
>> DIF bounce buffer sgl construction. Instead of trying to fix these
>> bugs, this removes it altogether and work with cmd->t_prot_sg
>> directly.
>>
>> The first patch is a simplification of the DIF verify varius
>> routines leaving a single generic sbc_dif_verify that handles
>> the protection information sgl we are working on.
>>
>> The second patch uses this simplification to remove the local
>> prot_fd bounce buffer altogether.
>>
>> This passed minimal IO testing.
>
> Looks good...
>
> I'll test with these patches and check if the problems I met
> disappear.

Thanks Akinobu,

Waiting to hear your verdict before sending a formal patchset.

Sagi.
