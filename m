From: Greg KH <greg@kroah.com>
Subject: Re: [PATCHSET] workqueue: update workqueue users - replace
 create_workqueue()
Date: Wed, 26 Jan 2011 12:46:49 +0800
Message-ID: <20110126044649.GA2991@kroah.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <20110125142921.GB27510@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110125142921.GB27510@htj.dyndns.org>
Sender: reiserfs-devel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org, davej@redhat.com, cpufreq@vger.kernel.org, Markus.Lidel@shadowconnect.com, tomas.winkler@intel.com, jayamohank@serverengines.com, andrew.vasquez@qlogic.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, tomof@acm.org, stf_xl@wp.pl, linux-usb@vger.kernel.org, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, reiserfs-devel@vger.kernel.org, aelder@sgi.com, hch@infradead.org, ericvh@gmail.com, rminnich@sandia.gov, v9fs-developer@lists.sourceforge.net, lucho@ionkov.net, andy.grover@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2011 at 03:29:21PM +0100, Tejun Heo wrote:
> Hello,
> 
> There was no response for the following patches and I'm planning on
> routing them through workqueue#for-2.6.39.  If you have an objection
> or want to take the patch through a different tree, please let me
> know.
> 
>  0019-usb-ueagle-atm-use-system_wq-instead-of-dedicated-wo.patch

I've already taken this in my usb-next tree to go into .39.

thanks,

greg k-h
