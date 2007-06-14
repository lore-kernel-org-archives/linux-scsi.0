From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] qla4xxx: allow hba to be online when initiator ip
 address is uninitialized
Date: Thu, 14 Jun 2007 10:54:03 -0700
Message-ID: <20070614105403.7857a8a6.randy.dunlap@oracle.com>
References: <1181348961.8711.4.camel@q-iscsi-upstream.site>
	<1181349436.8711.8.camel@q-iscsi-upstream.site>
	<4670D80C.2090708@cs.wisc.edu>
	<1181842033.3423.3.camel@q-iscsi-upstream.site>
	<20070614174420.GB16880@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:25737 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbXFNRx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 13:53:28 -0400
In-Reply-To: <20070614174420.GB16880@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: David C Somayajulu <david.somayajulu@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

On Thu, 14 Jun 2007 10:44:20 -0700 Andrew Vasquez wrote:

> On Thu, 14 Jun 2007, David Somayajulu wrote:
> 
> > On Thu, 2007-06-14 at 01:54 -0400, Mike Christie wrote:
> > > David C Somayajulu wrote:
> > > 
> > > It looks ok, but creating the status variable and setting it like this,
> > > just to quiet the compile warning, and never doing anything else with it
> > > doesn't seem nice.
> > I don't like it either. I tried with 
> > (void)pci_set_mwi(ha->pdev); 
> > and this is what I see
> 
> I was hoping that Randy's proposal for pci_try_set_mwi() was accepted:
> 
> 	http://article.gmane.org/gmane.linux.scsi/31230/
> 
> that way drivers could safely ignore the return (if necessary).

Andrew seems to still be trying to push it (i.e., he hasn't
given up on it yet).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
