From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Re: aic94xx driver woes continued
Date: Thu, 20 Mar 2008 20:14:47 +0100
Message-ID: <47E2B7A7.20206@ipax.at>
References: <47E2B044.70705@ipax.at> <1206039714.3038.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:55089 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbYCTTOu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 15:14:50 -0400
In-Reply-To: <1206039714.3038.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> This is all normal.  Seagate drives are known for throwing protocol
> errors under stress at certain revs of firmware.  That's what
> REQ_TASK_ABORT, reason=0x6 is.
> 
> Your logs indicate that the recovery occurred correctly (as in all tasks
> were eventually retried), so it doesn't show an actual problem.

ok, i already filed a trouble ticket at seagate - lets see if they
provide a firmware update for the disks. afaik mine is "firmware 0002"

>> sometimes even a disk is kicked out of the raid configuration.
> 
> This would be abnormal, if you have a log of this, could you post it.  I
> assume it was because of I/O errors?

i attached a bigger syslog file (.gz format).

the errors look like:
> syslog.1.gz:Mar 11 06:25:08 db-ipax-164 kernel: raid1: Disk failure on sda1, disabling device. 
> syslog.1.gz:Mar 11 06:25:01 db-ipax-164 kernel: raid10: Disk failure on sda7, disabling device. 
> syslog.1.gz:Mar 10 18:13:25 db-ipax-164 kernel: raid10: Disk failure on sda3, disabling device. 
> syslog.1.gz:Mar 10 18:13:23 db-ipax-164 kernel: raid10: Disk failure on sda9, disabling device. 
> syslog.1.gz:Mar 10 18:13:23 db-ipax-164 kernel: raid10: Disk failure on sda8, disabling device. 
> syslog.1.gz:Mar 10 18:13:23 db-ipax-164 kernel: raid10: Disk failure on sda5, disabling device. 
> syslog.0:Mar 18 18:30:48 db-ipax-164 kernel: raid10: Disk failure on sdd5, disabling device. 
> syslog.0:Mar 18 18:27:18 db-ipax-164 kernel: raid10: Disk failure on sdd8, disabling device. 

i will test the device for itself to see if it has errors.

cheers,
raoul
-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________
