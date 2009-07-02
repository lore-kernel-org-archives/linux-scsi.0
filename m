From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Linux-2.6.31-rc1-git9 Cannot Recognize Empty DVD Media
Date: Thu, 2 Jul 2009 13:07:28 -0700
Message-ID: <20090702130728.22af524c.akpm@linux-foundation.org>
References: <4A4CB4B4.5010307@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534AbZGBUIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 16:08:17 -0400
In-Reply-To: <4A4CB4B4.5010307@turknet.net.tr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

(cc linux-scsi)

On Thu, 02 Jul 2009 16:23:00 +0300
Tarkan Erimer <tarkan.erimer@turknet.net.tr> wrote:

> Hi,
> 
> I just compiled 2.6.31-rc1-git9 to give it a try. The problem I 
> encountered with this release is that it cannot recognize empty DVD 
> (probably CD will be the same. But, I didn't try it.) media with K3b. 
> I'm having the below error messages in dmesg. Also, I tried with several 
> new empty DVD medias. So, I'm sure that it's not a faulty DVD media. The 
> same media burns fine with K3b under <= 2.6.31-rc1-git6.
> 
> 
> [ 4526.724245] cdrom: This disc doesn't have any tracks I recognize!
> [ 4526.748278] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
> driverbyte=DRIVER_SENSE
> [ 4526.748285] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
> [ 4526.748292] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
> [ 4526.748300] end_request: I/O error, dev sr0, sector 0
> [ 4526.748307] Buffer I/O error on device sr0, logical block 0
> [ 4526.750295] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
> driverbyte=DRIVER_SENSE
> [ 4526.750302] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
> [ 4526.750308] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
> [ 4526.750316] end_request: I/O error, dev sr0, sector 0
> [ 4526.750321] Buffer I/O error on device sr0, logical block 0
> [ 4586.738212] cdrom: This disc doesn't have any tracks I recognize!
> [ 4586.753644] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
> driverbyte=DRIVER_SENSE
> [ 4586.753652] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
> [ 4586.753659] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
> [ 4586.753668] end_request: I/O error, dev sr0, sector 0
> [ 4586.753673] Buffer I/O error on device sr0, logical block 0
> [ 4586.757373] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK 
> driverbyte=DRIVER_SENSE
> [ 4586.757379] sr 0:0:0:0: [sr0] Sense Key : Illegal Request [current]
> [ 4586.757384] sr 0:0:0:0: [sr0] Add. Sense: Illegal mode for this track
> [ 4586.757391] end_request: I/O error, dev sr0, sector 0
> [ 4586.757395] Buffer I/O error on device sr0, logical block 0

There are no recent changes to cdrom.c.  Maybe it's due to a scsi change?
