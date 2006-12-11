From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Add support for asynchronous scans to libata
Date: Mon, 11 Dec 2006 11:18:17 -0500
Message-ID: <457D84C9.6020907@pobox.com>
References: <20061208211236.GC29763@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20061208211236.GC29763@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Some of the drivers (AHCI was mentioned to me as a culprit) take a long
> time to discover all the devices attached to them.  Even for ones which
> are relatively quick, if you put a lot of them in a machine, it will
> take a long time in aggregate.  This can be fixed by adding support for
> asynchronous scsi scans, which causes the time-consuming portions of
> initialisation to take place in threads.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

ACK.  I tried to apply the patch, but git-applymbox choked on every 
single file modified.  Quite possibly, its due to a whitespace cleanup 
in Alan territory.

If you would either (a) wait several hours for libata-dev.git#upstream 
to mirror out, and resend, or (b) supply a git:// URL to pull from, I'll 
merge.

	Jeff



