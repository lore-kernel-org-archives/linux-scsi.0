From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Wed, 09 Mar 2016 21:32:01 -0500
Message-ID: <yq1io0vqd0e.fsf@sermon.lab.mkp.net>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
	<CAGnHSEnLA+WRMuPCLHc=U5m6M5XG-CGbP4gcmh4WJ9QeWwDm0A@mail.gmail.com>
	<CAGnHSE=Ct7vFas3K-DDwU68W+R=ADx7Tx36LBBk3gxeDFZG3Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33101 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbcCJCcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2016 21:32:09 -0500
In-Reply-To: <CAGnHSE=Ct7vFas3K-DDwU68W+R=ADx7Tx36LBBk3gxeDFZG3Ow@mail.gmail.com>
	(Tom Yan's message of "Wed, 9 Mar 2016 11:38:15 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> Btw, why SD_MAX_WS16_BLOCKS (which is used for both SD_LBP_WS16 and
Tom> SD_LBP_UNMAP) is set to 0x7fffff (23-bit) instead of 0xffffffff
Tom> (32-bit, 4-byte)?

This limit represents the largest block range we can describe using a
single bio.

-- 
Martin K. Petersen	Oracle Linux Engineering
