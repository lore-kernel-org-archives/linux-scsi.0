From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Help - looking for a Linux SCSI testing utility
Date: Tue, 25 May 2004 17:01:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040525150136.GB13547@harddisk-recovery.com>
References: <519672568F040C41B6FAC21ADF51B18FF8E4@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from users.linvision.com ([62.58.92.114]:14483 "HELO bitwizard.nl")
	by vger.kernel.org with SMTP id S264912AbUEYPBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2004 11:01:37 -0400
Content-Disposition: inline
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FF8E4@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 25, 2004 at 09:42:38AM -0500, Lee Xing wrote:
> When we were working on Windows platform, we had a couple of tools
> that can issue selected SCSI command(s) to selected device(s).  Is
> there a similar tool for Linux?  It would be great if we can use it
> to send different SCSI command(s) to selected sd/sg device(s).

You mean scsi generic devices? See for example:
http://tldp.org/HOWTO/SCSI-Generic-HOWTO/


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
