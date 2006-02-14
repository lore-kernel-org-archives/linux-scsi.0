From: "T.Krishnanand" <krishnanand.thommandra@gmail.com>
Subject: question on TMF for ISP2432 (linux 2.6.x driver ver 8.01.01)
Date: Tue, 14 Feb 2006 15:05:11 +0530
Message-ID: <2bd90fb70602140135t572cfcd5x51b0c250af50bca1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.203]:52979 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030529AbWBNJfN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 04:35:13 -0500
Received: by zproxy.gmail.com with SMTP id r28so1241270nza
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2006 01:35:12 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

Andrew,

Does ISP2432 support ABORT_TASK_SET and CLEAR_TASK_SET TMFs ?

I understand that Linux SCSI EH strategy doesnt make use of these TMFs
so QLA2xxx driver doesn't have code related to these.

But If I want to extend the QLA driver to support these TMFs using
following mailbox commands:

MBC_ABORT_TASK_SET
MBC_CLEAR_TASK_SET

so that I can invoke them thru some IOCTL based appln...

a) would ISP 2432 firmware/asic support these TMFs ? Are there any
known gotchas that one should be careful about while implementing
these?

b) While coding the handler for these TMFs which existing EH routine
would u recommend to be used as template/reference ?

c) Since current/latest driver doesnt have any code for these TMFs,
what is the exact mailbox command format for these TMFs ?

thanks,
tkrishna
