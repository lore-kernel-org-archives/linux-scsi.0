From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Fw: [Bugme-new] [Bug 7614] New: kernel BUG at mm/slab.c:594!
	Seems to affect various SCSI systems in various ways.
Date: Sat, 02 Dec 2006 09:01:40 +0100
Message-ID: <1165046500.3233.138.camel@laptopd505.fenrus.org>
References: <20061201162528.44076c5d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:6533 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1031267AbWLBIBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 03:01:43 -0500
In-Reply-To: <20061201162528.44076c5d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org


> last sysfs file: /class/net/vmnet1/address
> Modules linked in: ipv6 vmnet(U) vmmon(U) video sbs i2c_ec container button


does this reproduce without these proprietary drivers as well ?



