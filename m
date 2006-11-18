From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/8] target mode support
Date: Sat, 18 Nov 2006 15:56:10 +0900 (JST)
Message-ID: <20061118155910R.fujita.tomonori@lab.ntt.co.jp>
References: <20061116192358C.fujita.tomonori@lab.ntt.co.jp>
	<455C76D1.9050501@emulex.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:64741 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1754075AbWKRG4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Nov 2006 01:56:24 -0500
In-Reply-To: <455C76D1.9050501@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com

From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 0/8] target mode support
Date: Thu, 16 Nov 2006 09:33:53 -0500

> One question....
> 
> Does this assume that an hba is both initiator and target ?  target only ?
> Do we have any issues if a scsi_host is a target only ?

As Mike said, now a scsi_host can be used as a target only. We need
some more work to make one scsi_host support both initiator and target
mode. Can a LLD use two scsi_hosts (for initiator and target mode
respectively)?

