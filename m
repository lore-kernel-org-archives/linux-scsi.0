From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BK PATCH] SCSI -rc1 fixes
Date: 14 Nov 2004 18:04:58 -0600
Message-ID: <1100477105.24921.3.camel@mulgrave>
References: <1100467267.23710.7.camel@mulgrave>
	<4197E4B7.3050008@pobox.com> <1100473795.23649.26.camel@mulgrave>
	<m3hdnsvvfd.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261382AbUKOAHT@vger.kernel.org>
In-Reply-To: <m3hdnsvvfd.fsf@merlin.emma.line.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2004-11-14 at 17:54, Matthias Andree wrote:
> Still wondering about SuSE's hwscan issue. Has someone managed to figure
> if it uses some ioctl that chokes the sym2 driver or if it hacks the
> hardware?

Well, I think we're stuck on that one.  SUSE doesn't seem willing to
debug hwscan enough to give a coherent description of the problem or a
non hwscan test case and no-one else wants to take hwscan apart to find
out exactly what it is doing.

James
