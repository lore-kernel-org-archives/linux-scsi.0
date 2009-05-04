From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
Date: Mon, 04 May 2009 17:02:47 +0900
Message-ID: <49FEA127.1000905@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>	
	<49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>	
	<49FA0349.3090706@garzik.org>
	<e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, Mauelshagen@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Dan Williams wrote:
> On Thu, Apr 30, 2009 at 1:00 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> Tejun Heo wrote:
>>> Hello,
>>>
>>> Jeff Garzik wrote:
>>>> <shrug>  I suppose...
>>>>
>>>> It just seems like a nasty hack, but unfortunately I don't see
>>>> anyone stepping up to do it properly -- with a DM device
>>>> automatically layered on top that splits the device into separate
>>>> regions: one block device for the 'regular' area, and one for the
>>>> HPA.
>>> Isn't that more hacky?  I don't know.  All that dm needs to know is
>>> the location of the metadata which is located w.r.t. the end of the
>>> device which might be at a different location if BIOS tried to pull
>>> silly stunts.  So, exporting the size BIOS might have used seems like
>>> a straight forward solution to me.
>> "<shrug> I suppose" is basically a reluctant ack, in the absence of other
>> solutions :)
>>
> 
> Couldn't the "fix" also just be a note to users to disable ignore_hpa
> if they notice that there raid arrays are not assembling correctly?

I don't know.  If it doesn't work automatically, the solution really
isn't worth much.  People generally don't (shouldn't need to) have any
idea what HPA is.  It basically boils down to "Linux doesn't support
RAID".  :-)

Maybe we should just put this issue to the rest and strongly advise
people against BIOS raids.

Thanks.

-- 
tejun
