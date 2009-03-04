From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Tue, 3 Mar 2009 20:54:47 -0700
Message-ID: <20090304035447.GA1884@parisc-linux.org>
References: <660360F4F2570145BD872F298951B17A7689E415@cosmail03.lsi.com> <49ADF402.4050504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44192 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZCDDzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 22:55:06 -0500
Content-Disposition: inline
In-Reply-To: <49ADF402.4050504@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Grant Grundler <grundler@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Mar 03, 2009 at 10:22:42PM -0500, Rob Evers wrote:
> >(1) Add readl following writel from the function that disables interrupts
>  
> Is a memory barrier required after the writel and before the readl to 
> ensure that the writel executes before the readl on processors other than 
> x86_64 and ia32?

No.  Architectures such as PowerPC and Altix which have the potential
to issue writes out of order wrt io memory are required to implement
barriers in their writel() implementation.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
