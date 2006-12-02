From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: [Bugme-new] [Bug 7614] New: kernel BUG at mm/slab.c:594!
 Seems to affect various SCSI systems in various ways.
Date: Sat, 2 Dec 2006 00:19:05 -0800
Message-ID: <20061202001905.6260db9c.akpm@osdl.org>
References: <20061201162528.44076c5d.akpm@osdl.org>
	<1165046500.3233.138.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35980 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1162831AbWLBITR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Dec 2006 03:19:17 -0500
In-Reply-To: <1165046500.3233.138.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Sat, 02 Dec 2006 09:01:40 +0100
Arjan van de Ven <arjan@infradead.org> wrote:

> 
> > last sysfs file: /class/net/vmnet1/address
> > Modules linked in: ipv6 vmnet(U) vmmon(U) video sbs i2c_ec container button
> 
> 
> does this reproduce without these proprietary drivers as well ?
> 

Why are you asking me?
