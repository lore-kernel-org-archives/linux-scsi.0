From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mptfusion: enable no_write_same in scsi_host_template
Date: Mon, 22 Sep 2014 11:19:29 -0700
Message-ID: <20140922181929.GA11319@infradead.org>
References: <1411408690-4766-1-git-send-email-chris.j.arges@canonical.com>
 <20140922180220.GA10166@infradead.org>
 <5420679D.3070406@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5420679D.3070406@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vget.kernel.org, bruce.lucas@mongodb.com, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 22, 2014 at 01:17:01PM -0500, Chris J Arges wrote:
> > 
> I've only been able to reproduce this on VMWare. There is a pretty
> straightforward reproducer in the BugLink if there is any interest in
> verifying on hardware.
> 
> How would you recommending blacklisting only VMWare guests in this case?

Can you check what PCI subdevice and subvendor IDs the device you can
reproduce it with have?  If the subvendor is Vmware that would be easy,
if not the Avago people might be able to help with a device specific
VMware identification.  If that fails we have kernel helpers to
identify the hypervisor, but I'd rather avoid that as it would also
trigger for PCI pass through devices.
