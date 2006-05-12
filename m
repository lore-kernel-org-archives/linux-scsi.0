From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Symbios-NCR 6285-3621 + Adaptec 2944W multilun problem
Date: Fri, 12 May 2006 10:09:56 -0500
Message-ID: <1147446596.3769.25.camel@mulgrave.il.steeleye.com>
References: <44648D9C.2090602@cooperativaobrera.com.ar>
	 <1147442986.3769.2.camel@mulgrave.il.steeleye.com>
	 <44649CE5.7070604@cooperativaobrera.com.ar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20907 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932114AbWELPKE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 11:10:04 -0400
In-Reply-To: <44649CE5.7070604@cooperativaobrera.com.ar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Gomiz <gomita@cooperativaobrera.com.ar>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-05-12 at 11:34 -0300, Gabriel Gomiz wrote:
> I'm attaching dmesg output. I'm sorry I forgot to attach it in the
> last 
> email. The I/O errors occur when the devices are being detected and 
> whenever I try to access them. For example to do 'fsidk -l /dev/sdc'.

Well, what I was hoping for was mode sense messages but, unfortunately,
there aren't any.  My suspicion is that the 6285 is dual controller
running in RDAC mode and you're attached to the inactive controller (in
that configuration it allowed INQUIRY and MODE SENSE through but errors
out on all other I/O operations).  I think you can verify by physically
removing one of the controllers and rebooting the array (or just attach
the SCSI cable to the other controller)

James


