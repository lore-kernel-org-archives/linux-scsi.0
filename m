From: Andrew Morton <akpm@digeo.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Thu, 30 Jan 2003 22:57:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030130225738.1874c2e0.akpm@digeo.com>
References: <20030129104731.A2811@beaverton.ibm.com>
	<3E382E2C.4030201@splentec.com>
	<20030129121117.A3389@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id WAA10142
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2003 22:56:59 -0800 (PST)
In-Reply-To: <20030129121117.A3389@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: luben@splentec.com, linux-scsi@vger.kernel.org

Patrick Mansfield <patmans@us.ibm.com> wrote:
>
> IMO we need something similiar to the request_queue_t free list, where
> we allocate a bunch of items up front out of a slab.

Please do not reinvent the mm/mempool.c functionality.

'twould be better to just use it ;)


