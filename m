From: Jens Axboe <axboe@kernel.dk>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO support optional
Date: Tue, 9 Feb 2016 06:29:38 -0700
Message-ID: <CB24E0BA-5A48-4D57-9B81-A81F6598F32F@kernel.dk>
References: <1454783624.2809.6.camel@HansenPartnership.com> <20160207092241.GA15331@lst.de> <1454861040.2329.4.camel@HansenPartnership.com> <56B7C527.6050300@kernel.dk> <20160209125011.GC25353@lst.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36674 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbcBIN3k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 08:29:40 -0500
Received: by mail-pf0-f182.google.com with SMTP id e127so32292923pfe.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Feb 2016 05:29:40 -0800 (PST)
In-Reply-To: <20160209125011.GC25353@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Feb 9, 2016, at 5:50 AM, Christoph Hellwig <hch@lst.de> wrote:
> 
> Jens,
> 
> do you want a 'default y' patch or just a better description?  I'd be
> happy to send either one.

A better description  

-- 
Jens Axboe
