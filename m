From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Controlling PATA access speeds
Date: Thu, 01 Jun 2006 13:59:56 -0500
Message-ID: <1149188396.3489.56.camel@mulgrave.il.steeleye.com>
References: <BAY113-F9629AB1FA5713C03D4F42DF900@phx.gbl>
	 <20060601185244.GH5869@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060601185244.GH5869@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: John Treubig <jtreubig@hotmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2006-06-01 at 14:52 -0400, Jeff Garzik wrote:
> The driver includes code to do cable detect.  Is this insufficient for
> some reason?

Fortunately PATA cables are shorter than SCSI ones, but for SCSI the
answer's "yes", which is why SPI tries to use domain validation (which
also doesn't fully detect all the issues, and why we sometimes have to
resort to "try reducing the transfer parameters down to X").

I have to believe, that even with shorter cable lengths and fewer
devices, PATA still runs into some (many) of the SPI issues.

James


