From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v3 00/13] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Wed, 20 Aug 2014 20:14:17 +0100
Message-ID: <20140820191416.GA1886@agordeev.usersys.redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
 <20140819170047.GA7237@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140819170047.GA7237@infradead.org>
Sender: linux-pci-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Naresh Kumar Inna <naresh@chelsio.com>, Arvind Bhushan <arvindb@chelsio.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 19, 2014 at 10:00:47AM -0700, Christoph Hellwig wrote:
> Thanks,
> 
> I've applied patches 1 to 7 to the drivers-for-3.18 branch.

Thanks, Christoph!

Not sure how to handle the rest, though. Chelsio driver has no
maintainers and none of be2iscsi, pmcraid and csiostor has been
reviewed for several months.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
