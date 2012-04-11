From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
Date: Wed, 11 Apr 2012 09:28:19 +0800
Message-ID: <4F84DE33.8050606@cn.fujitsu.com>
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
	<4F84329A.60703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <4F84329A.60703@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Avi Kivity <avi@redhat.com>
Cc: axboe@kernel.dk, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, asamymuthupa@micron.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, James.Bottomley@HansenPartnership.com, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

  On 04/10/2012 09:16 PM, Avi Kivity wrote:
> On 04/10/2012 10:28 AM, Ren Mingxin wrote:
>> The current virtio block's naming algorithm just supports 18278
>> (26^3 + 26^2 + 26) disks. If there are mass of virtio blocks,
>> there will be disks with the same name.
>>
>> Based on commit 3e1a7ff8a0a7b948f2684930166954f9e8e776fe, I add
>> function "virtblk_name_format()" for virtio block to support mass
>> of disks naming.
>>
>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> ---
>>   drivers/block/virtio_blk.c |   38 ++++++++++++++++++++++++++------------
>>   1 files changed, 26 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index c4a60ba..86516c8 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -374,6 +374,31 @@ static int init_vq(struct virtio_blk *vblk)
>>   	return err;
>>   }
>>
>> +static int virtblk_name_format(char *prefix, int index, char *buf, int buflen)
>> +{
>> +	const int base = 'z' - 'a' + 1;
>> +	char *begin = buf + strlen(prefix);
>> +	char *begin = buf + strlen(prefix);
> Duplicate line.
>

Oh, obvious missed :-(

-- 
Thanks,
Ren
