From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 14:16:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212282016.gBSKGrF03354@localhost.localdomain>
References: <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA09110
	for <linux-scsi@vger.kernel.org>; Sat, 28 Dec 2002 12:17:01 -0800
In-Reply-To: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
   of "Sat, 28 Dec 2002 12:16:50 MST." <712898112.1041103010@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Rik van Riel <riel@conectiva.com.br>, Tomas Szepe <szepe@pinerecords.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Samuel Flory <sflory@rackable.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

gibbs@scsiguy.com said:
> That hasn't applied since 6.2.10 or so.  2.5.X is still using 6.2.4. 

The bug report is against 2.5.53 which has 6.2.24 in it, so it still needs 
fixing.  At a cursory glance at the code, it looks like you don't call 
scsi_set_pci_device early enough in the detect routine.

James


