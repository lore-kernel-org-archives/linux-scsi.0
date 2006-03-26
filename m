From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Sun, 26 Mar 2006 21:51:38 +0200
Message-ID: <1143402698.3055.28.camel@laptopd505.fenrus.org>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Reply-To: arjan@infradead.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751508AbWCZTvm@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
To: Bodo Eggert <7eggert@gmx.de>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2006-03-26 at 21:28 +0200, Bodo Eggert wrote:
> Having a SCSI ID is a generic SCSI property, therefore reading it should 
> not be restricted to sg. The SCSI_IOCTL_GET_IDLUN from scsi is limited 
> below the kernel data types, so it isn't an adequate replacement.
> 
> This patch moves SG_GET_SCSI_ID from sg to scsi while renaming it to
> SCSI_IOCTL_GET_PCI. Additionally, I renamed struct sg_scsi_id to struct
> scsi_ioctl_id, since it is no longer restricted to sg. The corresponding 
> typedef will be gone.


To be honest, I think this is the wrong direction; this ioctl seems to
be a bad idea (it exposes the SPI parameters... while SPI is only one of
many nowadays). Expanding the use of such a thing... please no.
