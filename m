From: Matt_Domsch@Dell.com
Subject: RE: [PATCH 2.5] fix megaraid driver compile error
Date: Thu, 6 Feb 2003 13:59:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20BF5713E14D5B48AA289F72BD372D680211AAD4@AUSXMPC122.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, markh@osdl.org, atulm@lsil.com
Cc: torvalds@transmeta.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> Any reason we can't jump straight to the v2 driver instead of fixing
> the now obsolete driver?

Atul told linux-megaraid-devel last week that there's at least one important
change to the ISR interaction with firmware that needs to be made, as well
as a broken SCSI RESERVATION_STATUS command.  He is addressing these and
will submit a 2.00.3 driver soon (I hope).

Thanks,
Matt

--
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

