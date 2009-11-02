From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Mon, 02 Nov 2009 18:02:56 +0200
Message-ID: <4AEF02B0.2060506@panasas.com>
References: <20091029150830.497006534@bombadil.infradead.org>	<20091029151127.257902381@bombadil.infradead.org>	<yq1ws2dsh4g.fsf@sermon.lab.mkp.net>	<20091030050558.GC17714@infradead.org> <yq1eioh9hsr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:1251 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbZKBQC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 11:02:58 -0500
Received: by qw-out-2122.google.com with SMTP id 9so1147385qwb.37
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2009 08:03:03 -0800 (PST)
In-Reply-To: <yq1eioh9hsr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

On 11/02/2009 03:29 PM, Martin K. Petersen wrote:
> 
> With heterogeneous md and dm devices there may not be a meaningful value
> to put in the discard granularity field.  Then what?
> 

These alignment masks may only be base-2, no?
If so then the max alignment of all devices will work for any device.

I think
Boaz
