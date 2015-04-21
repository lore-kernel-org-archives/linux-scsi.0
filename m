From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND 1/18] megaraid_sas : Add separate function for
 setting up IRQs
Date: Tue, 21 Apr 2015 03:33:30 -0700
Message-ID: <20150421103330.GA8920@infradead.org>
References: <201504201234.t3KCYg04016312@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbDUKda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 06:33:30 -0400
Content-Disposition: inline
In-Reply-To: <201504201234.t3KCYg04016312@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On Mon, Apr 20, 2015 at 06:02:30PM +0530, Sumit.Saxena@avagotech.com wrote:
> This patch will create separate function for setting up IRQs and enable interrupts after adapter's initialization.

The structure of megasas_setup_irqs clearly suggest it should be two
functions: one for the traditional case, and one for MSI-X.

The irq unregister case should get a similar factoring.

Additionally the changelog needs an explanation on why you move around
the code that registeres interrupts as well as the
->instancet->enable_intr call.
