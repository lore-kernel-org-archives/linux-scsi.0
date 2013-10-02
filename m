From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: [PATCH 0/3] target: Fixes for COMPARE_AND_WRITE backend I/O
 failure cases
Date: Wed, 2 Oct 2013 06:31:58 +0200
Message-ID: <20131002043157.GA3057@glanzmann.de>
References: <1380672796-437-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1380672796-437-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Hello Nab,

> Thomas, these are all fairly obvious fixes to me, and I've been able
> to confirm them on my setup.  Please confirm on your end, and I'll
> plan to push them for v3.12-rc4 by the end of the week.

I confirm that the fixes work. Thank you for fixing this. I did the
following:

        - Applied the patches on top of your for-next, recompiled,
          installed modules and kernel got rid of
          '/lib/modules/3.11.0-rc5+/extra/' which contained target
          modules with an unknown symbol __dynamic_pr_debug (from the
          debug build, I assume)

        - Started the target, discovered from two esx servers, created
          VMFS (no error), deployed one VM, used XCOPY to clone it three
          times, powered it on and did 4 svmotion in parallel.

So the fix works. I also have the feeling that the xcopy code became
faster, but I first have to meassure it.

I'll today some more testing with rescans from 12 ESX and svmotion
(XCOPY) of 24 VMs in parallel. But everything is looking good from my
site. I'm also working on the discovery patch.

Cheers,
        Thomas
