From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: RE: How to resurrect offlined SCSI devices?
Date: Thu, 27 May 2004 22:04:07 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD38A6485.0D3AFAAD-ONC1256EA1.00663BDB@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:24009 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S265151AbUE0UEP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 16:04:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Infante, Jon" <Jon.Infante@Emulex.Com>, SCSI Mailing List <linux-scsi@vger.kernel.org>





> I'd really like to see all fibre events (like loop up/down, device
> add/remove) handled inside the FC transport class.  From there, it
> probably still make sense to use hotplug as the mechanism for importing
> user policy.

I am fine with deploying user space to handle policy decisions, as long as
the kernel's SCSI code allows to propagate events, which is needed to
make it work well.

Martin

