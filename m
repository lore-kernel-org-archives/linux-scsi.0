From: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 32/34] pmcraid: Drop __DATE__ usage
Date: Tue, 19 Apr 2011 00:21:48 +0200
Message-ID: <20110418222148.GI29882@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-33-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1302015561-21047-33-git-send-email-mmarek@suse.cz>
Sender: linux-kbuild-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 05, 2011 at 04:59:19PM +0200, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/scsi/pmcraid.c |    9 ++++-----
>  drivers/scsi/pmcraid.h |    1 -
>  2 files changed, 4 insertions(+), 6 deletions(-)

Applied to kbuild-2.6.git#trivial.

Michal

