From: "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [PATCH v3 20/20] docs: pci: fix broken links due to conversion
 from pci.txt to pci.rst
Date: Sat, 8 Jun 2019 08:37:43 -0700
Message-ID: <20190608153743.GG28207@linux.ibm.com>
References: <ff457774d46d96e8fe56b45409aba39d87a8672a.1559933665.git.mchehab+samsung@kernel.org>
 <780cb6c2dfe860873394675df6580765ea5a2680.1559933665.git.mchehab+samsung@kernel.org>
Reply-To: paulmck@linux.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <780cb6c2dfe860873394675df6580765ea5a2680.1559933665.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Alan Stern <stern@rowland.harvard.edu>, Andrea Parri <andrea.parri@amarulasolutions.com>, Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, Akira Yokosawa <akiyks@gmail.com>, Daniel Lustig <dlustig@nvidia.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arch@vger.kernel.org, esc.storagedev@mic
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 07, 2019 at 03:54:36PM -0300, Mauro Carvalho Chehab wrote:
> Some documentation files were still pointing to the old place.
> 
> Fixes: 229b4e0728e0 ("Documentation: PCI: convert pci.txt to reST")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Paul E. McKenney <paulmck@linux.ibm.com>

> ---
>  Documentation/memory-barriers.txt                    | 2 +-
>  Documentation/translations/ko_KR/memory-barriers.txt | 2 +-
>  drivers/scsi/hpsa.c                                  | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index f70ebcdfe592..f4170aae1d75 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -548,7 +548,7 @@ There are certain things that the Linux kernel memory barriers do not guarantee:
>  
>  	[*] For information on bus mastering DMA and coherency please read:
>  
> -	    Documentation/PCI/pci.txt
> +	    Documentation/PCI/pci.rst
>  	    Documentation/DMA-API-HOWTO.txt
>  	    Documentation/DMA-API.txt
>  
> diff --git a/Documentation/translations/ko_KR/memory-barriers.txt b/Documentation/translations/ko_KR/memory-barriers.txt
> index db0b9d8619f1..07725b1df002 100644
> --- a/Documentation/translations/ko_KR/memory-barriers.txt
> +++ b/Documentation/translations/ko_KR/memory-barriers.txt
> @@ -569,7 +569,7 @@ ACQUIRE 는 해당 오퍼레이션의 로드 부분에만 적용되고 RELEASE 
>  
>  	[*] 버스 마스터링 DMA 와 일관성에 대해서는 다음을 참고하시기 바랍니다:
>  
> -	    Documentation/PCI/pci.txt
> +	    Documentation/PCI/pci.rst
>  	    Documentation/DMA-API-HOWTO.txt
>  	    Documentation/DMA-API.txt
>  
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1bef1da273c2..53df6f7dd3f9 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7760,7 +7760,7 @@ static void hpsa_free_pci_init(struct ctlr_info *h)
>  	hpsa_disable_interrupt_mode(h);		/* pci_init 2 */
>  	/*
>  	 * call pci_disable_device before pci_release_regions per
> -	 * Documentation/PCI/pci.txt
> +	 * Documentation/PCI/pci.rst
>  	 */
>  	pci_disable_device(h->pdev);		/* pci_init 1 */
>  	pci_release_regions(h->pdev);		/* pci_init 2 */
> @@ -7843,7 +7843,7 @@ static int hpsa_pci_init(struct ctlr_info *h)
>  clean1:
>  	/*
>  	 * call pci_disable_device before pci_release_regions per
> -	 * Documentation/PCI/pci.txt
> +	 * Documentation/PCI/pci.rst
>  	 */
>  	pci_disable_device(h->pdev);
>  	pci_release_regions(h->pdev);
> -- 
> 2.21.0
> 
