From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC PATCH 0/4] dm-mpath: dynamic load balancers
Date: Fri, 30 Jan 2009 17:03:08 +0900
Message-ID: <4982B43C.7080203@ct.jp.nec.com>
References: <20080912.105038.102581623.k-ueda@ct.jp.nec.com>	<20090128153704.GA23158@agk.fab.redhat.com>	<498157D1.2010105@ct.jp.nec.com>
	<4981F181.2090905@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4981F181.2090905@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, stefan.bader@canonical.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Mike,

Thank you for the comment.

On 01/30/2009 03:12 AM +0900, Mike Christie wrote:
> Kiyoshi Ueda wrote:
>> Hi Alasdair,
>>
>> On 01/29/2009 12:37 AM +0900, Alasdair G Kergon wrote:
>>> On Fri, Sep 12, 2008 at 10:50:38AM -0400, Kiyoshi Ueda wrote:
>>>> The following patches add the following 2 dynamic load balancers
>>>> to request-based dm-multipath:
>>>>   o queue-length oriented dynamic load balancer, dm-queue-length.
>>>>   o service-time oriented dynamic load balancer, dm-service-time.
>>>  
>>> Could we have separate Kconfig options to select them?
>>
>> Sure.
>> I posted the new one rebased on top of 2.6.29-rc2:
>>   https://www.redhat.com/archives/dm-devel/2009-January/msg00183.html
>>   https://www.redhat.com/archives/dm-devel/2009-January/msg00186.html
>>
> 
> For the Kconfig help, is there something we could add to help people
> know when to choose one or the other? Sort of like how the block layer
> io scheduler (block/Kconfig.iosched) says one might be helpful for
> desktops and one is useful for data bses?

That's a good idea, but I don't have much information about that now.
To make such guide-line, we probably need lots of feedbacks from users.
(e.g. That may also depend on HW, not only work-load.)
So that is TODO in the future, I think.

Thanks,
Kiyoshi Ueda
