From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Mon, 31 Jul 2006 13:46:05 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607311344470.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <1154194239.9447.89.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291045540.4168@g5.osdl.org> <m3y7ubqdwg.fsf@zoo.weinigel.se>
 <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org> <m3u04yr5s5.fsf@zoo.weinigel.se>
 <Pine.LNX.4.64.0607311328541.4168@g5.osdl.org> <20060731204109.GB31908@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6888 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030237AbWGaUqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 16:46:18 -0400
In-Reply-To: <20060731204109.GB31908@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christer Weinigel <christer@weinigel.se>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Mon, 31 Jul 2006, Jens Axboe wrote:
> 
> There are, however, new uses of vendor specific commands that you need
> access to for fully utilizing your drive. As mentioned, Plextor is one
> of these. And they do make current and very good burners, yet we cannot
> add their opcodes to the table because they (sanely) used the vendor
> specific range for that.

However, before we do that, can somebody actially just FIX that stupid 
cdrecord bug. It shouldn't say it can't write the drive, if it's just that 
it's not allowed to use one of the vendor-specific extensions.

As mentioned, I bet burning _does_ actually work.

		Linus
