From: SL Baur <steve@kbuxd.necst.nec.co.jp>
Subject: aic7xxx driver in 2.5.44 is older than 2.4.20pre11 (and doesn't work)
Date: Wed, 23 Oct 2002 11:51:57 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15798.3789.10763.181120@sofia.bsd2.kbnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgate4.nec.co.jp ([10.7.69.197])
	by TYO201.gate.nec.co.jp (8.11.6/3.7W01080315) with ESMTP id g9N2mxl24541
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2002 11:48:59 +0900 (JST)
Received: from mailsv4.nec.co.jp (mailgate51.nec.co.jp [10.7.69.196]) by mailgate4.nec.co.jp (8.11.6/3.7W-MAILGATE-NEC) with ESMTP
	id g9N2mx808489 for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2002 11:48:59 +0900 (JST)
Received: from sv6l.kb.necst.nec.co.jp (ns1.kb.necst.nec.co.jp [10.108.80.236]) by mailsv4.nec.co.jp (8.11.6/3.7W-MAILSV4-NEC) with ESMTP
	id g9N2mv216336 for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2002 11:48:57 +0900 (JST)
Received: from mailgw1 (mailgw1.kb.necst.nec.co.jp [172.16.1.207])
	by sv6l.kb.necst.nec.co.jp (8.11.6/8.11.6) with SMTP id g9N2mv005246
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2002 11:48:57 +0900 (JST)
	(envelope-from steve@kbuxd.necst.nec.co.jp)
Received: from ews-sv.kbuxd.necst.nec.co.jp (ews-sv.kbuxd.necst.nec.co.jp [172.16.28.93])
	by sv1.kbuxd.necst.nec.co.jp (8.11.6/3.7W) with ESMTP id g9N2mv195617
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2002 11:48:57 +0900 (JST)
Received: from sofia.bsd2.kbnes.nec.co.jp ([172.16.28.191])
	by ews-sv.kbuxd.necst.nec.co.jp (8.9.3/3.7W-02090510) with ESMTP id LAA20567
	for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2002 11:48:56 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have been unable to boot 2.5.44 because it does not see my disk
controller (output is from vanilla 2.4.20pre11, which works fine).

scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

I notice that the driver version in 2.5.44 is 6.2.5 and the one in
2.4.20pre11 is 6.2.8.  Are there patches around to update the 2.5
aic7xxx driver to the working version?

