From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Mon, 5 Jan 2009 02:53:00 -0800
Message-ID: <20090105025300.3afbec23@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<1231135294.8179.45.camel@nigel-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1231135294.8179.45.camel@nigel-laptop>
Sender: linux-ide-owner@vger.kernel.org
To: ncunningham-lkml@crca.org.au
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 05 Jan 2009 17:01:34 +1100
Nigel Cunningham <ncunningham-lkml@crca.org.au> wrote:

> Hi Arjan.
> 
> Great work, and valuable too. I'm just wondering if the header file
> name "async.h" is a little too generic? Something like async_init.h
> perhaps?
> 

while the users I have in mind are during init, the concept and
infrastructure of asynchronous function calls is by no means limited to
that use case... I hope there are many other uses for this :)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
