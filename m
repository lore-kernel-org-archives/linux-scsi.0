From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] dmapool: improve scalability of dma_pool_free
Date: Sat, 28 Jul 2018 00:35:55 +0300
Message-ID: <CAHp75VcjMg2RABg4F3u=wpgQvGK8qr-4wxeRNmJtfMAE2VRRAw@mail.gmail.com>
References: <1288e597-a67a-25b3-b7c6-db883ca67a25@cybernetics.com>
	<20180726194209.GB12992@bombadil.infradead.org>
	<b3430dd4-a4d6-28f1-09a1-82e0bf4a3b83@cybernetics.com>
	<20180727000708.GA785@bombadil.infradead.org>
	<cae33099-3147-5014-ab4e-c22a4d66dc49@cybernetics.com>
	<20180727152322.GB13348@bombadil.infradead.org>
	<acdc2e32-466c-61d3-145f-80bfba2c6739@cybernetics.com>
	<88d362b7-1d53-b430-1741-b48cbc0a7887@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <88d362b7-1d53-b430-1741-b48cbc0a7887-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chaitra P B <chaitra.basappa-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suganath Prabu Subramani <suganath-prabu.subramani-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sathya Prakash <sathya.prakash-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 28, 2018 at 12:27 AM, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org> wrote:
> On 07/27/2018 03:38 PM, Tony Battersby wrote:
>> But the bigger problem is that my first patch adds another list_head to
>> the dma_page for the avail_page_link to make allocations faster.  I
>> suppose we could make the lists singly-linked instead of doubly-linked
>> to save space.
>>
>
> I managed to redo my dma_pool_alloc() patch to make avail_page_list
> singly-linked instead of doubly-linked.

Are you relying on llist.h implementation?

Btw, did you see quicklist.h?


-- 
With Best Regards,
Andy Shevchenko
