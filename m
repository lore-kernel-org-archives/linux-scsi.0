From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [2.6 patch] SCSI qla1280: some firmware files cleanups
Date: 15 Nov 2004 03:48:34 -0500
Message-ID: <yq07jona465.fsf@jaguar.mkp.net>
References: <20041115022640.GX2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:23969 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S261550AbUKOIsf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 03:48:35 -0500
In-Reply-To: <20041115022640.GX2249@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Adrian" == Adrian Bunk <bunk@stusta.de> writes:

Adrian> The patch below does the following changes to the qla1280
Adrian> firmware files: - make all this needlessly global code static
Adrian> - remove the unused firmware_version variables


Looks fine to me, though some of those could maybe even be turned into
#define's.

Cheers,
Jes
