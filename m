From: Laurent Riffard <laurent.riffard@free.fr>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118
 caused by "pktsetup dvd /dev/sr0"
Date: Thu, 28 Dec 2006 23:28:14 +0100
Message-ID: <459444FE.4080909@free.fr>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org> <20061212103842.GA9619@lst.de> <20061212132600.GA19912@lst.de> <457EBAE3.6090609@panasas.com> <457F2F17.3000009@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp10.orange.fr ([193.252.22.21]:37161 "EHLO smtp10.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965027AbWL1Wtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Dec 2006 17:49:33 -0500
Received: from smtp10.orange.fr (mwinf1002 [172.22.141.24])
	by mwinf1005.orange.fr (SMTP Server) with ESMTP id 59C2AC046D8
	for <linux-scsi@vger.kernel.org>; Thu, 28 Dec 2006 23:28:42 +0100 (CET)
In-Reply-To: <457F2F17.3000009@free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@lst.de>, Peter Osterlund <petero2@telia.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Adrian Bunk <bunk@stusta.de>


This BUG (http://bugzilla.kernel.org/show_bug.cgi?id=7667) still happens with 
2.6.20-rc2-mm1.

Fortunately, Christoph Hellwig's patch 
(http://bugzilla.kernel.org/show_bug.cgi?id=7667#c5) still fix it.

-- 
laurent
