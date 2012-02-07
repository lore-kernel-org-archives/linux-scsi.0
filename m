From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 7 Feb 2012 13:10:41 +0200
Message-ID: <20120207111041.GA6674@redhat.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>
 <4F30F4EE.4080607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F30F4EE.4080607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Hoff <christian.hoff@de.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 07, 2012 at 10:54:54AM +0100, Paolo Bonzini wrote:
> >Also, lun[1] = sc->device->id means that only 255 SCSI target IDs will be
> >supported. Think about bigger usage scenarios, such as FCP networks with
> >several hundred HBAs in the net. If you want to have the target ID<->HBA
> >mapping the same as on the guest as on the host, then 255 virtual target
> >IDs could be a limit.
> 
> I think you would hit other scalability limitations well before
> that.  I plan to give each target its own MSI-X interrupt, but there
> is no infinite supplies of those either.

virtio-pci generally lets guests share MSI-X vectors between queues,
why not allow this here?

-- 
MST
