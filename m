From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: remove artifical max_hw_sectors cap
Date: Tue, 21 Oct 2014 14:02:26 -0600
Message-ID: <5446BBD2.8040306@kernel.dk>
References: <1410044885-14893-1-git-send-email-hch@lst.de> <20141001130822.GA5362@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958CC7BAB@G4W3202.americas.hpqcorp.net> <20141001211258.GB24820@infradead.org> <20141017131247.GA16538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51290 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbaJUUC1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 16:02:27 -0400
Received: by mail-pa0-f48.google.com with SMTP id ey11so112842pad.7
        for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2014 13:02:27 -0700 (PDT)
In-Reply-To: <20141017131247.GA16538@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>

On 10/17/2014 07:12 AM, Christoph Hellwig wrote:
> On Wed, Oct 01, 2014 at 02:12:58PM -0700, Christoph Hellwig wrote:
>> On Wed, Oct 01, 2014 at 06:59:34PM +0000, Elliott, Robert (Server Storage) wrote:
>>> One supporting example: A low limit interferes with creation of
>>> full stripe writes for RAID controllers.
>>
>> Yes, both Linux mdraid and parity raids are often crippled by the
>> default.  The mdadm default of 512kb for each chunk combined with
>> the default limit very much guarantees a horrible out of the box
>> experience.
> 
> Jens, can you apply this patch once the 3.19 queue opens?

Yup, lets get it applied.

-- 
Jens Axboe

