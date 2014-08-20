From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: How to get the number of VFs assigned to the guests in XEN
Date: Wed, 20 Aug 2014 18:29:22 -0400
Message-ID: <20140820222922.GA7387@laptop.dumpdata.com>
References: <CAK=zhgpH2tG-EG4QP1SE46e+uHXA+GJGOPA1vi8UqAfRZ-EFTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK=zhgpH2tG-EG4QP1SE46e+uHXA+GJGOPA1vi8UqAfRZ-EFTA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Sathya Prakash <sathya.prakash@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, boris.ostrovsky@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 20, 2014 at 04:33:29PM +0530, Sreekanth Reddy wrote:
> HI,
> 
> 
> 
> For SRIOV support, currently in the KVM environment, mpt3sas driver can use
> the API pci_vfs_assigned() to know the number of VFs that are currently
> assigned to the running VMs. So that during the PF driver unload time, if
> the return value of this API is greater than zero the our driver won't call
> the pci_disable_sriov() to disable the VFs.
> 
> 
> 
> Now for the same purpose in XEN environment, is there any API similar to
> pci_vfs_assigned() which the low lever device driver can use to know 'the
> number of VFs that are currently assigned to the running VMs'. In XEN
> environment this API pci_vfs_assigned() will return always zero even though
> VFs are assigned to the running VMs.

Odd. It should return the same value. Are the devices binded to pci-back?

> 
> 
> 
> Regards,
> 
> Sreekanth
