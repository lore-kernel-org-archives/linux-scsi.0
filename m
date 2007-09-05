From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Wed, 05 Sep 2007 14:35:50 +0100
Message-ID: <20070905143550I.tomof@acm.org>
References: <200708311703.l7VH3NkK016220@mbox.iij4u.or.jp>
	<20070905150534.GJ17977@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:46989 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbXIEQ4F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Sep 2007 12:56:05 -0400
In-Reply-To: <20070905150534.GJ17977@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.de, fujita.tomonori@lab.ntt.co.jp

On Wed, 5 Sep 2007 08:05:34 -0700
Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:

> On Sat, 01 Sep 2007, FUJITA Tomonori wrote:
> 
> > This adds target mode support to qla2xxx.
> > 
> > With set ql2enable_target_mode module parameter to 1, the driver runs
> > in target mode. By default, ql2enable_target_mode is set to 0, and the
> > driver should work in initiator mode as before.
> > 
> > The driver could support dual-mode in the future but it doesn't at the
> > moment (we need to add dual-mode support tgt first).
> > 
> > It is based on scst qla2xxx target mode driver. Mike converted the
> > driver to use tgt long ago. I changed it to use the latest (mainline)
> > version of qla2xxx driver and tgt, and also converted it to use fc
> > transport class.
> 
> Thanks for doing this.  Some initial comments before a full review is
> complete, As was seen from the initiator updates needed for 24xx
> support, there are comparable changes needed in the area of
> target-mode support for 4gb and 8gb parts.

I see, thanks.

I heard that 24xx firmware doesn't support target mode and I thought
that I should not touch 24xx code. Not true?


> Also, which ISPs and firmwares were exercised with this code?

qla2xxx 0000:0a:02.0:
 QLogic Fibre Channel HBA Driver: 8.02.00-k2
  QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel
  ISP2312: PCI-X (133 MHz) @ 0000:0a:02.0 hdma-, host#=3, fw=3.03.20 IPX
