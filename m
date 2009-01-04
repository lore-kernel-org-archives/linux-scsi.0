From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
Date: Sun, 4 Jan 2009 11:52:16 -0800
Message-ID: <20090104115216.db746414.akpm@linux-foundation.org>
References: <20090104092430.7ffd2c41@infradead.org>
	<20090104092857.5fbf6b2d@infradead.org>
	<87k59aops9.fsf@basil.nowhere.org>
	<20090104110932.6563cc6d@infradead.org>
	<20090104194946.GB496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090104194946.GB496@one.firstfloor.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 4 Jan 2009 20:49:46 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> > 
> > > and this
> > > is just another variant that except for the sequence stuff
> > > isn't all that much different. So it would be better to have 
> > > a generic worker thread manager that just supports these
> > > barriers too.
> > 
> > ... or maybe think about seeing this system as exactly that thread
> > manager?
> 
> I'm not sure it's generic enough.

There's appreciable overlap with David Howells's "slow work" thread
pool thingy. If either of those was generic enough, the other would
go away.
