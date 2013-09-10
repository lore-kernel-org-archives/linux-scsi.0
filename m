From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
Date: Tue, 10 Sep 2013 15:02:01 -0700
Message-ID: <1378850521.23501.47.camel@dabdike.int.hansenpartnership.com>
References: <20130904200555.GA28147@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130904200555.GA28147@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-09-04 at 15:05 -0500, Mike Miller wrote:
> Patch 1 of 4
> 
> From: Mike Miller <mike.miller@hp.com>

Just for future reference, doing it this way means I have to edit the
patch.  The way git am works when applying patches is that if the first
body line is a keyword it recognises (like From: or Subject: or Date:)
it will fold that into the commit metadata, otherwise everything becomes
the commit message.  So by putting the redundant "patch 1 of 4" first,
git thinks the entire body is the commit message.

James

> This patch adds the PCI ID's for HP Smart Array Gen9 controllers. Please
> consider this patch for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> ---
