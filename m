From: Andries.Brouwer@cwi.nl
Subject: Re: [linux-usb-devel] USB storage problems (2.5.69 BK)
Date: Tue, 27 May 2003 01:02:25 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200305262302.h4QN2PF04675.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:45483 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S262358AbTEZWt3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2003 18:49:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: jochen@scram.de, linux-usb-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

    under 2.5.68 and current 2.5.69 BK, my card reader doesn't work. Under
    2.4.20, i have no such problems. Log with verbose usb-storage debug
    attached.

    --jochen

    Content-Type: APPLICATION/octet-stream; name="usb.log.gz"

(i) attachment - yuk
(ii) gzipped - yuk - plain text allows grep, Google, etc.
(iii) maybe your device wants to return more bytes than 4;
      the error is -EOVERFLOW, that is, "babble".
      I expect my recent patch would help.
      (have no time to dig it up, and will be away the coming days;
       basically I think things are under control, we just need to
       push these scsi changes, and then these usb changes)

Andries
