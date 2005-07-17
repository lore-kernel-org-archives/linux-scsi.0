From: Lee Revell <rlrevell@joe-job.com>
Subject: Re: [2.6 patch] SCSI_QLA2ABC mustn't select SCSI_FC_ATTRS
Date: Sat, 16 Jul 2005 23:11:26 -0400
Message-ID: <1121569886.13990.4.camel@mindpipe>
References: <20050715013653.36006990.akpm@osdl.org>
	 <20050715102744.GA3569@stusta.de> <20050715144037.GA25648@plap.qlogic.org>
	 <20050717023809.GE3613@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viper.oldcity.dca.net ([216.158.38.4]:38586 "HELO
	viper.oldcity.dca.net") by vger.kernel.org with SMTP
	id S261754AbVGQDL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2005 23:11:28 -0400
In-Reply-To: <20050717023809.GE3613@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sun, 2005-07-17 at 04:38 +0200, Adrian Bunk wrote:
> SCSI_QLA2XXX is automatically enabled for (SCSI && PCI).

This has bugged me for a while.  Why does this one SCSI driver default
to Y in the first place?

Lee

