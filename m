From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ibmvscsis: Fix srp_transfer_data fail return code
Date: Mon, 9 Jan 2017 18:55:44 +0100
Message-ID: <20170109175544.GB6750@kroah.com>
References: <1483978880-93705-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <20170109164748.GA21437@kroah.com>
 <6b74ee38-4490-79df-8311-4d7349749cbf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6b74ee38-4490-79df-8311-4d7349749cbf@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Bart.VanAssche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 09, 2017 at 11:23:23AM -0600, Bryant G. Ly wrote:
> On 1/9/17 10:47 AM, Greg KH wrote:
> 
> > On Mon, Jan 09, 2017 at 10:21:20AM -0600, Bryant G. Ly wrote:
> > > From: "Bryant G. Ly" <bgly@us.ibm.com>
> > > 
> > > If srp_transfer_data fails within ibmvscsis_write_pending, then
> > > the most likely scenario is that the client timed out the op and
> > > removed the TCE mapping. Thus it will loop forever retrying the
> > > op that is pretty much guaranteed to fail forever. A better return
> > > code would be EIO instead of EAGAIN.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> > > Tested-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> > > Signed-off-by: Bryant G. Ly <bgly@us.ibm.com>
> > > ---
> > >   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > Why are you sending this to me?
> > 
> > confused,
> > 
> > greg k-h
> Sorry I meant to put --to target-devel@vger.kernel.org, and just --cc you.

Why even cc: me?
