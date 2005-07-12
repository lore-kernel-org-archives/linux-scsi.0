From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: PE1800 S-ATA RAID CERC6 with RHEL 3 / 4 ???
Date: Tue, 12 Jul 2005 09:40:19 -0500
Message-ID: <20050712144019.GG17093@humbolt.us.dell.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201ACD4@xbl3.ma.emulex.com>
Reply-To: Matt Domsch <Matt_Domsch@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-poweredge-bounces@dell.com>
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201ACD4@xbl3.ma.emulex.com>
List-Unsubscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=unsubscribe>
List-Archive: <http://lists.us.dell.com/pipermail/linux-poweredge>
List-Post: <mailto:linux-poweredge@dell.com>
List-Help: <mailto:linux-poweredge-request@dell.com?subject=help>
List-Subscribe: <http://lists.us.dell.com/mailman/listinfo/linux-poweredge>,
	<mailto:linux-poweredge-request@dell.com?subject=subscribe>
Sender: linux-poweredge-bounces@dell.com
Errors-To: linux-poweredge-bounces@dell.com
To: James.Smart@Emulex.Com
Cc: kitgerrits@gmail.com, linux-poweredge@dell.com, linux-scsi@vger.kernel.org, mark_salyzyn@adaptec.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2005 at 10:35:09AM -0400, James.Smart@Emulex.Com wrote:
> I really hated these patches.  The issue that was causing >90% of the 
> problems we encountered was that pci_alloc_consistent was overextending
> when no_iommu was set by ignoring the dma masks of the adapter and
> forcing the use of the dma map pool when it wasn't necessary. IMHO, fixing
> this issue seems like a much better approach than having to make the
> dma pool or swiotlb larger.

It's a matter of timing here though.  This *was* fixed in the 2.6
kernel series, and thus in vendor kernels based on 2.6, it just wasn't
ever backported fixed in 2.4, or in particular, the individual 2.4
vendor kernels.  At least with RHEL, there are kABI constraints which
make "proper" fixes more difficult, but I do have requests in with Red
Hat to fix this.  Their engineers are bright and know the constraints.
They can choose to ignore my patches come up with something better.

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
