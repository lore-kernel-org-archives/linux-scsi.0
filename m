From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76241] New: USB Device Not Recognised
Date: Thu, 15 May 2014 02:46:47 +0000
Message-ID: <bug-76241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50727 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaEOCqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2014 22:46:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AA28C201F5
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2014 02:46:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 01EDA2035D
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2014 02:46:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D76241

            Bug ID: 76241
           Summary: USB Device Not Recognised
           Product: IO/Storage
           Version: 2.5
    Kernel Version: linux-2.6.37
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: zhouqikevin61@gmail.com
        Regression: No

Created attachment 136131
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D136131&action=3De=
dit
Errorhappen

USB Device connected by USB Hub cannot be Recognised
it seems like the Inquiry command failed and the USB device reset a lot
Something wrong with the DMA transmit=EF=BC=9F need help ~~~

Notice=EF=BC=9AThe odds of this happening are quite low=EF=BC=8CMost of=
 the time the usb device
work well=E3=80=82=20

[   31.642735] scsi_probe_and_add_lun: scsi_alloc_sdev end=20
[   31.659215] scsi_execute: req->cmd=3D18, 0, 0, 0, 36, 0
[   31.674883] blk_execute_rq:wait_for_completion start
[   52.771720] cppi41_channel_abort: DMA busy,status=3D2
[   52.786768] cppi41_get_teardown_info: dma_num =3D=3D cppi41_num_dma_=
block
[   52.806614] usb_check_teardown:not a teardown descriptor
[   52.822985] usb_tx_ch_teardown 1047: Invalid PD(9f069000)popped from=
 TearDn
completionqueue
[   52.848875] usb_stor_invoke_transport: command was aborted
[   52.981830] usb 1-1: reset high speed USB device using musb-hdrc and=
 address
2
[   53.142833] scsi command aborted result=3D0x50000
[   63.152043] cppi41_channel_abort: DMA busy,status=3D2
[   63.167097] cppi41_get_teardown_info: dma_num =3D=3D cppi41_num_dma_=
block
[   63.186946] usb_check_teardown:not a teardown descriptor
[   63.203315] usb_tx_ch_teardown 1047: Invalid PD(9f069000)popped from=
 TearDn
completionqueue
[   63.229272] usb_stor_invoke_transport: command was aborted
[   63.361852] usb 1-1: reset high speed USB device using musb-hdrc and=
 address
2
[   63.522612] scsi command aborted result=3D0x50000
[   79.531713] cppi41_channel_abort: DMA busy,status=3D2
[   79.546765] cppi41_get_teardown_info: dma_num =3D=3D cppi41_num_dma_=
block
[   79.566620] usb_check_teardown:not a teardown descriptor
[   79.582988] usb_tx_ch_teardown 1047: Invalid PD(9f069040)popped from=
 TearDn
completionqueue
[   79.608877] usb_stor_invoke_transport: command was aborted
[   79.741853] usb 1-1: reset high speed USB device using musb-hdrc and=
 address
2
[   79.902536] scsi command aborted result=3D0x50000
[   80.031854] usb 1-1: reset high speed USB device using musb-hdrc and=
 address
2
[   90.191974] cppi41_channel_abort: DMA busy,status=3D2
[   90.207022] cppi41_get_teardown_info: dma_num =3D=3D cppi41_num_dma_=
block
[   90.226871] usb_check_teardown:not a teardown descriptor
[   90.243243] usb_tx_ch_teardown 1047: Invalid PD(9f069040)popped from=
 TearDn
completionqueue
[   90.269170] usb_stor_invoke_transport: command was aborted
[   90.401706] usb 1-1: reset high speed USB device using musb-hdrc and=
 address
2
[   90.562603] scsi command aborted result=3D0x50000
[   90.578826] scsi 0:0:0:0: Device offlined - not ready after error re=
covery
[   90.600292] blk_execute_rq:wait_for_completion end
[   90.615120] scsi_probe_lun: scsi_execute_req failed with code 0x5000=
0
[   90.634999] scsi_probe_lun return -EIO=20
[   90.646823] scsi_probe_and_add_lun: scsi_probe_lun failed

--=20
You are receiving this mail because:
You are the assignee for the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
