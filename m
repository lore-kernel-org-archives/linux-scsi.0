From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3] scsi: require CAP_SYS_ADMIN to write to procfs
 interface
Date: Sun, 5 Nov 2017 08:31:21 +0100
Message-ID: <20171105073121.GB1431@kroah.com>
References: <20171105025635.10843-1-asarai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171105025635.10843-1-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, Valentin Rothberg <vrothberg@suse.com>, cyphar@cyphar.com, stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 05, 2017 at 01:56:35PM +1100, Aleksa Sarai wrote:
> Previously, the only capability effectively required to operate on the
> /proc/scsi interface was CAP_DAC_OVERRIDE (or for some other files,
> having an fsuid of GLOBAL_ROOT_UID was enough). This means that
> semi-privileged processes could interfere with core components of a
> system (such as causing a DoS by removing the underlying SCSI device of
> the host's / mount).

Given that the previous patch didn't even compile, I worry that you have
not tested this at all to see what breaks/changes in userspace with this
type of user-visable api change.

What did you do to test this?

thanks,

greg k-h
