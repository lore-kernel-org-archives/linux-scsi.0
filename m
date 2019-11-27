Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26104C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 00:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0655920674
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 00:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfK0AVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:21:16 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53984 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfK0AVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 19:21:16 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id E5F1122C35;
        Tue, 26 Nov 2019 19:21:11 -0500 (EST)
Date:   Wed, 27 Nov 2019 11:21:13 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Andrea Vai <andrea.vai@unipv.it>
cc:     Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
Message-ID: <alpine.LNX.2.21.1.1911271055200.8@nippy.intranet>
References: <20191109222828.GA30568@ming.t460p>         <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>         <20191123072726.GC25356@ming.t460p>         <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>         <20191125035437.GA3806@ming.t460p>
         <bf47a6c620b847fa9e27f8542eb761529f3e0381.camel@unipv.it>         <20191125102928.GA20489@ming.t460p>         <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>         <20191125151535.GA8044@ming.t460p>        
 <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>         <20191126023253.GA24501@ming.t460p> <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 26 Nov 2019, Andrea Vai wrote:

> Then I started another set of 100 trials and let them run tonight, and 
> the first 10 trials were around 1000s, then gradually decreased to 
> ~300s, and finally settled around 200s with some trials below 70-80s. 
> This to say, times are extremely variable and for the first time I 
> noticed a sort of "performance increase" with time.
> 

The sheer volume of testing (probably some terabytes by now) would 
exercise the wear leveling algorithm in the FTL.

This in itself seems unlikely to improve performance significantly. But if 
the flash memory came from a bad batch, perhaps it would have that effect.

To find out, someone may need to source another (genuine) Kingston 
DataTraveller device.

-- 
