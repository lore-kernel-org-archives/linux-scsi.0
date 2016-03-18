From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: UFS V11 patch-set
Date: Fri, 18 Mar 2016 14:53:41 +0000
Message-ID: <56EC1675.2050002@synopsys.com>
References: <56EBF966.8040907@synopsys.com> <56EBF9FD.9080906@synopsys.com>
 <4014649.ENvamPh3sb@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:34911 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbcCROxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2016 10:53:48 -0400
In-Reply-To: <4014649.ENvamPh3sb@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinayak holikatti <vinholikatti@gmail.com>, JBottomley@parallels.com, rafael.j.wysocki@intel.com, hch@lst.de, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Carlos Palminha <CARLOS.PALMINHA@synopsys.com>

Hi!

On 3/18/2016 2:49 PM, Arnd Bergmann wrote:
> On Friday 18 March 2016 12:52:13 Joao Pinto wrote:
>> Hi!
>>
>> Could you please check the following patch-set in order to evaluate if it is
>> ready for v4.6?
>>
> 
> I think the code is ok now, but the timing apparently didn't work for 4.6.
> I'd suggest you resend as soon as 4.6-rc1 is out so it can get merged into 4.7.

Isn't it possible to be merged into a ufs-dwc branch in the SCSI Git tree that
could be pulled later, like Bjorn did in the PCIe RC?

> 
> 	Arnd
> 

Joao

