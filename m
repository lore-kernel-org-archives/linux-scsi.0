From: Christoph Hellwig <hch@infradead.org>
Subject: Re: qla2300 read buffer problems
Date: Tue, 12 Jul 2005 16:01:23 +0100
Message-ID: <20050712150123.GA5524@infradead.org>
References: <24233.1121179331@www63.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19642 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261530AbVGLPBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 11:01:25 -0400
Content-Disposition: inline
In-Reply-To: <24233.1121179331@www63.gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rother-ml@gmx.de
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 12, 2005 at 04:42:11PM +0200, rother-ml@gmx.de wrote:
> Hi all,
> 
> we are encountering SAN problems. Twice or threetimes a minute we can
> neither read nor write for up to five seconds from/to our LUs. After that
> short periode, it catches up and resumes normally. The diagnostics in
> SANsurfer (Read/Write Buffer Test) runs a few times successfully (approx.
> 8-10 times) and then tells us about a problem with the buffer cache: 
> Info: DiagRWBufferTest:  Unable to send Pass-Thru READ_DATA_BUFF on target
> (50-06-0e-80-00-c2-8a-03) (0x20000040) (SCSI check condition)
> Info: DiagRWBufferTest: Sense Key:  0xe, asc:  0x1d, ascq:  0x0.
> 
> The numbers of "Link Failure", "Sync Loss" and "Signal Loss" are also
> increasing.
> 
> After compiling the modules with almost every debug option the syslogd
> notices the following lines:
> qla2x00_scsi_passthru(18): entered.

These traces are not from the in-kernel qla2xxx driver.  Either use the
proper driver or complain to qlogic tech support.

