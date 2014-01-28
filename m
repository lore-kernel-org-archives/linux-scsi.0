From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
Date: Tue, 28 Jan 2014 09:28:45 -0600
Message-ID: <52E7CCAD.5070008@linux.vnet.ibm.com>
References: <cover.1389904166.git.agordeev@redhat.com> <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com> <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 01/28/2014 03:54 AM, Alexander Gordeev wrote:
> On Fri, Jan 17, 2014 at 05:02:18PM +0100, Alexander Gordeev wrote:
>> As result deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range() and pci_enable_msix_range()
>> interfaces.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> 
> Brian, James,
> 
> Could you please review patches 3 and 4?

These look like they will conflict with a recent patch to
the ipr driver:

http://www.spinics.net/lists/linux-scsi/msg71644.html

Do you want me to rediff your patches on top of this one,
or do you want to keep the entire MSI series together
and do the rediff? Otherwise the patches seem fine.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
