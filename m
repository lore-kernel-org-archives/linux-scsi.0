From: Nic Ferrier <nferrier@tapsellferrier.co.uk>
Subject: aacraid died on kernel 2.4.27
Date: Thu, 10 Mar 2005 21:01:50 +0000
Message-ID: <87sm33kyf5.fsf@tapsellferrier.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from owls-tree.tapsellferrier.co.uk ([80.168.156.78]:34973 "EHLO
	owls-tree.tapsellferrier.co.uk") by vger.kernel.org with ESMTP
	id S261239AbVCJVG6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2005 16:06:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been trying, without success, to get the aacraid driver to work
reliably on a Dell 2650 Poweredge.

I'm using Debian so I tried kernel 2.6.8 first (Debian has it packaged
nicely but from a SCSI driver point of view it's just a standard
kernel.org source).

2.6.8 worked... but died as soon as we put the server under load.

2.6.11 also died under load.

Yesterday I put 2.4.27 on the box because I had understood that the
aacraid is stable in that release of the kernel. But a few hours ago
the box died in exactly the same way (it was under quite heavy load).

Unfortunately, I can't give you error messages because I don't have
any log from the failures. It comes out on the console and I don't
have it saved anywhere. But it definitely is the raid controller.


Maybe someone can answer the following for me:

- is the driver understood to be stable in 2.4.27?

- is there another driver I could try (would the pre-Cox one work?)

- is there anything I can do to alleviate the problem?




Nic Ferrier
http://www.tapsellferrier.co.uk
