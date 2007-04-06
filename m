From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Fri, 06 Apr 2007 11:47:32 -0500
Message-ID: <1175878053.3677.32.camel@mulgrave.il.steeleye.com>
References: <200704061551.l36FpWoV015751@cichlid.com>
	 <1175876096.3677.24.camel@mulgrave.il.steeleye.com>
	 <4616761F.2050905@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933331AbXDFQyn@vger.kernel.org>
In-Reply-To: <4616761F.2050905@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
To: dougg@torque.net
Cc: Andrew Burgess <aab@cichlid.com>, cebbert@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, aradford@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-04-06 at 12:32 -0400, Douglas Gilbert wrote:
> That last line should be:
>         request_buffer[7] = 10;	/* minimum size per SPC: 18 bytes */

Er, yes, I'm afraid when I see n-7 I always think n is the lenght, not n
is the last byte ...

James
