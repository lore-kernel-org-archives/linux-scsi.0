From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Thu, 23 Dec 2004 13:28:03 +0000
Message-ID: <20041223132803.GA23861@infradead.org>
References: <EA4DC661A6353747A2E5C0DE8792DDDE075013FE@orsmsx404.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <EA4DC661A6353747A2E5C0DE8792DDDE075013FE@orsmsx404.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 22, 2004 at 01:54:45PM -0800, Caushik, Ramesh wrote:
> The newer Qlogic (qla2xxx) driver for kernel versions 2.6.9 and later do not support the fc_transport class. The support is #ifdefed for kernels > 2.6.6 & < 2.6.9. So I will have to wait till they support this for newer kernels. Meanwhile I can work with a patched version of multipath tools. Thanks for feedback. 

It's supported in the mainline driver.  The qlogic drivers do lots of silly
things and you shouldn't use them.

