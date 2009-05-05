From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/scsi/st.c:2967: warning: suggest parentheses around operand
	of '!' or change '|' to '||' or '!' to '~'
Date: Tue, 5 May 2009 09:51:38 +0200
Message-ID: <10f740e80905050051q37524c4dv5d33b501b704b3b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:35913 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZEEHvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 03:51:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

drivers/scsi/st.c:2967: warning: suggest parentheses around operand of
'!' or change '|' to '||' or '!' to '~'

        if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
            !(STp->use_pf & PF_TESTED)) {
                /* Try the other possible state of Page Format if not
                   already tried */
                STp->use_pf = !STp->use_pf | PF_TESTED;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                st_release_request(SRpnt);
                SRpnt = NULL;
                return st_int_ioctl(STp, cmd_in, arg);
        }

Looks indeed incorrect to me...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
