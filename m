From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 3/3] iscsi_tcp: Enable large commands
Date: Tue, 15 Apr 2008 09:08:23 -0400
Message-ID: <4804A8C7.504@emulex.com>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <48049E8A.7030700@panasas.com> <4804A16D.7000002@panasas.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44895 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYDONLg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2008 09:11:36 -0400
In-Reply-To: <4804A16D.7000002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Alasdair G Kergon <agk@redhat.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Boaz Harrosh wrote:
> Let through up to the largest command of 260 defined by the scsi standard.
> iscsi core supports this already. Now that the scsi-ml supports it we can
> start using large commands.

Just to double-check:
if we use sg_io to pass through requests from user-land, which are addressed to
drivers or transports, and which may not be a SCSI command but rather just something
utilizing the sg_io infrastructure for management or pass-thru, are we limited to
260 bytes for request/cmd payload ?

-- james s
