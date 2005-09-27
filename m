From: "Kolli, Neela Syam" <Neela.Kolli@engenio.com>
Subject: RE: Status of MegaRAID SAS based RAID driver
Date: Tue, 27 Sep 2005 18:16:49 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5707005A4E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:11756 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965205AbVI0WRI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 18:17:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Ju, Seokmann" <Seokmann.Ju@engenio.com>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>

Hi James,
I am Hardware Raid Device Driver Manager.  I will get more details on SCSI
issue by next Wednesday.

Thanks,
Neela Syam Kolli.

 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Tuesday, September 27, 2005 4:14 PM
To: Bagalkote, Sreenivas
Cc: 'linux-scsi@vger.kernel.org'; Kolli, Neela Syam; 'Christoph Hellwig';
'hch@lst.de'
Subject: Re: Status of MegaRAID SAS based RAID driver

On Tue, 2005-09-27 at 15:51 -0400, Bagalkote, Sreenivas wrote:
> What is the status of the megaraid_sas module that I submitted?
> Could you please us a hint as to when you are planning to include
> and in which version?

It's here:

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=c
ommit;h=c4a3e0a529ab3e65223e81681c7c6b1bc188fa58

I was planning to send this tree when we get a fix for the old megaraid
issue with MODE SENSE and scatter gather sorted out.  Could you prod the
people who work on this to see if they agree with my conclusion that it
looks like a firmware issue?

Thanks,

James

