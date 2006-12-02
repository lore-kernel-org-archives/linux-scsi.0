From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 7614] New: kernel BUG at mm/slab.c:594!
	Seems to affect various SCSI systems in various ways.
Date: Sat, 02 Dec 2006 10:37:01 +0100
Message-ID: <1165052221.3233.140.camel@laptopd505.fenrus.org>
References: <20061201162528.44076c5d.akpm@osdl.org>
	 <1165046500.3233.138.camel@laptopd505.fenrus.org>
	 <20061202001905.6260db9c.akpm@osdl.org>
Reply-To: arjan@infradead.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:65191 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1162866AbWLBJhD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 04:37:03 -0500
In-Reply-To: <20061202001905.6260db9c.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Sat, 2006-12-02 at 00:19 -0800, Andrew Morton wrote:
> On Sat, 02 Dec 2006 09:01:40 +0100
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > 
> > > last sysfs file: /class/net/vmnet1/address
> > > Modules linked in: ipv6 vmnet(U) vmmon(U) video sbs i2c_ec container button
> > 
> > 
> > does this reproduce without these proprietary drivers as well ?
> > 
> 
> Why are you asking me?

I was asking the bugzilla ;)


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

