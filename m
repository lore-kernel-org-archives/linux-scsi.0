From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Help - looking for a Linux SCSI testing utility
Date: Tue, 25 May 2004 08:08:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040525080852.2e444c47.rddunlap@osdl.org>
References: <1F6D1D1660975A4887628A011443A1BC0305E3C1@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:40380 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264851AbUEYPTj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2004 11:19:39 -0400
In-Reply-To: <1F6D1D1660975A4887628A011443A1BC0305E3C1@uswaumsx13medge.med.ge.com>
List-Id: linux-scsi@vger.kernel.org
To: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Cc: lxing@Crossroads.com, linux-scsi@vger.kernel.org

On Tue, 25 May 2004 09:56:19 -0500 Edwards, Scott (MED, Kelly IT Resouces) wrote:

| 
| I have been trying to find a way to send a write cache command to a scsi
| drive.  I found the sg_utils which I haven't gotten to send a write
| cache command, but they might do what you want.
| 
| http://www.torque.net/sg

Others to consider/try:

http://members.aol.com/plscsi/linux/plscsi.tar.gz

http://www.bit-net.com/~rmiller/scu.html  (binary only)


| -Scott
| 
| 
| -----Original Message-----
| From: linux-scsi-owner@vger.kernel.org
| [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Lee Xing
| Sent: Tuesday, May 25, 2004 8:43 AM
| To: linux-scsi@vger.kernel.org
| Subject: Help - looking for a Linux SCSI testing utility
| 
| 
| Hi,
| 
| When we were working on Windows platform, we had a couple of tools that
| can issue selected SCSI command(s) to selected device(s).  Is there a
| similar tool for Linux?  It would be great if we can use it to send
| different SCSI command(s) to selected sd/sg device(s).
| 
| Thanks,
| 
| 
| Lee 


--
~Randy
