From: SL Baur <steve@kbuxd.necst.nec.co.jp>
Subject: Re: Is the scsi-misc-2.5 BK tree corrupted?
Date: Fri, 13 Dec 2002 10:11:05 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15865.13225.842834.163228@sofia.bsd2.kbnes.nec.co.jp>
References: <steve@kbuxd.necst.nec.co.jp>
	<15864.4045.584597.590434@sofia.bsd2.kbnes.nec.co.jp>
	<200212121419.gBCEJWp02105@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgate4.nec.co.jp ([10.7.69.193])
	by TYO201.gate.nec.co.jp (8.11.6/3.7W01080315) with ESMTP id gBD17gw23764
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2002 10:07:42 +0900 (JST)
Received: from mailsv.nec.co.jp (mailgate51.nec.co.jp [10.7.69.190]) by mailgate4.nec.co.jp (8.11.6/3.7W-MAILGATE-NEC) with ESMTP
	id gBD17Sn08175 for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2002 10:07:41 +0900 (JST)
Received: from sv6l.kb.necst.nec.co.jp (ns1.kb.necst.nec.co.jp [10.108.80.236]) by mailsv.nec.co.jp (8.11.6/3.7W-MAILSV-NEC) with ESMTP
	id gBD17Ms05461 for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2002 10:07:27 +0900 (JST)
Received: from mailgw1 (mailgw1.kb.necst.nec.co.jp [172.16.1.207])
	by sv6l.kb.necst.nec.co.jp (8.11.6/8.11.6) with SMTP id gBD17M630281
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2002 10:07:22 +0900 (JST)
	(envelope-from steve@kbuxd.necst.nec.co.jp)
In-Reply-To: <200212121419.gBCEJWp02105@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley writes:

> I have noticed BK do this periodically on other trees (most notably
> the linux ones).  It seems to be related to some type of backup
> program that bkbits runs.  I usually just wait a while and try
> again, which has worked so far.

O.K.  I can live with that.  I did retry it yesterday a couple of
times, maybe I didn't wait long enough.  It works now.  Thanks for the
clue.

