From: Lee Revell <rlrevell@joe-job.com>
Subject: Re: [2.6 patch] SCSI_QLA2ABC mustn't select SCSI_FC_ATTRS
Date: Sun, 17 Jul 2005 00:20:44 -0400
Message-ID: <1121574045.14698.3.camel@mindpipe>
References: <20050715013653.36006990.akpm@osdl.org>
	 <20050715102744.GA3569@stusta.de> <20050715144037.GA25648@plap.qlogic.org>
	 <20050717023809.GE3613@stusta.de> <1121569886.13990.4.camel@mindpipe>
	 <20050716210456.12accf7b.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mustang.oldcity.dca.net ([216.158.38.3]:62677 "HELO
	mustang.oldcity.dca.net") by vger.kernel.org with SMTP
	id S261935AbVGQEUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jul 2005 00:20:47 -0400
In-Reply-To: <20050716210456.12accf7b.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: bunk@stusta.de, andrew.vasquez@qlogic.com, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sat, 2005-07-16 at 21:04 -0700, randy_dunlap wrote:
> On Sat, 16 Jul 2005 23:11:26 -0400 Lee Revell wrote:
> 
> > On Sun, 2005-07-17 at 04:38 +0200, Adrian Bunk wrote:
> > > SCSI_QLA2XXX is automatically enabled for (SCSI && PCI).
> > 
> > This has bugged me for a while.  Why does this one SCSI driver default
> > to Y in the first place?
> 
> It's not a driver, it's a subdirectory.

Ah, ok.  Thanks.

Lee

