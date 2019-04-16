From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.14] scsi:be2iscsi: Fix a kernel address leakage in
 be_main.c
Date: Tue, 16 Apr 2019 10:57:01 +0200
Message-ID: <20190416085701.GB4209@kroah.com>
References: <20190416070634.13421-1-huangfq.daxian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190416070634.13421-1-huangfq.daxian@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: stable@vger.kernel.org, Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 16, 2019 at 03:06:34PM +0800, Fuqian Huang wrote:
> Outputting kernel addresses will reveal the locations of kernel code
> and data. And there is no need to print the address of a global object 
> beiscsi_iscsi_transport in beiscsi_module_init.
> This case is similar to CVE-2018-7273[1].
> Just remove the print statement.
> 
> [1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-7273
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
