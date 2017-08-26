From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: scsi: ufs: Delete an error message for a failed memory allocation
 in ufshcd_memory_alloc()
Date: Sat, 26 Aug 2017 13:17:00 +0200
Message-ID: <b218274a-da50-4f0c-2e55-cc6d708cef92@users.sourceforge.net>
References: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
 <3d355c13-159a-2570-9ead-af93ad95c210@users.sourceforge.net>
 <019b6365c15b0764c156d6453648f7a2@codeaurora.org>
 <1493231242.18659.28.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1493231242.18659.28.camel@perches.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Cc: "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> PS: ufshcd_memory_alloc() also does some DMA coherent memory allocation 
>> (via dmam_alloc_coherent() APIs) and tries to print out the message on 
>> allocation failure. Although i don't know "out of memory" messages will 
>> be printed out by dmam_alloc_coherent() APIs or not. If it does print it 
>> out then we might want to remove our local memory allocation failure log 
>> messages.
> 
> Basically most everything that has a gfp_t argument does a
> dump_stack() on OOM unless __GFP_NOWARN is specified by that gfp_t.

How do you think about to continue the clarification for this aspect
of the involved programming interfaces?

Regards,
Markus
