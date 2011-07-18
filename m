From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/3] libsas: sas_queuecommand doesnt need host_lock
Date: Mon, 18 Jul 2011 16:40:17 -0700
Message-ID: <CAA9_cmeHGbdW+c-RE+Lk9+kNy0arxHjU=OPcJZZtnUTLRuH8Kw@mail.gmail.com>
References: <20110711184922.859239377@bombadil.infradead.org>
	<20110711185045.179355504@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57770 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1GRXkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2011 19:40:18 -0400
Received: by iwn6 with SMTP id 6so3556566iwn.19
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2011 16:40:17 -0700 (PDT)
In-Reply-To: <20110711185045.179355504@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, "dave.jiang" <dave.jiang@intel.com>

On Mon, Jul 11, 2011 at 11:49 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>

Dave can add his Tested-by, but looks like a nice bump in iops.

--
Dan
