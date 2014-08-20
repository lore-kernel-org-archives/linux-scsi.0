From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 00/13] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Wed, 20 Aug 2014 12:22:39 -0700
Message-ID: <20140820192239.GA25281@infradead.org>
References: <cover.1408335523.git.agordeev@redhat.com>
 <20140819170047.GA7237@infradead.org>
 <20140820191416.GA1886@agordeev.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140820191416.GA1886@agordeev.usersys.redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, Naresh Kumar Inna <naresh@chelsio.com>, Arvind Bhushan <arvindb@chelsio.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 20, 2014 at 08:14:17PM +0100, Alexander Gordeev wrote:
> > I've applied patches 1 to 7 to the drivers-for-3.18 branch.
> 
> Thanks, Christoph!
> 
> Not sure how to handle the rest, though. Chelsio driver has no
> maintainers and none of be2iscsi, pmcraid and csiostor has been
> reviewed for several months.

I've added Tomas to the Cc list who has been very helpful with reviewing
drivers lately.  Tomas, can you take a quick look at these patches?
