From: michael@freenet-ag.de
Subject: Question on drivers/scsi/scsi_error.c
Date: 21 May 2002 14:31:14 -0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020521143114.21069.qmail@nostromo.freenet-ag.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [194.97.50.144] (helo=mx1.freenet.de)
	by mout1.freenet.de with esmtp (Exim 4.04)
	id 17AAfS-00026l-00
	for linux-scsi@vger.kernel.org; Tue, 21 May 2002 16:31:14 +0200
Received: from nostromo.freenet-ag.de ([194.97.7.6])
	by mx1.freenet.de with smtp (Exim 3.36 #1)
	id 17AAfS-0002Vo-00
	for linux-scsi@vger.kernel.org; Tue, 21 May 2002 16:31:14 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

why does scsi_check_sense return SUCCESS on e.g. HARDWARE_ERRORs?

        case ILLEGAL_REQUEST:
        case BLANK_CHECK:
        case DATA_PROTECT:
        case HARDWARE_ERROR:
        default:
                return SUCCESS;

I think that those errors should return FAILED, but I may overlook
something.  Please send Cc: to me, as I am not subscribed to the list.

Michael
