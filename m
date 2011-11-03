From: KY Srinivasan <kys@microsoft.com>
Subject: RE: scsi scan
Date: Thu, 3 Nov 2011 22:52:20 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA6501D@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1320352142-30592-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailc.microsoft.com ([131.107.115.214]:15887 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1KCWwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 18:52:21 -0400
In-Reply-To: <1320352142-30592-1-git-send-email-kys@microsoft.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, hch@i


> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Thursday, November 03, 2011 4:29 PM
> To: linux-scsi@vger.kernel.org; james.bottomley@hansenpartnership.com;
> hch@infradead.org; KY Srinivasan
> Subject: scsi scan
> 
> James,
> 
> On the Windows host they allow hot add/remove of block devices attached to
> the scsi controller(s) assigned to the guest.
> So, when a hot add/remove event occurs, the host sends a message to the guest
> that something has changed on the hba and
> the guest is responsible for figuring out what has changed: a) Setup state to
> manage new devices that may have been added
> and b) get rid of devices that may have been removed. As I look at implementing
> this functionality for Linux guests,
> I would need to be able to do a scan on the hba under question and deal only
> with whatever has changed.
> Is this something that the scsi core supports or would I need to roll out a version
> of scan that would ignore
> devices already scanned (except for the remove case) and properly add new
> devices that may be found.
> Any guidance here would be greatly appreciated.

I see that the re-scan is correctly done through sysfs by writing
the string "- - -" to the scan file under /sys/class/scsi_host/*/scan.

Regards,

K. Y

