From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH]  2.4.23-pre8 driver udpate for MPT Fusion (2.05.10)
Date: 24 Oct 2003 11:20:59 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1067008859.2109.18.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57035A944F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57035A944F@exa-atlanta.se.lsil.com>
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2003-10-24 at 10:53, Moore, Eric Dean wrote:
> Here's a patch for 2.4.23-pre8 kernel for MPT Fusion driver, coming from LSI
> Logic.
> 
> This patch is large, so I have placed it on the LSI ftp site at:
> ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.05.10/mptlinux-2.05
> .10.patch
> 
> A new email address is setup for directing any MPT Fusion questions:
> mpt_linux_developer@lsil.com

The policy for driver updates into 2.4 is that they should be backports
from 2.6 (for things like mpt fusion that have similar drivers) so that
the newer driver gets into 2.6 first.  If you want to send the 2.6
patches, I can queue them up for when the "bugfix only" freeze is
relaxed.

James
