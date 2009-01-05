From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Mon, 05 Jan 2009 22:18:25 +1100
Message-ID: <1231154305.8179.148.camel@nigel-laptop>
References: <20090104092430.7ffd2c41@infradead.org>
	 <1231135294.8179.45.camel@nigel-laptop>
	 <20090105025300.3afbec23@infradead.org>
Reply-To: ncunningham-lkml@crca.org.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090105025300.3afbec23@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi.

On Mon, 2009-01-05 at 02:53 -0800, Arjan van de Ven wrote:
> On Mon, 05 Jan 2009 17:01:34 +1100
> Nigel Cunningham <ncunningham-lkml@crca.org.au> wrote:
> 
> > Hi Arjan.
> > 
> > Great work, and valuable too. I'm just wondering if the header file
> > name "async.h" is a little too generic? Something like async_init.h
> > perhaps?
> > 
> 
> while the users I have in mind are during init, the concept and
> infrastructure of asynchronous function calls is by no means limited to
> that use case... I hope there are many other uses for this :)

Okee doke. How about async_fn or something like that then? It's just
that there's async I/O and no doubt other async stuff I haven't thought
of. Still, it's a relatively minor point.

Night!

Nigel

