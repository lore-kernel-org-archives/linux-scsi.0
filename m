From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Mon, 06 Oct 2014 13:16:49 +0200
Message-ID: <54327A21.6070202@acm.org>
References: <541C27BF.6070609@acm.org> <541C28E0.7010705@acm.org> <CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com> <541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com> <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk> <542C270B.5020002@acm.org> <542C31C4.1020702@kernel.dk> <542D8143.3050305@acm.org> <20141002173044.GB25437@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:33775 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaJFLQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2014 07:16:58 -0400
In-Reply-To: <20141002173044.GB25437@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Robert Elliott <Elliott@hp.com>, Roland Dreier <roland@kernel.org>

On 10/02/14 19:30, Christoph Hellwig wrote:
> Also if we want to merge scsi LLDDs that can take advantage of
> multiqueue support it would probably be best if I take this via the SCSI
> tree.

Sending these patches to you is fine with me, at least if Roland agrees.

Bart.


