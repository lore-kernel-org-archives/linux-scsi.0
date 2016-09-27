From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: UAS driver seems to be reporting a 4k sector size for a 512 byte sector device?
Date: Mon, 26 Sep 2016 21:24:24 -0400
Message-ID: <yq160pi2kzb.fsf@sermon.lab.mkp.net>
References: <20160926161926.cmayrily476v3wa7@thunk.org>
        <20160926162511.GA1949@infradead.org>
        <20160926215247.nplawebmdmyarldo@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35681 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932482AbcI0BZA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 21:25:00 -0400
In-Reply-To: <20160926215247.nplawebmdmyarldo@thunk.org> (Theodore Ts'o's
        message of "Mon, 26 Sep 2016 17:52:47 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

>>>>> "Ted" == Theodore Ts'o <tytso@mit.edu> writes:

Ted,

Ted> sg_readcap doesn't report the physical sector size, just the
Ted> logical block size:

Ted> # sg_readcap /dev/sdd
Ted> Read Capacity results:
Ted>    Last logical block address=4000797359 (0xee7752af), Number of
Ted>    blocks=4000797360 Logical block length=512 bytes
Ted> Hence:
Ted>    Device size: 2048408248320 bytes, 1953514.3 MiB, 2048.41 GB

You need to run sg_readcap with the -l option to get to the physical
block size exponent. Please let us know if that makes a difference.

-- 
Martin K. Petersen	Oracle Linux Engineering
