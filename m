From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: coding style question
Date: Wed, 25 Feb 2004 20:28:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403D4BCD.2010407@pobox.com>
References: <Pine.LNX.4.44.0402251128430.6557-100000@dent.deepthot.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:54734 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262597AbUBZB26
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 20:28:58 -0500
In-Reply-To: <Pine.LNX.4.44.0402251128430.6557-100000@dent.deepthot.org>
List-Id: linux-scsi@vger.kernel.org
To: Jay Denebeim <denebeim@deepthot.org>
Cc: linux-scsi@vger.kernel.org

Two reasons I can think of off the top of my head:
* POSIX prefers "struct foo" as opposed to "foo" or "foo_t"

* typedefs obscure the fact that a data structure is in fact a 
structure, and not a native machine type.  Typically typedefs are best 
used for discrete elements those contents are either opaque or a single 
value.

	Jeff



