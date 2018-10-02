From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Tue, 2 Oct 2018 19:59:08 +0300
Message-ID: <f4ace065-fb9c-6901-d4d9-6b849e08d054@electrozaur.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org>
 <20181002145613.GA11156@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002145613.GA11156@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

On 02/10/18 17:56, Christoph Hellwig wrote:
> On Mon, Oct 01, 2018 at 06:16:32PM -0700, Bart Van Assche wrote:
>> Boaz, the most recent osd patch that is neither trivial nor treewide
>> refactoring is six years old (51976a8c85ce ("[SCSI] osd_uld: Add osdname &
>> systemid sysfs at scsi_osd class"). That suggests that nobody is using this
>> driver anymore. Can this driver be removed from the kernel tree?
> 
> Last time we tried to exofs and the osd code Boaz complained loudly,
> but as far as I can tell it really is not used and bitrotting, so we
> should finally go ahead and drop it.
> 

As I said then. It is used in Universities for studies and experiments.
Every once in a while. I get an email with questions and reports.

But yes feel free to remove the all thing!!

I guess I can put it up on github. In a public tree.

Just that I will need to forward port it myself, til now you guys
been doing this for me ;-)

Thanks, sorry for the hassle
Boaz
