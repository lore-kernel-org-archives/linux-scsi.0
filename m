From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v1] ibmvscsis: Fix cleaning up pointers
Date: Thu, 11 May 2017 10:21:49 -0700
Message-ID: <1494523309.14920.3.camel@haakon3.risingtidesystems.com>
References: <1494348626-62378-1-git-send-email-bryantly@linux.vnet.ibm.com>
         <1494387933.16894.56.camel@haakon3.risingtidesystems.com>
         <068b2d6e-fde5-f72c-1032-485f6bab68f2@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <068b2d6e-fde5-f72c-1032-485f6bab68f2@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mikecyr@linux.vnet.ibm.com, mikecyr@us.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-05-11 at 10:40 -0500, Bryant G. Ly wrote:
> On 5/9/17 10:45 PM, Nicholas A. Bellinger wrote:
> 
> > On Tue, 2017-05-09 at 11:50 -0500, Bryant G. Ly wrote:
> >> This patch is dependent on:
> >> 'commit 25e78531268e ("ibmvscsis: Do not send aborted task response")'
> >> This patch cleans up some pointers after usage.
> >>
> >> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> >> Reviewed-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> >> Cc: <stable@vger.kernel.org> # v4.8+
> >> ---
> >>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> > Applied, with a more verbose commit message.
> >
> > Thanks for splitting this out into an incremental patch.
> >
> No problem, did you end up forgetting it once you reverted Bart's VERIFY/WRITE VERIFY patch?
> 
> It seems to be missing from your for-next now.
> 

Yep, going to include it post -rc1 with your latest patch.
