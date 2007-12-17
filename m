From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Re: FC-LTO4 tape drive: Sense Key : Illegal Request
Date: Mon, 17 Dec 2007 15:00:55 +0100
Message-ID: <xfksl214e08.fsf@uxkm53.drewag.de>
References: <xfk63z5ci9w.fsf@uxkm53.drewag.de> <475F0D54.4090000@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.drewag.de ([212.111.238.29]:32774 "EHLO
	miranda.drewag.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbXLQOAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2007 09:00:55 -0500
In-Reply-To: <475F0D54.4090000@emulex.com> (James Smart's message of "Tue,
 11 Dec 2007 17:21:08 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart <James.Smart@Emulex.Com> writes:

> This sounds like the recent lpfc bug found on the LTO-3 or LTO-4. The lpfc
> driver had messed up tag handling (a long time bug).  The patch was posted
> at http://marc.info/?l=linux-scsi&m=119367024313743&w=2
> and has been pulled into scsi-rc-fixes, and I believe will be in 2.6.24.

I use the patch with 2.6.23.8 and it works now. Thank you!

	Sven 

