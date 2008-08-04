From: David Vrabel <david.vrabel@csr.com>
Subject: Re: [PATCH 2/2] fusion:  Implement generic interrupt misroute handling
Date: Mon, 04 Aug 2008 14:55:25 +0100
Message-ID: <48970A4D.2090309@csr.com>
References: <1217786709.4179.27.camel@localhost.localdomain> <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:41048 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYHDN4Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 09:56:25 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Moore, Eric wrote:
> Thanks, I will try this out.   However I thought I saw lost
> interrupts occurring randomly, meaning it was not necessarily the
> first config page access.  I'm back in the office on 8/11, I will
> test it out then and provide feedback.

Is this using MSI on a device without per-vector mask bits?  If so, then
this patch may help.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
