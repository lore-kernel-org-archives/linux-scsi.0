From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 33/41] scsi: osd: osd_initiator: mark expected switch
 fall-throughs
Date: Tue, 18 Dec 2018 11:19:34 -0600
Message-ID: <172604f4-daff-48bc-2933-38b51ef1aa3a@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <09026c2661bf3c4bcf41dbb265cf1dae2c3487fd.1543374820.git.gustavo@embeddedor.com>
 <ee906c63-72cd-8d3c-d5c8-50dc59d984d8@electrozaur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ee906c63-72cd-8d3c-d5c8-50dc59d984d8@electrozaur.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 12/18/18 11:13 AM, Boaz Harrosh wrote:
> On 28/11/18 06:32, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> ACK-by: Boaz Harrosh <ooo@electrozaur.com>
> 

Thank you, Boaz.
--
Gustavo
