From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 0/8] target mode support
Date: Sat, 18 Nov 2006 10:11:25 -0500
Message-ID: <455F229D.5060503@emulex.com>
References: <20061116192358C.fujita.tomonori@lab.ntt.co.jp>	<455C76D1.9050501@emulex.com> <20061118155910R.fujita.tomonori@lab.ntt.co.jp>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33730 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1754625AbWKRPLl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Nov 2006 10:11:41 -0500
In-Reply-To: <20061118155910R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@SteelEye.com


FUJITA Tomonori wrote:
> As Mike said, now a scsi_host can be used as a target only. We need
> some more work to make one scsi_host support both initiator and target
> mode. Can a LLD use two scsi_hosts (for initiator and target mode
> respectively)?

Sure.. a small amount of programming :)

It does help some of the presentation, but may do so at the cost of a
little code bloat.   Unfortunately, the technical issues of sharing the
transport port still exist, but that's true whether 1 or multiple
scsi_hosts are being used.

-- james s
