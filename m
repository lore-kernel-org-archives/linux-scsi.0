From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 1/1] cciss: bug fix, prevent cciss from loading in kdump
 kernel
Date: Tue, 16 Apr 2013 15:00:41 -0700
Message-ID: <20130416150041.ef8bac2a578c8cb0e5df4c49@linux-foundation.org>
References: <20130415175906.GA16955@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130415175906.GA16955@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Apr 2013 12:59:06 -0500 Mike Miller <mike.miller@hp.com> wrote:

> Patch 1/1
> 
> If hpsa is selected as the Smart Array driver cciss may try to load in the
> kdump kernel. When this happens kdump fails and a core file cannot be created.
> This patch prevents cciss from trying to load in this scenario. This effects
> primarily older Smart Array controllers.
> 

OK, this is weird.  kdump and scsi drivers are pretty darn remote things
and I've never heard of such an interaction.  Can you tell us a bit more
about how and why this happened?  Is there something special about
cciss, or can we expect similar kdump interactions with other device drivers?
