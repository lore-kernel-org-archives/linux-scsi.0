From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Wed, 28 Jan 2009 09:35:17 +0900
Message-ID: <20090128093443H.fujita.tomonori@lab.ntt.co.jp>
References: <20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
	<497F9CC5.8080807@s5r6.in-berlin.de>
	<tkrat.511cc93cd769cafe@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.511cc93cd769cafe@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 01:03:34 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > FUJITA Tomonori wrote:
> >> On Tue, 27 Jan 2009 18:03:40 +0100 (CET)
> >> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >>> +	if (orb->page_table_bus)
> >>> +		dma_unmap_single(card_device, orb->page_table_bus,
> >>> +				 sizeof(orb->page_table), DMA_TO_DEVICE);
> >> 
> >> Well, this does not look correct since zero can be a valid dma
> >> address.
> 
> 
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: firewire: sbp2: fix DMA mapping leak on the failure path
> 
> Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> who also provided a first version of the fix.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/fw-sbp2.c |   27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)

It's time to ask him to test this patch with the default or _less_
swiotlb resource, I guess.

------------------------------------------------------------------------------
This SF.net email is sponsored by:
SourcForge Community
SourceForge wants to tell your story.
http://p.sf.net/sfu/sf-spreadtheword
