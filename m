From: Douglas Gilbert <dougg@torque.net>
Subject: 2.5.48 /proc/scsi directory missing
Date: Tue, 19 Nov 2002 10:45:25 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD97B95.9040908@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-12.triode.net.au [202.147.125.12])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gAINjg100406
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2002 10:45:42 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

That directory (and all who sail in her, e.g. /proc/scsi/scsi)
seems to have disappeared. When the scsi_debug module is
loaded a /proc/scsi_debug/0 entry appears (that used to be
/proc/scsi/scsi_debug/0).

Doug Gilbert

