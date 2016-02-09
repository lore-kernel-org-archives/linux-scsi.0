From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] ibmvscsi: Add and use enums for valid CRQ header
 values
Date: Tue, 9 Feb 2016 10:27:12 -0800
Message-ID: <56BA2F80.8090009@linux.vnet.ibm.com>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1454542114-1797-3-git-send-email-tyreld@linux.vnet.ibm.com>
 <56B3ACC9.60009@linux.vnet.ibm.com> <56B3C1C1.3080804@linux.vnet.ibm.com>
 <56BA24E1.9090808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56BA24E1.9090808@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: manoj@linux.vnet.ibm.com, JBottomley@odin.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On 02/09/2016 09:41 AM, Manoj Kumar wrote:
>> Yeah, I can see how that is confusing. Since, all three possible valid
>> crq message types have the first bit set I think this was originally a
>> cute hack to grab anything that was likely valid. Then in
>> ibmvscsi_handle_crq() we explicitly match the full header value in a
>> switch statement logging anything that turned out actually invalid.
>>
>>>
>>> If 'valid' will only have one of these four enums defined, would
>>> this be better written as:
>>>
>>> 	if (crq->valid != VIOSRP_CRQ_FREE)
>>
>> This definitely would make the logic easier to read and follow. Also,
>> this would make sure any crq with an invalid header that doesn't have
>> its first bit set will also be logged by the ibmvscsi_handle_crq()
>> switch statement default block and not silently ignored.
>>
>> -Tyrel
> 
> Sounds good, Tyrel. Does this mean I should expect a v2 of this patch
> series?
> 
> - Manoj N. Kumar

Haven't had a chance to clean up and resubmit, but yes there will be a
v2 coming along soon.

-Tyrel

> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
