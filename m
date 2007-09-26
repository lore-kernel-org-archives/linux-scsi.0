From: Jeff Garzik <jeff@garzik.org>
Subject: Re: queued patches for SCSI for 2.6.24
Date: Tue, 25 Sep 2007 23:34:00 -0400
Message-ID: <46F9D328.4030801@garzik.org>
References: <1190768402.8707.20.camel@localhost.localdomain> <20070925065233Q.tomof@acm.org> <1190770955.8707.23.camel@localhost.localdomain> <20070925073735U.tomof@acm.org> <46F9C5ED.6050505@garzik.org> <20070926025608.GA3899@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58069 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbXIZDeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 23:34:08 -0400
In-Reply-To: <20070926025608.GA3899@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Matthew Wilcox wrote:
> On Tue, Sep 25, 2007 at 10:37:33PM -0400, Jeff Garzik wrote:
>> Are there any const-ness worries for scsi_host_template, or plans for 
>> the future?  I do not see any other examples of the host template 
>> members getting modified.
> 
> Goodness, Jeff, you haven't looked too hard.  There's dozens of examples
> I've come across trawling the horrible unmaintained drivers.  I'd love
> to see scsi_host_template become const, but it's not happening any time
> soon, and we can address this little piece when the time comes.

Well, sure, the driver is the owner of that memory.

We're talking about common code.

If everybody agrees SHT is R/W in the core, Fujita-san's patch is fine.

	Jeff



