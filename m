From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.5 patch] MegaRAID driver: remove kernel 2.0 and 2.2 code
Date: 21 Jan 2003 02:43:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1043117030.13113.15.camel@dhcp22.swansea.linux.org.uk>
References: <20030118162243.GF10647@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030118162243.GF10647@fs.tum.de>
To: Adrian Bunk <bunk@fs.tum.de>
Cc: groudier@free.fr, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2003-01-18 at 16:22, Adrian Bunk wrote:
> The patch below removes obsolete #if'd code for kernel 2.0 and 2.2 from
> drivers/scsi/megaraid.{h,c} (this includes the expansion of some
> #define's that were definded differently for different kernel versions).
> 
> I've tested the compilation with 2.5.59.

AMI still issue 2.2 versions of this driver so its probably excessive
(AMI ? -- LSI now I guess)
