From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: 2.5.56-mm1 fails to detect cd burner
Date: Tue, 11 Mar 2003 08:03:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311160358.GN465@holomorphy.com>
References: <20030311063627.GJ1399@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030311063627.GJ1399@holomorphy.com>
List-Id: linux-scsi@vger.kernel.org
To: gibbs@scsiguy.com
Cc: linux-scsi@vger.kernel.org

On Mon, Mar 10, 2003 at 10:36:27PM -0800, William Lee Irwin III wrote:
>  scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
>  DRIVER, Rev 6.2.26
>          <Adaptec 3960D Ultra160 SCSI adapter>
>          aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
>  
>  (scsi0:A:0:0): Completed command without status.
>  (scsi0:A:0:0): Protocol violation in Message-in phase.  Attempting to abort.
>  (scsi0:A:0:0): Abort Message Sent
>  (scsi0:A:0:0): SCB 3 - Abort Completed.
>  scsi0:A:0:0: DV failed to configure device. Please file a bug report against this driver.
> 
> It's had other problems burning CD's in 2.5.x

jejb referred me to you (gibbs) for this after guiding me through a
cable check.


-- wli
