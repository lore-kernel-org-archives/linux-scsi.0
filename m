From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] fix parallel builds for aic7xxx
Date: Sat, 16 Aug 2003 16:36:45 +1000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F3DD0FD.9060705@torque.net>
References: <1060906080.4753.92.camel@cherrytest.pdx.osdl.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1060906080.4753.92.camel@cherrytest.pdx.osdl.net>
To: John Cherry <cherry@osdl.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

While on the subject of aic7xxx Makefiles, they add the
"-Werror" flag to CFLAGS in both lk 2.4.22-rc2 and
lk 2.6.0-test3 .

This flag can be annoying if there is some messiness in
include files somewhere. In my case some mis-applied patches
in the ide headers cause otherwise harmless compiler warning.
That is until my kernel build tries to build the aic7xxx driver.

As a side note drivers/scsi/aic7xxx/Makefile seems to be the only
Makefile in lk 2.4.22-rc2 adding the "-Werror" flag. About a
dozen Makefiles add it in lk 2.6.0-test3 (mainly in the alpha
and sparc64 architecture trees).

Doug Gilbert
