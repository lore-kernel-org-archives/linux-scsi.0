From: Jason Harrop <jharrop@speedlegal.com>
Subject: Dell/Adaptec PERC3/Di crashes, even with kernel 2.4.25 and aacraid
 1.1.5
Date: Mon, 12 Apr 2004 14:47:52 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <407A1F78.7040603@speedlegal.com>
References: <407755DB.8000800@speedlegal.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.xn.com.au ([203.89.254.34]:54463 "HELO ns.xn.com.au")
	by vger.kernel.org with SMTP id S262754AbUDLExJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2004 00:53:09 -0400
In-Reply-To: <407755DB.8000800@speedlegal.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-poweredge@dell.com

Crashed again :(

It seems that the problem occurs when the cron daily jobs run.  It looks 
like the system survived the cron daily job on April 11, but not April 12.

Its only since i upgraded to kernel 2.4.25 and aacraid 1.1.5 that i've 
started to get anything like this in the logs.

Apr 11 04:02:01 promo syslogd 1.4.1: restart.
Apr 12 04:03:02 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 12 04:04:02 promo kernel: aacraid: SCSI bus appears hung
Apr 12 04:04:12 promo kernel: scsi: device set offline - command error 
recover failed: host 0 channel 0 id 0 lun 0
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185272
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185288
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185304
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185320
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20447272

# ls /etc/cron.daily/
00-logwatch  0anacron  inn-cron-expire  logrotate  makewhatis.cron  rpm 
  slocate.cron  tmpwatch



Any ideas what I should try next?

thanks,

Jason





Jason Harrop wrote:
> Dell 2650 BIOS A15
> PERC3/Di firmware 3170
> ext3 filesystem
> 
> It crashed less than 2 days after rebooting, which is less uptime than 
> with RedHat kernel 2.4.18-14smp
> 
> See below for contents of log.
> 
> cheers,
> 
> Jason
> 
> --------------
> 
> Apr 10 04:03:51 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:04:51 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:05:01 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:06:01 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:06:11 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:07:11 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:07:21 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:08:21 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:08:31 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:09:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:09:41 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:10:41 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:10:51 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> :
> Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request. SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:15:31 promo kernel: scsi: device set offline - command error 
> recover failed: host 0 channel 0 id 0 lun 0
> Apr 10 04:15:31 promo kernel: SCSI disk error : host 0 channel 0 id 0 
> lun 0 return code = 6000000
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 11014520
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 12058624
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 12058856
> :
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 39846008
> Apr 10 04:15:31 promo kernel:  I/O errev 08:03, sector 262368
> :
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 19398840
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 19398856
> Apr 10 04:15:31 promo kernel:  I/O error: dev 0 sector 9464
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 74856
> 
> 

