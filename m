From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.0-test4] blocking access to mounted scsi devices
Date: Tue, 26 Aug 2003 15:32:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030826153228.A26979@infradead.org>
References: <3F49B515.6010107@torque.net> <20030825130822.A4258@infradead.org> <3F4B3482.4060304@torque.net> <1061906937.1830.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1061906937.1830.11.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Aug 26, 2003 at 09:08:54AM -0500
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: dougg@torque.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ballen@gravity.phys.uwm.edu
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 26, 2003 at 09:08:54AM -0500, James Bottomley wrote:
> Hang on, that's not the way it's supposed to work.
> 
> Mount should be on partition devices (like /dev/sda1) whereas the tools
> should be on whole disc devices (like /dev/sda).  I thought we'd agreed
> that even opening a partition exclusively wouldn't affect the ability to
> open the whole disc device (but opening the whole disc device
> exclusively would block access to all partitions).

Linus accepted a patch from Neil Brown in -test4 that changes this.
