From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] hpsa: fix physical device lun and target
 numbering problem
Date: Tue, 9 Aug 2011 09:13:15 -0700
Message-ID: <20110809161315.GA8756@kroah.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-bounces@linux.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 09, 2011 at 08:18:01AM -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> If a physical device exposed to the OS by hpsa
> is replaced (e.g. one hot plug tape drive is replaced
> by another, or a tape drive is placed into "OBDR" mode
> in which it acts like a CD-ROM device) and a rescan is
> initiated, the replaced device will be added to the
> SCSI midlayer with target and lun numbers set to -1.
> After that, a panic is likely to ensue.  When a physical
> device is replaced, the lun and target number should be
> preserved.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable
