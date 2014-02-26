From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
Date: Wed, 26 Feb 2014 09:02:07 -0600
Message-ID: <530E01EF.904@linux.vnet.ibm.com>
References: <cover.1389904166.git.agordeev@redhat.com> <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com> <20140128095441.GA6951@dhcp-26-207.brq.redhat.com> <52E7CCAD.5070008@linux.vnet.ibm.com> <20140129132651.GA27764@dhcp-26-207.brq.redhat.com> <20140130140630.GA32349@dhcp-26-207.brq.redhat.com> <20140224081209.GA32200@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20140224081209.GA32200@dhcp-26-207.brq.redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 02/24/2014 02:12 AM, Alexander Gordeev wrote:
> On Thu, Jan 30, 2014 at 03:06:30PM +0100, Alexander Gordeev wrote:
>> On Wed, Jan 29, 2014 at 02:26:52PM +0100, Alexander Gordeev wrote:
>>>> Do you want me to rediff your patches on top of this one,
>>>> or do you want to keep the entire MSI series together
>>>> and do the rediff? Otherwise the patches seem fine.
>>>
>>> I would prefer the former.
>>
>> Hi Brian,
>>
>> I am sending the refreshed patches on top of "ipr: Handle early EEH".
> 
> Hi Brian,
> 
> What three the two patches you ACKed are against?
> Should I ask James to take them?

Wendy - can you pull in these two patches from Alexander and rebase on
top of the latest patches you've sent upstream?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
