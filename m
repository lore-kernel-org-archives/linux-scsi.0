From: S Iremonger <exxsi@bath.ac.uk>
Subject: linux 2.6 "seagate" scsi hardware driver ?incomplete?
Date: Tue, 1 Feb 2005 02:11:48 +0000 (GMT)
Message-ID: <Pine.GSO.4.53.0502010159390.22349@amos.bath.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from binda.bath.ac.uk ([138.38.32.22]:4941 "EHLO binda.bath.ac.uk")
	by vger.kernel.org with ESMTP id S261496AbVBACLs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 21:11:48 -0500
Received: from amos.bath.ac.uk ([138.38.32.36] ident=mmdf)
	by binda.bath.ac.uk with smtp  id 1CvnW8-0002O0-AN
	for linux-scsi@vger.kernel.org; Tue, 01 Feb 2005 02:11:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I would like if anybody out there knwos why linux-2.6 (well, at
  least 2.6.8.1 and 2.6.10) seems to have "seagate" as an
  "incomplete or experimental" driver, at least that it
  does not appear in the SCSI low level drivers list
  unless the "enabled incomplete and/or experimental" drivers
  config option is enabled (not sure of the CONFIG_ option
  myself).

This is quite annoying because this means the module is not
  included with some distributions etc.

I don't think this driver is 'experimental' in 2.4 kernel series.
I wonder if this is just a mistake, or if there is something I
  am missing!

Please point me in the right direction, people ;-).


Thankyou in advance
--S Iremonger <exxsi@bath.ac.uk>

