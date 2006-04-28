From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 10:47:47 -0700 (PDT)
Message-ID: <20060428174747.15085.qmail@web31804.mail.mud.yahoo.com>
References: <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Fri, 2006-04-28 at 09:28 -0500, Brian King wrote:
> > Any comments on the patch below?
> 
> The mechanistic comment is that the max_cmd_len parameter should be per
> target not per device.
> 
> However, since this is SATA only, and SATA is supposed to be moving out
> of the SCSI subsystem,

Can you justify this "decision" with a technological argument.*  A lot of
technologists following this mailing list would love to learn.

Thank you,
    Luben
* I.e. a technological argument aside from Linux and the state of SCSI Core.


