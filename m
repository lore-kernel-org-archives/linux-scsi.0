From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] hisi_sas: Restrict SCSI_HISI_SAS to arm64
Date: Tue, 19 Jan 2016 19:25:34 -0500
Message-ID: <yq1si1tqept.fsf@sermon.lab.mkp.net>
References: <1452865149-32064-1-git-send-email-geert@linux-m68k.org>
	<1452865149-32064-2-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:30160 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934275AbcATB0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 20:26:06 -0500
In-Reply-To: <1452865149-32064-2-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Fri, 15 Jan 2016 14:39:09 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Geert" == Geert Uytterhoeven <geert@linux-m68k.org> writes:

Geert> The HiSilicon SAS HBA is available in HiSilicon arm64 SoCs only.
Geert> Restrict it to arm64, unless compile-testing.

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
