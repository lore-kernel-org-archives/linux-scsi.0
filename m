From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Tue, 16 Dec 2003 00:16:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071530203.1365.8.camel@cala>
References: <1071483139.1433.3.camel@cala> <3FDD9D52.2060405@cri74.org>
	 <1071511696.1932.1.camel@cala>  <20031215181944.GB1259@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp3.tin.it ([212.216.176.223]:35039 "EHLO vsmtp3.tin.it")
	by vger.kernel.org with ESMTP id S264309AbTLOXQ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 18:16:57 -0500
In-Reply-To: <20031215181944.GB1259@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org

Il lun, 2003-12-15 alle 19:19, Andrew Vasquez ha scritto:

> Try the attached patch against 6.06.10 (available from the QLogic
> website).
> 
Thank you very much! It almost works now!
BTW: I checked again qlogic website and I have not found it...
BTW2: About iSCSI. There are several software iscsi initiator and target
for linux (search with google and in sourceforge). I suggest ardis
target and cisco initiator. They are completely software so they run on
every tcp/ip based network. I have tested them on ethernet but they
should run also on fc0. But they are completely software based: they use
fibre channel only like a fast ethernet.

AND NOW the big problem:

I try to ping from qlogic card to mpt-fusion (lsi logic) card and
viceversa.

Hardware works (both cards see my fibre channel hard disks)

All packets are lost (destination host unreachable), route is ok.

On qlogic based host I see in dmesg output:

qla2x00_send_packet: Unable to determine loop id for destination.
qla2200ip: fc0 - Unable to send packet -- Bad error occured!!!
qla2x00_send_packet: Unable to determine loop id for destination.
qla2200ip: fc0 - Unable to send packet -- Bad error occured!!!
qla2x00_send_packet: Unable to determine loop id for destination.
qla2200ip: fc0 - Unable to send packet -- Bad error occured!!!
...
...

I suppose the bug is perhaps in mpt-fusion code because I triggered it
also with two lsi logic cards.

Please tell it to lsi logic developers also!

Thanks again for past and future help!


-- 
Mario Giammarco

