From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 10:40:45 -0500
Message-ID: <yq1ab86efia.fsf@sermon.lab.mkp.net>
References: <20090227163326V.fujita.tomonori@lab.ntt.co.jp>
	<yq1eixjdws0.fsf@sermon.lab.mkp.net>
	<20090228045014.GP16891@parisc-linux.org>
	<20090228141855Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:51731 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZB1Pk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2009 10:40:57 -0500
In-Reply-To: <20090228141855Z.fujita.tomonori@lab.ntt.co.jp> (FUJITA Tomonori's message of "Sat\, 28 Feb 2009 14\:19\:07 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matthew@wil.cx, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>>>>> "Tomo" == FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:

Tomo> Yeah, that's why my patch sets SCSI_TRANSPORT_SPI to 0. So a lot
Tomo> of parallel SCSI drivers that don't use spi class can get 'spi'
Tomo> properly.

Oh, duh.  I added the unknown bits last minute to check for devices that
didn't have a class.  Shows you how many parallel devices I have left :)

-- 
Martin K. Petersen	Oracle Linux Engineering
