From: devnetfs <devnetfs@yahoo.com>
Subject: scsi bus-reset in qlogic causes system stall
Date: Fri, 17 Jan 2003 10:20:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030117182013.22919.qmail@web20422.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am running RedHat 2.4.9-13 with qlogic qla2x00 driver (ver 4.31.7b).
Trying to do a bus-reset (in an multi-initiator, shared-scsi scenario)
stalls one (or more) nodes in the system for a while. dmesg shows the
message: "Waiting for LIP to complete...", on all nodes. Everything
freezes for a while (around 10-40secs). It happens on UP/SMP both.

Is this normal? or a bug in qlogic driver? 

Thanks in advance for any insight,
A.


__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
