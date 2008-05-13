From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] dpt_i2o: 64 bit support (take 5)
Date: Mon, 12 May 2008 22:42:20 -0700
Message-ID: <20080512224220.5a87a119.akpm@linux-foundation.org>
References: <20080501230211.GA19796@xs4all.net>
	<20080506201055.12bf16c4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755352AbYEMFnI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2008 01:43:08 -0400
In-Reply-To: <20080506201055.12bf16c4.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <mikevs@xs4all.net>, linux-scsi@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>, miquels@cistron.nl, Rolf Eike Beer <eike-kernel@sf-tec.de>, James
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

On Tue, 6 May 2008 20:10:55 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> I'll let someone else ponder ia64:
> 
> drivers/scsi/dpt_i2o.c:83: error: `PROC_IA64' undeclared here (not in a function)
> drivers/scsi/dpt_i2o.c:83: error: initializer element is not constant
> drivers/scsi/dpt_i2o.c:83: error: (near initialization for `DPTI_sig.dsProcessor')

fyi, this is still happening.
