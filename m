From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: please revert [PATCH] s390: zfcp act enhancements
Date: Wed, 17 Nov 2004 17:03:04 +0100
Message-ID: <20041117160304.GD14119@devserv.devel.redhat.com>
References: <OFD875A546.5C9126AF-ONC1256F4F.005746F3-C1256F4F.00589AD6@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41449 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262353AbUKQQD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 11:03:27 -0500
Content-Disposition: inline
In-Reply-To: <OFD875A546.5C9126AF-ONC1256F4F.005746F3-C1256F4F.00589AD6@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, BOEBLINGEN LINUX390 <linux390@de.ibm.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>

On Wed, Nov 17, 2004 at 05:01:12PM +0100, Martin Peschke3 wrote:
> 
> 
> 
> 
> > the answer is "put a sensible interface in the FC transport class".
> 
> Obviously a good place. Now the question boils down to "sensible".
> Which particular functions of the HBA API do you object to?

wrong question.

the real question is "What interfaces are missing to do proper management"
