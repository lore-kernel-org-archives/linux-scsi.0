From: "'Patrick Mansfield'" <patmans@us.ibm.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Thu, 9 Dec 2004 10:00:37 -0800
Message-ID: <20041209180037.GA7221@us.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E57057A1B87@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:33481 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261575AbULISD0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 13:03:26 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57057A1B87@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Matt Domsch' <Matt_Domsch@Dell.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>

On Thu, Dec 09, 2004 at 12:31:37PM -0500, Mukker, Atul wrote:

> > How does the driver supply the mapping if it does not know 
> > about the "change"? Is it reserving or telling user space the 
> > hctl that will be used?
> This point was thoroughly explained in my previous post item 2. Yes, driver
> reserves a virtual bus on which all logical drives would be exported.

OK ... 

> > If so, why can't the driver call scsi_add_device(h,c,t,l) 
> > after the ioctl to create the logical drive completes?
> This idea was already turned down, see mails on linux-scsi on 12/3

Well you can call scsi_add_device() from the driver, the objections I saw
were to add an ioctl that would just call scsi_add_device().

But it doesn't matter if adding driver post-ioctl specific actions is not
an option.

-- Patrick Mansfield
