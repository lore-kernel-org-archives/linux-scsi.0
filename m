From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Sat, 9 Aug 2003 10:09:52 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308091005540.6012@kai.makisara.local>
References: <20030806231359.A28252@mail.kroptech.com>
 <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local> <20030807201916.A1065@mail.kroptech.com>
 <20030808173003.GA3231@kai.makisara.local> <Pine.LNX.4.56.0308081357160.13076@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:55455 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S272223AbTHIHJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Aug 2003 03:09:56 -0400
In-Reply-To: <Pine.LNX.4.56.0308081357160.13076@filesrv1.baby-dragons.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>

On Fri, 8 Aug 2003, Mr. James W. Laferriere wrote:

> 	Hello Kai ,  Is this (or something simular) necessary for 2.4.x ?

No. This bug crept in while adding direct transfers between the user
buffer and SCSI HBA at 2.5.32.

-- 
Kai
