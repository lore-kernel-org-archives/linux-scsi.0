From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Fri, 30 Sep 2005 18:19:30 -0400
Message-ID: <433DB9F2.6040300@adaptec.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org>	 <433D8542.1010601@adaptec.com>	 <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com>	 <433D8D1F.1030005@adaptec.com>	 <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com> <87f94c370509301510nba59ac2m59f507f70de6e46b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:3037 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030473AbVI3WTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 18:19:47 -0400
In-Reply-To: <87f94c370509301510nba59ac2m59f507f70de6e46b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, jgarzik@pobox.com, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 09/30/05 18:10, Greg Freemyer wrote:
> 
> Luben has more than once called for adding a small number of
> additional calls to the existing SCSI core.  These calls would
> implement the new (reduced) functionallity.  The old calls would
> continue to support the full SPI functionallity.  No existing  LLDD
> would need modification.
> 
> Then, over time, more radical restructuring could be done that pulls
> SPI out of SCSI core.
> 
> I believe this proposal is what he was talking about, not the brand
> new simplified SCSI core that has been discussed recently in this
> thread.

See?  There _are_ smart people out there.

	Luben
