From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: ServeRAID Linux Driver ( ips )  7.00.15 Patch
Date: 29 Mar 2004 09:59:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080572361.1804.6.camel@mulgrave>
References: <A121ABA5B472B74EB59076B8E3C8F0191D97D3@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:50667 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262903AbUC2PAD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 10:00:03 -0500
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F0191D97D3@rtpe2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: Arjan van de Ven <arjanv@redhat.com>, Hubert Mantel <mantel@suse.de>, Jens Axboe <axboe@suse.de>, "Marcelo Wormsbecker Tosatti (E-mail)" <marcelo@conectiva.com.br>, torvalds@transmeta.com, coughlan@redhat.com, dledford@redhat.com, bjohnson@redhat.com, bhlim@vmware.com, rofarrell@vmware.com, kerneldriver@suse.de, go@turbolinux.co.jp, rogerv@sco.com, schwab@suse.de, michael@turbolinux.com, vcat@caldera.com, sdenham@redhat.com, "Jeffery, David" <David_Jeffery@adaptec.com>, "Pasteur, Bob" <bob_pasteur@adaptec.com>, "Wendy Hung (E-mail)" <wendyh@us.ibm.com>, "Leah Cunningham (E-mail)" <leahc@us.ibm.com>, "Brad Thomas (E-mail)" <bwthomas@us.ibm.com>, "Felica Turner (E-mail)" <faturner@us.ibm.com>, "Marie Jazynka (E-mail)" <mjazynka@us.ibm.com>, Chris McDermott <lcm@us.ibm.com>, "Williams, Bill" <Bill_Williams@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-03-29 at 09:10, Hammer, Jack wrote:
> Please apply the following patch to the ips driver source that I
> released last week. If removes an offensive "#ifdef" that was
> essentially a NOP anyway.

Actually, I already cleaned this and the formatting style problems out
of the patch before applying.

What I propose to send in is at:

http://linux-scsi.bkbits.net:8080/scsi-misc-2.6/cset@4065a895G3dygp05xNIYEvui-Ok4kg

If anyone wants to check it.

James


