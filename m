From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] add support for DWC UFS Host Controller
Date: Wed, 3 Feb 2016 09:27:46 +1100
Message-ID: <CAGRGNgU_Wzhrckr6HurtzA2TB_zY68AeDWPLoa=UDY4Uy3zc6w@mail.gmail.com>
References: <33d190af027d92da449f379a5e60366729d37eab.1454330442.git.jpinto@synopsys.com>
 <CAGRGNgUZOZx80yQoqLq-YWxj7u7rWvGEy9UKSRU++t7VtXEOXQ@mail.gmail.com>
 <56B08359.1010405@synopsys.com> <CAGRGNgVwqKWM5_QmSisEJPM098RjxmmAHMhrvXenBKSy+Jh9wQ@mail.gmail.com>
 <56B09762.10402@synopsys.com> <CAGRGNgWmjnf-fUqMEQ5K2sykdwk8dV9fkJv_0=Q5bz2CiqA-8Q@mail.gmail.com>
 <56B0C183.3010509@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:32997 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbcBBW2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 17:28:07 -0500
In-Reply-To: <56B0C183.3010509@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@infradead.org>, gbroner@codeaurora.org, subhashj@codeaurora.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, CARLOS.PALMINHA@synopsys.com, Ian Campbell <ijc+devicetree@hellion.org.uk>

Hi Joao,

On Wed, Feb 3, 2016 at 1:47 AM, Joao Pinto <Joao.Pinto@synopsys.com> wrote:
> Hi,
> In order to make a ufs-dwc-pci glue driver I will need to create a "pci driver
> lib" like we have already for platform (ufshcd-pltfm.c). Should I call the
> samsung glue driver ufs-samsung-pci.c which will use common pci functions from a
> ufshcd-pci.c? Agree?

That sounds sensible.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
