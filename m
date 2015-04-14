From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] target/file: Fix UNMAP with DIF protection support
Date: Mon, 13 Apr 2015 21:20:16 -0400
Message-ID: <yq138437bfz.fsf@sermon.lab.mkp.net>
References: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
	<1428934918-4004-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbbDNBUb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 21:20:31 -0400
In-Reply-To: <1428934918-4004-3-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 13 Apr 2015 23:21:58 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> When UNMAP command is issued with DIF protection support
Akinobu> enabled, the protection info for the unmapped region is remain
Akinobu> unchanged.  So READ command for the region causes data
Akinobu> integrity failure.

Akinobu> This fixes it by invalidating protection info for the unmapped
Akinobu> region by filling with 0xff pattern.  This change also adds
Akinobu> helper function fd_do_prot_fill() in order to reduce code
Akinobu> duplication with existing fd_format_prot().

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
