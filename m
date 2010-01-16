From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi/osst.c: remove unncessary casting of kmalloc.
Date: Sat, 16 Jan 2010 16:37:06 +0100
Message-ID: <4B51DD22.4040404@s5r6.in-berlin.de>
References: <503939f4cfd0b8c362a2f5a103285f8dc330b99a.1263651173.git.tfransosi@gmail.com> <4B51DCBF.9090902@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57416 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0APPhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jan 2010 10:37:25 -0500
In-Reply-To: <4B51DCBF.9090902@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Thiago Farina wrote:
>> -		os_scsi_tapes =
>> -			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
>> -				   GFP_ATOMIC);
>> +		os_scsi_tapes = kmalloc(osst_max_dev * sizeof(struct osst_tape *),
>> +					GFP_ATOMIC);

> Since you update the style of this kmalloc usage, you could at the same
> time change the sizeof expression to sizeof(* os_scsi_tapes).

PS: osst_max_dev * sizeof(* os_scsi_tapes) of course, if it wasn't obvious.
-- 
Stefan Richter
-=====-==-=- ---= =----
http://arcgraph.de/sr/
