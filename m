From: David Lang <david.lang@digitalinsight.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx intothe
 kernel
Date: Mon, 3 Oct 2005 07:26:38 -0700 (PDT)
Message-ID: <Pine.LNX.4.62.0510030721540.11541@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from warden3-p.diginsite.com ([208.147.64.186]:3308 "HELO
	warden3.diginsite.com") by vger.kernel.org with SMTP
	id S932260AbVJCObW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2005 10:31:22 -0400
In-Reply-To: dlang@dlang.diginsite.com
References: dlang@dlang.diginsite.com
In-Reply-To: <43413D9C.2050904@adaptec.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org>
 <433D8542.1010601@adaptec.com> <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com>
 <433D8D1F.1030005@adaptec.com> <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com>
 <433DB8AF.4090207@adaptec.com> <433DD95C.5050209@pobox.com>
 <43413D9C.2050904@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Kyle Moffett <mrmacman_g4@mac.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Mon, 3 Oct 2005, Luben Tuikov wrote:

>>
>> The SAS transport class supports commonality across all SAS
>> implementations.  This includes both MPT and Adaptec 94xx.
>>
>> SAS transport class + libsas supports software implementations of SAS,
>> including transport layer management.  This includes Adaptec 94xx but
>> NOT MPT.
>
> You almost get it right, other than the layering infrastructure.
>
> The SAS Transport Layer is a layer in its own right.  It is not
> a "libsas".
>
> MPT and open transport a very different, one hides the transport,
> i.e. the transport layer is in firmware; the other exposes it
> and needs a transport layer. See the pictures here:
> http://marc.theaimsgroup.com/?l=linux-kernel&m=112810649712793&w=2

in this case wouldn't it be trivial to write a 'null transport' driver 
that just passed things down to the card to let the firmware deal with it?
(reformatting the data if needed)

having a null driver for a layer for some hardware, and a much more 
complex driver for the same layer for other hardware is fairly common in 
Linux. I believe ti was Linus that said in an interview that Linux is now 
largely designed for an ideal abstracted CPU, with code put in on the 
architectures that don't have a feature to simulate that feature in 
software.

David Lang

-- 
There are two ways of constructing a software design. One way is to make it so simple that there are obviously no deficiencies. And the other way is to make it so complicated that there are no obvious deficiencies.
  -- C.A.R. Hoare
