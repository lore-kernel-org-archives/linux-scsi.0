From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: [PATCH 0/3] target: EXTENDED_COPY bugfixes for v3.12-rc
Date: Tue, 8 Oct 2013 22:20:26 +0200
Message-ID: <20131008202026.GA5808@glanzmann.de>
References: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Hello Nab,

>   target: Make target_do_xcopy failures return INVALID_PARAMETER_LIST
>   target: Allow non zero ListID in EXTENDED_COPY parameter list
>   target: Reject EXTENDED_COPY when emulate_3pc is disabled

I pull them right now, rebuild and test them tomorrow in my currently
ongoing class. I'll report back by the end of the week if there have
been any problems, but I assume there will not be. I also wondered why
you allowed xcopy when the feature was not enabled, but never bothered
to ask. :-) However I'm still fighting with the demo mode discovery, I
should know the code by now.

Cheers,
        Thomas
