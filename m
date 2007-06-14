From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla4xxx: allow hba to be online when initiator ip	address is uninitialized
Date: Thu, 14 Jun 2007 10:44:20 -0700
Message-ID: <20070614174420.GB16880@plap.qlogic.org>
References: <1181348961.8711.4.camel@q-iscsi-upstream.site> <1181349436.8711.8.camel@q-iscsi-upstream.site> <4670D80C.2090708@cs.wisc.edu> <1181842033.3423.3.camel@q-iscsi-upstream.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:2990 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXFNRpW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 13:45:22 -0400
Content-Disposition: inline
In-Reply-To: <1181842033.3423.3.camel@q-iscsi-upstream.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

On Thu, 14 Jun 2007, David Somayajulu wrote:

> On Thu, 2007-06-14 at 01:54 -0400, Mike Christie wrote:
> > David C Somayajulu wrote:
> > 
> > It looks ok, but creating the status variable and setting it like this,
> > just to quiet the compile warning, and never doing anything else with it
> > doesn't seem nice.
> I don't like it either. I tried with 
> (void)pci_set_mwi(ha->pdev); 
> and this is what I see

I was hoping that Randy's proposal for pci_try_set_mwi() was accepted:

	http://article.gmane.org/gmane.linux.scsi/31230/

that way drivers could safely ignore the return (if necessary).
