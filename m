From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/6] fastboot: Asynchronous function calls to speed up
 kernel boot
Date: Tue, 6 Jan 2009 05:57:18 -0800
Message-ID: <20090106055718.2a5472a1@infradead.org>
References: <20090105200959.04a626ac@infradead.org>
	<20090105201041.3289d3dd@infradead.org>
	<20090105202514.399da36e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090105202514.399da36e.akpm@linux-foundation.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 5 Jan 2009 20:25:14 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 5 Jan 2009 20:10:41 -0800 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> >  kernel/async.c         |  307
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Am still wondering if this is unacceptably duplicative of dhowells's
> slow-work infrastructure: http://lkml.org/lkml/2008/11/20/193

ok having looked at it a lot more; I can add priorities to the async
function calls, at which point they are a superset to the slow-work
infrastructure basically. I'll need to check with David to make 10)%
sure the solution I have in mind will work for him, but I suspect it
will.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
