From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 14 Feb 2012 03:11:45 +0200
Message-ID: <20120214011144.GB5192@redhat.com>
References: <20120213130005.GB26773@redhat.com>
 <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com>
 <20120213131848.GD26773@redhat.com>
 <4F39287A.9030808@suse.de>
 <CAN05THT=7xJhqAMrAvDsK2Z1_4d+=tV9yhOFkr5Z-i43k5hAGA@mail.gmail.com>
 <CAN05THT6t_w=9Zt+o-B4s8E3jUMWsxiBvTyySxNEK2QfvLe-BA@mail.gmail.com>
 <20120213225623.GA2988@redhat.com>
 <CAN05THS_zTf2VRz6QdccHbkOacnE86LNhtxp7b8twe+XezBU6Q@mail.gmail.com>
 <20120213233334.GC4430@redhat.com>
 <CAN05THTTva709Dab9f_PBWxehMWnP9Gg4T7Nnmg7Swk3xuz7aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAN05THTTva709Dab9f_PBWxehMWnP9Gg4T7Nnmg7Swk3xuz7aQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2012 at 11:49:55AM +1100, ronnie sahlberg wrote:
> By just exposing this device to the kernel, the kernel keeps sending,
> or if not the kernel maybe some other process trying to poll the
> status?
> 
> every few seconds :
> PREVENT_ALLOW_MEDIUM_REMOVAL  prevent removal
> PREVENT_ALLOW_MEDIUM_REMOVAL  to immediatel change it back to allow
> removal again
> TEST_UNIT_READY
> 
> 
> After I run this
> mount /dev/sdd1 /mnt
> 
> The kernel sends a single
> PREVENT_ALLOW_MEDIUM_REMOVAL to prevent removal
> then every few seconds a
> TEST_UNIT_READY
> 
> 
> This is what it does for removable SBC disks. Maybe it does something
> differently for "permanent" SBC disks.
> 
> regards
> ronnie sahlberg

There used to be a daemon for this.

