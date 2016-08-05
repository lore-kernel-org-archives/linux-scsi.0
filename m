From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v5 0/8] Replay Protected Memory Block (RPMB) subsystem
Date: Fri, 5 Aug 2016 22:06:01 +0200
Message-ID: <20160805200601.GA7999@amd>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi!

> Few storage technologies such is EMMC, UFS, and NVMe support RPMB
> hardware partition with common protocol and frame layout.
> The RPMB partition cannot be accessed via standard block layer, but by a
> set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and
> PROGRAM_KEY.
> Such a partition provides authenticated and replay protected access,
> hence suitable as a secure storage.

...and that is suitable from locking devices from their owners, as
Nokia N9 (aka brick, because Microsoft turned off support servers)
teached me recently.

So I have to ask -- what are non-evil uses for this?

There were "secure extensions" mentioned before, but my understanding
is that it currently has severe limitations making it unsuitable for
mainline kernel. (IOW you can't event test the functionality if you
are not Intel).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
