From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Driver for Adaptec AHA-1530P
Date: Sat, 10 Jan 2004 22:24:51 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401102219130.6033-100000@poirot.grange>
References: <0bb601c3d78a$f3394020$060ba8c0@AldiP4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:41603 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S265464AbUAJVni (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 16:43:38 -0500
In-Reply-To: <0bb601c3d78a$f3394020$060ba8c0@AldiP4>
List-Id: linux-scsi@vger.kernel.org
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: linux-scsi@vger.kernel.org

On Sat, 10 Jan 2004, Kai Ruhnau wrote:

> The kernel 2.4.10 is from a SuSE-Linux 7.3 boot-disk with the aha152x as
> module.
>
> Here is the log after I loaded the module:

Hm, it might also be, that your problem comes not from changes in the
driver, but from switching from module to compiled-in. Can you try either
2.4.10 with driver compiled-in or 2.4.2x with driver as a module (also
with a diskette or initrd)?

Guennadi
---
Guennadi Liakhovetski


