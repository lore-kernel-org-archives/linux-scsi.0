From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/5] ibmvstgt: remove
Date: Tue, 01 Jul 2014 13:16:00 +0200
Message-ID: <53B29870.9080005@redhat.com>
References: <1397557614-21243-1-git-send-email-hch@lst.de> <1397557614-21243-2-git-send-email-hch@lst.de> <537F7785.7010304@linux.vnet.ibm.com> <20140624142819.GA17733@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:49589 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaGALQG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2014 07:16:06 -0400
Received: by mail-qg0-f41.google.com with SMTP id i50so3197167qgf.28
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jul 2014 04:16:04 -0700 (PDT)
In-Reply-To: <20140624142819.GA17733@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Paul Mackerras <paulus@au1.ibm.com>

Il 24/06/2014 16:28, Christoph Hellwig ha scritto:
>> > Adding Paul and Nathan to cc here. I'm pretty sure the backend for ibmvscsi in
>> > KVM was all done in qemu and there is no dependency on ibmvstgt.
>> >

FWIW the ibmvscsi backend is indeed entirely in userspace 
(hw/scsi/spapr_vscsi.c in the QEMU tree).

Paolo
