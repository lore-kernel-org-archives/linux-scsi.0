From: Douglas Gilbert <dougg@torque.net>
Subject: extracting resid from struct scsi_cmnd
Date: Sun, 28 Nov 2004 12:02:07 +1000
Message-ID: <41A9319F.9070206@torque.net>
References: <20041127124222.GA1200@abulafia> <20041127154849.GA24460@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:3489 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261386AbUK1CCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Nov 2004 21:02:14 -0500
In-Reply-To: <20041127154849.GA24460@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens,
While on the subject of extracting info from struct scsi_cmnd
I have noticed that scsi_cmnd::resid doesn't make it into
sg_io_hdr::resid in the block layer SG_IO implementation.
"rq->data_len" is put there instead and it invariably has a
value of 0.

"struct request" does not have a 'resid' field which is defined
as the number of bytes requested to be transferred less the actual
number transferred.

Doug Gilbert
