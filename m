From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 24 May 2002 16:32:52 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E17BH3k-0006cI-00@the-village.bc.nu>
References: <20020522231445.A3014@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020522231445.A3014@redhat.com> from "Doug Ledford" at May 22, 2002 11:14:45 PM
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> I'm not sure, but I would hope there is also a timeout since otherwise 
> returning non-0 with no outstanding commands on a device because your 
> driver is busy with something else could cause a queue to hang).  Anyway, 
> it's there even if I never did personally use it since my driver used the 
> old eh code ;-)

That does sound close to unusable on an SMP system. I don't see how you
guarantee that all your events do not complete between you executing the
non zero return to the scsi stack and it check for events
