From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: 10 Jan 2004 15:43:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073767436.1945.60.camel@mulgrave>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
	<1073698638.2026.3.camel@opiate>
	<6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
	<1073716698.2026.18.camel@opiate>  <1073747000.1945.5.camel@mulgrave>
	<1073761884.6434.12.camel@opiate>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:64428 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265394AbUAJUn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 15:43:59 -0500
In-Reply-To: <1073761884.6434.12.camel@opiate>
List-Id: linux-scsi@vger.kernel.org
To: Eric Kerin <eric@bootseg.com>
Cc: "Larry W. Finger" <Larry.Finger@lwfinger.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-01-10 at 14:11, Eric Kerin wrote:
> Yes, I agree the best place to put that block of code would have been
> aha152x_stub.c, but I couldn't find an existing way to reference the
> driver template from that file. The "s" struct is a aha152x_setup, not a
> aha152x_driver_template. That's why I put it in aha152x.c with an ifdef
> 
> I could setup aha152x_driver_template as an extern, but since I'm still
> somewhat new around here, wasn't sure if that was a good way to handle
> it.  If an extern is fine with you, I'll code it up that way. Although
> in that case, it would be best to put the INIT_LIST_HEAD in module_init.
> That's where it would normally be done, and we would have a reference at
> that point.

Yes, I see the problem, that's what I get for suggesting something
without trying it.

However, could you try Juergen Fischer's patch, please...that's really
done the way I wanted.

James


