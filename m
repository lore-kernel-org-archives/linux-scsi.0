From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and
	scsi_eh_flush_done_q()
Date: Tue, 24 Jan 2006 18:20:50 +0100
Message-ID: <1138123250.2977.49.camel@laptopd505.fenrus.org>
References: <20060124171117.61067.qmail@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3764 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030447AbWAXRVB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 12:21:01 -0500
In-Reply-To: <20060124171117.61067.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, jgarzik@pobox.com

On Tue, 2006-01-24 at 09:11 -0800, Luben Tuikov wrote:

> So when scsi_finish_command() is unexported, then _all_ EH strategies
> would have to define local done_q, and splice eh_cmd_q into local work_q,
> then from local work_q into local done_q and then that is passed
> to SCSI Core, via scsi_eh_flush_done_q().


custom error handling was supposed to have gone away already, but then
libata came around for now... (until that moves to be a block driver),
so.. I don't see the problem really.


