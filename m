From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: tgt infrastructure removal
Date: Fri, 04 Jul 2014 11:52:54 +0200
Message-ID: <53B67976.4030900@redhat.com>
References: <1397557614-21243-1-git-send-email-hch@lst.de> <20140704093643.GA21482@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50402 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaGDJw7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 05:52:59 -0400
Received: by mail-qa0-f49.google.com with SMTP id w8so1149269qac.8
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jul 2014 02:52:59 -0700 (PDT)
In-Reply-To: <20140704093643.GA21482@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Il 04/07/2014 11:36, Christoph Hellwig ha scritto:
> I got an older Ack from Tomo for the removal, and some sort of acks
> for the ibmvscsi target removal from Brian, Paolo and Nathan.
>
> Can I get some formal reviews for the code removal patches (1-4) so I
> can queue this up for 3.17?

Not that there's much to review there. :)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
