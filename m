From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 12:16:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <712898112.1041103010@aslan.scsiguy.com>
References: <200212281500.gBSF0pc01929@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <200212281500.gBSF0pc01929@localhost.localdomain>
Content-Disposition: inline
To: James Bottomley <James.Bottomley@steeleye.com>, Rik van Riel <riel@conectiva.com.br>
Cc: Tomas Szepe <szepe@pinerecords.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Samuel Flory <sflory@rackable.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

> So far, the only bug report I have is from Andrew Morton proving that it
> still  doesn't get it's bounce buffers right.

That hasn't applied since 6.2.10 or so.  2.5.X is still using 6.2.4.

--
Justin
