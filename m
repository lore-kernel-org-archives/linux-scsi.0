From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix idiocy in asd_init_lseq_mdp()
Date: Mon, 25 Sep 2006 13:43:22 -0400
Message-ID: <1159206202.3463.62.camel@mulgrave.il.steeleye.com>
References: <4517EBF7.4020508@torque.net>
	 <20060925171634.69667.qmail@web31809.mail.mud.yahoo.com>
	 <20060925173922.GL29920@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751399AbWIYRnj@vger.kernel.org>
In-Reply-To: <20060925173922.GL29920@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>, Al Viro <viro@ftp.linux.org.uk>
Cc: Luben Tuikov <ltuikov@yahoo.com>, dougg@torque.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-09-25 at 18:39 +0100, Al Viro wrote:
> Far more interesting question: where does the hardware expect to see
> the
> upper 16 bits of that 32bit value?  Which one it is -
> LmSEQ_INTEN_SAVE(lseq)
> ori LmSEQ_INTEN_SAVE(lseq) + 2?

I don't honestly know.  The change was made as part of a slew of changes
by Robert Tarte at Adaptec to make the driver run on Big Endian
platforms.  I've copied Jack Hammer who's now looking after it in the
hope that he can enlighten us.

James
