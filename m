From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SNIA iSCSI Management API Public Review
Date: Tue, 26 Oct 2004 22:07:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026210734.GA18479@infradead.org>
References: <20041026182914.GA6006@lists.us.dell.com> <20041026194926.GA17456@infradead.org> <417EAC8F.5010109@netapp.com> <20041026202311.GA17844@infradead.org> <417EBBD1.7090508@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:1038 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261465AbUJZVHp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 17:07:45 -0400
Content-Disposition: inline
In-Reply-To: <417EBBD1.7090508@netapp.com>
List-Id: linux-scsi@vger.kernel.org
To: David Wysochanski <davidw@netapp.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, linux-scsi@vger.kernel.org

> >it throws far too much things together, own type and object system,
> >functions to deal with firmware.  there's ill suited abstractions like
> >the phba, etc..
> >
> Sounds like you don't like the modelling.  Keep in mind that a
> lot of this came out of the T11 HBA API (for Fibre Channel HBAs
> and FC storage management).  Thus, the "phba" idea really fits
> the model well.  If you're thinking about it from a software
> only perspective, with standard ethernet NICs, it does look
> a little strange.

If you browse the archives you'll find my opinion on the HBA API ;-)

