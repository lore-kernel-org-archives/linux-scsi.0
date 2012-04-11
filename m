From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
Date: Wed, 11 Apr 2012 09:31:04 +0800
Message-ID: <4F84DED8.1080800@cn.fujitsu.com>
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
	<4F84329A.60703@redhat.com> <20120410133406.GA18899@redhat.com>
	<20120410154943.GB11614@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120410155308.GB20551@redhat.com> <4F84DCA3.3000805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <4F84DCA3.3000805@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: axboe@kernel.dk, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, asamymuthupa@micron.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, James.Bottomley@HansenPartnership.com, Avi Kivity <avi@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

  On 04/11/2012 09:21 AM, Asias He wrote:
> On 04/10/2012 11:53 PM, Michael S. Tsirkin wrote:
>> On Tue, Apr 10, 2012 at 08:49:43AM -0700, Tejun Heo wrote:
>>> Hello, guys.
>>>
>>> On Tue, Apr 10, 2012 at 04:34:06PM +0300, Michael S. Tsirkin wrote:
>>>>> Why not use 'base' below?  neither unit nor base change.
>>>>
>>>> Yes it's a bit strange, it was the same in Tejun's patch.
>>>> Tejun, any idea?
>>>
>>> It was years ago, so I don't recall much.  I think I wanted to use a
>>> variable name which signifies its role - I worked out the rather
>>> convoluted base number logic on paper first and I probably wanted to
>>> keep the distinctions.  I don't think it really matters at this point
>>> tho.  Just make sure those functions are marked deprecated so that no
>>> one else copies them.
>>>
>>> Thanks.
>>
>> I guess I'll keep it same so it's easier to deduplicate
>> if someon wants to.

So, I'd keep this in the next version.

>
> Why not fix it both in sd_format_disk_name() and virtblk_name_format().
> Ren, mind to send v2 to drop the duplicate line?
>

I'll send v2 soon.

-- 
Thanks,
Ren
