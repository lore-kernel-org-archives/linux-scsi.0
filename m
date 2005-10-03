From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 03 Oct 2005 10:04:57 -0400
Message-ID: <43413A89.60505@adaptec.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org>	 <433D8542.1010601@adaptec.com>	 <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com>	 <433D8D1F.1030005@adaptec.com>	 <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com> <87f94c370509301510nba59ac2m59f507f70de6e46b@mail.gmail.com> <433DD020.8000906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932240AbVJCOFm@vger.kernel.org>
In-Reply-To: <433DD020.8000906@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Kyle Moffett <mrmacman_g4@mac.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

On 09/30/05 19:54, Jeff Garzik wrote:
> Greg Freemyer wrote:
> 
>>Luben has more than once called for adding a small number of
>>additional calls to the existing SCSI core.  These calls would
>>implement the new (reduced) functionallity.  The old calls would
>>continue to support the full SPI functionallity.  No existing  LLDD
>>would need modification.
> 
> 
> IOW, what Luben wants is:
> 
> 	if (Luben)
> 		do this
> 	else
> 		do current stuff
> 
> If this is the case, why bother touching drivers/scsi/* at all?

In order to have a new better, faster, slimmer SCSI Core.

	Luben
