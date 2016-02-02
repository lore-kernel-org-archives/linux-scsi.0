From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH] add support for DWC UFS Host Controller
Date: Tue, 2 Feb 2016 14:47:31 +0000
Message-ID: <56B0C183.3010509@synopsys.com>
References: <33d190af027d92da449f379a5e60366729d37eab.1454330442.git.jpinto@synopsys.com>
 <CAGRGNgUZOZx80yQoqLq-YWxj7u7rWvGEy9UKSRU++t7VtXEOXQ@mail.gmail.com>
 <56B08359.1010405@synopsys.com>
 <CAGRGNgVwqKWM5_QmSisEJPM098RjxmmAHMhrvXenBKSy+Jh9wQ@mail.gmail.com>
 <56B09762.10402@synopsys.com>
 <CAGRGNgWmjnf-fUqMEQ5K2sykdwk8dV9fkJv_0=Q5bz2CiqA-8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:60625 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbcBBOrh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 09:47:37 -0500
In-Reply-To: <CAGRGNgWmjnf-fUqMEQ5K2sykdwk8dV9fkJv_0=Q5bz2CiqA-8Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@infradead.org>, gbroner@codeaurora.org, subhashj@codeaurora.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com, Ian Campbell <ijc+devicetree@hellion.org.uk>

Hi,
In order to make a ufs-dwc-pci glue driver I will need to create a "pci driver
lib" like we have already for platform (ufshcd-pltfm.c). Should I call the
samsung glue driver ufs-samsung-pci.c which will use common pci functions from a
ufshcd-pci.c? Agree?

On 2/2/2016 11:49 AM, Julian Calaby wrote:
> Hi Joao,
> 
> On Tue, Feb 2, 2016 at 10:47 PM, Joao Pinto <Joao.Pinto@synopsys.com> wrote:
>>
>> Hi Julian,
>> I am already changing the architecture and I will send a v2 soon.
>> Thanks for the review.
> 
> Awesome, I look forward to it.
> 
> Thanks,
> 

Thanks.

Joao
