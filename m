From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RFC PATCH] lpfc: Add lockdep assertions
Date: Thu, 17 Dec 2015 09:59:32 +0100
Message-ID: <56727974.3040603@sandisk.com>
References: <1448023037-43391-1-git-send-email-jthumshirn@suse.de>
 <5671F24A.1020607@avagotech.com> <20151217084954.GB2890@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151217084954.GB2890@c203.arch.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/17/2015 09:49 AM, Johannes Thumshirn wrote:
> On Wed, Dec 16, 2015 at 03:22:50PM -0800, James Smart wrote:
>> Johannes,
>>
>> Thank you for the time and effort on the patch. At this time, as it doesn't
>> functionally change anything, I did not include the patch. I will consider
>> it if we see additional issues it can help resolve.
>
> As I already said in the patch mail, I'm not sure if it is of intereset for
> upstream, but can actually be quite handy to find something if it goes wrong.

I'd like to see this patch being merged upstream. lockdep_assert_held() 
statements are checked at runtime when using a debug kernel, which is 
not the case for comments that document locking conventions.

Thanks,

Bart.
