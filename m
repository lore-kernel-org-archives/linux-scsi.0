From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ibmvstgt: remove
Date: Wed, 02 Jul 2014 11:14:52 -0500
Message-ID: <53B42FFC.1010001@linux.vnet.ibm.com>
References: <1397557614-21243-1-git-send-email-hch@lst.de> <1397557614-21243-2-git-send-email-hch@lst.de> <537F7785.7010304@linux.vnet.ibm.com> <20140624142819.GA17733@lst.de> <53B29870.9080005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:39576 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaGBQPz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2014 12:15:55 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <nfont@linux.vnet.ibm.com>;
	Wed, 2 Jul 2014 10:15:55 -0600
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 8BBF06E8041
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jul 2014 12:15:42 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s62GFhRj51052736
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jul 2014 16:15:51 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s62GFIOE023274
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jul 2014 12:15:19 -0400
In-Reply-To: <53B29870.9080005@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Paul Mackerras <paulus@au1.ibm.com>

On 07/01/2014 06:16 AM, Paolo Bonzini wrote:
> Il 24/06/2014 16:28, Christoph Hellwig ha scritto:
>>> > Adding Paul and Nathan to cc here. I'm pretty sure the backend for ibmvscsi in
>>> > KVM was all done in qemu and there is no dependency on ibmvstgt.
>>> >
> 
> FWIW the ibmvscsi backend is indeed entirely in userspace (hw/scsi/spapr_vscsi.c in the QEMU tree).
> 

I do not see any reason we cannot remove this driver.

-Nathan

