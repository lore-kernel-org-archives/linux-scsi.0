From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: sym2 2.1.18k
Date: Mon, 13 Sep 2004 23:33:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m38ybdlur2.fsf@merlin.emma.line.org>
References: <20040913194803.GV642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:52878 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S268981AbUIMVdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 17:33:08 -0400
In-Reply-To: <20040913194803.GV642@parcelfarce.linux.theplanet.co.uk> (Matthew
	Wilcox's message of "Mon, 13 Sep 2004 20:48:03 +0100")
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox <willy@debian.org> writes:

> 2.1.18k:
>  - Relicence from dual BSD/GPL to pure GPL

Urgh. There was a time when the driver was shared among deveral OSs,
among them FreeBSD. The BSD world ain't gonna like this for practical
reasons, the consequence is that they'll either stop merging patches
from Linux or remove the sym driver from their GENERIC kernels if they
want your patches.

Of course, he who writes the code gets to determine the license, hence
no plea to revert this change, but I'd like to know why this change has
been made.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
