From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: syslog message
Date: Mon, 30 Aug 2004 10:07:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408301707.i7UH7DPb008233@bach.leonora.org>
References: <41333352.9060303@us.ibm.com>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:55025
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S268580AbUH3RHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 13:07:15 -0400
Received: from bach.leonora.org (localhost.localdomain [127.0.0.1])
	by bach.leonora.org (8.12.11/8.12.11) with ESMTP id i7UH7E3i008236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 10:07:14 -0700
Received: from bach.leonora.org (vladimir@localhost)
	by bach.leonora.org (8.12.11/8.12.11/Submit) with ESMTP id i7UH7DPb008233
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 10:07:14 -0700
In-Reply-To: Your message of "Mon, 30 Aug 2004 09:01:54 CDT."
             <41333352.9060303@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This
kernel: Badness in sym_complete_error at drivers/scsi/sym53c8xx_2/sym_hipd.c:5513
kernel:  [<82886a76>] sym_complete_error+0x96/0x233 [sym53c8xx]
kernel:  [<8288021f>] sym53c8xx_intr+0x59/0xc5 [sym53c8xx]
kernel:  [<021073f1>] handle_IRQ_event+0x21/0x43
kernel:  [<02107884>] do_IRQ+0x15f/0x22e
kernel:  =======================
kernel:  [<021168b6>] smp_apic_timer_interrupt+0x122/0x127
kernel:  [<02104018>] default_idle+0x0/0x2c
kernel:  [<022d007b>] unix_stream_data_wait+0x28/0x10c
kernel:  [<02104041>] default_idle+0x29/0x2c
kernel:  [<0210409d>] cpu_idle+0x26/0x3b
kernel:  [<0238d78c>] start_kernel+0x1d0/0x1d5


--- Vladimir

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
