From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
Date: Wed, 15 Jul 2009 15:09:23 +0000
Message-ID: <1247670563.4236.16.camel@mulgrave.site>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
	 <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48959 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZGOPJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 11:09:26 -0400
In-Reply-To: <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rohan a <info1686@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 20:33 +0530, rohan a wrote:
> Hi guys,
> 
> Any suggestions...please help

I know of no kernel bug that could be causing this.  The SLES9 kernel is
just too old though for me to remember clearly.  I'd suggest you file a
support incident with SUSE ... they'll debug and fix this on the older
kernels; we really only deal with the new kernel and one or two back
revisions here on linux-scsi.

James


