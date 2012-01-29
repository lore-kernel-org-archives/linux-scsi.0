From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [LSF/MM TOPIC] [ATTEND] qla2xxx FC target mode
Date: Sat, 28 Jan 2012 16:27:49 -0800
Message-ID: <1327796869.18763.211.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
Cc: Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <mail@hannes-reinecke.de>
List-Id: linux-scsi@vger.kernel.org

Hello,

Given the interest getting the Qlogic FC Target driver merged into
mainline during the v3.4 -> v3.5 time frame, I would like to propose a
LSF storage track discussion for some of the longer term items wrt
qla2xxx target mode that are stretching across SCSI + target subsystems.

We would like to eventually support mixed SCSI initiator / target mode
on a per HW port context basis.  Before that can happen in mainline some
of the interaction between SCSI core and target core will need to be
sorted out..

This includes:

- I -> T transition between active initiator mode LLD LUNs 
  + active TCM ports in same LLD
- T -> I transition + rescan of ports without having to restart SCSI LLD
- mixed mode running on the same physical/virtual port
- target core dependencies in SCSI core to make this work..?

More background is available in the RFC-v4 posting here:
http://www.spinics.net/lists/target-devel/msg01424.html

Thanks!

--nab
