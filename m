From: Domen Puncer <domen@coderock.org>
Subject: [PATCH 0/15] decrapify FlashPoint
Date: Fri, 15 Jul 2005 00:17:45 +0200
Message-ID: <20050714221745.GA2466@homer.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:24225 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S262551AbVGNWRv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 18:17:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnz@dandelion.com
Cc: linux-scsi@vger.kernel.org, adobriyan@gmail.com

Hi.

I'm not going to send these patches to mailing list, as they are
cca. 600k in size. If someone really wants them in their mailbox
just drop me a mail.

Tarball [100k] of them is at:
wget http://coderock.org/kj/2.6.13-rc3-kj/flashpoint_patches.tar.gz
You can also get them one by one, they start with "flashpoint_":
http://coderock.org/kj/2.6.13-rc3-kj/split/


Original summary by author Alexey Dobriyan <adobriyan@gmail.com>:

Don't pay attention to whatever whitespace left/added on the way. Lindent will
take care of it.

1) Mostly remove unused #defines.
2) Remove wrappers.

3-7) Switch to sane types.
8-13) Remove useless typedefs.

        Splitted for your reviewing pleasure.

14) Lindent the sucker.
15) return (*); => return *;

Compile tested with CONFIG_SCSI_OMIT_FLASHPOINT=y and =n.
