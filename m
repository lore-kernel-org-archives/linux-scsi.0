From: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [PATCH 05/16] megaraid: clean up unnecessary MSI/MSI-X capability
 find
Date: Mon, 26 Aug 2013 09:40:11 +0800
Message-ID: <521AB1FB.6070401@huawei.com>
References: <1375967264-25644-1-git-send-email-wangyijing@huawei.com> <088E451FE1854947BD9145EF8C016FF413A00DC559@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47542 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3HZBlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Aug 2013 21:41:17 -0400
In-Reply-To: <088E451FE1854947BD9145EF8C016FF413A00DC559@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "Saxena, Sumit" <Sumit.Saxena@lsi.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>> PCI_MSIX_FLAGS,
>> 						      control &
>> 						      ~PCI_MSIX_FLAGS_ENABLE);
>> 			}
>> --
>> 1.7.1
>>
>>
> Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

Hi James,
   Can you merge this patch?

Thanks!
Yijing.


> 
> 


-- 
Thanks!
Yijing

