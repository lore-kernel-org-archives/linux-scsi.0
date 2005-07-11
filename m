From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: PE1800 S-ATA RAID CERC6 with RHEL 3 / 4 ???
Date: Mon, 11 Jul 2005 08:54:45 -0500
Message-ID: <20050711135445.GB11319@lists.us.dell.com>
References: <60807403EABEB443939A5A7AA8A7458B01642F00@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-poweredge-bounces@dell.com>
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01642F00@otce2k01.adaptec.com>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=unsubscribe>
List-Archive: <http://lists.us.dell.com/pipermail/linux-poweredge>
List-Post: <mailto:linux-poweredge@dell.com>
List-Help: <mailto:linux-poweredge-request@dell.com?subject=help>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=subscribe>
Sender: linux-poweredge-bounces@dell.com
Errors-To: linux-poweredge-bounces@dell.com
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Kit Gerrits <kitgerrits@gmail.com>, linux-scsi@vger.kernel.org, linux-poweredge@dell.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 11, 2005 at 08:02:47AM -0400, Salyzyn, Mark wrote:
> One of the problems with this class (2.4.* based 64 bit) is the Software
> IOMMU. You may have to boot with 'swiotlb=12288' in order to free enough
> mapping resources for the card.

And if you're running RHEL3 Update 5 or higher, the swiotlb no longer
is mapped into ZONE_DMA space, so you can safely make it larger (as
Mark describes above) without depleating the 16MB ZONE_DMA.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

_______________________________________________
Linux-PowerEdge mailing list
Linux-PowerEdge@dell.com
http://lists.us.dell.com/mailman/listinfo/linux-poweredge
Please read the FAQ at http://lists.us.dell.com/faq
