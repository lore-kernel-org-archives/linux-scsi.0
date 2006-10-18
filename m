From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Mid-layer API?
Date: Wed, 18 Oct 2006 13:08:43 -0700
Message-ID: <20061018130843.299361dc.rdunlap@xenotime.net>
References: <861B5CF71BC70C478DFEB9EAFE98F699A86E82@G3W0068.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:41902 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1422663AbWJRUHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 16:07:10 -0400
Received: from midway.site ([71.117.236.95]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 13:07:08 -0700
In-Reply-To: <861B5CF71BC70C478DFEB9EAFE98F699A86E82@G3W0068.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 18 Oct 2006 14:43:09 -0500 Haefliger, Juerg wrote:

> Hi All,
> 
> First, I'm a newbie to SCSI so please forgive me if any of the following
> questions are silly. Having said that, I very much appreciate pointers
> to good SCSI references and the Linux implementaion of the SCSI
> subsystem...
> 
> I have a kernel driver that needs to send SCSI commands and data to a FC
> disk attached to a Qlogic FC HBA. I'm hooking into the SCSI mid-layer by
> calling scsi_do_req(). It seems to work but I'm not sure if this is the
> right way of doing things. Is scsi_do_req the right entry point into the
> mid-layer or should I use something else? Or should I hook into
> something else than the mid-layer? And finally, is there any
> documentation talking about the mid-layer API?
> 
> Any help is greatly appreciated.


I began on a scsi-mid-layer-api.txt file a few years ago.  :(
Sadly I haven't touched it since then.  You can see if it may help
you any:  http://www.xenotime.net/linux/doc/scsi-interfaces.txt

It's just text from scsi .h and .c files.

You can also see if this other *also outdated* SCSI driver doc
helps you any:  (get pdf or OpenOffice files from
http://developer.osdl.org/dev/opendrivers/wiki/index.php/Storage )


Feel free to update/correct either of them.  :)

---
~Randy
