From: Thomas Soddemann <Thomas.Soddemann@rzg.mpg.de>
Subject: ide-scsi with ide-hd?
Date: Fri, 06 Dec 2002 10:16:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DF06AD0.5070507@rzg.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rzg.mpg.de (tkspc.rzg.mpg.de [130.183.2.156])
	by post.rzg.mpg.de (8.9.2/8.9.2) with ESMTP id KAA64354
	for <linux-scsi@vger.kernel.org>; Fri, 6 Dec 2002 10:15:58 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

does anybody know whether there is there a possibility to use ide-scsi 
in connection with an IDE HD?
If so, where can I get more information from? By looking at the source 
of ide-scsi I get the impression, that only IDE devices work, which have 
a kind of SCSI origin.
The intention is to use IDE HDs via the ide-scsi driver in connection 
with a special file system (GPFS), since it does not (at least not 
officially) support IDE drives. Single node harddisk performance is not 
really an issue, since GPFS is a parallel filesystem, and it will be 
used with GBit Ethernet, in our case.

Thanks,
Thomas

-- 
--------------------------------------------------
 Dr. Thomas Soddemann     |  Boltzmannstrasse 2
 Applications Consultant  |  85748 Garching
 Rechenzentrum der MPG    |  Germany 
 am MPI fuer Plasmaphysik |
---------------------------------------------------
 phone: +49 89 3299 2694  |  fax: +49 89 3299 1301
---------------------------------------------------


