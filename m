From: Anders Henke <anders.henke@1und1.de>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in directory) (fwd)
Date: Wed, 12 Dec 2007 11:58:41 +0100
Message-ID: <20071212105841.GN6770@1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxintern.schlund.de ([212.227.126.201]:61535 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbXLLLAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 06:00:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: miquels@cistron.nl, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, matthew@wil.cx, akpm@linux-foundation.org

Hi,

I'd like to let you now that my boxes are running a 32-bit kernel, so
the 64-bit-uncleanliness shouldn't apply to my boxes; however,

http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch

fixed the issue on my testbox.

I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.



Regards,

Anders

PS: Sorry for breaking the threading, I'm not a regular subscriber to
linux-kernel and haven't received Miguel's message by mail.
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren
