From: Meelis Roos <mroos@linux.ee>
Subject: Re: mptscsi: BUG: unable to handle kernel NULL pointer, in
 scsi_send_eh_cmnd
Date: Tue, 10 Jul 2012 14:54:55 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1207101452270.9883@math.ut.ee>
References: <alpine.SOC.1.00.1207101143030.9883@math.ut.ee> <1341911745.3021.40.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341911745.3021.40.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, support@lsi.com
List-Id: linux-scsi@vger.kernel.org

> > I am using Linux 3.4.0 with a 53c1030 and a tape library that sometimes 
> > barfs for yet unknown reasons. When it happens, I get a BUG with 
> > backtrace and this scsi channel is dead until I reboot. Seems to be 
> > something with either generic scsi error handling or with mpt scsi.
> 
> I think it might actually be fixed by this:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=222a806af830fda34ad1f6bc991cd226916de060

Tested on top on 3.4.0, works - mptscsih is reset successfully, domain 
validation for all scsi devices succeeds, no BUG. Scsi communication 
works.

-- 
Meelis Roos (mroos@linux.ee)
