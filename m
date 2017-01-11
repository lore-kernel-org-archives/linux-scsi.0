From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: select UIO
Date: Tue, 10 Jan 2017 23:10:42 -0500
Message-ID: <yq137gqs0cd.fsf@oracle.com>
References: <20170110152744.3139180-1-arnd@arndb.de>
        <1484079574.15161.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484079574.15161.91.camel@localhost.localdomain> (Ewan
        D. Milne's message of "Tue, 10 Jan 2017 15:19:34 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@cavium.com, Johannes Thumshirn <jthumshirn@suse.de>, Nilesh Javali <nilesh.javali@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Manish Rangankar <manish.rangankar@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> Randy posted a similar patch back in December but I don't think
Ewan> there was ever a reply to Christoph's question about why qedi
Ewan> depends on uio.

I did queue up Randy's patch to shut up the build warnings. But we're
still looking for a long term fix or an explanation as to why UIO is
needed in the first place.

-- 
Martin K. Petersen	Oracle Linux Engineering
