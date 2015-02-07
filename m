From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 2/4] SCSI-QLA4...: Less function calls in qla4xxx_is_session_exists()
 after error detection
Date: Sat, 07 Feb 2015 18:23:42 +0100
Message-ID: <54D64A1E.40405@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54D53BE4.7010807@users.sourceforge.net> <54D53CF1.8050009@users.sourceforge.net> <20150207093322.GA5206@mwanda> <alpine.DEB.2.02.1502071110330.2241@localhost6.localdomain6> <20150207103249.GA5155@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150207103249.GA5155@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Julia Lawall <julia.lawall@lip6.fr>
Cc: "James E. J. Bottomley" <JBottomley@parallels.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> 1)  People gloss over initializers without reading them.

I would find such a habit strange.


>     You shouldn't put complicated code in initializers.

Does the affected memory allocation fall into such a category?


> 2)  It means you have to put a line of separation between the allocation
>     and the NULL check, but they should be next to each other.

Would you like to extend the Linux coding style documentation?

Regards,
Markus
