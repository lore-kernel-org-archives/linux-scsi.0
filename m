From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
Date: Sun, 4 Jan 2009 11:09:32 -0800
Message-ID: <20090104110932.6563cc6d@infradead.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092857.5fbf6b2d@infradead.org>
	<87k59aops9.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <87k59aops9.fsf@basil.nowhere.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 04 Jan 2009 20:05:26 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Surely the thread should die again boot up? On module load
> synchronisity is usually not a problem.

sadly that's not correct in practice based on the fast boot work we've
done.

> 
> Personally I think it would be better to make this more generic.
> Various subsystems have thread pool implementations now, 

sort of kinda. If a good one appears I'd be happy to build on top of
that, assuming it's generic enough.

> and this
> is just another variant that except for the sequence stuff
> isn't all that much different. So it would be better to have 
> a generic worker thread manager that just supports these
> barriers too.

... or maybe think about seeing this system as exactly that thread
manager?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
