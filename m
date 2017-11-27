From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.13.12: frequent AACraid crash with a drive
Date: Mon, 27 Nov 2017 07:24:21 -0800
Message-ID: <20171127152421.GA5171@merlins.org>
References: <20171127152147.b4buun2oknt4634i@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37632 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbdK0PYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Nov 2017 10:24:21 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.87 #1)
        id 1eJLGf-0001xu-7J by authid <merlin>
        for <linux-scsi@vger.kernel.org>; Mon, 27 Nov 2017 07:24:21 -0800
Content-Disposition: inline
In-Reply-To: <20171127152147.b4buun2oknt4634i@merlins.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Nov 27, 2017 at 07:21:47AM -0800, Marc MERLIN wrote:
> Crash log:

I should add that sometimes the reset works ok:
aacraid: Host adapter abort request.
aacraid: Outstanding commands on (10,1,0,0):
aacraid: Host adapter reset request. SCSI hang ?
aacraid 0000:02:00.0: outstanding cmd: midlevel-0
aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
aacraid 0000:02:00.0: outstanding cmd: error handler-1
aacraid 0000:02:00.0: outstanding cmd: firmware-0
aacraid 0000:02:00.0: outstanding cmd: kernel-0
aacraid 0000:02:00.0: Controller reset type is 3
aacraid 0000:02:00.0: Issuing IOP reset
aacraid 0000:02:00.0: IOP reset succeded
aacraid: Comm Interface type2 enabled
aacraid 0000:02:00.0: Issuing bus rescan
sd 10:1:0:0: [sdd] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
sd 10:1:0:0: [sdd] tag#0 CDB: ATA command pass through(16) 85 06 20 00 d8 00 00 00 00 00 4f 00 c2 00 b0 00

The drive in question seems ok when I test it directly, but it's hard to tell for sure.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
