From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] Target development work-flow re-org
Date: Tue, 12 Jun 2012 20:55:59 -0700
Message-ID: <1339559759.13709.228.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <mail@hannes-reinecke.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Hello target devels & Co,

I'd like to announce that target development work-flow has been
re-organized for v3.5 to follow a model similar to what Linux/KVM has
adopted for recent mainline releases.

The target-pending.git tree will now be the main development tree, and
the location target developers should be basing their work on:

http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=summary

This tree is now setup using the following branch structure:

*) master: contains latest target rc-fixes for the current release
*) for-next: contains developmental patches for next merge window
*) for-next-merge: contains new fabric drivers for next merge window
*) queue: contains untested patches (usually) headed into for-next*
*) auto-next: combination of current master + for-next* (rebased often)

These branches are currently based on v3.5-rc2, and master + for-next
branches have been updated to include the latest patches outstanding on
target-devel.

So from this point onwards, the old development tree (lio-core.git)
should be considered deprecated.  For working with the new layout here
are some simple guidelines from KVM's docs:

If you're a developer, usually developing against 'for-next' is okay. If
'for-next' is unstable for you or you need a new upstream API, work
against 'auto-next', but let the maintainers know that when posting your
patch.

If you're working on a fix for the current cycle, work against upstream
or 'master' (they should be equivalent most of the time).

If you're a submaintainer, post git pull requests against 'for-next' or
'master', according to your merge target.

So I'm really quite happy with the new layout as it will end up saving
me extra work, and should make life easier for other developers as
well.  ;)

--nab
