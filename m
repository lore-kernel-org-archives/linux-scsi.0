From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Status of MegaRAID SAS based RAID driver
Date: Tue, 27 Sep 2005 15:13:40 -0500
Message-ID: <1127852021.4823.27.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57060CD1E2@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:39837 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751044AbVI0UNq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Sep 2005 16:13:46 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CD1E2@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, 'Christoph Hellwig' <hch@infradead.org>, "'hch@lst.de'" <hch@lst.de>

On Tue, 2005-09-27 at 15:51 -0400, Bagalkote, Sreenivas wrote:
> What is the status of the megaraid_sas module that I submitted?
> Could you please us a hint as to when you are planning to include
> and in which version?

It's here:

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=c4a3e0a529ab3e65223e81681c7c6b1bc188fa58

I was planning to send this tree when we get a fix for the old megaraid
issue with MODE SENSE and scatter gather sorted out.  Could you prod the
people who work on this to see if they agree with my conclusion that it
looks like a firmware issue?

Thanks,

James


