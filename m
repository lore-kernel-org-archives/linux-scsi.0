From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [Consult]: Can the coming Huawei scsi device handler
 be accepted in the scsi/device_handler
Date: Mon, 15 May 2017 12:08:12 +0800
Message-ID: <70bd5fb5-a612-53d3-cc39-92ade30de9c0@huawei.com>
References: <a708085e-e9f0-3b5f-0290-00db8071a6b2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a708085e-e9f0-3b5f-0290-00db8071a6b2@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "Zouming (IT)" <zouming.zouming@huawei.com>, linux-scsi@vger.kernel.org, snitzer@redhat.com, Yang Feng <philip.yang@huawei.com>, shenhong09@huawei.com, dm-devel@redhat.com, "Hege (A)" <hege09@huawei.com>, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi, Christoph Hellwig
  Thanks for your reply. But I am  a little confused:

  Our Huawei scsi device handler will support ALUA. Besides , some new enhancements such as error self negotiation
on the scsi (maybe NMVe in the future) error status handling to enhance reliability.  Here are two choices:
   1) Alter the scsi_dh_alua.c directly and make a generic way to handle error status.
   2) Add a new file named scsi_dh_huawei.c which implements the ALUA feature and error negotiation feature.

   Can those two choices be accepted by linux-scsi?

On 2017/5/13 12:07, Guan Junxiong wrote:
>> Hello,Alasdair and Mike:
>>     I am going to add our vendor specific Huawei scsi device handler based on scsi_dh
>> framework into the linux/drivers/scsi/device_handler directory.
>>     Is it possible to be merged into the device handler list?
>> 
>>     I am looking forward to your reply.
>>     Best withes to you!
>> 
>Any new device must support ALUA, other device handlers are legacy only.

>And btw, the right list for this is linux-scsi.
