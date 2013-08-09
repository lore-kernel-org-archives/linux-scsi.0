From: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [PATCH 11/16] pm8001: clean up unnecessary MSI/MSI-X capability
 find
Date: Fri, 9 Aug 2013 15:30:23 +0800
Message-ID: <52049A8F.8060006@huawei.com>
References: <1375967421-26540-1-git-send-email-wangyijing@huawei.com> <00aa01ce94ac$412320b0$c3696210$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:26115 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401Ab3HIHat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2013 03:30:49 -0400
In-Reply-To: <00aa01ce94ac$412320b0$c3696210$@com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lindar_liu <lindar_liu@usish.com>
Cc: "'James E.J. Bottomley'" <JBottomley@parallels.com>, 'Hanjun Guo' <guohanjun@huawei.com>, jiang.liu@huawei.com, xjtuwjp@gmail.com, linux-scsi@vger.kernel.org

On 2013/8/9 10:57, lindar_liu wrote:
> On 08/08/2013 9:10 PM, Yijing Wang wrote: 
>> PCI core will initialize device MSI/MSI-X capability in
>> pci_msi_init_pci_dev(). So device driver should use pci_dev-
>>> msi_cap/msix_cap to determine whether the device support MSI/MSI-X
>> instead of using pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
>> Access to PCIe device config space again will consume more time.
>>
> It's fine.
> You can add my Acked-by.

Thanks!


