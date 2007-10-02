From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 15/17] mpt fusion: shut up uninitialized variable  warnings
Date: Tue, 2 Oct 2007 15:55:08 -0600
Message-ID: <20071002215508.GB12049@parisc-linux.org>
References: <200710022138.l92LcB8Z023600@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49777 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXJBVzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:55:09 -0400
Content-Disposition: inline
In-Reply-To: <200710022138.l92LcB8Z023600@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, satyam@infradead.org, eric.moore@lsi.com

On Tue, Oct 02, 2007 at 02:38:11PM -0700, akpm@linux-foundation.org wro=
te:
> drivers/message/fusion/mptctl.c: In function =E2=80=98mptctl_mpt_comm=
and=E2=80=99:

Could we lose the UTF-8 garbage?

--=20
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
