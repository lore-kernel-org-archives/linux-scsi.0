From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Why are MegaRAID drivers mutually exclusive?
Date: Thu, 11 Nov 2004 15:24:08 +0100
Message-ID: <1100183048.4387.11.camel@laptop.fenrus.org>
References: <0E3FA95632D6D047BA649F95DAB60E570562C174@exa-atlanta>
	 <20041110220854.GB28524@lists.us.dell.com>
	 <1100160080.2646.10.camel@laptop.fenrus.org>
	 <20041111140745.GA1508368@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:35346 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S262238AbUKKOYV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2004 09:24:21 -0500
In-Reply-To: <20041111140745.GA1508368@hiwaay.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Adams <cmadams@hiwaay.net>
Cc: Matt Domsch <Matt_Domsch@dell.com>, "Mukker, Atul" <Atulm@lsil.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


> It looks like the only place they overlap is in the device node.
> 
> I don't see this as being all that different from when there were
> multiple sym53c8xx SCSI or tulip network drivers in the kernel.

the difference is that in those situations the new driver supported all
old hw too; while here... well.. you legitamitly can have an old and new
megaraid card in the same server (say you had two and one got replaced 2
years later)
-- 

