From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH v3] scsi/ata: Use unsigned int for cmd's type in ioctls
 in scsi_host_template
Date: Sun, 13 Jan 2019 21:57:54 -0700
Message-ID: <20190114045754.GA8440@flashbox>
References: <20181020050143.589-1-natechancellor@gmail.com>
 <20190114044206.6351-1-natechancellor@gmail.com>
 <c1f7f039-04b2-a660-2408-8d4ac0ea63c4@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c1f7f039-04b2-a660-2408-8d4ac0ea63c4@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, Bradley Grove <linuxdrivers@attotech.com>, Don Brace <don.brace@microsemi.com>, Brian King <brking@us.ibm.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Nick Desaulniers <ndesaulniers@google.com>, Joel Stanley <joel@jms.id.au>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 13, 2019 at 08:54:35PM -0800, Bart Van Assche wrote:
> On 1/13/19 8:42 PM, Nathan Chancellor wrote:
> > @@ -1292,7 +1292,7 @@ int esas2r_ioctl_handler(void *hostdata, int cmd, void __user *arg)
> >   	ioctl = memdup_user(arg, sizeof(struct atto_express_ioctl));
> >   	if (IS_ERR(ioctl)) {
> >   		esas2r_log(ESAS2R_LOG_WARN,
> > -			   "ioctl_handler access_ok failed for cmd %d, "
> > +			   "ioctl_handler access_ok failed for cmd %u, "
> >   			   "address %p", cmd,
> >   			   arg);
> >   		return PTR_ERR(ioctl);
> 
> If you have to repost this patch, please use that opportunity to join the
> above split strings. Additionally, since this patch touches much more SCSI

Sorry, I should have caught that. If I have to post again, I will fix
that.

> code than ATA code I think it should have been sent to Martin instead of to
> Jens. Anyway:
> 

I had Jens, Martin, and James on the 'to' line, with all of the other
maintainers of the individual files on cc. If I should have done it
differently, please let me know.

> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

Thank you, I will carry this forward if I need to.

Nathan
