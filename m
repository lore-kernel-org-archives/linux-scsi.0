From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] ibmvstgt: remove
Date: Tue, 24 Jun 2014 16:28:19 +0200
Message-ID: <20140624142819.GA17733@lst.de>
References: <1397557614-21243-1-git-send-email-hch@lst.de> <1397557614-21243-2-git-send-email-hch@lst.de> <537F7785.7010304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44848 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbaFXO2W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 10:28:22 -0400
Content-Disposition: inline
In-Reply-To: <537F7785.7010304@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Paul Mackerras <paulus@au1.ibm.com>

On Fri, May 23, 2014 at 11:29:57AM -0500, Brian King wrote:
> Adding Paul and Nathan to cc here. I'm pretty sure the backend for ibmvscsi in
> KVM was all done in qemu and there is no dependency on ibmvstgt.
> 
> Unless there is a use case for KVM, I'm OK with this, as the ibmvstgt driver
> has never been tested or officially supported by IBM. 

Paul, Nathan,

any feedback on this?

