From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Max IO size
Date: Wed, 31 Jul 2002 17:22:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020801002238.88172.qmail@web14001.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!
Couple of other questions..forgot to ask in the
previous email!

1) When we do 512 byte sequential reads, the mid
level( or someone else) seems to be combining the
requests and sending them down as one big 60k+
request. Can this combining of requests be disabled
somehow?
2) If we do 512k IOs, the mid layer seems to be
breaking it up into 64 k chunks. The Scatter gather
size is set to 240, so there is no reason for it to
break it up. Is there something I am missing? Or is
there a tunable I can set to increase the IO size sent
down to the low level driver?
3) What exactly does the max_sectors in the host
structure do?

Sorry for the long list! I would really appreciate any
response!

Thanks
M


__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com
