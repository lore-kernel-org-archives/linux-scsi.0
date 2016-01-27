From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] mptlan: add checks for dma mapping errors
Date: Tue, 26 Jan 2016 21:22:45 -0500
Message-ID: <yq1pownhibu.fsf@sermon.lab.mkp.net>
References: <56A6568B.9020707@ispras.ru>
	<1453744944-4065-1-git-send-email-khoroshilov@ispras.ru>
	<56A79FD3.2060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20523 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbcA0CXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 21:23:04 -0500
In-Reply-To: <56A79FD3.2060200@redhat.com> (Tomas Henzl's message of "Tue, 26
	Jan 2016 17:33:23 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

Tomas> Other than that - previous patch for this driver came in in 2010
Tomas> - six years ago and the driver seems unmaintained now.  I'm not
Tomas> sure if we should fix hw we can't test and when there is not an
Tomas> user bug report. This example nicely shows how easy it is to add
Tomas> new bugs even when a fix looks trivial.

Yeah, I'm inclined to leave it as is.

If somebody provides a Tested-by: I'll reconsider.

-- 
Martin K. Petersen	Oracle Linux Engineering
