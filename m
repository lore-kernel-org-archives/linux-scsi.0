From: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 23/34] scsi/wd33c93: Drop __TIME__ usage
Date: Tue, 19 Apr 2011 00:20:45 +0200
Message-ID: <20110418222045.GF29882@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-24-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1302015561-21047-24-git-send-email-mmarek@suse.cz>
Sender: linux-kbuild-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 05, 2011 at 04:59:10PM +0200, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/scsi/wd33c93.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)

Applied to kbuild-2.6.git#trivial.

Michal

