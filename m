From: Oktay Akbal <oktay.akbal@s-tec.de>
Subject: qlogic failover multipath
Date: Fri, 6 Sep 2002 11:53:43 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209061142150.12655-100000@omega.s-tec.de>
References: <Pine.LNX.4.44.0209051043570.2844-100000@omega.s-tec.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0209051043570.2844-100000@omega.s-tec.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hello,

we do have some Problems with some qlogic 2202f fibrechannel card.
When trying to use failover via plugging out some cable or using
qlogics sansurfer to set an alternate path, there seem to be no errors,
but everything works extremly slow and does not recover.

This was used with driver 6.0b23 as from suse kernel 2.4.18.

When trying 6.1b2 or b5 the disks get recognized as multiple scsi-disks,
is this wanted for use with md multipath personality ?
Is there a way to enable previos behavior ?

Please reply also to me directly.

Thanks

Oktay Akbal


