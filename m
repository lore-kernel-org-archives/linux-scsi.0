From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 17:48:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408250048.i7P0mcsg019531@bach.leonora.org>
References: <20040824221258.GD16196@parcelfarce.linux.theplanet.co.uk>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:56307
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S269043AbUHYAsr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 20:48:47 -0400
In-Reply-To: Your message of "Tue, 24 Aug 2004 23:12:58 BST."
             <20040824221258.GD16196@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Wouldn't you know! Just as I was reading your email, my system frozen.
Then it froze twice again just after rebooting. Most unusal. "Normally" my
system hangs only at night, and it's never hung so many times in a row.
Maybe it's time for memtest...

>>>>> "mw" == Matthew Wilcox <willy@debian.org> writes:

    mw> sym2 has always displayed these messages at boot:
    mw> 
    mw>    kernel: sym0: handling phase mismatch from SCRIPTS.
    mw>    kernel: sym0: SCSI BUS has been reset.
    mw> 
    mw> The first one means "If there is a phase mismatch, we'll handle it in
    mw> the SCRIPTS rather than in the driver".  The second one is a normal part
    mw> of bringup.  Now, I'm all in favour of reducing driver verbosity at boot,
    mw> but I'm not sure I can delete either of those messages at this stage.
    mw> It's certainly something I want to look at doing.

OK. A possible rephrasing:

   kernel: sym0: handling phase mismatches in SCRIPTS.
   kernel: sym0: normal SCSI BUS reset.

    >> kernel: sym0:6: ERROR (81:0) (8-0-0) (3e/18/80) @ (scripta 38:f31c0004).
    >> kernel: sym0: script cmd = e21c0004
    >> kernel: sym0: regdump: da 00 00 18 47 3e 06 0f 04 08 86 00 80 00 0f 0a 72 cf 0c 00 02 00 00 00.
    >> kernel: sym0: SCSI BUS reset detected.
    >> kernel: sym0: enabling clock multiplier
    >> kernel: sym0: Downloading SCSI SCRIPTS.
    >> kernel: sym0: SCSI BUS has been reset.
    >> kernel: sym0: command processing suspended for 3 seconds
    >> kernel: sym0: command processing resumed

    mw> umm.  The third one looks like it needs some investigation
    mw> though.

(In my last email, I meant to say that "script cmd = 90080000" also
causes these errors.)

Is there any way I can help with an investigation? I'd *really* like to
solve these problems. It's been two years...

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
