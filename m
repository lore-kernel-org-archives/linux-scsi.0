From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata update posted
Date: Sun, 14 Sep 2003 13:26:21 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F64A4BD.6030906@pobox.com>
References: <3F628DC7.3040308@pobox.com> <20030913205652.GA3478@werewolf.able.es> <20030913212849.GB21426@gtf.org> <20030914111225.A3371@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030914111225.A3371@pclin040.win.tue.nl>
To: Andries Brouwer <aebr@win.tue.nl>
Cc: "J.A. Magallon" <jamagallon@able.es>, SCSI Mailing List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Andries Brouwer wrote:
> This shows why defkeymap.c is not generated in the kernel build
> but distributed.

There is a difference between distributed generating files, and checking 
generated files into a repository...  I do not advocate changing the 
tarball, just the BK repo behind it.

	Jeff



