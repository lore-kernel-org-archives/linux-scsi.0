From: Andy Grover <agrover@redhat.com>
Subject: Re: NVMe over Fabrics target implementation
Date: Tue, 7 Jun 2016 14:02:09 -0700
Message-ID: <9352d5f2-b75f-9cc6-9a93-2e49c0883e84@redhat.com>
References: <1465248177-17970-1-git-send-email-hch@lst.de>
 <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, keith.busch@intel.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/06/2016 11:23 PM, Nicholas A. Bellinger wrote:
> Hi HCH & Co,
>
> On Mon, 2016-06-06 at 23:22 +0200, Christoph Hellwig wrote:
>> This patch set adds a generic NVMe over Fabrics target. The
>> implementation conforms to the NVMe 1.2b specification (which
>> includes Fabrics) and provides the NVMe over Fabrics access
>> to Linux block devices.
>>
>
> Thanks for all of the development work by the fabric_linux_driver team
> (HCH, Sagi, Ming, James F., James S., and Dave M.) over the last year.
>
> Very excited to see this code get a public release now that NVMf
> specification is out.  Now that it's in the wild, it's a good
> opportunity to discuss some of the more interesting implementation
> details, beyond the new NVMf wire-protocol itself.

I'm sorry but I missed it, can you repeat the link to the NVMe spec(s)?

Thanks -- Andy
