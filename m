From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: SCSI tape write problems at EOT (patch)
Date: Thu, 20 Mar 2003 21:28:14 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0303202116100.1552@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kai.makisara.local ([62.248.235.203])
          by fep02-app.kolumbus.fi with ESMTP
          id <20030320192813.CYSB4145.fep02-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2003 21:28:13 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The SCSI tape driver is currently somewhat too conservative when writing
in fixed block mode near the EOT early warning and reports as errors
conditions that could be recovered. This has probably caused the problems
some people have found but I have not been able to reconstruct earlier.
I have made a patch for the 2.4.20 kernel to fix these problems. The patch
and more information can be found from
http://www.kolumbus.fi/kai.makisara/st-eot.html
-- 
Kai
